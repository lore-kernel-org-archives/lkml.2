Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2AYJ2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:28:53 -0500
Received: from straum.hexapodia.org ([207.7.131.186]:56737 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2AYJ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:28:49 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 04:28:49 EST
Date: Wed, 25 Jan 2012 01:21:01 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net
Subject: e1000e: repeated eth0: Error reading PHY register
Message-ID: <20120125092101.GA10626@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Thinkpad X201s running 3.3-rc1 I'm seeing bursts of these:

[ 1270.207370] e1000e 0000:00:19.0: eth0: Error reading PHY register
[ 1271.003042] e1000e 0000:00:19.0: eth0: Error reading PHY register
[ 1271.798896] e1000e 0000:00:19.0: eth0: Error reading PHY register
[ 1272.595324] e1000e 0000:00:19.0: eth0: Error reading PHY register

I've been seeing these messages for a few kernel versions, but
unfortunately due to a hardware failure I don't have kernels further
back than 3.0.  I'm pretty sure this didn't happen on 2.6.38.

There are nearly always exactly 12 messages (I have one log sequence
where there are only 5, out of 110 occurrences), and they come every 300
seconds during some period, then they go away for a long time, then come
back with no clear cause.

% dmesg | grep PHY | uniq -w4 -c
 25 [    1.253783] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: A002FF-0FF
 12 [  370.314165] e1000e 0000:00:19.0: eth0: Error reading PHY register
 12 [  670.201544] e1000e 0000:00:19.0: eth0: Error reading PHY register
 12 [  970.045374] e1000e 0000:00:19.0: eth0: Error reading PHY register
 12 [ 1270.207370] e1000e 0000:00:19.0: eth0: Error reading PHY register
 12 [ 1570.031407] e1000e 0000:00:19.0: eth0: Error reading PHY register

(the clock is currently at 3636.)

The machine is on and off of AC power, and suspended with "sudo
pm-suspend" then resumed, on a regular basis; there doesn't seem to be
any clear correlation.

There's nothing plugged into the ethernet jack when this happens.  (I
don't use wired ethernet often enough to be sure if it happens when the
wire is connected; there doesn't seem to be any impact on
functionality on the rare occasion I do use it.)

% sudo ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Speed: Unknown!
        Duplex: Unknown! (255)
        Port: Twisted Pair
        PHYAD: 2
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: Unknown
        Supports Wake-on: pumbg
        Wake-on: d
        Current message level: 0x00000001 (1)
                               drv
        Link detected: no

% sudo lspci -vvvs 0:19
00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Connection (rev 06)
        Subsystem: Lenovo Device 2153
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 40
        Region 0: Memory at f2500000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at f2525000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at 1820 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0f00c  Data: 4149
        Capabilities: [e0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: e1000e


Full dmesg at http://web.hexapodia.org/~adi/snow/dmesg-3.3.0-rc1

Thanks,
-andy
