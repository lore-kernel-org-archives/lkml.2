Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0FUKbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:31:46 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:47378 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab0FUKbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:31:44 -0400
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
Date: Mon, 21 Jun 2010 13:31:07 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.31.13-131-pae; KDE/4.4.4; i686; ; )
Cc: stern@rowland.harvard.edu, gregkh@suse.de, rjw@sisk.pl
References: <201006211022.37707.ozan@pardus.org.tr>
In-Reply-To: <201006211022.37707.ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006211331.08010.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pazartesi 21 Haziran 2010 günü (saat 10:22:37) Ozan Çağlayan şunları yazmıştı:
> Hi,
> 
> First of all I know that 2.6.31 is not maintained anymore and I don't know
> if the problem still exists in kernels > 2.6.31 as I don't have any
> hardware to reproduce it.

And also here's some probably interesting warnings available on both machines' dmesg output:

[    0.136578] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    0.136585] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    0.136618] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.136732] pci 0000:00:02.0: reg 10 64bit mmio: [0xf4000000-0xf40fffff]
[    0.136741] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.136748] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.136798] pci 0000:00:02.1: reg 10 64bit mmio: [0xf4100000-0xf41fffff]
[    0.136932] pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
[    0.137029] pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
[    0.137129] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf4704000-0xf47043ff]
[    0.137218] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.137225] pci 0000:00:1a.7: PME# disabled
[    0.137288] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4500000-0xf4503fff]
[    0.137360] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.137365] pci 0000:00:1b.0: PME# disabled
[    0.137464] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.137470] pci 0000:00:1c.0: PME# disabled
[    0.137574] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.137580] pci 0000:00:1c.1: PME# disabled
[    0.137682] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.137687] pci 0000:00:1c.2: PME# disabled
[    0.137764] pci 0000:00:1d.0: reg 20 io port: [0x1860-0x187f]
[    0.137856] pci 0000:00:1d.1: reg 20 io port: [0x1880-0x189f]
[    0.137948] pci 0000:00:1d.2: reg 20 io port: [0x18a0-0x18bf]
[    0.138050] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4704400-0xf47047ff]
[    1.238005] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001       ****************
[    1.238043] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.238050] pci 0000:00:1d.7: PME# disabled
[    1.238243] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    1.238248] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    1.238256] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0068 (mask 0007)
[    1.238320] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    1.238330] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    1.238339] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    1.238348] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    1.238358] pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
[    1.238424] pci 0000:00:1f.2: reg 10 io port: [0x1c00-0x1c07]
[    1.238434] pci 0000:00:1f.2: reg 14 io port: [0x18f4-0x18f7]
[    1.238443] pci 0000:00:1f.2: reg 18 io port: [0x18f8-0x18ff]
[    1.238453] pci 0000:00:1f.2: reg 1c io port: [0x18f0-0x18f3]
[    1.238462] pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ef]
[    1.238471] pci 0000:00:1f.2: reg 24 io port: [0x18d0-0x18df]
[    1.238506] pci 0000:00:1f.2: PME# supported from D3hot
[    1.238512] pci 0000:00:1f.2: PME# disabled
[    1.238544] pci 0000:00:1f.3: reg 10 32bit mmio: [0x000000-0x0000ff]
[    1.238574] pci 0000:00:1f.3: reg 20 io port: [0x1c20-0x1c3f]
[    1.238676] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    1.238682] pci 0000:00:1c.0: bridge 32bit mmio: [0xf2000000-0xf3ffffff]
[    1.238692] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf0000000-0xf1ffffff]
[    1.238926] pci 0000:05:00.0: reg 10 64bit mmio: [0xf4200000-0xf420ffff]
[    1.239180] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    1.239192] pci 0000:05:00.0: PME# disabled
[    1.239719] pci 0000:00:1c.1: bridge 32bit mmio: [0xf4200000-0xf42fffff]
[    1.239827] pci 0000:06:00.0: reg 10 64bit mmio: [0xf4300000-0xf4301fff]
[    1.239954] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.239963] pci 0000:06:00.0: PME# disabled
[    1.242155] pci 0000:00:1c.2: bridge 32bit mmio: [0xf4300000-0xf43fffff]
[    1.242240] pci 0000:0a:09.0: reg 10 32bit mmio: [0xf4400000-0xf44007ff]
[    1.242324] pci 0000:0a:09.0: supports D1 D2
[    1.242327] pci 0000:0a:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.242333] pci 0000:0a:09.0: PME# disabled
[    1.242391] pci 0000:0a:09.1: reg 10 32bit mmio: [0xf4400800-0xf44008ff]
[    1.242474] pci 0000:0a:09.1: supports D1 D2
[    1.242477] pci 0000:0a:09.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.242484] pci 0000:0a:09.1: PME# disabled
[    1.242542] pci 0000:0a:09.2: reg 10 32bit mmio: [0xf4400c00-0xf4400cff]
[    1.242625] pci 0000:0a:09.2: supports D1 D2
[    1.242628] pci 0000:0a:09.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.242635] pci 0000:0a:09.2: PME# disabled
[    1.242694] pci 0000:0a:09.3: reg 10 32bit mmio: [0xf4401000-0xf44010ff]
[    1.242777] pci 0000:0a:09.3: supports D1 D2
[    1.242780] pci 0000:0a:09.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.242787] pci 0000:0a:09.3: PME# disabled
[    1.242844] pci 0000:0a:09.4: reg 10 32bit mmio: [0xf4401400-0xf44014ff]
[    1.242928] pci 0000:0a:09.4: supports D1 D2
[    1.242930] pci 0000:0a:09.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.242937] pci 0000:0a:09.4: PME# disabled
[    1.243009] pci 0000:00:1e.0: transparent bridge
[    1.243018] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4400000-0xf44fffff]
[    1.243057] pci_bus 0000:00: on NUMA node 0
[    1.243063] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.243329] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.243415] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.243501] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.243622] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    1.243724] ACPI Error (psargs-0359): [CDW1] Namespace lookup failure, AE_NOT_FOUND
[    1.243731] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0._OSC] (Node f6c135b8), AE_NOT_FOUND
[    1.256510] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    1.256630] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.256746] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.256861] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.256975] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    1.257097] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 *3 4 5 6 7 11 12 14 15)
[    1.257211] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 *4 5 6 7 10 12 14 15)
[    1.257324] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 15)


---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
