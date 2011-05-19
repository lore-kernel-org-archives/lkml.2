Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768Ab1ESUur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:50:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077Ab1ESUup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ntmaCcfLNkXLOc/zkVKFCb9gSszQkeJORyrmGAniHraOi8w5Th2rkVY7CMSSrube6Q
         wRkYaoa52tfWDZJMeKm1TIHN6xfiOXI5NDehQUCf/TyPGmtzuUCKthbyyOoW/qUSOvK7
         CRWkt4faLSiJe9Rz+m146gMQ3GsFVefuwatBE=
MIME-Version: 1.0
In-Reply-To: <sig.512079e334.4DD57D44.50009@radicalsystems.co.za>
References: <4DD5452F.9050108@radicalsystems.co.za>
	<BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com>
	<sig.512079e334.4DD57D44.50009@radicalsystems.co.za>
Date: Thu, 19 May 2011 15:50:43 -0500
Message-ID: <BANLkTikHQNQdWoDS2dXUC9gTPWvtmUM=yA@mail.gmail.com>
Subject: Re: PCI BAR1 Unassigned
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Jan Zwiegers <jan@radicalsystems.co.za>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 3:27 PM, Jan Zwiegers <jan@radicalsystems.co.za> wrote:
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
>>
>> Bjorn
>>
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
>
> Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

What's the size for BAR1? one reason is that no more space to
align/allocate BAR1.

If the board stays the same then your FPGA might be the cause, I have
seen similar issues and they ended up in FPGA implementation.
