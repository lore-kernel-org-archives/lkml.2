Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0DYR1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:27:45 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:47411 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0DYR1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eCltbjF8i1+38KhXRhNNcwAnZSWl2ulzQf8tBzRVi2VeqorSX4I8yZ4ICuikksUhSz
         oKO0L0kvUdyWctt2zM2FMOQwcTIpc7/FH0//1SL09Rr2gHo1mTGmlH2u4ml8hGI7scfJ
         HG03xOv8cv4nrP+uUjnuDBQw5sP0UxdTNsETw=
MIME-Version: 1.0
In-Reply-To: <r2x80b317761004250957l66922ba3x3a52b16e800ddf26@mail.gmail.com>
References: <o2l80b317761004250816q17a14763g812d9fbe32d42f80@mail.gmail.com>
	 <4BD4721D.2090202@gmail.com>
	 <r2x80b317761004250957l66922ba3x3a52b16e800ddf26@mail.gmail.com>
Date: Sun, 25 Apr 2010 11:27:42 -0600
Message-ID: <q2n51f3faa71004251027j5c554599lc5c7156535a4b3bc@mail.gmail.com>
Subject: Re: [bug ?] device reported invalid CHS sector 0 / NCQ disabled due 
	to excessive errors
From: Robert Hancock <hancockrwd@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 10:57 AM, Richard Genoud
<richard.genoud@gmail.com> wrote:
> 2010/4/25 Robert Hancock <hancockrwd@gmail.com>:
>> Usually this sort of thing is some kind of hardware problem - either a
>> firmware bug in the drive, or else a SATA link communication problem like a
>> bad cable, or the drives not getting clean power under load.
> I'll try other sata cables, but I'm afraid, like you said, that it's a
> firmware bug...
>
>> The log is missing the detail messages indicating what actually happened -
>> can you post the output from dmesg instead?
> you're right, there's more informations in there :
>
> [    2.701742] ahci 0000:00:1f.2: version 3.0
> [    2.701751]   alloc irq_desc for 21 on node 0
> [    2.701752]   alloc kstat_irqs on node 0
> [    2.701756] ahci 0000:00:1f.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
> [    2.701826]   alloc irq_desc for 35 on node 0
> [    2.701827]   alloc kstat_irqs on node 0
> [    2.701833] ahci 0000:00:1f.2: irq 35 for MSI/MSI-X
> [    2.701855] ahci: SSS flag set, parallel bus scan disabled
> [    2.719878] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3
> Gbps 0x3f impl SATA mode
> [    2.719947] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
> clo pmp pio slum part ems
> [    2.720011] ahci 0000:00:1f.2: setting latency timer to 64
> [    2.819723] scsi0 : ahci
> [    2.819817] scsi1 : ahci
> [    2.819888] scsi2 : ahci
> [    2.819960] scsi3 : ahci
> [    2.820034] scsi4 : ahci
> [    2.820104] scsi5 : ahci
> [    2.820226] ata1: SATA max UDMA/133 abar m2048@0xfbaf7000 port
> 0xfbaf7100 irq 35
> [    2.820288] ata2: SATA max UDMA/133 abar m2048@0xfbaf7000 port
> 0xfbaf7180 irq 35
> [    2.820349] ata3: SATA max UDMA/133 abar m2048@0xfbaf7000 port
> 0xfbaf7200 irq 35
> [    2.820411] ata4: SATA max UDMA/133 abar m2048@0xfbaf7000 port
> 0xfbaf7280 irq 35
> [    2.820472] ata5: SATA max UDMA/133 abar m2048@0xfbaf7000 port
> 0xfbaf7300 irq 35
> [    2.820534] ata6: SATA max UDMA/133 abar m2048@0xfbaf7000 port
> 0xfbaf7380 irq 35
> [    2.820630] ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    2.839665] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3
> Gbps 0x3 impl SATA mode
> [    2.839736] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio
> [    2.839787] ahci 0000:03:00.0: setting latency timer to 64
> [    2.839869] scsi6 : ahci
> [    2.839939] scsi7 : ahci
> [    2.840024] ata7: SATA max UDMA/133 abar m8192@0xfbdfa000 port
> 0xfbdfa100 irq 18
> [    2.840086] ata8: SATA max UDMA/133 abar m8192@0xfbdfa000 port
> 0xfbdfa180 irq 18
> [    3.348939] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.366808] ata1.00: ATA-7: HDS728080PLA380, PF2OA60A, max UDMA/133
> [    3.366869] ata1.00: 160836480 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    3.368030] ata1.00: configured for UDMA/133
> [    4.317329] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.338405] ata2.00: ATA-7: HDS728080PLA380, PF2OA60A, max UDMA/133
> [    4.338466] ata2.00: 160836480 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.339643] ata2.00: configured for UDMA/133
> [    5.285674] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    5.305917] ata3.00: ATA-8: Hitachi HDP725050GLA360, GM4OA5CA, max UDMA/133
> [    5.305979] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    5.307132] ata3.00: configured for UDMA/133
> [    5.675046] ata4: SATA link down (SStatus 0 SControl 300)
> [    6.044399] ata5: SATA link down (SStatus 0 SControl 300)
> [    6.413775] ata6: SATA link down (SStatus 0 SControl 300)
..

> [16840.450530] ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
> [16840.450535] ata1.00: cmd 61/b8:00:20:d5:8b/02:00:05:00:00/40 tag 0
> ncq 356352 out
> [16840.450536]          res 40/00:00:00:4f:c2/00:01:00:00:00/00 Emask
> 0x4 (timeout)
> [16840.450538] ata1.00: status: { DRDY }
> [16840.450541] ata1.00: cmd 61/80:08:99:bd:86/01:00:09:00:00/40 tag 1
> ncq 196608 out
> [16840.450542]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [16840.450543] ata1.00: status: { DRDY }
> [16840.450546] ata1: hard resetting link
> [16840.978820] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [16840.981055] ata1.00: configured for UDMA/133
> [16840.981064] ata1.00: device reported invalid CHS sector 0
> [16840.981069] ata1.00: device reported invalid CHS sector 0
> [16840.981078] ata1: EH complete

Looks like it's only happening on one of the drives, I'd suspect
there's some kind of drive fault or power problem specific to that
one..
