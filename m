Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab1ESWjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:39:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab1ESWjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=txMVr/3HCwINsrNvCrxHUoEKzJIrJGlaP9duPz5VkZNwL1NdML74fqvZy5dZPPsRbg
         LhkCCroD5fJq/c/3h9Gw==
MIME-Version: 1.0
In-Reply-To: <sig.2120eee186.4DD597A2.4040306@radicalsystems.co.za>
References: <4DD5452F.9050108@radicalsystems.co.za> <BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com>
 <sig.512079e334.4DD57D44.50009@radicalsystems.co.za> <BANLkTinK5PtxuWpaJq9XeDDN_quGj=MhTg@mail.gmail.com>
 <sig.2120eee186.4DD597A2.4040306@radicalsystems.co.za>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 May 2011 16:38:43 -0600
Message-ID: <BANLkTi=DJsiHuic4u90nEw-jPc2AKWNXcw@mail.gmail.com>
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

On Thu, May 19, 2011 at 4:20 PM, Jan Zwiegers <jan@radicalsystems.co.za> wrote:
> On 2011-05-20 12:13 AM, Bjorn Helgaas wrote:
>>
>> On Thu, May 19, 2011 at 2:27 PM, Jan Zwiegers<jan@radicalsystems.co.za>
>>  wrote:
>>>
>>> On 2011-05-19 08:50 PM, Bjorn Helgaas wrote:
>>>>
>>>> On Thu, May 19, 2011 at 10:28 AM, Jan Zwiegers<jan@radicalsystems.co.za>
>>>>  wrote:
>>>>>
>>>>> I have the problem below where my PCI card's second BAR does not get
>>>>> assigned.
>>>>> What can be the cause of this problem?
>>>>> The last kernel I tested on which worked OK was 2.6.27.
>>>>> My current problematic kernel 2.6.35.
>>>>>
>>>>> 05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O
>>>>> Card
>>>>> (rev 5c)
>>>>>    Flags: bus master, slow devsel, latency 32, IRQ 22
>>>>>    Memory at 93b00000 (type 3, prefetchable) [size=2K]
>>>>>    Memory at<unassigned>    (type 3, prefetchable)
>>>>>    Capabilities: [80] #00 [0600]
>>>>>    Kernel modules: pci703drv
>>>>
>>>> Could be resource exhaustion or, more likely, we ran out because we
>>>> now assign resource to things that don't need them, leaving none for
>>>> things that *do* need them.  This sounds like a regression, so we
>>>> should open a bugzilla for it and attach dmesg logs from 2.6.27 and
>>>> 2.6.35.
>>>>
>>>> Does this problem keep the driver from working?  (Sometimes drivers
>>>> don't actually use all the BARs a device supports.)
>>>
>>> I'm the maintainer of the driver and was involved in the development of
>>> the
>>> board as well in 2003. The board uses two BARS and the second BAR is the
>>> most important. The board worked fine since the 2.4 days and only
>>> recently
>>> became problematic. I suspect it works on even later kernels than 27,
>>> maybe
>>> 2.6.32.
>>>
>>> My knowledge is too little to actually determine if the problem is
>>> because
>>> the FPGA based PCI interface is not within spec or something that changed
>>> in
>>> the kernel, because of the post .30 releases becoming more strict to PCI
>>> specification, i.e. BIOS / Kernel interaction.
>>
>> Well, let's at least look at the working and broken dmesg logs.  My
>> money is on kernel breakage.  If it used to work, it should still
>> work.
>
> What do you need from me? I have at least 3 machines on which it used to
> work and is now running a later kernel. I can post dmesg from both .27 and
> .35. Will do tomorrow when I'm back at the office.

Since you don't have continuous access to the machines, maybe you can
collect the /proc/iomem and "lspci -v" output at the same time you
collect the dmesg logs.  That should be enough to get started.

Thanks,
  Bjorn
