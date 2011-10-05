Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572Ab1JEMUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:20:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57104 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab1JEMUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:20:09 -0400
Message-ID: <4E8C4B74.5040200@suse.cz>
Date: Wed, 05 Oct 2011 14:20:04 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: wim@iguana.be
CC: linux-watchdog@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: WATCHDOG: 28d41f53f broke temperature sensors
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 28d41f53f05c51d4f445129de325b1072ee25b8b
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Nov 19 22:25:53 2008 +0000

    [WATCHDOG] iTCO_wdt: add PCI ID's for ICH9 & ICH10 chipsets

breaks temperature sensor of CPU on an ICH10 chipset. After the module
is loaded, it is just stuck with one value.

All is working unless this is performed in iTCO_wdt_init:
        /* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
        val32 = inl(SMI_EN);
        val32 &= 0xffffdfff;    /* Turn off SMI clearing watchdog */
        outl(val32, SMI_EN);



The LPC device in question:
00:1f.0 ISA bridge [0601]: Intel Corporation 82801JIR (ICH10R) LPC
Interface Controller [8086:3a16]
	Subsystem: Intel Corporation Device [8086:3a18]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt
00: 86 80 16 3a 07 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 18 3a
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 10 00 00 80 00 00 00 81 11 00 00 10 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 85 8a 8b 87 d0 00 00 00 80 80 80 80 f8 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 10 00 0f 3c 00 00 00 00 01 08 fc 00 b1 02 fc 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: a0 06 00 00 08 02 80 00 13 1c 0a 00 00 03 00 c0
b0: 00 00 f0 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 33 22 11 00 67 45 00 00 cf ff 00 00 00 00 00 00
e0: 09 00 0c 10 01 00 c4 02 64 02 00 00 00 00 00 00
f0: 01 c0 d1 fe 00 00 00 00 86 0f 00 00 00 00 00 00



This happened after switch from 2.6.27 to 2.6.32. I tried also the TCO
wdt module from upstream on 2.6.32 with no change. Now I'm going to test
a 3.1-rc kernel. But I don't think it will change anything...

Also I don't know the code and don't know much how these things work.
I've just investigated the reason. So if you need some more info, let me
know.

thanks,
-- 
js
suse labs
