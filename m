Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab0HUTyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:54:09 -0400
Received: from many.many.be ([94.23.232.144]:36043 "EHLO many.many.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0HUTyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:54:08 -0400
Message-ID: <4C70301C.6090607@jungers.net>
Date: Sat, 21 Aug 2010 21:59:24 +0200
From: Nicolas Jungers <nicolas@jungers.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0pre Thunderbird/3.0.6
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: possible esata regression in 2.6.35
References: <4C702070.5020809@jungers.net> <4C702554.4040005@teksavvy.com>
In-Reply-To: <4C702554.4040005@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2010 09:13 PM, Mark Lord wrote:
> On 10-08-21 02:52 PM, Nicolas Jungers wrote:
>> My arm box doesn't succeed to use my esata port multiplier (addonics
>> sil3726 based). It was working well with 2.6.34.1 and 2.6.34.4 but not
>> with both 2.6.35.2 and 2.6.35.3. I haven't test other kernels.
>>
>> The kernels are from http://sheeva.with-linux.com/sheeva/ with for
>> example the following config
>> http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config
>>
>> The symptoms are in the console a loop on the esata links. Here is the
>> start of it:
>>
>> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
>> ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
>> ata2: SError: { PHYRdyChg DevExch }
>> ata2: hard resetting link
>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
>> ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> ata2.00: hard resetting link
>> ata2.01: hard resetting link
>> ata2.02: hard resetting link
>> ata2.03: hard resetting link
>> ata2.04: hard resetting link
>> ata2.05: hard resetting link
>> ata2.00: qc timeout (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2.15: hard resetting link
>> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
>> ata2.00: hard resetting link
>> ata2.01: hard resetting link
>> ata2.02: hard resetting link
>> ata2.04: hard resetting link
>> ata2.05: hard resetting link
>> ata2.00: qc timeout (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2.15: hard resetting link
>> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
>> ata2.00: hard resetting link
>> ata2.01: hard resetting link
>> ata2.02: hard resetting link
>> ata2.03: hard resetting link
>> ata2.04: hard resetting link
>> ata2.05: hard resetting link
>> ata2.00: qc timeout (cmd 0xec)
>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>> ata2.00: failed to recover link after 3 tries, disabling
>> ata2.15: hard resetting link
>> ata2.15: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
> ...
>
>  From the "edma_err" keyword above, we can deduce that you've got this PM
> plugged into a Marvell SATA controller of some kind, managed by sata_mv.
> Care to tell us more?

sorry, I'm deep into it, so it's too obvious for me.  Yes, it's he 
marvell plug computer (esata sheevaplug), kirkwood platform with indeed 
the sata_mv module taking care of the sata port.

Start of the boot:

Linux version 2.6.35.3 (kelly@speedy) (gcc version 4.4.3 (Sourcery G++ 
Lite er) ) #1 PREEMPT Fri Aug 20 18:22:29 MDT 2010
CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: Marvell eSATA SheevaPlug Reference Board

and later:

Waiting for /dev to be fully populated...sata_mv sata_mv.0: version 1.28
sata_mv sata_mv.0: slots 32 ports 2
scsi0 : sata_mv
scsi1 : sata_mv
ata1: SATA max UDMA/133 irq 21
ata2: SATA max UDMA/133 irq 21
ata1: SATA link down (SStatus 0 SControl F300)
ata2: SATA link down (SStatus 0 SControl F300)
done.

>
> There are various changes in libata in 2.6.34/35 that break sata_mv,
> particularly for ATAPI drives and any SSDs that support the DSM/TRIM
> commands.
> Do either of those two things apply in your case?

I couldn't tell, but the problem is with the port multiplier.  When I 
directly attach a sata drive, it works.

>
> If so, there are two pending patches which fix them.
> They were posted to linux-ide this past Thursday,
> and can also be found as attachments to this bug report:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=16434

I haven't compiled a kernel in ages, but I'll try that Monday and report.

>
> Cheers

thanks,
N.
