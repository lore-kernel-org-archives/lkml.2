Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab1ETHmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:42:17 -0400
Received: from ns5.dns-guards.com ([41.203.20.164]:18011 "EHLO
	velocity.dns-guards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154Ab1ETHmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:42:14 -0400
Message-ID: <sig.51214cae32.4DD61B48.8010601@radicalsystems.co.za>
Date: Fri, 20 May 2011 09:42:00 +0200
From: Jan Zwiegers <jan@radicalsystems.co.za>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xianghua Xiao <xiaoxianghua@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PCI BAR1 Unassigned
References: <4DD5452F.9050108@radicalsystems.co.za>	<BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com>	<sig.512079e334.4DD57D44.50009@radicalsystems.co.za> <BANLkTikHQNQdWoDS2dXUC9gTPWvtmUM=yA@mail.gmail.com>
In-Reply-To: <BANLkTikHQNQdWoDS2dXUC9gTPWvtmUM=yA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-ID: velocity.dns-guards.com ()
X-Assp-Version: 1.7.1.3(1.0.2)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - velocity.dns-guards.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - radicalsystems.co.za
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-19 10:50 PM, Xianghua Xiao wrote:
> On Thu, May 19, 2011 at 3:27 PM, Jan Zwiegers<jan@radicalsystems.co.za>  wrote:
>> On 2011-05-19 08:50 PM, Bjorn Helgaas wrote:
>>>
>>> On Thu, May 19, 2011 at 10:28 AM, Jan Zwiegers<jan@radicalsystems.co.za>
>>>   wrote:
>>>>
>>>> I have the problem below where my PCI card's second BAR does not get
>>>> assigned.
>>>> What can be the cause of this problem?
>>>> The last kernel I tested on which worked OK was 2.6.27.
>>>> My current problematic kernel 2.6.35.
>>>>
>>>> 05:01.0 Unassigned class [ff00]: Eagle Technology PCI-703 Analog I/O Card
>>>> (rev 5c)
>>>>     Flags: bus master, slow devsel, latency 32, IRQ 22
>>>>     Memory at 93b00000 (type 3, prefetchable) [size=2K]
>>>>     Memory at<unassigned>    (type 3, prefetchable)
>>>>     Capabilities: [80] #00 [0600]
>>>>     Kernel modules: pci703drv
>>>
>>> Could be resource exhaustion or, more likely, we ran out because we
>>> now assign resource to things that don't need them, leaving none for
>>> things that *do* need them.  This sounds like a regression, so we
>>> should open a bugzilla for it and attach dmesg logs from 2.6.27 and
>>> 2.6.35.
>>>
>>> Does this problem keep the driver from working?  (Sometimes drivers
>>> don't actually use all the BARs a device supports.)
>>>
>>> Bjorn
>>>
>>
>> I'm the maintainer of the driver and was involved in the development of the
>> board as well in 2003. The board uses two BARS and the second BAR is the
>> most important. The board worked fine since the 2.4 days and only recently
>> became problematic. I suspect it works on even later kernels than 27, maybe
>> 2.6.32.
>>
>> My knowledge is too little to actually determine if the problem is because
>> the FPGA based PCI interface is not within spec or something that changed in
>> the kernel, because of the post .30 releases becoming more strict to PCI
>> specification, i.e. BIOS / Kernel interaction.
>>
>> Jan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> What's the size for BAR1? one reason is that no more space to
> align/allocate BAR1.
>
> If the board stays the same then your FPGA might be the cause, I have
> seen similar issues and they ended up in FPGA implementation.
>

I have submitted the difference in iomem, lspci and dmesg of 2.6.27 & 
2.6.35 kernels from the same machine. The BAR size is 2K. As above BAR0 
is at 93b0000 and BAR1 should be at 93b00800.

The board has been fine since 2003, so I'm confident the FPGA is within 
spec.



