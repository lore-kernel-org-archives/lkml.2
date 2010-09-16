Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0IPSli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:41:38 -0400
Received: from hydra.rus.uni-stuttgart.de ([129.69.1.55]:39925 "EHLO
	hydra.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab0IPSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:41:37 -0400
Message-ID: <4C9264DD.5050903@math.tu-berlin.de>
Date: Thu, 16 Sep 2010 20:41:33 +0200
From: Thomas Richter <thor@math.tu-berlin.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: parport_pc: irq= parameter with limited usefulness, kernel hang
 on PPC/OldWorldMac
References: <4C8F88EC.2020009@math.tu-berlin.de> <3821_1284476021_4C8F8C75_3821_60120_1_20100914161433.55457b6f@lxorguk.ukuu.org.uk>
In-Reply-To: <3821_1284476021_4C8F8C75_3821_60120_1_20100914161433.55457b6f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Alan, hi Ben,

>> *) Under at least 2.6.31 and up, the kernel assigns IRQ 25 to the card. 
>> Under 2.6.28 and below, the card
>> was run in polling mode (i.e. irq was -1, not 25).
>>
>> *) Furthermore, the above report suggests that the system wants to 
>> handle an edge-triggered IRQ, though
>> according to /proc/interrupts, IRQ 25 is level-triggered.
>>     
>
> The parport_pc code just asks for the IRQ so any level/edge mismatch
> would appear to be coming from the firmware or architecture code. The
> older kernel didn't know to use the IRQ on PCI devices which stopped some
> things working and hurt performance. That would also have masked the bug
> you see - so the report makes total sense.
>   

I see, thanks.


>> *) parport_pc should take irq=none seriously and should not silently 
>> override it,
>>     
>
> parport_pc could do with a way to specify whether to use the IRQ or DMA
> on PCI ports but really this shouldn't be needed if the rest of the
> kernel logic is right.
>
>   
>> *) parport_pc should at least not crash the system completely in case 
>> the IRQ is enabled.
>>
>> The latter *might* be an issue with the G3 powermac hardware, which is 
>> of course weird and has a couple of hardware
>>     
>
> The latter looks like a bug in the PPC side support, perhaps misreporting
> an IRQ, or mislabelling it in some way. I think the first step is to find
> a PPC hacker who can figure out why the apparently sane IRQ request from
> the parport layer is exploding.
>
> Even if there is some technical reason the IRQ can't be used then the arch
> code shouldn't be reporting an IRQ for it, and the parport_pc could ought
> to just work.
>
> Adding Ben to the Cc: so we it can get hunted down.
Ben, anything I can do to find this bug? The current state is
"workaround that works ok for me", but that's not very satisfying.

Greetings,
    Thomas


