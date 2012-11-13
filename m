Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2KMWIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:08:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35304 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2KMWIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:08:16 -0500
From: Dimitar Popov <dimitar.georgiev.popov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: DMA Errors from SATA Controller with 4G Memory Remapping Enabled
Date: Tue, 13 Nov 2012 23:08:07 +0100
Message-ID: <1871872.oE0GX69FUF@darkstar>
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have an old computer with motherboard ASUS SK8N with AMD Opteron 148 and 4 
GiB of DDR400. There is an onboard SATA Promise RAID controller working in IDE 
mode (i.e. not as RAID controller) with 2 SATA disks. In order to use all 4 
GiB RAM I need to enable the "4G Memory Remapping" option from the BIOS. 
However, if I do that I receive the following errors:

ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: failed command: WRITE DMA
[136B blob data]
ata2.00: status: { DRDY }
ata2: hard resetting link
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/133
ata2.00: device reported invalid CHS sector 0
sd 1:0:0:0: [sdb]  
Result: hostbyte=0x00 driverbyte=0x08
sd 1:0:0:0: [sdb]  
Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        00 00 00 00 
sd 1:0:0:0: [sdb]  
ASC=0x0 ASCQ=0x0
sd 1:0:0:0: [sdb] CDB: 
cdb[0]=0x2a: 2a 00 00 2a 63 f0 00 00 08 00
end_request: I/O error, dev sdb, sector 2778096
btrfs: bdev /dev/sdb6 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
ata2: EH complete

I don't know if it is a bug in the BIOS or a kernel bug. Here some info (I'll 
provide further info, if needed):

$ uname -a
Linux darkstar 3.6.6-1-ARCH #1 SMP PREEMPT Mon Nov 5 11:57:22 CET 2012 x86_64 
GNU/Linux

01:08.0 RAID bus controller: Promise Technology, Inc. PDC20378 (FastTrak 
378/SATA 378) (rev 02)
        Subsystem: ASUSTeK Computer Inc. K8V Deluxe/PC-DL Deluxe motherboard
        Flags: bus master, 66MHz, medium devsel, latency 96, IRQ 19
        I/O ports at dc00 [size=64]
        I/O ports at d800 [size=16]
        I/O ports at d400 [size=128]
        Memory at fa9ff000 (32-bit, non-prefetchable) [size=4K]
        Memory at fa9c0000 (32-bit, non-prefetchable) [size=128K]
        Capabilities: [60] Power Management version 2
        Kernel driver in use: sata_promise

Thank you in advance!

Regards,
Dimitar
