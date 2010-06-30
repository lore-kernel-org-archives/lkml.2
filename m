Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab0F3ERg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 00:17:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:19980 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab0F3ERf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 00:17:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,509,1272870000"; 
   d="scan'208";a="531632689"
Message-ID: <4C2AC55E.3040303@intel.com>
Date: Tue, 29 Jun 2010 21:17:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Li <lkml@chrisli.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, david.woodhouse@intel.com
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	<4C29420D.2010406@intel.com>	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>	<4C2A8879.8010000@intel.com> <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
In-Reply-To: <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ copying David to see if I am barking up the wrong VT-d tree.  This is 
on a MacPro 3,1 according to dmesg so a 5400 series MCH ]

On 6/29/2010 6:07 PM, Chris Li wrote:
> On Tue, Jun 29, 2010 at 4:57 PM, Dan Williams<dan.j.williams@intel.com>  wrote:
>>> 0000:00:0f.0: ioat2_timer_event: Channel halted (10)
>>
>> This says that we got an invalid chain address error when trying to start
>> the engine.  If there was a driver problem with init I would have expected
>> to see reports from other systems.  The attached patch will print out what
>> chain address we are setting.  The hardware expects a 64-byte aligned
>> address which should be guaranteed by the use of pci_pool_alloc().
>
> OK. I can't do this test remotely so I will get back to you tomorrow.

I appreciate it!

>
>>
>> However, if you are up for another experiment, I'd like to see what happens
>> if you disable VT-d.  Maybe it is a misconfigured iommu table that is
>> blocking the engine's access to memory?
>
> You mean disable VT-d in kernel config or the BIOS?

I was thinking in the BIOS, but appending iommu=off to the kernel 
command-line should also do the trick.

> BTW, I don't know how to disable VT-d in Mac BIOS. It use EFI, then simulate
> a normal BIOS in the boot camp mode to boot Linux.
>
> Another stab in the dark is that, it is Mac. It has some strange SMI interaction
> like TSC drifting even after boot. I notice that in the past.

...but the failure is not intermittent, right?

Where it fell over is a pretty straightforward usage of the dma engine 
and it is failing on the first transaction that the first channel issues 
to memory.  You should be able to 'modprobe ioatdma' after you boot and 
watch it fail again if my suspicion is correct... if the signature 
changes that would also be good to know.

--
Dan
