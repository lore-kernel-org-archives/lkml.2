Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab2BNOmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:42:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46269 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2BNOmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:42:16 -0500
MIME-Version: 1.0
Date: Tue, 14 Feb 2012 15:42:16 +0100
Message-ID: <CAD74y4kASzFUK4+5wkysFdZA+LfcPpSs-d4+TByBMHe0J8+fmw@mail.gmail.com>
Subject: realtek NIC constantly hanging up
From: Georgi Kehaiov <kehaiov.lkml@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I've got a new gigabyte 970a-ud3 with a built in realtek ethernet
controller. The problem I'm experiencing is that the network interface
goes down (kinda... it's still there but I don't seem to receive or
send any packets at all) and I need to restart my network daemon to
get networking back on. In couple of minutes/hours the same problem
occurs again. And then again and again... Sometimes it happens while
I'm uploading something big (3-4 MB/s), sometimes it just happens when
I'm playing nethack (next to no traffic at all). I've been browsing
around for some time now and there are actually some people who've had
a similair issue. But in my case it has nothing to do with
1000T-base-mode or 100T-base-mode - I'm downloading stuff from dc hubs
with ~100MB/s. I have tried both the r8168 and r8169 drivers - it
doesn't matter, the problem keeps occuring.

Some info:

 lspci -vvv
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
        Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+
<TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 43
        Region 0: I/O ports at ee00 [size=256]
        Region 2: Memory at fdbff000 (64-bit, prefetchable) [size=4K]
        Region 4: Memory at fdbf8000 (64-bit, prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: r8168
 uname -a
Linux imladris 3.2.5-1-ARCH #1 SMP PREEMPT Tue Feb 7 08:34:36 CET 2012
x86_64 AMD Phenom(tm) II X4 960T Processor AuthenticAMD GNU/Linux

 ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: Unknown
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000033 (51)
                               drv probe ifdown ifup
        Link detected: yes
my current dmesg: http://paste.pocoo.org/show/550817/
my current lsmod: http://paste.pocoo.org/show/550820/


I'm completely clueless here, so if anyone can help me out on this it
would be awesome.
Best Regards,
Georgi Kehaiov
