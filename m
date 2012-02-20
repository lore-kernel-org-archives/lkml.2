Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2BTSCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:02:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48114 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2BTSCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:02:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.gortmaker@gmail.com designates 10.68.212.130 as permitted sender) smtp.mail=paul.gortmaker@gmail.com; dkim=pass header.i=paul.gortmaker@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAD74y4kASzFUK4+5wkysFdZA+LfcPpSs-d4+TByBMHe0J8+fmw@mail.gmail.com>
References: <CAD74y4kASzFUK4+5wkysFdZA+LfcPpSs-d4+TByBMHe0J8+fmw@mail.gmail.com>
Date: Mon, 20 Feb 2012 13:02:30 -0500
Message-ID: <CAP=VYLo+oqs0fH=GexhbjNQ8wCwWDr-UUp7zVURHiFrPi8KLiw@mail.gmail.com>
Subject: Re: realtek NIC constantly hanging up
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: Georgi Kehaiov <kehaiov.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 9:42 AM, Georgi Kehaiov
<kehaiov.lkml@googlemail.com> wrote:
> Hello everyone,
>
> I've got a new gigabyte 970a-ud3 with a built in realtek ethernet
> controller. The problem I'm experiencing is that the network interface
> goes down (kinda... it's still there but I don't seem to receive or
> send any packets at all) and I need to restart my network daemon to
> get networking back on. In couple of minutes/hours the same problem
> occurs again. And then again and again... Sometimes it happens while

I recall reading about some of the ASUS 970 based boards having problems
when IOMMU was enabled in the BIOS -- the rtl would be detected but not
tx/rx packets -- fix was either disable IOMMU and/or install the newest BIOS.

Not sure if that is at all applicable to Gigabyte boards, but I suspect the core
bios code is largely very similar.  What does "dmesg" say after you have an
outage event?

Paul.

> I'm uploading something big (3-4 MB/s), sometimes it just happens when
> I'm playing nethack (next to no traffic at all). I've been browsing
> around for some time now and there are actually some people who've had
> a similair issue. But in my case it has nothing to do with
> 1000T-base-mode or 100T-base-mode - I'm downloading stuff from dc hubs
> with ~100MB/s. I have tried both the r8168 and r8169 drivers - it
> doesn't matter, the problem keeps occuring.
>
> Some info:
>
>  lspci -vvv
> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
>         Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort+
> <TAbort+ <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 43
>         Region 0: I/O ports at ee00 [size=256]
>         Region 2: Memory at fdbff000 (64-bit, prefetchable) [size=4K]
>         Region 4: Memory at fdbf8000 (64-bit, prefetchable) [size=16K]
>         Capabilities: <access denied>
>         Kernel driver in use: r8168
>  uname -a
> Linux imladris 3.2.5-1-ARCH #1 SMP PREEMPT Tue Feb 7 08:34:36 CET 2012
> x86_64 AMD Phenom(tm) II X4 960T Processor AuthenticAMD GNU/Linux
>
>  ethtool eth0
> Settings for eth0:
>         Supported ports: [ TP ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>         Supported pause frame use: No
>         Supports auto-negotiation: Yes
>         Advertised link modes:  10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>         Advertised pause frame use: Symmetric Receive-only
>         Advertised auto-negotiation: Yes
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: Twisted Pair
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: on
>         MDI-X: Unknown
>         Supports Wake-on: pumbg
>         Wake-on: g
>         Current message level: 0x00000033 (51)
>                                drv probe ifdown ifup
>         Link detected: yes
> my current dmesg: http://paste.pocoo.org/show/550817/
> my current lsmod: http://paste.pocoo.org/show/550820/
>
>
> I'm completely clueless here, so if anyone can help me out on this it
> would be awesome.
> Best Regards,
> Georgi Kehaiov
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
