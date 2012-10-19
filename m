Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2JSTU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:20:28 -0400
Received: from nm16-vm3.bullet.mail.gq1.yahoo.com ([98.137.177.251]:36346 "EHLO
	nm16-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756843Ab2JSTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:20:26 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2012 15:20:26 EDT
X-Yahoo-Newman-Id: 942086.78942.bm@smtp101.rog.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hhEN0kIVM1loRJFNieR7sZKZEkQerlaZTJKnvA_nlTNqjr1
 Wy3IaIIE_Y_1nCWbxBMK0qrQ1hDrM5haPKxOATw1iqn67iG77IsSS_XrbeAy
 y4cCILv5On9jAKo_mXaUW8t7mVIvGhJccs0RSUaERbtiWzdUyJi.bK7cQZxH
 Ax6yFzBRgAzXPIXWYRJhWipWlH.m8BEpsqm7NhsZgUjMjTLSRj8hbHt2LgPj
 uxsZ8co6506h4vWodG1FAjLpzqgD15OP57c0FsK6uukuXB1EWTs5Zbu1LAr2
 S49zs1BBJ7J6sjfxOX7u1mlVZuhWe9DGTgax2GAeOdjNU2W4o48lUN9lqt2U
 DkgJukjWqUC6JpUnKQ1W2k4j6YcipqlC45csm5r_n7zAm6l0jMDG0BTN_sse
 gHHKx4JnKajta_3LfxNpEXMFGOxc3Zsbb1SLh41LbAQT8BYTOoeRkUXx28Zl
 n9fYXW7T1sn3ZnWVMUJoYN1qCZk8IIx7AFhDrLUtosQ44w.NVAw--
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [3.6.x][e1000e] - Regression - Unable to receive packets if MTU == 1500
Date: Fri, 19 Oct 2012 15:14:27 -0400
Message-ID: <2991283.pW8E6b5cIe@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.9.2 (Linux/3.6.2-2.fc18.x86_64; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel folks,

I recently decided to reinstall my Lenovo W500 laptop and found I wasn't able 
to get DHCP leases, I wasn't able to install over PXE (when getting the IP a 
second time within the OS)

Fedora is currently using kernel-3.6.2-2.fc18.x86_64 (Pre-beta)

The only difference I noticed was in my old install of Fedora, I had added 
MTU=9000 to the interface config while using a 3.5 kernel, not knowing 3.6.x 
seems to break things.

I have noticed tx unit hang errors sometimes, but not when MTU is above 1500.

PCI info:

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network 
Connection (rev 03)
        Subsystem: Lenovo Device 20ee
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 46
        Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at fc025000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at 1840 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 41a2
        Capabilities: [e0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: e1000e

e1000e conversation log:

[   12.653816] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[   12.653819] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   12.653855] e1000e 0000:00:19.0: setting latency timer to 64
[   12.653938] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set 
to dynamic conservative mode
[   12.653980] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   12.844121] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 
00:22:68:0c:96:e3
[   12.844124] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   12.844150] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[   17.459570] e1000e 0000:00:19.0: eth0: changing MTU from 1500 to 9000
[   17.459577] e1000e 0000:00:19.0: Interrupt Throttle Rate turned off
[   17.948121] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   18.049164] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   20.442936] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: Rx/Tx

When I set MTU = 1500 (2000 works), it will stop receiving packets, it also 
disables Interrupt Throttling when MTU is set higher.

After testing reasons why it wasn't get a DHCP lease, I decided to bump the 
MTU to 9000 for Jumbo Frames and as soon as I did this, I was able to get a 
lease and the network functioned.

Can anyone else report regressions?

Thanks,
Shawn.

