Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1ANR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:56:18 -0500
Received: from smtp208.alice.it ([82.57.200.104]:51994 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab1ANR4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:56:13 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 12:56:12 EST
From: Alberto Mattea <alberto@mattea.info>
To: linux-kernel@vger.kernel.org
Subject: sata_nv silently ignores discard (TRIM) command?
Date: Fri, 14 Jan 2011 18:50:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-020637-generic; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101141850.25252@alby>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all.
I'm testing linux 2.6.37 final with a Crucial RealSSD C300 (256GB).
The chipset is a nforce 570 (M2N32-SLI Deluxe); lspci:
IDE interface [0101]: nVidia Corporation MCP55 SATA Controller [10de:037f] 
(rev a2) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Device [1043:cb84]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin C routed to IRQ 21
        Region 0: I/O ports at f200 [size=8]
        Region 1: I/O ports at f100 [size=4]
        Region 2: I/O ports at f000 [size=8]
        Region 3: I/O ports at ef00 [size=4]
        Region 4: I/O ports at ee00 [size=16]
        Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+
        Kernel driver in use: sata_nv
        Kernel modules: sata_nv

On the device there is a single ext4 partition, mounted with -o discard. 
Dmesg:
EXT4-fs (sda1): re-mounted. Opts: errors=remount-
ro,discard,data=writeback,commit=0

To test whether TRIM is working, I did the following:
# dd if=/dev/urandom of=tempfile count=100 bs=512k oflag=direct
# hdparm --fibmap tempfile
(File begins at 66090496)
# hdparm --read-sector 66090496 /dev/sda
(Random data)
# rm tempfile
# sync
# hdparm --read-sector 66090496 /dev/sda
Now, if I'm correct after a successful TRIM the last command should output all 
zeroes, but exactly the same random data is reported instead. However, there 
is nothing in dmesg about TRIM failing. Does sata_nv support TRIM on the 570?
Thanks
Alberto
