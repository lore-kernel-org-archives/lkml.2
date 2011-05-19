Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185Ab1ESWNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:13:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935139Ab1ESWNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OPqLalsANXLgF0gPBInAVzr7strQC1WX2AO8zKWk416yxfRHAC5/irZn2HPTSQM5kE
         4V+/1Bnzr2bFM9MVB/Qg==
MIME-Version: 1.0
In-Reply-To: <sig.512079e334.4DD57D44.50009@radicalsystems.co.za>
References: <4DD5452F.9050108@radicalsystems.co.za> <BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com>
 <sig.512079e334.4DD57D44.50009@radicalsystems.co.za>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 May 2011 16:13:25 -0600
Message-ID: <BANLkTinK5PtxuWpaJq9XeDDN_quGj=MhTg@mail.gmail.com>
Subject: Re: PCI BAR1 Unassigned
To: Jan Zwiegers <jan@radicalsystems.co.za>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 2:27 PM, Jan Zwiegers <jan@radicalsystems.co.za> wrote:
> On 2011-05-19 08:50 PM, Bjorn Helgaas wrote:
>>
>> On Thu, May 19, 2011 at 10:28 AM, Jan Zwiegers<jan@radicalsystems.co.za>
>>  wrote:
>>>
>>> I have the problem below where my PCI card's second BAR does not get
>>> assigned.
>>> What can be the cause of this problem?
>>> The last kernel I tested on which worked OK was 2.6.27.
>>> My current problematic kernel 2.6.35.
>>>
>>> 05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O Card
>>> (rev 5c)
>>>    Flags: bus master, slow devsel, latency 32, IRQ 22
>>>    Memory at 93b00000 (type 3, prefetchable) [size=2K]
>>>    Memory at<unassigned>  (type 3, prefetchable)
>>>    Capabilities: [80] #00 [0600]
>>>    Kernel modules: pci703drv
>>
>> Could be resource exhaustion or, more likely, we ran out because we
>> now assign resource to things that don't need them, leaving none for
>> things that *do* need them.  This sounds like a regression, so we
>> should open a bugzilla for it and attach dmesg logs from 2.6.27 and
>> 2.6.35.
>>
>> Does this problem keep the driver from working?  (Sometimes drivers
>> don't actually use all the BARs a device supports.)
>
> I'm the maintainer of the driver and was involved in the development of the
> board as well in 2003. The board uses two BARS and the second BAR is the
> most important. The board worked fine since the 2.4 days and only recently
> became problematic. I suspect it works on even later kernels than 27, maybe
> 2.6.32.
>
> My knowledge is too little to actually determine if the problem is because
> the FPGA based PCI interface is not within spec or something that changed in
> the kernel, because of the post .30 releases becoming more strict to PCI
> specification, i.e. BIOS / Kernel interaction.

Well, let's at least look at the working and broken dmesg logs.  My
money is on kernel breakage.  If it used to work, it should still
work.
