Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1GLQMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:12:48 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:60155
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846Ab1GLQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:12:46 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p6CGCKDF028877
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Keith Packard <keithp@keithp.com>
Cc: Pekka Enberg <penberg@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Robse <rob-se@live.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Bug #37472] Lenovo U160 (i915 black screen)
In-Reply-To: <yunei1vec1k.fsf@aiko.keithp.com> (Keith Packard's message of
	"Tue, 12 Jul 2011 08:47:19 -0700")
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
	<gK_efVqs2fP.A.NJ.7lYGOB@chimera>
	<CAOJsxLGkWX61TLqwgL19tN5ZQuB2cUibPsNSvCB+Ydihtus__w@mail.gmail.com>
	<yun7h7pg8y7.fsf@aiko.keithp.com> <gisjqb6h0q.fsf@karga.hank.lab>
	<gioc0z6gn2.fsf@karga.hank.lab> <yunei1vec1k.fsf@aiko.keithp.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Tue, 12 Jul 2011 18:12:18 +0200
Message-ID: <gi8vs3o4v1.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Tue, 12 Jul 2011 18:12:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard <keithp@keithp.com> writes:

> On Tue, 12 Jul 2011 10:35:13 +0200, Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>
>> I'm sorry for the noise, I did not check new comments in the bug report
>> where Robse noted that the workaround works for him.  I'm not sure if
>> that means the bug can be closed.
>
> A kernel commandline workaround isn't ideal; we should at least provide
> a quirk that does this automatically for this hardware. Can we get the
> PCI information for the graphics device on this hardware (lspci -v -n)?

Of course.  Probably, some of the information in the bug report at
freedesktop.org[1] is also useful.

Dirk

[1] https://bugs.freedesktop.org/show_bug.cgi?id=31596

------------------------------------------------------------------------
00:00.0 0600: 8086:0044 (rev 02)
	Subsystem: 17aa:391e
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: agpgart-intel

00:02.0 0300: 8086:0046 (rev 02) (prog-if 00 [VGA controller])
	Subsystem: 17aa:3920
	Flags: bus master, fast devsel, latency 0, IRQ 41
	Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 2
	Capabilities: [a4] PCI Advanced Features
	Kernel driver in use: i915
	Kernel modules: i915

00:16.0 0780: 8086:3b64 (rev 06)
	Subsystem: 17aa:38a5
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at f0804000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+

00:1a.0 0c03: 8086:3b3c (rev 05) (prog-if 20 [EHCI])
	Subsystem: 17aa:38aa
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at f0806000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1b.0 0403: 8086:3b56 (rev 05)
	Subsystem: 17aa:38af
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at f0800000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 0604: 8086:3b42 (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f0400000-f04fffff
	Prefetchable memory behind bridge: 000000007c200000-000000007c3fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: 17aa:38b0
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1c.1 0604: 8086:3b44 (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f0500000-f05fffff
	Prefetchable memory behind bridge: 000000007c000000-000000007c1fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: 17aa:38b1
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1d.0 0c03: 8086:3b34 (rev 05) (prog-if 20 [EHCI])
	Subsystem: 17aa:38b8
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at f0807000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1e.0 0604: 8086:2448 (rev a5) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0f, subordinate=0f, sec-latency=0
	Capabilities: [50] Subsystem: 17aa:383f

00:1f.0 0601: 8086:3b09 (rev 05)
	Subsystem: 17aa:38be
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=10 <?>

00:1f.2 0106: 8086:3b29 (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: 17aa:38c1
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 40
	I/O ports at 1818 [size=8]
	I/O ports at 180c [size=4]
	I/O ports at 1810 [size=8]
	I/O ports at 1808 [size=4]
	I/O ports at 1820 [size=32]
	Memory at f0808000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci

00:1f.3 0c05: 8086:3b30 (rev 05)
	Subsystem: 17aa:38bf
	Flags: medium devsel, IRQ 18
	Memory at f0809000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 1840 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

00:1f.6 1180: 8086:3b32 (rev 05)
	Subsystem: 17aa:38c0
	Flags: fast devsel, IRQ 10
	Memory at f080a000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-

03:00.0 0200: 1969:1063 (rev c0)
	Subsystem: 17aa:38a3
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f0400000 (64-bit, non-prefetchable) [size=256K]
	I/O ports at 2000 [size=128]
	Capabilities: [40] Power Management version 3
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [58] Express Endpoint, MSI 00
	Capabilities: [6c] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [180] Device Serial Number ff-0a-37-ef-5c-ff-35-ff
	Kernel driver in use: atl1c
	Kernel modules: atl1c

04:00.0 0280: 14e4:4727 (rev 01)
	Subsystem: 14e4:0510
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at f0500000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [d0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-82-ff-ff-6e-00-26
	Capabilities: [16c] Power Budgeting <?>
	Kernel driver in use: wl
	Kernel modules: wl

ff:00.0 0600: 8086:2c62 (rev 02)
	Subsystem: 17aa:392b
	Flags: bus master, fast devsel, latency 0

ff:00.1 0600: 8086:2d01 (rev 02)
	Subsystem: 17aa:392b
	Flags: bus master, fast devsel, latency 0

ff:02.0 0600: 8086:2d10 (rev 02)
	Subsystem: 17aa:392b
	Flags: bus master, fast devsel, latency 0

ff:02.1 0600: 8086:2d11 (rev 02)
	Subsystem: 17aa:392b
	Flags: bus master, fast devsel, latency 0

ff:02.2 0600: 8086:2d12 (rev 02)
	Subsystem: 17aa:392b
	Flags: bus master, fast devsel, latency 0

ff:02.3 0600: 8086:2d13 (rev 02)
	Subsystem: 17aa:392b
	Flags: bus master, fast devsel, latency 0
