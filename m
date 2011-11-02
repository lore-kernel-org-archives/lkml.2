Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1KBMJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 08:09:04 -0400
Received: from smtprelay0201.b.hostedemail.com ([64.98.42.201]:35910 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752969Ab1KBMJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 08:09:02 -0400
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 3946
Date: Wed, 2 Nov 2011 12:09:00 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com
Cc: linux-kernel@vger.kernel.org
Message-ID: <1615426146.371527.1320235740785.JavaMail.mail@webmail03>
Subject: About the fix "e1000e: workaround for packet drop on 82579 at
 100Mbps (commit 0ed013e28fe853244f4972cf18d8e2bd62eeb8fc)"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.161.40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm now running Linux 3.0.8 and I still see this issue:

$ ifconfig eth0

eth0   Link encap:Ethernet  HWaddr f4:6d:04:39:XX:XX
          inet addr:192.168.0.1  Bcast:192.168.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:123911 errors:0 dropped:386 overruns:0 frame:0
          TX packets:122441 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:96626066 (92.1 MiB)  TX bytes:15191495 (14.4 MiB)
          Interrupt:18 Memory:fb500000-fb520000

More about this particular onboard NIC (motherboard ASUS P8P67 PRO Rev 3.0)

# lspci -vvv -s 00:19.0

00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network Connection (rev 05)
        Subsystem: ASUSTeK Computer Inc. Device 849c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 49
        Region 0: Memory at fb500000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at fb528000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at f040 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 416a
        Capabilities: [e0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: e1000e
        Kernel modules: e1000e

# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Speed: 100Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 2
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: off
        Supports Wake-on: pumbg
        Wake-on: d
        Current message level: 0x00000001 (1)
                               drv
        Link detected: yes

I'm not absolutely certain about the quality of equipment I'm connected to - so I'd like to know how can I
remove it out of equation.

My Internet connection seemingly works this way:

My_PC -> 16-port unmanageable Ethernet switch -> Cisco Ethernet switch -> Cisco PPPoE concentrator (the
first device I can ping via PPPoE connection)

Best wishes,

Artem
