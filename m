Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1K1Rre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:47:34 -0500
Received: from postino.bo.infn.it ([131.154.11.5]:55991 "EHLO
	postino.bo.infn.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1K1Rrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:47:33 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 12:47:32 EST
Date: Mon, 28 Nov 2011 18:39:36 +0100 (CET)
From: Stefano Laporta <Stefano.Laporta@bo.infn.it>
To: linux-kernel@vger.kernel.org
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: 3.1.3 2.6.37.6 2.6.33.4 kernel bug in pata_oldpiix driver
Message-ID: <alpine.LNX.2.00.1111281823440.12891@g-3.bo.infn.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1702650358-640012607-1322501976=:12891"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (postino.bo.infn.it [131.154.11.5]); Mon, 28 Nov 2011 18:37:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1702650358-640012607-1322501976=:12891
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

I have discovered a bug in the oldpiix pata driver in kernels 2.6.33.4 and
2.6.37.6 from installation CD of Slackware 13.1 and 13.37. 
The pc is a  Pentium 133MHz, 64MB RAM, mainboard Freeway 586F61-PB, Chipset i430fx Intel
Triton I,  80GB IDE HD Hitachi. Memtest is OK.
The bug is repeatable, and stable under many kernel configuration changes.
The error messages are all very similar. 
Changing the config of 2.6.37.6 from  "Voluntary Kernel Preemption (Desktop)"
to "No Forced Preemption (Server)" the bug *apparently* disappears.
Actually it reappears making subsequent changes to config, e.g.
deleting drivers.

The bug does not appear in 2.6.38.7, 2.6.39.4, 3.2.0rc3.
But reappears in 3.1.3.   (all these one compiled with GCC 4.4.4)

For safety's sake, I have switched back from PATA to the oldpiix IDE driver. 
No problem from IDE driver, for years the machine ran 2.4.29 flawlessy.

I append here only the relevant error trace and lspci output. 
I attach also a tar file containing complete dmesg (through serial port) and 
configs of kernels 2.6.37.6, 2.6.33.4, and 3.1.3.

Hope it helps.

Stefano Laporta

------------------------------------------------------------------------
error trace from 2.6.37.6 
------------------------------------------------------------------------
BUG: unable to handle kernel paging request at 45230451
IP: [<c17bb1f3>] oldpiix_set_dmamode+0xb3/0x120
*pde = 00000000 
Oops: 0000 [#1] 
last sysfs file: 
Modules linked in:

Pid: 878, comm: scsi_eh_2 Not tainted 2.6.37.6 #2 
EIP: 0060:[<c17bb1f3>] EFLAGS: 00010006 CPU: 0
EIP is at oldpiix_set_dmamode+0xb3/0x120
EAX: 0000800f EBX: c3f9d6e0 ECX: c1c06dd8 EDX: c1c06dd8
ESI: 00000040 EDI: c3f9c000 EBP: c3fa9ccc ESP: c3fa9c9c
  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process scsi_eh_2 (pid: 878, ti=c3fa8000 task=c3fdc000 task.ti=c3fa8000)
Stack:
  c3fa9cbe c30b9600 c1c06dd8 c1c06de0 c302bc00 00000008 0000000b 0000000c
  8004cccc c3f9d6e0 c3f9d3a0 c3f9c000 c3fa9ce0 c17bb3b0 c3f9d3a0 c3f9c000
  00000000 c3fa9d1c c1788d8a fffba7fa c3fa9d14 c1d22800 c3fa9d58 c19802da
Call Trace:
  [<c17bb3b0>] ? oldpiix_qc_issue+0x40/0x60
  [<c1788d8a>] ? ata_qc_issue+0x1ea/0x330
  [<c19802da>] ? schedule_timeout+0x10a/0x230
  [<c1789192>] ? ata_exec_internal_sg+0x2c2/0x4f0
  [<c1798c90>] ? ata_sff_check_status+0x10/0x20
  [<c1798a03>] ? ata_sff_check_ready+0x13/0x30
  [<c1789424>] ? ata_exec_internal+0x64/0x90
  [<c178950d>] ? ata_do_dev_read_id+0x2d/0x30
  [<c17897fc>] ? ata_dev_read_id+0x2ec/0x560
  [<c17965ef>] ? ata_eh_recover+0x69f/0x1300
  [<c1799d40>] ? ata_sff_postreset+0x0/0x90
  [<c1799d40>] ? ata_sff_postreset+0x0/0x90
  [<c179a4d0>] ? ata_sff_softreset+0x0/0x1a0
  [<c17bb0e0>] ? oldpiix_pre_reset+0x0/0x60
  [<c102e7d6>] ? dequeue_task_fair+0x46/0x50
  [<c179a4d0>] ? ata_sff_softreset+0x0/0x1a0
  [<c17bb0e0>] ? oldpiix_pre_reset+0x0/0x60
  [<c179a4d0>] ? ata_sff_softreset+0x0/0x1a0
  [<c1797a00>] ? ata_do_eh+0x40/0xb0
  [<c1799d40>] ? ata_sff_postreset+0x0/0x90
  [<c179a4d0>] ? ata_sff_softreset+0x0/0x1a0
  [<c1799b8a>] ? ata_sff_error_handler+0x9a/0xe0
  [<c1799d40>] ? ata_sff_postreset+0x0/0x90
  [<c1799c46>] ? ata_bmdma_error_handler+0x76/0x100
  [<c179771c>] ? ata_scsi_error+0x3fc/0x6a0
  [<c1029556>] ? check_preempt_curr+0x76/0x90
  [<c1573f34>] ? scsi_error_handler+0x84/0x380
  [<c102c8f0>] ? default_wake_function+0x10/0x20
  [<c1029078>] ? __wake_up_common+0x48/0x70
  [<c1573eb0>] ? scsi_error_handler+0x0/0x380
  [<c1573eb0>] ? scsi_error_handler+0x0/0x380
  [<c10503f4>] ? kthread+0x74/0x80
  [<c1050380>] ? kthread+0x0/0x80
  [<c1003546>] ? kernel_thread_helper+0x6/0x10
Code: 45 dc 8d 14 95 03 00 00 00 76 03 83 ca 08 8b 43 04 85 c0 74 6b 89 d0 0f b7 55 f2 c1 e0 04 66 81 e2 0e cc 09 d0 8b 55 d8 8b 4d d8 <0f> b6 94 12 a1 28 a2 c1 c1 e2 08 89 55 dc 0f b6 94 09 a0 28 a2 
EIP: [<c17bb1f3>] oldpiix_set_dmamode+0xb3/0x120 SS:ESP 0068:c3fa9c9c
CR2: 0000000045230451
---[ end trace 5c1353daa3433c2c ]---

------------------------------------------------------------------------
machine informations  (obtained booting 2.6.39.4 with pata driver)
--------------------------------------------------------------------------

root@slackware:/# lspci -vvxxx[J
00:00.0 Host bridge: Intel Corporation 430FX - 82437FX TSC [Triton I] (rev 02)
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
 	Latency: 32
00: 86 80 2d 12 06 00 00 22 02 00 00 06 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 49 00 23 00 00 00 00 03 2a 10 55 00 00 00 00 00
60: 08 08 10 10 10 00 00 00 01 00 00 00 00 00 00 00
70: 00 00 0a 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 00 00

00:07.0 ISA bridge: Intel Corporation 82371FB PIIX ISA [Triton I] (rev 02)
 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
00: 86 80 2e 12 0f 00 80 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 5f 00 a3 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 0b 80 0a 80 00 00 00 00 00 f2 04 00 00 00 00 00
70: 0f 07 00 00 00 00 04 04 02 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 00 00 00 02 00 00 00 0f 00 00 00 08 00 01 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 0f 00 00 00 00 00 00

00:07.1 IDE interface: Intel Corporation 82371FB PIIX IDE [Triton I] (rev 02) (prog-if 80 [Master])
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 32
 	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
 	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
 	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
 	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
 	Region 4: I/O ports at 3000 [size=16]
 	Kernel driver in use: pata_oldpiix
00: 86 80 30 12 05 00 80 02 02 80 01 01 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 07 a3 30 a3 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 0f 00 00 00 00 00 00

00:0e.0 VGA compatible controller: S3 Inc. 86c325 [ViRGE] (rev 06) (prog-if 00 [VGA controller])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 32 (1000ns min, 63750ns max)
 	Interrupt: pin A routed to IRQ 10
 	Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=64M]
 	[virtual] Expansion ROM at 04040000 [disabled] [size=64K]
00: 33 53 31 56 07 00 00 02 06 00 00 03 00 20 00 00
10: 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 04 ff
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.0 Ethernet controller: Davicom Semiconductor, Inc. 21x4x DEC-Tulip compatible 10/100 Ethernet (rev 31)
 	Subsystem: Device 4554:434e
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 32 (5000ns min, 10000ns max)
 	Interrupt: pin A routed to IRQ 11
 	Region 0: I/O ports at 6000 [size=256]
 	Region 1: Memory at f4000000 (32-bit, non-prefetchable) [size=256]
 	[virtual] Expansion ROM at 04000000 [disabled] [size=256K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=220mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
00: 82 12 02 91 07 00 10 02 31 00 00 02 00 20 00 00
10: 01 60 00 00 00 00 00 f4 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 54 45 4e 43
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 14 28
40: 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 12 f9 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

root@slackware:/# 
root@slackware:/# lspci -vvxxx[J
00:00.0 Host bridge: Intel Corporation 430FX - 82437FX TSC [Triton I] (rev 02)
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
 	Latency: 32
00: 86 80 2d 12 06 00 00 22 02 00 00 06 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 49 00 23 00 00 00 00 03 2a 10 55 00 00 00 00 00
60: 08 08 10 10 10 00 00 00 01 00 00 00 00 00 00 00
70: 00 00 0a 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 00 00

00:07.0 ISA bridge: Intel Corporation 82371FB PIIX ISA [Triton I] (rev 02)
 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
00: 86 80 2e 12 0f 00 80 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 5f 00 a3 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 0b 80 0a 80 00 00 00 00 00 f2 04 00 00 00 00 00
70: 0f 07 00 00 00 00 04 04 02 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 08 00 00 00 02 00 00 00 0f 00 00 00 08 00 01 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 0f 00 00 00 00 00 00

00:07.1 IDE interface: Intel Corporation 82371FB PIIX IDE [Triton I] (rev 02) (prog-if 80 [Master])
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 32
 	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
 	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
 	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
 	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
 	Region 4: I/O ports at 3000 [size=16]
 	Kernel driver in use: pata_oldpiix
00: 86 80 30 12 05 00 80 02 02 80 01 01 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 07 a3 30 a3 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 0f 00 00 00 00 00 00

00:0e.0 VGA compatible controller: S3 Inc. 86c325 [ViRGE] (rev 06) (prog-if 00 [VGA controller])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 32 (1000ns min, 63750ns max)
 	Interrupt: pin A routed to IRQ 10
 	Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=64M]
 	[virtual] Expansion ROM at 04040000 [disabled] [size=64K]
00: 33 53 31 56 07 00 00 02 06 00 00 03 00 20 00 00
10: 00 00 00 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 04 ff
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:10.0 Ethernet controller: Davicom Semiconductor, Inc. 21x4x DEC-Tulip compatible 10/100 Ethernet (rev 31)
 	Subsystem: Device 4554:434e
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 32 (5000ns min, 10000ns max)
 	Interrupt: pin A routed to IRQ 11
 	Region 0: I/O ports at 6000 [size=256]
 	Region 1: Memory at f4000000 (32-bit, non-prefetchable) [size=256]
 	[virtual] Expansion ROM at 04000000 [disabled] [size=256K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=220mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
00: 82 12 02 91 07 00 10 02 31 00 00 02 00 20 00 00
10: 01 60 00 00 00 00 00 f4 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 54 45 4e 43
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 14 28
40: 00 00 00 08 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 12 f9 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


root@slackware:/# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 5
model		: 2
model name	: Pentium 75 - 200
stepping	: 12
cpu MHz		: 133.280
cache size	: 0 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: yes
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr mce cx8
bogomips	: 266.56
clflush size	: 32
cache_alignment	: 32
address sizes	: 32 bits physical, 32 bits virtual
power management:

---1702650358-640012607-1322501976=:12891
Content-Type: APPLICATION/octet-stream; name=oldpiixbug.tar.xz
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.1111281839360.12891@g-3.bo.infn.it>
Content-Description: 
Content-Disposition: attachment; filename=oldpiixbug.tar.xz

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
rhJscUTKo+lUJ1s90MMR9uSpQGa5BQ+rGvxJ/hDmR0EP6KB29wJdroGYMY3B
zuiZfmYBO4niCTbduUjJL5o5bphByVcdnqPPP7qtHXjG66dtcIGYbjUAsea1
CLUC4pcn5O18HnoRFbCjldhrEyYmS9Gt+3x0br4QTt5KStE1Ye3+RC8D7atZ
q0yWcCaOWPKIvumlJVeVhoRC1Myb1CzewOTwciNS/dxLzFFUhfvZj83ak9vi
yNy+/gdMKD11X0g/1zhdcPI8yK1UIL25XRx5VjFPzzLWZDrLdHseszApy8m4
NWteUExxCGI3LomYm5ZEeLwZL+quyadHkguUxoHr2nu8kcDD2iJjlI/8Il1Z
29etZEwDsS04M5JgbI/XLAvAEmEpFRmjRYMZZFwzqDx4KOJLw3Az9IrRQ9xA
Th7CIr7PhG/ynfyzWy9JDdPLQ1QSaKlOmqT60we9z0WeKlW+fbnZTuScX+eG
U9GYDf+sP4JdMEaz0zYCcotJpZgSX3LnkdddWsP+9VlmXuWaohV0ug/f4Jpw
MRlka4jodHdj42OPpFWYg3AYZQ8Bj2Q57K/oLDj8zXr5mnV/9dYeZWuEu/Yc
k0u4ut4oUfTJtK/jhmHv3irVH8ULSmwaMlFOK2RiaQvn1OSrK4E92Mrl3ib4
gZBrKmme6jG9EnbaT55ynnZQCbUCY9tRl2SUa+w7nU+gPizXlZlg9GZQLRCs
L9W4Ho9B8oTXcmgaXkFX7AOsC4lh6GqzB8JJ+CnC4W/cjuRUlLlV4BgSdt4p
nEPcCVojmOrSSVS+U9utozsUcrfOqpwVKFU5nqC0Fyf9I3c09ewXSrd3BRv1
NVebi2cTwlHzLXd+NElpo7TiFR/TRb8ipTpv8zITM4HJMz+HMw0pZX/LtQP/
KHWdJI4MG/Ogvrxqcv7Gv+VSxt3UFhrWR9/bKUlsz+kkrgf+D6PBn2M8Q88X
uhfXeiQQ3moK62Nacv4JJcdk6SnZ7yqJTFzPJZSSyq5CCOSv1ZjLQZJ0Uztu
EFT9Y4WmRrVfa6Ym3w1bKZz89vcPSrOTlq75kpt38U9KZDYb0hvogEDG5DT3
7PMrsgLDUNnX6vOiA4SYK1yEafwM+Gi1eVJqIRGWP10ibtpVV5W7jyl4kKMF
F+V/5WAH/Vrz6lDlBa4VO49nKqwFZU7wiJpOmDzpT6lmBxkok/RWMTOt102j
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
vwABquMCgKAaws3/DLHEZ/sCAAAAAARZWg==

---1702650358-640012607-1322501976=:12891--
