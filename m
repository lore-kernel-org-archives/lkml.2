Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab0I0NhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:37:20 -0400
Received: from smtp.kponet.fi ([213.145.209.38]:35437 "EHLO smtp.kponet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0I0NhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:37:18 -0400
X-Greylist: delayed 1060 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 09:37:18 EDT
Date: Mon, 27 Sep 2010 16:19:35 +0300
From: Sami Farin <hvtaifwkbgefbaei@gmail.com>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net
Cc: Sami Farin <hvtaifwkbgefbaei@gmail.com>
Subject: Linux 2.6.35.6/e1000e does not receive replies from DHCP server,
 2.6.33 works
Message-ID: <20100927131935.d5f2ghpfaufiq6yx@m.safari.iki.fi>
Mail-Followup-To: Sami Farin <hvtaifwkbgefbaei@gmail.com>,
	linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi (please Cc:),

With 2.6.33 I could reliably get IP address from ISP's DHCP server,
but when I upgraded to 2.6.35, it just does not work anymore.
ISP's technicians verified that from their end, they see my DHCP Request
packets and they send the DHCP ACK packet, but my Linux just does not
see the ACKs.  I have been running tcpdump to verify this.
Technician got DHCP connection up just fine with a Windows system.
I am using Telewell TW-EA501.
Also, sometimes changing MAC addresses of the Intel NIC back and forth
makes DHCP work.

Three days ago with 2.6.35.5, dhclient sent quite a many packets
in eight hours, but received only one DHCP ACK packet, and
then it failed to get ARP reply, so dhclient did not succeed in
getting connection up.

Now I tried 2.6.35.6 with latest e1000e version from Linux git
32163f4b2cef28a5aab8b226ffecfc6379a53786, and DHCP ACK was received
just fine.  e1000e from 2.6.35.1 did not work any better than 2.6.35.6.
Combination kernel 2.6.35.6 + e1000e from 2.6.33 did not compile.

So, what changed 2.6.35.6 --> Git in e1000e driver?
If that is what's the problem..

I have Intel DQ965GF motherboard.

the dmesg is the same, whether it works or not..

[ 6759.184351] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[ 6759.184357] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[ 6759.184413] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 6759.184426] e1000e 0000:00:19.0: setting latency timer to 64
[ 6759.184714] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 6759.415542] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:19:d1:00:5f:01
[ 6759.415548] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[ 6759.415579] e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: ffffff-0ff
[ 6759.946202] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 6759.997053] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
...
[ 7506.674005] eth0: no IPv6 routers present
[ 7530.742331] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 7530.793171] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[ 7530.793813] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 7532.160896] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[ 7532.161539] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 7532.566537] eth0: IPv6 duplicate address fe80::219:d1ff:fe00:5f01 detected!

# grep eth0 /proc/interrupts 
 46:    1044515          0   PCI-MSI-edge      eth0

lspci
00:19.0 Ethernet controller: Intel Corporation 82566DM Gigabit Network Connection (rev 02)
        Subsystem: Intel Corporation Device 0001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 46
        Region 0: Memory at d0300000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at d0324000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at 20e0 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 418b
        Kernel driver in use: e1000e
        Kernel modules: e1000e
00: 86 80 4a 10 07 04 10 00 02 00 00 02 00 00 00 00
10: 00 00 30 d0 00 40 32 d0 e1 20 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 01 00
30: 00 00 00 00 c8 00 00 00 00 00 00 00 09 01 00 00

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
        PHYAD: 1
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: off
        Supports Wake-on: pumbag
        Wake-on: g
        Current message level: 0x00000001 (1)
        Link detected: yes

-- 
Do what you love because life is too short for anything else.

