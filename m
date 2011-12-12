Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1LLQfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:35:23 -0500
Received: from home.keithp.com ([63.227.221.253]:57164 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1LLQfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:35:20 -0500
From: Keith Packard <keithp@keithp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed address is invalid"
In-Reply-To: <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com> <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com> <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com> <8639cqjvyn.fsf@sumi.keithp.com> <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Notmuch/0.10.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 12 Dec 2011 08:35:25 -0800
Message-ID: <86sjkpiw8i.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 10:01:23 +0000, Matt Fleming <matt@console-pimps.org> w=
rote:

> How about the dmesg from a kernel with this revert applied?

Happy to oblige. Here's the first few seconds (until X starts):

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-rc5-00021-g899e4f0 (keithp@sumi) (gcc ve=
rsion 4.6.2 (Debian 4.6.2-5) ) #211 SMP Sun Dec 11 15:53:31 PST 2011
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.2.0-rc5-00021-g89=
9e4f0 root=3D/dev/sda4 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
[    0.000000]  BIOS-e820: 0000000000090000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 000000008ad36000 (usable)
[    0.000000]  BIOS-e820: 000000008ad36000 - 000000008ad5f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000008ad5f000 - 000000008ad6f000 (usable)
[    0.000000]  BIOS-e820: 000000008ad6f000 - 000000008ad8f000 (ACPI data)
[    0.000000]  BIOS-e820: 000000008ad8f000 - 000000008ae33000 (usable)
[    0.000000]  BIOS-e820: 000000008ae33000 - 000000008ae8f000 (reserved)
[    0.000000]  BIOS-e820: 000000008ae8f000 - 000000008aed2000 (usable)
[    0.000000]  BIOS-e820: 000000008aed2000 - 000000008aeff000 (reserved)
[    0.000000]  BIOS-e820: 000000008aeff000 - 000000008afa2000 (usable)
[    0.000000]  BIOS-e820: 000000008afa2000 - 000000008fa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e00f8000 - 00000000e00f9000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffed0000 - 00000000fff00000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000016fe00000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] EFI v1.10 by Apple
[    0.000000]  ACPI=3D0x8ad8e000  ACPI 2.0=3D0x8ad8e014  SMBIOS=3D0x8ad3d0=
00=20
[    0.000000] Kernel-defined memdesc doesn't match the one from EFI!
[    0.000000] EFI: mem00: type=3D7, attr=3D0x80000000000000f, range=3D[0x0=
000000000000000-0x000000000008f000) (0MB)
[    0.000000] EFI: mem01: type=3D0, attr=3D0x80000000000000f, range=3D[0x0=
00000000008f000-0x0000000000090000) (0MB)
[    0.000000] EFI: mem02: type=3D7, attr=3D0x80000000000000f, range=3D[0x0=
000000000090000-0x00000000000a0000) (0MB)
[    0.000000] EFI: mem03: type=3D2, attr=3D0xf, range=3D[0x000000000010000=
0-0x0000000000443000) (3MB)
[    0.000000] EFI: mem04: type=3D7, attr=3D0xf, range=3D[0x000000000044300=
0-0x0000000020000000) (507MB)
[    0.000000] EFI: mem05: type=3D0, attr=3D0xf, range=3D[0x000000002000000=
0-0x0000000020200000) (2MB)
[    0.000000] EFI: mem06: type=3D7, attr=3D0xf, range=3D[0x000000002020000=
0-0x0000000040000000) (510MB)
[    0.000000] EFI: mem07: type=3D0, attr=3D0xf, range=3D[0x000000004000000=
0-0x0000000040200000) (2MB)
[    0.000000] EFI: mem08: type=3D7, attr=3D0xf, range=3D[0x000000004020000=
0-0x0000000065b74000) (601MB)
[    0.000000] EFI: mem09: type=3D2, attr=3D0xf, range=3D[0x0000000065b7400=
0-0x0000000087d1e000) (545MB)
[    0.000000] EFI: mem10: type=3D4, attr=3D0xf, range=3D[0x0000000087d1e00=
0-0x0000000087d30000) (0MB)
[    0.000000] EFI: mem11: type=3D7, attr=3D0xf, range=3D[0x0000000087d3000=
0-0x00000000889e0000) (12MB)
[    0.000000] EFI: mem12: type=3D1, attr=3D0xf, range=3D[0x00000000889e000=
0-0x0000000088a01000) (0MB)
[    0.000000] EFI: mem13: type=3D7, attr=3D0xf, range=3D[0x0000000088a0100=
0-0x0000000088a1d000) (0MB)
[    0.000000] EFI: mem14: type=3D4, attr=3D0xf, range=3D[0x0000000088a1d00=
0-0x0000000088a23000) (0MB)
[    0.000000] EFI: mem15: type=3D2, attr=3D0xf, range=3D[0x0000000088a2300=
0-0x0000000088a82000) (0MB)
[    0.000000] EFI: mem16: type=3D4, attr=3D0xf, range=3D[0x0000000088a8200=
0-0x0000000088a85000) (0MB)
[    0.000000] EFI: mem17: type=3D2, attr=3D0xf, range=3D[0x0000000088a8500=
0-0x0000000088acd000) (0MB)
[    0.000000] EFI: mem18: type=3D4, attr=3D0xf, range=3D[0x0000000088acd00=
0-0x0000000088ad4000) (0MB)
[    0.000000] EFI: mem19: type=3D2, attr=3D0xf, range=3D[0x0000000088ad400=
0-0x0000000088ad6000) (0MB)
[    0.000000] EFI: mem20: type=3D4, attr=3D0xf, range=3D[0x0000000088ad600=
0-0x0000000088af3000) (0MB)
[    0.000000] EFI: mem21: type=3D1, attr=3D0xf, range=3D[0x0000000088af300=
0-0x0000000088b10000) (0MB)
[    0.000000] EFI: mem22: type=3D4, attr=3D0xf, range=3D[0x0000000088b1000=
0-0x0000000088b28000) (0MB)
[    0.000000] EFI: mem23: type=3D2, attr=3D0xf, range=3D[0x0000000088b2800=
0-0x0000000088b2d000) (0MB)
[    0.000000] EFI: mem24: type=3D4, attr=3D0xf, range=3D[0x0000000088b2d00=
0-0x0000000088b3b000) (0MB)
[    0.000000] EFI: mem25: type=3D2, attr=3D0xf, range=3D[0x0000000088b3b00=
0-0x0000000088b3c000) (0MB)
[    0.000000] EFI: mem26: type=3D4, attr=3D0xf, range=3D[0x0000000088b3c00=
0-0x0000000088b3d000) (0MB)
[    0.000000] EFI: mem27: type=3D2, attr=3D0xf, range=3D[0x0000000088b3d00=
0-0x0000000088b45000) (0MB)
[    0.000000] EFI: mem28: type=3D4, attr=3D0xf, range=3D[0x0000000088b4500=
0-0x0000000089491000) (9MB)
[    0.000000] EFI: mem29: type=3D3, attr=3D0xf, range=3D[0x000000008949100=
0-0x0000000089492000) (0MB)
[    0.000000] EFI: mem30: type=3D4, attr=3D0xf, range=3D[0x000000008949200=
0-0x000000008960b000) (1MB)
[    0.000000] EFI: mem31: type=3D3, attr=3D0xf, range=3D[0x000000008960b00=
0-0x0000000089610000) (0MB)
[    0.000000] EFI: mem32: type=3D4, attr=3D0xf, range=3D[0x000000008961000=
0-0x000000008962c000) (0MB)
[    0.000000] EFI: mem33: type=3D3, attr=3D0xf, range=3D[0x000000008962c00=
0-0x0000000089635000) (0MB)
[    0.000000] EFI: mem34: type=3D4, attr=3D0xf, range=3D[0x000000008963500=
0-0x0000000089637000) (0MB)
[    0.000000] EFI: mem35: type=3D3, attr=3D0xf, range=3D[0x000000008963700=
0-0x0000000089638000) (0MB)
[    0.000000] EFI: mem36: type=3D4, attr=3D0xf, range=3D[0x000000008963800=
0-0x0000000089639000) (0MB)
[    0.000000] EFI: mem37: type=3D3, attr=3D0xf, range=3D[0x000000008963900=
0-0x000000008963a000) (0MB)
[    0.000000] EFI: mem38: type=3D4, attr=3D0xf, range=3D[0x000000008963a00=
0-0x000000008963c000) (0MB)
[    0.000000] EFI: mem39: type=3D3, attr=3D0xf, range=3D[0x000000008963c00=
0-0x0000000089641000) (0MB)
[    0.000000] EFI: mem40: type=3D4, attr=3D0xf, range=3D[0x000000008964100=
0-0x0000000089655000) (0MB)
[    0.000000] EFI: mem41: type=3D3, attr=3D0xf, range=3D[0x000000008965500=
0-0x0000000089659000) (0MB)
[    0.000000] EFI: mem42: type=3D4, attr=3D0xf, range=3D[0x000000008965900=
0-0x0000000089660000) (0MB)
[    0.000000] EFI: mem43: type=3D3, attr=3D0xf, range=3D[0x000000008966000=
0-0x0000000089661000) (0MB)
[    0.000000] EFI: mem44: type=3D4, attr=3D0xf, range=3D[0x000000008966100=
0-0x0000000089664000) (0MB)
[    0.000000] EFI: mem45: type=3D3, attr=3D0xf, range=3D[0x000000008966400=
0-0x000000008966e000) (0MB)
[    0.000000] EFI: mem46: type=3D4, attr=3D0xf, range=3D[0x000000008966e00=
0-0x0000000089673000) (0MB)
[    0.000000] EFI: mem47: type=3D3, attr=3D0xf, range=3D[0x000000008967300=
0-0x0000000089675000) (0MB)
[    0.000000] EFI: mem48: type=3D4, attr=3D0xf, range=3D[0x000000008967500=
0-0x000000008969a000) (0MB)
[    0.000000] EFI: mem49: type=3D3, attr=3D0xf, range=3D[0x000000008969a00=
0-0x000000008969d000) (0MB)
[    0.000000] EFI: mem50: type=3D4, attr=3D0xf, range=3D[0x000000008969d00=
0-0x00000000896ad000) (0MB)
[    0.000000] EFI: mem51: type=3D3, attr=3D0xf, range=3D[0x00000000896ad00=
0-0x00000000896b1000) (0MB)
[    0.000000] EFI: mem52: type=3D4, attr=3D0xf, range=3D[0x00000000896b100=
0-0x00000000896d6000) (0MB)
[    0.000000] EFI: mem53: type=3D3, attr=3D0xf, range=3D[0x00000000896d600=
0-0x00000000896eb000) (0MB)
[    0.000000] EFI: mem54: type=3D4, attr=3D0xf, range=3D[0x00000000896eb00=
0-0x00000000896f6000) (0MB)
[    0.000000] EFI: mem55: type=3D3, attr=3D0xf, range=3D[0x00000000896f600=
0-0x000000008970b000) (0MB)
[    0.000000] EFI: mem56: type=3D4, attr=3D0xf, range=3D[0x000000008970b00=
0-0x0000000089710000) (0MB)
[    0.000000] EFI: mem57: type=3D3, attr=3D0xf, range=3D[0x000000008971000=
0-0x0000000089719000) (0MB)
[    0.000000] EFI: mem58: type=3D4, attr=3D0xf, range=3D[0x000000008971900=
0-0x0000000089726000) (0MB)
[    0.000000] EFI: mem59: type=3D3, attr=3D0xf, range=3D[0x000000008972600=
0-0x0000000089739000) (0MB)
[    0.000000] EFI: mem60: type=3D4, attr=3D0xf, range=3D[0x000000008973900=
0-0x000000008973a000) (0MB)
[    0.000000] EFI: mem61: type=3D3, attr=3D0xf, range=3D[0x000000008973a00=
0-0x000000008973c000) (0MB)
[    0.000000] EFI: mem62: type=3D4, attr=3D0xf, range=3D[0x000000008973c00=
0-0x0000000089742000) (0MB)
[    0.000000] EFI: mem63: type=3D3, attr=3D0xf, range=3D[0x000000008974200=
0-0x0000000089743000) (0MB)
[    0.000000] EFI: mem64: type=3D4, attr=3D0xf, range=3D[0x000000008974300=
0-0x0000000089744000) (0MB)
[    0.000000] EFI: mem65: type=3D3, attr=3D0xf, range=3D[0x000000008974400=
0-0x0000000089748000) (0MB)
[    0.000000] EFI: mem66: type=3D4, attr=3D0xf, range=3D[0x000000008974800=
0-0x000000008974a000) (0MB)
[    0.000000] EFI: mem67: type=3D3, attr=3D0xf, range=3D[0x000000008974a00=
0-0x000000008974b000) (0MB)
[    0.000000] EFI: mem68: type=3D4, attr=3D0xf, range=3D[0x000000008974b00=
0-0x000000008974f000) (0MB)
[    0.000000] EFI: mem69: type=3D3, attr=3D0xf, range=3D[0x000000008974f00=
0-0x0000000089752000) (0MB)
[    0.000000] EFI: mem70: type=3D4, attr=3D0xf, range=3D[0x000000008975200=
0-0x0000000089753000) (0MB)
[    0.000000] EFI: mem71: type=3D3, attr=3D0xf, range=3D[0x000000008975300=
0-0x0000000089754000) (0MB)
[    0.000000] EFI: mem72: type=3D4, attr=3D0xf, range=3D[0x000000008975400=
0-0x0000000089755000) (0MB)
[    0.000000] EFI: mem73: type=3D3, attr=3D0xf, range=3D[0x000000008975500=
0-0x0000000089759000) (0MB)
[    0.000000] EFI: mem74: type=3D4, attr=3D0xf, range=3D[0x000000008975900=
0-0x000000008975c000) (0MB)
[    0.000000] EFI: mem75: type=3D3, attr=3D0xf, range=3D[0x000000008975c00=
0-0x000000008975d000) (0MB)
[    0.000000] EFI: mem76: type=3D4, attr=3D0xf, range=3D[0x000000008975d00=
0-0x000000008975f000) (0MB)
[    0.000000] EFI: mem77: type=3D3, attr=3D0xf, range=3D[0x000000008975f00=
0-0x0000000089761000) (0MB)
[    0.000000] EFI: mem78: type=3D4, attr=3D0xf, range=3D[0x000000008976100=
0-0x0000000089765000) (0MB)
[    0.000000] EFI: mem79: type=3D3, attr=3D0xf, range=3D[0x000000008976500=
0-0x0000000089769000) (0MB)
[    0.000000] EFI: mem80: type=3D4, attr=3D0xf, range=3D[0x000000008976900=
0-0x000000008976a000) (0MB)
[    0.000000] EFI: mem81: type=3D3, attr=3D0xf, range=3D[0x000000008976a00=
0-0x000000008976b000) (0MB)
[    0.000000] EFI: mem82: type=3D4, attr=3D0xf, range=3D[0x000000008976b00=
0-0x000000008976e000) (0MB)
[    0.000000] EFI: mem83: type=3D3, attr=3D0xf, range=3D[0x000000008976e00=
0-0x0000000089775000) (0MB)
[    0.000000] EFI: mem84: type=3D4, attr=3D0xf, range=3D[0x000000008977500=
0-0x0000000089776000) (0MB)
[    0.000000] EFI: mem85: type=3D3, attr=3D0xf, range=3D[0x000000008977600=
0-0x000000008977b000) (0MB)
[    0.000000] EFI: mem86: type=3D4, attr=3D0xf, range=3D[0x000000008977b00=
0-0x000000008977f000) (0MB)
[    0.000000] EFI: mem87: type=3D3, attr=3D0xf, range=3D[0x000000008977f00=
0-0x0000000089780000) (0MB)
[    0.000000] EFI: mem88: type=3D4, attr=3D0xf, range=3D[0x000000008978000=
0-0x0000000089781000) (0MB)
[    0.000000] EFI: mem89: type=3D3, attr=3D0xf, range=3D[0x000000008978100=
0-0x0000000089786000) (0MB)
[    0.000000] EFI: mem90: type=3D4, attr=3D0xf, range=3D[0x000000008978600=
0-0x0000000089788000) (0MB)
[    0.000000] EFI: mem91: type=3D3, attr=3D0xf, range=3D[0x000000008978800=
0-0x000000008978a000) (0MB)
[    0.000000] EFI: mem92: type=3D4, attr=3D0xf, range=3D[0x000000008978a00=
0-0x000000008978b000) (0MB)
[    0.000000] EFI: mem93: type=3D3, attr=3D0xf, range=3D[0x000000008978b00=
0-0x000000008978f000) (0MB)
[    0.000000] EFI: mem94: type=3D4, attr=3D0xf, range=3D[0x000000008978f00=
0-0x00000000897a7000) (0MB)
[    0.000000] EFI: mem95: type=3D3, attr=3D0xf, range=3D[0x00000000897a700=
0-0x00000000897bb000) (0MB)
[    0.000000] EFI: mem96: type=3D4, attr=3D0xf, range=3D[0x00000000897bb00=
0-0x00000000897be000) (0MB)
[    0.000000] EFI: mem97: type=3D3, attr=3D0xf, range=3D[0x00000000897be00=
0-0x00000000897c2000) (0MB)
[    0.000000] EFI: mem98: type=3D4, attr=3D0xf, range=3D[0x00000000897c200=
0-0x00000000897c3000) (0MB)
[    0.000000] EFI: mem99: type=3D3, attr=3D0xf, range=3D[0x00000000897c300=
0-0x00000000897c5000) (0MB)
[    0.000000] EFI: mem100: type=3D4, attr=3D0xf, range=3D[0x00000000897c50=
00-0x00000000897c7000) (0MB)
[    0.000000] EFI: mem101: type=3D3, attr=3D0xf, range=3D[0x00000000897c70=
00-0x00000000897c9000) (0MB)
[    0.000000] EFI: mem102: type=3D4, attr=3D0xf, range=3D[0x00000000897c90=
00-0x00000000897ca000) (0MB)
[    0.000000] EFI: mem103: type=3D3, attr=3D0xf, range=3D[0x00000000897ca0=
00-0x00000000897d7000) (0MB)
[    0.000000] EFI: mem104: type=3D4, attr=3D0xf, range=3D[0x00000000897d70=
00-0x00000000897d9000) (0MB)
[    0.000000] EFI: mem105: type=3D3, attr=3D0xf, range=3D[0x00000000897d90=
00-0x00000000897db000) (0MB)
[    0.000000] EFI: mem106: type=3D4, attr=3D0xf, range=3D[0x00000000897db0=
00-0x00000000897e3000) (0MB)
[    0.000000] EFI: mem107: type=3D3, attr=3D0xf, range=3D[0x00000000897e30=
00-0x00000000897e6000) (0MB)
[    0.000000] EFI: mem108: type=3D4, attr=3D0xf, range=3D[0x00000000897e60=
00-0x00000000897e8000) (0MB)
[    0.000000] EFI: mem109: type=3D3, attr=3D0xf, range=3D[0x00000000897e80=
00-0x00000000897ea000) (0MB)
[    0.000000] EFI: mem110: type=3D4, attr=3D0xf, range=3D[0x00000000897ea0=
00-0x00000000897ef000) (0MB)
[    0.000000] EFI: mem111: type=3D3, attr=3D0xf, range=3D[0x00000000897ef0=
00-0x00000000897f5000) (0MB)
[    0.000000] EFI: mem112: type=3D4, attr=3D0xf, range=3D[0x00000000897f50=
00-0x00000000897f7000) (0MB)
[    0.000000] EFI: mem113: type=3D3, attr=3D0xf, range=3D[0x00000000897f70=
00-0x00000000897fe000) (0MB)
[    0.000000] EFI: mem114: type=3D4, attr=3D0xf, range=3D[0x00000000897fe0=
00-0x0000000089800000) (0MB)
[    0.000000] EFI: mem115: type=3D3, attr=3D0xf, range=3D[0x00000000898000=
00-0x0000000089806000) (0MB)
[    0.000000] EFI: mem116: type=3D4, attr=3D0xf, range=3D[0x00000000898060=
00-0x000000008980a000) (0MB)
[    0.000000] EFI: mem117: type=3D3, attr=3D0xf, range=3D[0x000000008980a0=
00-0x000000008980b000) (0MB)
[    0.000000] EFI: mem118: type=3D4, attr=3D0xf, range=3D[0x000000008980b0=
00-0x000000008980c000) (0MB)
[    0.000000] EFI: mem119: type=3D3, attr=3D0xf, range=3D[0x000000008980c0=
00-0x0000000089813000) (0MB)
[    0.000000] EFI: mem120: type=3D4, attr=3D0xf, range=3D[0x00000000898130=
00-0x0000000089815000) (0MB)
[    0.000000] EFI: mem121: type=3D3, attr=3D0xf, range=3D[0x00000000898150=
00-0x000000008981b000) (0MB)
[    0.000000] EFI: mem122: type=3D4, attr=3D0xf, range=3D[0x000000008981b0=
00-0x000000008981f000) (0MB)
[    0.000000] EFI: mem123: type=3D3, attr=3D0xf, range=3D[0x000000008981f0=
00-0x000000008982e000) (0MB)
[    0.000000] EFI: mem124: type=3D4, attr=3D0xf, range=3D[0x000000008982e0=
00-0x000000008982f000) (0MB)
[    0.000000] EFI: mem125: type=3D3, attr=3D0xf, range=3D[0x000000008982f0=
00-0x0000000089848000) (0MB)
[    0.000000] EFI: mem126: type=3D4, attr=3D0xf, range=3D[0x00000000898480=
00-0x0000000089849000) (0MB)
[    0.000000] EFI: mem127: type=3D3, attr=3D0xf, range=3D[0x00000000898490=
00-0x000000008984f000) (0MB)
[    0.000000] EFI: mem128: type=3D4, attr=3D0xf, range=3D[0x000000008984f0=
00-0x0000000089853000) (0MB)
[    0.000000] EFI: mem129: type=3D3, attr=3D0xf, range=3D[0x00000000898530=
00-0x0000000089859000) (0MB)
[    0.000000] EFI: mem130: type=3D4, attr=3D0xf, range=3D[0x00000000898590=
00-0x000000008985a000) (0MB)
[    0.000000] EFI: mem131: type=3D3, attr=3D0xf, range=3D[0x000000008985a0=
00-0x000000008985b000) (0MB)
[    0.000000] EFI: mem132: type=3D4, attr=3D0xf, range=3D[0x000000008985b0=
00-0x000000008985f000) (0MB)
[    0.000000] EFI: mem133: type=3D3, attr=3D0xf, range=3D[0x000000008985f0=
00-0x0000000089860000) (0MB)
[    0.000000] EFI: mem134: type=3D4, attr=3D0xf, range=3D[0x00000000898600=
00-0x0000000089865000) (0MB)
[    0.000000] EFI: mem135: type=3D3, attr=3D0xf, range=3D[0x00000000898650=
00-0x0000000089867000) (0MB)
[    0.000000] EFI: mem136: type=3D4, attr=3D0xf, range=3D[0x00000000898670=
00-0x0000000089869000) (0MB)
[    0.000000] EFI: mem137: type=3D3, attr=3D0xf, range=3D[0x00000000898690=
00-0x000000008986a000) (0MB)
[    0.000000] EFI: mem138: type=3D4, attr=3D0xf, range=3D[0x000000008986a0=
00-0x000000008986d000) (0MB)
[    0.000000] EFI: mem139: type=3D3, attr=3D0xf, range=3D[0x000000008986d0=
00-0x000000008986e000) (0MB)
[    0.000000] EFI: mem140: type=3D4, attr=3D0xf, range=3D[0x000000008986e0=
00-0x000000008986f000) (0MB)
[    0.000000] EFI: mem141: type=3D3, attr=3D0xf, range=3D[0x000000008986f0=
00-0x0000000089871000) (0MB)
[    0.000000] EFI: mem142: type=3D4, attr=3D0xf, range=3D[0x00000000898710=
00-0x0000000089873000) (0MB)
[    0.000000] EFI: mem143: type=3D3, attr=3D0xf, range=3D[0x00000000898730=
00-0x0000000089875000) (0MB)
[    0.000000] EFI: mem144: type=3D4, attr=3D0xf, range=3D[0x00000000898750=
00-0x0000000089877000) (0MB)
[    0.000000] EFI: mem145: type=3D3, attr=3D0xf, range=3D[0x00000000898770=
00-0x0000000089880000) (0MB)
[    0.000000] EFI: mem146: type=3D4, attr=3D0xf, range=3D[0x00000000898800=
00-0x0000000089881000) (0MB)
[    0.000000] EFI: mem147: type=3D3, attr=3D0xf, range=3D[0x00000000898810=
00-0x0000000089883000) (0MB)
[    0.000000] EFI: mem148: type=3D4, attr=3D0xf, range=3D[0x00000000898830=
00-0x0000000089884000) (0MB)
[    0.000000] EFI: mem149: type=3D3, attr=3D0xf, range=3D[0x00000000898840=
00-0x0000000089885000) (0MB)
[    0.000000] EFI: mem150: type=3D4, attr=3D0xf, range=3D[0x00000000898850=
00-0x000000008988a000) (0MB)
[    0.000000] EFI: mem151: type=3D3, attr=3D0xf, range=3D[0x000000008988a0=
00-0x000000008988b000) (0MB)
[    0.000000] EFI: mem152: type=3D4, attr=3D0xf, range=3D[0x000000008988b0=
00-0x0000000089890000) (0MB)
[    0.000000] EFI: mem153: type=3D3, attr=3D0xf, range=3D[0x00000000898900=
00-0x0000000089891000) (0MB)
[    0.000000] EFI: mem154: type=3D4, attr=3D0xf, range=3D[0x00000000898910=
00-0x0000000089892000) (0MB)
[    0.000000] EFI: mem155: type=3D3, attr=3D0xf, range=3D[0x00000000898920=
00-0x0000000089899000) (0MB)
[    0.000000] EFI: mem156: type=3D4, attr=3D0xf, range=3D[0x00000000898990=
00-0x000000008989e000) (0MB)
[    0.000000] EFI: mem157: type=3D3, attr=3D0xf, range=3D[0x000000008989e0=
00-0x00000000898a0000) (0MB)
[    0.000000] EFI: mem158: type=3D4, attr=3D0xf, range=3D[0x00000000898a00=
00-0x00000000898a6000) (0MB)
[    0.000000] EFI: mem159: type=3D3, attr=3D0xf, range=3D[0x00000000898a60=
00-0x00000000898a7000) (0MB)
[    0.000000] EFI: mem160: type=3D4, attr=3D0xf, range=3D[0x00000000898a70=
00-0x00000000898a9000) (0MB)
[    0.000000] EFI: mem161: type=3D3, attr=3D0xf, range=3D[0x00000000898a90=
00-0x00000000898aa000) (0MB)
[    0.000000] EFI: mem162: type=3D4, attr=3D0xf, range=3D[0x00000000898aa0=
00-0x00000000898db000) (0MB)
[    0.000000] EFI: mem163: type=3D3, attr=3D0xf, range=3D[0x00000000898db0=
00-0x00000000898ee000) (0MB)
[    0.000000] EFI: mem164: type=3D4, attr=3D0xf, range=3D[0x00000000898ee0=
00-0x0000000089934000) (0MB)
[    0.000000] EFI: mem165: type=3D3, attr=3D0xf, range=3D[0x00000000899340=
00-0x0000000089948000) (0MB)
[    0.000000] EFI: mem166: type=3D4, attr=3D0xf, range=3D[0x00000000899480=
00-0x0000000089949000) (0MB)
[    0.000000] EFI: mem167: type=3D3, attr=3D0xf, range=3D[0x00000000899490=
00-0x000000008994c000) (0MB)
[    0.000000] EFI: mem168: type=3D4, attr=3D0xf, range=3D[0x000000008994c0=
00-0x0000000089968000) (0MB)
[    0.000000] EFI: mem169: type=3D3, attr=3D0xf, range=3D[0x00000000899680=
00-0x000000008996d000) (0MB)
[    0.000000] EFI: mem170: type=3D4, attr=3D0xf, range=3D[0x000000008996d0=
00-0x000000008997a000) (0MB)
[    0.000000] EFI: mem171: type=3D3, attr=3D0xf, range=3D[0x000000008997a0=
00-0x000000008997b000) (0MB)
[    0.000000] EFI: mem172: type=3D4, attr=3D0xf, range=3D[0x000000008997b0=
00-0x000000008997c000) (0MB)
[    0.000000] EFI: mem173: type=3D3, attr=3D0xf, range=3D[0x000000008997c0=
00-0x000000008997d000) (0MB)
[    0.000000] EFI: mem174: type=3D4, attr=3D0xf, range=3D[0x000000008997d0=
00-0x000000008998f000) (0MB)
[    0.000000] EFI: mem175: type=3D3, attr=3D0xf, range=3D[0x000000008998f0=
00-0x00000000899a4000) (0MB)
[    0.000000] EFI: mem176: type=3D4, attr=3D0xf, range=3D[0x00000000899a40=
00-0x00000000899a5000) (0MB)
[    0.000000] EFI: mem177: type=3D3, attr=3D0xf, range=3D[0x00000000899a50=
00-0x00000000899b1000) (0MB)
[    0.000000] EFI: mem178: type=3D4, attr=3D0xf, range=3D[0x00000000899b10=
00-0x00000000899b4000) (0MB)
[    0.000000] EFI: mem179: type=3D3, attr=3D0xf, range=3D[0x00000000899b40=
00-0x00000000899b8000) (0MB)
[    0.000000] EFI: mem180: type=3D4, attr=3D0xf, range=3D[0x00000000899b80=
00-0x0000000089dd9000) (4MB)
[    0.000000] EFI: mem181: type=3D3, attr=3D0xf, range=3D[0x0000000089dd90=
00-0x0000000089dde000) (0MB)
[    0.000000] EFI: mem182: type=3D4, attr=3D0xf, range=3D[0x0000000089dde0=
00-0x0000000089ddf000) (0MB)
[    0.000000] EFI: mem183: type=3D3, attr=3D0xf, range=3D[0x0000000089ddf0=
00-0x0000000089de1000) (0MB)
[    0.000000] EFI: mem184: type=3D4, attr=3D0xf, range=3D[0x0000000089de10=
00-0x0000000089de2000) (0MB)
[    0.000000] EFI: mem185: type=3D3, attr=3D0xf, range=3D[0x0000000089de20=
00-0x0000000089de5000) (0MB)
[    0.000000] EFI: mem186: type=3D4, attr=3D0xf, range=3D[0x0000000089de50=
00-0x0000000089de6000) (0MB)
[    0.000000] EFI: mem187: type=3D3, attr=3D0xf, range=3D[0x0000000089de60=
00-0x0000000089df3000) (0MB)
[    0.000000] EFI: mem188: type=3D4, attr=3D0xf, range=3D[0x0000000089df30=
00-0x0000000089df5000) (0MB)
[    0.000000] EFI: mem189: type=3D3, attr=3D0xf, range=3D[0x0000000089df50=
00-0x0000000089e02000) (0MB)
[    0.000000] EFI: mem190: type=3D4, attr=3D0xf, range=3D[0x0000000089e020=
00-0x0000000089e03000) (0MB)
[    0.000000] EFI: mem191: type=3D3, attr=3D0xf, range=3D[0x0000000089e030=
00-0x0000000089e06000) (0MB)
[    0.000000] EFI: mem192: type=3D4, attr=3D0xf, range=3D[0x0000000089e060=
00-0x0000000089e07000) (0MB)
[    0.000000] EFI: mem193: type=3D3, attr=3D0xf, range=3D[0x0000000089e070=
00-0x0000000089e08000) (0MB)
[    0.000000] EFI: mem194: type=3D4, attr=3D0xf, range=3D[0x0000000089e080=
00-0x000000008ad0f000) (15MB)
[    0.000000] EFI: mem195: type=3D7, attr=3D0xf, range=3D[0x000000008ad0f0=
00-0x000000008ad36000) (0MB)
[    0.000000] EFI: mem196: type=3D10, attr=3D0xf, range=3D[0x000000008ad36=
000-0x000000008ad5f000) (0MB)
[    0.000000] EFI: mem197: type=3D7, attr=3D0xf, range=3D[0x000000008ad5f0=
00-0x000000008ad6f000) (0MB)
[    0.000000] EFI: mem198: type=3D9, attr=3D0xf, range=3D[0x000000008ad6f0=
00-0x000000008ad8f000) (0MB)
[    0.000000] EFI: mem199: type=3D7, attr=3D0xf, range=3D[0x000000008ad8f0=
00-0x000000008ae33000) (0MB)
[    0.000000] EFI: mem200: type=3D6, attr=3D0x800000000000000f, range=3D[0=
x000000008ae33000-0x000000008ae8f000) (0MB)
[    0.000000] EFI: mem201: type=3D7, attr=3D0xf, range=3D[0x000000008ae8f0=
00-0x000000008aed2000) (0MB)
[    0.000000] EFI: mem202: type=3D5, attr=3D0x800000000000000f, range=3D[0=
x000000008aed2000-0x000000008aeff000) (0MB)
[    0.000000] EFI: mem203: type=3D7, attr=3D0xf, range=3D[0x000000008aeff0=
00-0x000000008af9a000) (0MB)
[    0.000000] EFI: mem204: type=3D2, attr=3D0xf, range=3D[0x000000008af9a0=
00-0x000000008afa2000) (0MB)
[    0.000000] EFI: mem205: type=3D0, attr=3D0xf, range=3D[0x000000008afa20=
00-0x000000008afff000) (0MB)
[    0.000000] EFI: mem206: type=3D6, attr=3D0x800000000000000f, range=3D[0=
x000000008afff000-0x000000008b000000) (0MB)
[    0.000000] EFI: mem207: type=3D7, attr=3D0xf, range=3D[0x00000001000000=
00-0x000000016fe00000) (1790MB)
[    0.000000] EFI: mem208: type=3D0, attr=3D0x8000000000000000, range=3D[0=
x00000000000a0000-0x0000000000100000) (0MB)
[    0.000000] EFI: mem209: type=3D0, attr=3D0x8000000000000000, range=3D[0=
x000000008b000000-0x000000008fa00000) (74MB)
[    0.000000] EFI: mem210: type=3D11, attr=3D0x8000000000000000, range=3D[=
0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] EFI: mem211: type=3D11, attr=3D0x8000000000000000, range=3D[=
0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] EFI: mem212: type=3D11, attr=3D0x8000000000000000, range=3D[=
0x00000000ffed0000-0x00000000fff00000) (0MB)
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir4,1/Mac-C08A6BB70A942AC2, BIOS MBA=
41.88Z.0077.B00.1106300929 06/30/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x16fe00 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0x8afa2 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000008afa2000
[    0.000000]  0000000000 - 008ae00000 page 2M
[    0.000000]  008ae00000 - 008afa2000 page 4k
[    0.000000] kernel direct mapping tables up to 8afa2000 @ 1fffb000-20000=
000
[    0.000000] init_memory_mapping: 0000000100000000-000000016fe00000
[    0.000000]  0100000000 - 016fe00000 page 2M
[    0.000000] kernel direct mapping tables up to 16fe00000 @ 8af9b000-8afa=
2000
[    0.000000] ACPI: RSDP 000000008ad8e014 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000A4 (v01 APPLE   Apple00 00000=
060      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000=
060 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad81000 05050 (v01 APPLE  MacBookA 00040=
001 INTL 20100915)
[    0.000000] ACPI: FACS 000000008ad40000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7e000 00107 (v01 APPLE  SataAhci 00001=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7d000 00024 (v01 APPLE   SmcDppt 00001=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7a000 006BE (v01 APPLE  UsbNoRmh 00001=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad75000 00032 (v01 APPLE    SsdtS3 00001=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad72000 00569 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad71000 009B1 (v01  PmRef    CpuPm 00003=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad70000 00315 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6f000 0037A (v01  PmRef    ApTst 00003=
000 INTL 20100915)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000016fe00000
[    0.000000] Initmem setup node 0 0000000000000000-000000016fe00000
[    0.000000]   NODE_DATA [000000016fdfb000 - 000000016fdfffff]
[    0.000000]  [ffffea0000000000-ffffea00051fffff] PMD -> [ffff88016b40000=
0-ffff88016edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0016fe00
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[10] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000008f
[    0.000000]     0: 0x00000090 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x0008ad36
[    0.000000]     0: 0x0008ad5f -> 0x0008ad6f
[    0.000000]     0: 0x0008ad8f -> 0x0008ae33
[    0.000000]     0: 0x0008ae8f -> 0x0008aed2
[    0.000000]     0: 0x0008aeff -> 0x0008afa2
[    0.000000]     0: 0x00100000 -> 0x0016fe00
[    0.000000] On node 0 totalpages: 1026143
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 9 pages reserved
[    0.000000]   DMA zone: 3918 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 549640 pages, LIFO batch:31
[    0.000000]   Normal zone: 6265 pages used for memmap
[    0.000000]   Normal zone: 451975 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 00000000000=
90000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 00000000202=
00000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 00000000402=
00000
[    0.000000] PM: Registered nosave memory: 000000008ad36000 - 000000008ad=
5f000
[    0.000000] PM: Registered nosave memory: 000000008ad6f000 - 000000008ad=
8f000
[    0.000000] PM: Registered nosave memory: 000000008ae33000 - 000000008ae=
8f000
[    0.000000] PM: Registered nosave memory: 000000008aed2000 - 000000008ae=
ff000
[    0.000000] PM: Registered nosave memory: 000000008afa2000 - 000000008fa=
00000
[    0.000000] PM: Registered nosave memory: 000000008fa00000 - 00000000e00=
f8000
[    0.000000] PM: Registered nosave memory: 00000000e00f8000 - 00000000e00=
f9000
[    0.000000] PM: Registered nosave memory: 00000000e00f9000 - 00000000fed=
1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed=
20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffe=
d0000
[    0.000000] PM: Registered nosave memory: 00000000ffed0000 - 00000000fff=
00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at 8fa00000 (gap: 8fa00000=
:506f8000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88016fa00000 s82112 r8192=
 d24384 u262144
[    0.000000] pcpu-alloc: s82112 r8192 d24384 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1005533
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.2.0-rc5-00=
021-g899e4f0 root=3D/dev/sda4 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3932228k/6027264k available (4771k kernel code, 1922=
692k absent, 172344k reserved, 4027k data, 592k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 1799.985 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3599.97 BogoMIPS (lpj=3D1799985)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000047] init_memory_mapping: 000000008afff000-000000008b000000
[    0.000050]  008afff000 - 008b000000 page 4k
[    0.000227] init_memory_mapping: 000000008b000000-000000008fa00000
[    0.000229]  008b000000 - 008fa00000 page 2M
[    0.039269] Security Framework initialized
[    0.039708] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.040859] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.041319] Mount-cache hash table entries: 256
[    0.041429] Initializing cgroup subsys cpuacct
[    0.041434] Initializing cgroup subsys memory
[    0.041444] Initializing cgroup subsys devices
[    0.041446] Initializing cgroup subsys freezer
[    0.041447] Initializing cgroup subsys net_cls
[    0.041449] Initializing cgroup subsys blkio
[    0.041482] CPU: Physical Processor ID: 0
[    0.041484] CPU: Processor Core ID: 0
[    0.041490] mce: CPU supports 7 MCE banks
[    0.041504] CPU0: Thermal monitoring enabled (TM1)
[    0.041511] using mwait in idle threads.
[    0.043090] ACPI: Core revision 20110623
[    0.051138] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.061125] CPU0: Intel(R) Core(TM) i7-2677M CPU @ 1.80GHz stepping 07
[    0.162482] Performance Events: PEBS fmt1+, SandyBridge events, Intel PM=
U driver.
[    0.162488] PEBS disabled due to CPU errata.
[    0.162491] ... version:                3
[    0.162492] ... bit width:              48
[    0.162494] ... generic registers:      4
[    0.162495] ... value mask:             0000ffffffffffff
[    0.162497] ... max period:             000000007fffffff
[    0.162498] ... fixed-purpose events:   3
[    0.162500] ... event mask:             000000070000000f
[    0.162646] NMI watchdog enabled, takes one hw-pmu counter.
[    0.162746] Booting Node   0, Processors  #1
[    0.162748] smpboot cpu 1: start_ip =3D 9a000
[    0.253474] NMI watchdog enabled, takes one hw-pmu counter.
[    0.253574]  #2
[    0.253576] smpboot cpu 2: start_ip =3D 9a000
[    0.344322] NMI watchdog enabled, takes one hw-pmu counter.
[    0.344426]  #3
[    0.344428] smpboot cpu 3: start_ip =3D 9a000
[    0.435151] NMI watchdog enabled, takes one hw-pmu counter.
[    0.435180] Brought up 4 CPUs
[    0.435182] Total of 4 processors activated (14398.34 BogoMIPS).
[    0.439934] devtmpfs: initialized
[    0.440868] PM: Registering ACPI NVS region at 8ad36000 (167936 bytes)
[    0.441025] print_constraints: dummy:=20
[    0.441086] NET: Registered protocol family 16
[    0.441183] ACPI: bus type pci registered
[    0.441264] PCI: MMCONFIG for domain 0000 [bus 00-97] at [mem 0xe0000000=
-0xe97fffff] (base 0xe0000000)
[    0.441268] PCI: not using MMCONFIG
[    0.441270] PCI: Using configuration type 1 for base access
[    0.441991] bio: create slab <bio-0> at 0
[    0.442089] ACPI: Added _OSI(Module Device)
[    0.442091] ACPI: Added _OSI(Processor Device)
[    0.442093] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.442096] ACPI: Added _OSI(Processor Aggregator Device)
[    0.443450] ACPI: EC: EC description table is found, configuring boot EC
[    0.450776] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.451448] ACPI: SSDT 000000008ad3b190 00781 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20100915)
[    0.451819] ACPI: Dynamic OEM Table Load:
[    0.451822] ACPI: SSDT           (null) 00781 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20100915)
[    0.454358] ACPI: SSDT 000000008ad3c710 003A4 (v01  PmRef    ApIst 00003=
000 INTL 20100915)
[    0.454793] ACPI: Dynamic OEM Table Load:
[    0.454796] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003=
000 INTL 20100915)
[    0.457148] ACPI: SSDT 000000008ad3ad90 00119 (v01  PmRef    ApCst 00003=
000 INTL 20100915)
[    0.457500] ACPI: Dynamic OEM Table Load:
[    0.457502] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20100915)
[    0.460695] ACPI: Interpreter enabled
[    0.460699] ACPI: (supports S0 S3 S4 S5)
[    0.460724] ACPI: Using IOAPIC for interrupt routing
[    0.460747] PCI: MMCONFIG for domain 0000 [bus 00-97] at [mem 0xe0000000=
-0xe97fffff] (base 0xe0000000)
[    0.463446] PCI: MMCONFIG at [mem 0xe0000000-0xe97fffff] reserved in ACP=
I motherboard resources
[    0.525934] ACPI: EC: GPE =3D 0x17, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.526127] ACPI: No dock devices found.
[    0.526129] HEST: Table not found.
[    0.526132] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.526385] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.526726] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.526729] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.526732] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.526734] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x00=
0c3fff]
[    0.526736] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x00=
0c7fff]
[    0.526739] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x00=
0cbfff]
[    0.526741] pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x00=
0cffff]
[    0.526743] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff]
[    0.526746] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    0.526748] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    0.526750] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x00=
0dffff]
[    0.526753] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x00=
0e3fff]
[    0.526755] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x00=
0e7fff]
[    0.526757] pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x00=
0ebfff]
[    0.526759] pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x00=
0effff]
[    0.526762] pci_root PNP0A08:00: host bridge window [mem 0x000f0000-0x00=
0fffff]
[    0.526764] pci_root PNP0A08:00: host bridge window [mem 0x8fa00000-0xfe=
afffff]
[    0.526767] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfe=
d44fff]
[    0.526784] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    0.526824] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.526857] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.526861] pci 0000:00:01.0: PME# disabled
[    0.526885] pci 0000:00:02.0: [8086:0116] type 0 class 0x000300
[    0.526897] pci 0000:00:02.0: reg 10: [mem 0xa0000000-0xa03fffff 64bit]
[    0.526905] pci 0000:00:02.0: reg 18: [mem 0x90000000-0x9fffffff 64bit p=
ref]
[    0.526910] pci 0000:00:02.0: reg 20: [io  0x2000-0x203f]
[    0.526968] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.526996] pci 0000:00:16.0: reg 10: [mem 0xa0607100-0xa060710f 64bit]
[    0.527064] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.527069] pci 0000:00:16.0: PME# disabled
[    0.527105] pci 0000:00:1a.0: [8086:1c2c] type 0 class 0x000c03
[    0.527152] pci 0000:00:1a.0: reg 20: [io  0x2140-0x215f]
[    0.527216] pci 0000:00:1a.7: [8086:1c2d] type 0 class 0x000c03
[    0.527239] pci 0000:00:1a.7: reg 10: [mem 0xa0606c00-0xa0606fff]
[    0.527318] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.527323] pci 0000:00:1a.7: PME# disabled
[    0.527351] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.527369] pci 0000:00:1b.0: reg 10: [mem 0xa0600000-0xa0603fff 64bit]
[    0.527430] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.527435] pci 0000:00:1b.0: PME# disabled
[    0.527463] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.527566] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.527571] pci 0000:00:1c.0: PME# disabled
[    0.527608] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    0.527710] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.527716] pci 0000:00:1c.1: PME# disabled
[    0.527760] pci 0000:00:1d.0: [8086:1c27] type 0 class 0x000c03
[    0.527807] pci 0000:00:1d.0: reg 20: [io  0x20e0-0x20ff]
[    0.527876] pci 0000:00:1d.7: [8086:1c26] type 0 class 0x000c03
[    0.527899] pci 0000:00:1d.7: reg 10: [mem 0xa0606800-0xa0606bff]
[    0.527978] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.527983] pci 0000:00:1d.7: PME# disabled
[    0.528013] pci 0000:00:1f.0: [8086:1c4d] type 0 class 0x000601
[    0.528138] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
[    0.528160] pci 0000:00:1f.2: reg 10: [io  0x2168-0x216f]
[    0.528169] pci 0000:00:1f.2: reg 14: [io  0x217c-0x217f]
[    0.528179] pci 0000:00:1f.2: reg 18: [io  0x2160-0x2167]
[    0.528188] pci 0000:00:1f.2: reg 1c: [io  0x2178-0x217b]
[    0.528197] pci 0000:00:1f.2: reg 20: [io  0x2060-0x207f]
[    0.528207] pci 0000:00:1f.2: reg 24: [mem 0xa0606000-0xa06067ff]
[    0.528243] pci 0000:00:1f.2: PME# supported from D3hot
[    0.528248] pci 0000:00:1f.2: PME# disabled
[    0.528268] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.528286] pci 0000:00:1f.3: reg 10: [mem 0xa0607000-0xa06070ff 64bit]
[    0.528309] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.528377] pci 0000:03:00.0: [8086:151a] type 1 class 0x000604
[    0.528426] pci 0000:03:00.0: supports D1 D2
[    0.528428] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.528431] pci 0000:03:00.0: PME# disabled
[    0.529869] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.529876] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.529882] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.529892] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff=
 64bit pref]
[    0.529956] pci 0000:04:00.0: [8086:151a] type 1 class 0x000604
[    0.530008] pci 0000:04:00.0: supports D1 D2
[    0.530010] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.530014] pci 0000:04:00.0: PME# disabled
[    0.530047] pci 0000:04:03.0: [8086:151a] type 1 class 0x000604
[    0.530098] pci 0000:04:03.0: supports D1 D2
[    0.530100] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.530104] pci 0000:04:03.0: PME# disabled
[    0.530132] pci 0000:04:04.0: [8086:151a] type 1 class 0x000604
[    0.530183] pci 0000:04:04.0: supports D1 D2
[    0.530185] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.530189] pci 0000:04:04.0: PME# disabled
[    0.530231] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.530238] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.530297] pci 0000:05:00.0: [8086:151a] type 0 class 0x000880
[    0.530312] pci 0000:05:00.0: reg 10: [mem 0xa0700000-0xa073ffff]
[    0.530323] pci 0000:05:00.0: reg 14: [mem 0xa0740000-0xa0740fff]
[    0.530400] pci 0000:05:00.0: supports D1 D2
[    0.530402] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.530407] pci 0000:05:00.0: PME# disabled
[    0.531867] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.531881] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.531943] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.531951] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.531995] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.532003] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.532097] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.532106] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.532266] pci 0000:02:00.0: [14e4:4353] type 0 class 0x000280
[    0.532318] pci 0000:02:00.0: reg 10: [mem 0xa0400000-0xa0403fff 64bit]
[    0.532524] pci 0000:02:00.0: supports D1 D2
[    0.532526] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.532536] pci 0000:02:00.0: PME# disabled
[    0.533879] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.533893] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.533927] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.534099] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.534221] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.534358]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.534538]  pci0000:00: ACPI _OSC control (0x19) granted
[    0.538802] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.538866] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.538923] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.538980] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.539036] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.539091] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.539145] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.539202] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.539307] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.539318] vgaarb: loaded
[    0.539319] vgaarb: bridge control possible 0000:00:02.0
[    0.539430] SCSI subsystem initialized
[    0.539446] libata version 3.00 loaded.
[    0.539501] PCI: Using ACPI for IRQ routing
[    0.543584] PCI: pci_cache_line_size set to 64 bytes
[    0.543710] reserve RAM buffer: 000000000008f000 - 000000000008ffff=20
[    0.543712] reserve RAM buffer: 000000008ad36000 - 000000008bffffff=20
[    0.543717] reserve RAM buffer: 000000008ad6f000 - 000000008bffffff=20
[    0.543720] reserve RAM buffer: 000000008ae33000 - 000000008bffffff=20
[    0.543723] reserve RAM buffer: 000000008aed2000 - 000000008bffffff=20
[    0.543726] reserve RAM buffer: 000000008afa2000 - 000000008bffffff=20
[    0.543728] reserve RAM buffer: 000000016fe00000 - 000000016fffffff=20
[    0.543841] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.543847] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.545867] Switching to clocksource hpet
[    0.548891] pnp: PnP ACPI init
[    0.548906] ACPI: bus type pnp registered
[    0.549107] pnp 00:00: [bus 00-ff]
[    0.549110] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.549113] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.549115] pnp 00:00: [io  0x0d00-0xffff window]
[    0.549117] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.549120] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.549122] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.549124] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.549126] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.549129] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.549131] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.549133] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.549135] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.549137] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.549141] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.549143] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.549145] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.549147] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.549150] pnp 00:00: [mem 0x8fa00000-0xfeafffff window]
[    0.549152] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.549205] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.549299] pnp 00:01: [io  0x0000-0x001f]
[    0.549301] pnp 00:01: [io  0x0081-0x0091]
[    0.549303] pnp 00:01: [io  0x0093-0x009f]
[    0.549305] pnp 00:01: [io  0x00c0-0x00df]
[    0.549307] pnp 00:01: [dma 4]
[    0.549339] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.549348] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.549376] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.549466] pnp 00:03: [irq 0 disabled]
[    0.549475] pnp 00:03: [irq 8]
[    0.549477] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.549527] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.549531] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01=
 (active)
[    0.549543] pnp 00:04: [io  0x00f0]
[    0.549549] pnp 00:04: [irq 13]
[    0.549578] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.549590] pnp 00:05: [io  0x002e-0x002f]
[    0.549592] pnp 00:05: [io  0x004e-0x004f]
[    0.549594] pnp 00:05: [io  0x0061]
[    0.549596] pnp 00:05: [io  0x0063]
[    0.549597] pnp 00:05: [io  0x0065]
[    0.549599] pnp 00:05: [io  0x0067]
[    0.549601] pnp 00:05: [io  0x0080]
[    0.549603] pnp 00:05: [io  0x0092]
[    0.549605] pnp 00:05: [io  0x00b2-0x00b3]
[    0.549607] pnp 00:05: [io  0x1000-0x100f]
[    0.549609] pnp 00:05: [io  0x0400-0x047f]
[    0.549610] pnp 00:05: [io  0x0500-0x057f]
[    0.549658] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.549662] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.549664] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.549667] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.549677] pnp 00:06: [io  0x0070-0x0077]
[    0.549706] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.549720] pnp 00:07: [io  0x0300-0x031f]
[    0.549725] pnp 00:07: [irq 6]
[    0.549755] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
[    0.549943] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.549945] pnp 00:08: [mem 0xfed10000-0xfed17fff]
[    0.549947] pnp 00:08: [mem 0xfed18000-0xfed18fff]
[    0.549949] pnp 00:08: [mem 0xfed19000-0xfed19fff]
[    0.549951] pnp 00:08: [mem 0xe0000000-0xefffffff]
[    0.549953] pnp 00:08: [mem 0xfed20000-0xfed3ffff]
[    0.549955] pnp 00:08: [mem 0xfed90000-0xfed93fff]
[    0.549957] pnp 00:08: [mem 0xfed45000-0xfed8ffff]
[    0.549959] pnp 00:08: [mem 0xff000000-0xffffffff]
[    0.549961] pnp 00:08: [mem 0xfee00000-0xfeefffff]
[    0.549964] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.550019] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.550022] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.550025] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.550028] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.550031] system 00:08: [mem 0xe0000000-0xefffffff] could not be reser=
ved
[    0.550034] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.550037] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.550039] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.550042] system 00:08: [mem 0xff000000-0xffffffff] could not be reser=
ved
[    0.550045] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.550048] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.555807] pnp 00:09: [mem 0x20000000-0x201fffff]
[    0.555809] pnp 00:09: [mem 0x40000000-0x401fffff]
[    0.555909] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.555920] system 00:09: [mem 0x40000000-0x401fffff] has been reserved
[    0.555923] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.555933] pnp: PnP ACPI: found 10 devices
[    0.555935] ACPI: ACPI bus type pnp unregistered
[    0.562891] PCI: max bus depth: 3 pci_try_num: 4
[    0.562954] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.562959] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.562967] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.562972] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.562980] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.562985] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.562993] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.562997] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.563005] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.563007] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.563011] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.563014] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff=
 64bit pref]
[    0.563019] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.563026] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.563039] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.563047] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.563070] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.563074] pci 0000:00:01.0: setting latency timer to 64
[    0.563080] pci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.563084] pci 0000:03:00.0: setting latency timer to 64
[    0.563090] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.563094] pci 0000:04:00.0: setting latency timer to 64
[    0.563099] pci 0000:04:03.0: enabling device (0000 -> 0002)
[    0.563106] pci 0000:04:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.563111] pci 0000:04:03.0: setting latency timer to 64
[    0.563117] pci 0000:04:04.0: enabling device (0000 -> 0002)
[    0.563120] pci 0000:04:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.563125] pci 0000:04:04.0: setting latency timer to 64
[    0.563132] pci 0000:00:1c.0: enabling device (0000 -> 0002)
[    0.563137] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.563144] pci 0000:00:1c.0: setting latency timer to 64
[    0.563212] pci 0000:00:1c.1: power state changed by ACPI to D0
[    0.563217] pci 0000:00:1c.1: power state changed by ACPI to D0
[    0.563227] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.563233] pci 0000:00:1c.1: setting latency timer to 64
[    0.563238] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.563240] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.563243] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.563245] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.563247] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.563249] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.563252] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.563254] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.563257] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.563259] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.563261] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.563263] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.563266] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.563268] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.563270] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.563272] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    0.563275] pci_bus 0000:00: resource 20 [mem 0x8fa00000-0xfeafffff]
[    0.563277] pci_bus 0000:00: resource 21 [mem 0xfed40000-0xfed44fff]
[    0.563279] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.563282] pci_bus 0000:03: resource 1 [mem 0xa0700000-0xa49fffff]
[    0.563284] pci_bus 0000:03: resource 2 [mem 0xa4a00000-0xa89fffff 64bit=
 pref]
[    0.563287] pci_bus 0000:04: resource 1 [mem 0xa0700000-0xa09fffff]
[    0.563289] pci_bus 0000:05: resource 1 [mem 0xa0700000-0xa07fffff]
[    0.563292] pci_bus 0000:06: resource 1 [mem 0xa0800000-0xa08fffff]
[    0.563294] pci_bus 0000:37: resource 1 [mem 0xa0900000-0xa09fffff]
[    0.563296] pci_bus 0000:01: resource 1 [mem 0xa0500000-0xa05fffff]
[    0.563299] pci_bus 0000:02: resource 1 [mem 0xa0400000-0xa04fffff]
[    0.563367] NET: Registered protocol family 2
[    0.563538] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.564633] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.566364] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.566521] TCP: Hash tables configured (established 524288 bind 65536)
[    0.566524] TCP reno registered
[    0.566533] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.566557] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.566676] NET: Registered protocol family 1
[    0.566692] pci 0000:00:02.0: Boot video device
[    0.566704] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd =3D 0x0080
[    0.566706] pci 0000:00:1a.0: Performing full reset
[    0.566765] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd =3D 0x0080
[    0.566767] pci 0000:00:1d.0: Performing full reset
[    0.566860] PCI: CLS 256 bytes, default 64
[    0.566923] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.566926] Placing 64MB software IO TLB between ffff880083d1e000 - ffff=
880087d1e000
[    0.566929] software IO TLB at phys 0x83d1e000 - 0x87d1e000
[    0.567432] audit: initializing netlink socket (disabled)
[    0.567442] type=3D2000 audit(1323648347.406:1): initialized
[    0.587702] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.597159] VFS: Disk quotas dquot_6.5.2
[    0.597197] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.597490] msgmni has been set to 7748
[    0.597647] alg: No test for stdrng (krng)
[    0.597683] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.597686] io scheduler noop registered
[    0.597688] io scheduler deadline registered
[    0.597708] io scheduler cfq registered (default)
[    0.597796] pcieport 0000:00:01.0: setting latency timer to 64
[    0.597825] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.598037] pcieport 0000:03:00.0: setting latency timer to 64
[    0.598072] pcieport 0000:03:00.0: irq 41 for MSI/MSI-X
[    0.598150] pcieport 0000:04:00.0: setting latency timer to 64
[    0.598186] pcieport 0000:04:00.0: irq 42 for MSI/MSI-X
[    0.598265] pcieport 0000:04:03.0: setting latency timer to 64
[    0.598301] pcieport 0000:04:03.0: irq 43 for MSI/MSI-X
[    0.598378] pcieport 0000:04:04.0: setting latency timer to 64
[    0.598414] pcieport 0000:04:04.0: irq 44 for MSI/MSI-X
[    0.598597] efifb: probing for efifb
[    0.600178] efifb: framebuffer at 0x90000000, mapped to 0xffffc9000a9000=
00, using 4224k, total 4224k
[    0.600181] efifb: mode is 1366x768x32, linelength=3D5632, pages=3D1
[    0.600183] efifb: scrolling: redraw
[    0.600185] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.603411] Console: switching to colour frame buffer device 170x48
[    0.606470] fb0: EFI VGA frame buffer device
[    0.606478] intel_idle: MWAIT substates: 0x21120
[    0.606480] intel_idle: v0.4 model 0x2A
[    0.606482] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.606530] ERST: Table is not found!
[    0.606532] GHES: HEST is not enabled!
[    0.606588] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.651164] Linux agpgart interface v0.103
[    0.651257] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    0.651457] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K tota=
l, 262144K mappable
[    0.653389] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.653500] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x90000000
[    0.653624] ahci 0000:00:1f.2: version 3.0
[    0.653635] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.653687] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.653737] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
1 impl SATA mode
[    0.653741] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum=
 part ems apst=20
[    0.653747] ahci 0000:00:1f.2: setting latency timer to 64
[    0.654324] scsi0 : ahci
[    0.654427] scsi1 : ahci
[    0.654502] scsi2 : ahci
[    0.654573] scsi3 : ahci
[    0.654643] scsi4 : ahci
[    0.654715] scsi5 : ahci
[    0.654842] ata1: SATA max UDMA/133 abar m2048@0xa0606000 port 0xa060610=
0 irq 45
[    0.654844] ata2: DUMMY
[    0.654846] ata3: DUMMY
[    0.654847] ata4: DUMMY
[    0.654848] ata5: DUMMY
[    0.654849] ata6: DUMMY
[    0.654942] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.655834] i8042: No controller found
[    0.655926] mousedev: PS/2 mouse device common for all mice
[    0.655967] rtc_cmos 00:06: RTC can wake from S4
[    0.656088] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.656119] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.656127] Linux telephony interface: v1.00
[    0.656268] cpuidle: using governor ladder
[    0.656478] cpuidle: using governor menu
[    0.656630] TCP cubic registered
[    0.656717] NET: Registered protocol family 10
[    0.657193] Mobile IPv6
[    0.657196] NET: Registered protocol family 17
[    0.657200] Registering the dns_resolver key type
[    0.657345] PM: Checking hibernation image partition /dev/sda2
[    0.959383] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.960988] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    0.962135] ata1.00: ATA-8: APPLE SSD SM256C, AXM09A1Q, max UDMA/133
[    0.962151] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 31/32=
), AA
[    0.962588] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    0.963852] ata1.00: configured for UDMA/133
[    0.964143] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SM256C AX=
M0 PQ: 0 ANSI: 5
[    0.964438] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB=
/233 GiB)
[    0.964905] sd 0:0:0:0: [sda] Write Protect is off
[    0.964909] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.965064] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.968829]  sda: sda1 sda2 sda3 sda4
[    0.969926] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.969976] PM: Hibernation image partition 8:2 present
[    0.969979] PM: Looking for hibernation image.
[    0.970402] PM: Image not found (code -22)
[    0.970405] PM: Hibernation image not present or could not be loaded.
[    0.970420] registered taskstats version 1
[    0.975735] rtc_cmos 00:06: setting system clock to 2011-12-12 00:05:48 =
UTC (1323648348)
[    0.975813] Initializing network drop monitor service
[    0.979429] kjournald starting.  Commit interval 5 seconds
[    0.979489] EXT3-fs (sda4): mounted filesystem with ordered data mode
[    0.979499] VFS: Mounted root (ext3 filesystem) readonly on device 8:4.
[    0.980054] devtmpfs: mounted
[    0.981102] Freeing unused kernel memory: 592k freed
[    0.981190] Write protecting the kernel read-only data: 8192k
[    0.985598] Freeing unused kernel memory: 1356k freed
[    0.987580] Freeing unused kernel memory: 552k freed
[    1.119369] udevd[103]: starting version 175
[    1.211273] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input0
[    1.211320] ACPI: Lid Switch [LID0]
[    1.211384] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input1
[    1.211390] ACPI: Power Button [PWRB]
[    1.211458] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input2
[    1.211464] ACPI: Sleep Button [SLPB]
[    1.211529] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[    1.211534] ACPI: Power Button [PWRF]
[    1.217016] ACPI: AC Adapter [ADP1] (on-line)
[    1.221758] usbcore: registered new interface driver usbfs
[    1.221782] usbcore: registered new interface driver hub
[    1.223372] usbcore: registered new device driver usb
[    1.230537] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.230543] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
[    1.230585] ehci_hcd 0000:00:1a.7: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    1.230612] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.230618] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.230641] drivers/usb/core/inode.c: creating file 'devices'
[    1.230648] drivers/usb/core/inode.c: creating file '001'
[    1.230653] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    1.230665] ehci_hcd 0000:00:1a.7: reset hcs_params 0x203206 dbg=3D2 cc=
=3D3 pcc=3D2 ordered !ppc ports=3D6
[    1.230671] ehci_hcd 0000:00:1a.7: reset hcc_params 36881 caching frame =
1024 64 bit addr
[    1.230692] ehci_hcd 0000:00:1a.7: support lpm
[    1.230708] ehci_hcd 0000:00:1a.7: debug port 2
[    1.230714] ehci_hcd 0000:00:1a.7: reset command 0080012 (park)=3D0 ithr=
esh=3D8 Periodic period=3D1024 Reset HALT
[    1.234604] ehci_hcd 0000:00:1a.7: cache line size of 256 is not support=
ed
[    1.234610] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    1.234633] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xa0606c00
[    1.234641] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=3D0 ithr=
esh=3D8 period=3D1024 Reset HALT
[    1.238532] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=3D0 ithre=
sh=3D1 period=3D1024 RUN
[    1.241697] uhci_hcd: USB Universal Host Controller Interface driver
[    1.244860] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.244895] usb usb1: default language 0x0409
[    1.244906] usb usb1: udev 1, busnum 1, minor =3D 0
[    1.244910] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.244914] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.244918] usb usb1: Product: EHCI Host Controller
[    1.244921] usb usb1: Manufacturer: Linux 3.2.0-rc5-00021-g899e4f0 ehci_=
hcd
[    1.244924] usb usb1: SerialNumber: 0000:00:1a.7
[    1.245038] usb usb1: usb_probe_device
[    1.245043] usb usb1: configuration #1 chosen from 1 choice
[    1.245053] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.245088] hub 1-0:1.0: usb_probe_interface
[    1.245091] hub 1-0:1.0: usb_probe_interface - got id
[    1.245095] hub 1-0:1.0: USB hub found
[    1.245101] hub 1-0:1.0: 6 ports detected
[    1.245104] hub 1-0:1.0: standalone hub
[    1.245107] hub 1-0:1.0: no power switching (usb 1.0)
[    1.245110] hub 1-0:1.0: individual port over-current protection
[    1.245113] hub 1-0:1.0: power on to power good time: 20ms
[    1.245118] hub 1-0:1.0: local power source is good
[    1.245122] hub 1-0:1.0: trying to enable port power on non-switchable h=
ub
[    1.245167] drivers/usb/core/inode.c: creating file '001'
[    1.245245] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 22 (level, low) -> I=
RQ 22
[    1.245275] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.245281] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.245290] drivers/usb/core/inode.c: creating file '002'
[    1.245296] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    1.245307] ehci_hcd 0000:00:1d.7: reset hcs_params 0x204208 dbg=3D2 cc=
=3D4 pcc=3D2 ordered !ppc ports=3D8
[    1.245313] ehci_hcd 0000:00:1d.7: reset hcc_params 36881 caching frame =
1024 64 bit addr
[    1.245331] ehci_hcd 0000:00:1d.7: support lpm
[    1.245344] ehci_hcd 0000:00:1d.7: debug port 2
[    1.245351] ehci_hcd 0000:00:1d.7: reset command 0080012 (park)=3D0 ithr=
esh=3D8 Periodic period=3D1024 Reset HALT
[    1.246151] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    1.249230] ehci_hcd 0000:00:1d.7: cache line size of 256 is not support=
ed
[    1.249234] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    1.249253] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xa0606800
[    1.249258] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=3D0 ithr=
esh=3D8 period=3D1024 Reset HALT
[    1.253127] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=3D0 ithre=
sh=3D1 period=3D1024 RUN
[    1.258838] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.258873] usb usb2: default language 0x0409
[    1.258884] usb usb2: udev 1, busnum 2, minor =3D 128
[    1.258887] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.258891] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.258894] usb usb2: Product: EHCI Host Controller
[    1.258897] usb usb2: Manufacturer: Linux 3.2.0-rc5-00021-g899e4f0 ehci_=
hcd
[    1.258900] usb usb2: SerialNumber: 0000:00:1d.7
[    1.259008] usb usb2: usb_probe_device
[    1.259011] usb usb2: configuration #1 chosen from 1 choice
[    1.259019] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    1.259054] hub 2-0:1.0: usb_probe_interface
[    1.259057] hub 2-0:1.0: usb_probe_interface - got id
[    1.259061] hub 2-0:1.0: USB hub found
[    1.259067] hub 2-0:1.0: 8 ports detected
[    1.259070] hub 2-0:1.0: standalone hub
[    1.259072] hub 2-0:1.0: no power switching (usb 1.0)
[    1.259075] hub 2-0:1.0: individual port over-current protection
[    1.259078] hub 2-0:1.0: power on to power good time: 20ms
[    1.259084] hub 2-0:1.0: local power source is good
[    1.259088] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[    1.259137] drivers/usb/core/inode.c: creating file '001'
[    1.259417] uhci_hcd 0000:00:1a.0: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    1.259429] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.259434] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.259443] drivers/usb/core/inode.c: creating file '003'
[    1.259449] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    1.259461] uhci_hcd 0000:00:1a.0: detected 2 ports
[    1.259495] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    1.259498] uhci_hcd 0000:00:1a.0: Performing full reset
[    1.259644] uhci_hcd 0000:00:1a.0: irq 21, io base 0x00002140
[    1.259680] usb usb3: default language 0x0409
[    1.259686] usb usb3: udev 1, busnum 3, minor =3D 256
[    1.259688] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.259691] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.259693] usb usb3: Product: UHCI Host Controller
[    1.259696] usb usb3: Manufacturer: Linux 3.2.0-rc5-00021-g899e4f0 uhci_=
hcd
[    1.259699] usb usb3: SerialNumber: 0000:00:1a.0
[    1.259911] usb usb3: usb_probe_device
[    1.259916] usb usb3: configuration #1 chosen from 1 choice
[    1.259926] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    1.259965] hub 3-0:1.0: usb_probe_interface
[    1.259968] hub 3-0:1.0: usb_probe_interface - got id
[    1.259971] hub 3-0:1.0: USB hub found
[    1.259978] hub 3-0:1.0: 2 ports detected
[    1.259980] hub 3-0:1.0: standalone hub
[    1.259983] hub 3-0:1.0: no power switching (usb 1.0)
[    1.259985] hub 3-0:1.0: individual port over-current protection
[    1.259988] hub 3-0:1.0: power on to power good time: 2ms
[    1.259994] hub 3-0:1.0: local power source is good
[    1.259997] hub 3-0:1.0: trying to enable port power on non-switchable h=
ub
[    1.260037] drivers/usb/core/inode.c: creating file '001'
[    1.260071] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    1.260091] uhci_hcd 0000:00:1d.0: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    1.260098] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.260102] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.260107] drivers/usb/core/inode.c: creating file '004'
[    1.260111] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 4
[    1.260118] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.260123] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[    1.260125] uhci_hcd 0000:00:1d.0: Performing full reset
[    1.260152] uhci_hcd 0000:00:1d.0: irq 19, io base 0x000020e0
[    1.260214] usb usb4: default language 0x0409
[    1.260264] usb usb4: udev 1, busnum 4, minor =3D 384
[    1.260267] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.260270] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.260274] usb usb4: Product: UHCI Host Controller
[    1.260276] usb usb4: Manufacturer: Linux 3.2.0-rc5-00021-g899e4f0 uhci_=
hcd
[    1.260279] usb usb4: SerialNumber: 0000:00:1d.0
[    1.260483] usb usb4: usb_probe_device
[    1.260487] usb usb4: configuration #1 chosen from 1 choice
[    1.260497] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    1.260559] hub 4-0:1.0: usb_probe_interface
[    1.260562] hub 4-0:1.0: usb_probe_interface - got id
[    1.260565] hub 4-0:1.0: USB hub found
[    1.260572] hub 4-0:1.0: 2 ports detected
[    1.260575] hub 4-0:1.0: standalone hub
[    1.260577] hub 4-0:1.0: no power switching (usb 1.0)
[    1.260580] hub 4-0:1.0: individual port over-current protection
[    1.260583] hub 4-0:1.0: power on to power good time: 2ms
[    1.260588] hub 4-0:1.0: local power source is good
[    1.260592] hub 4-0:1.0: trying to enable port power on non-switchable h=
ub
[    1.260618] drivers/usb/core/inode.c: creating file '001'
[    1.260661] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    1.319627] ACPI: Battery Slot [BAT0] (battery present)
[    1.322053] i801_smbus 0000:00:1f.3: enabling device (0000 -> 0003)
[    1.322081] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) ->=
 IRQ 18
[    1.340640] cfg80211: Calling CRDA to update world regulatory domain
[    1.345651] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001803 0  ACK=
 POWER sig=3Dj CSC CONNECT
[    1.345660] hub 1-0:1.0: port 1: status 0501 change 0001
[    1.345673] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001803 0  ACK=
 POWER sig=3Dj CSC CONNECT
[    1.345678] hub 1-0:1.0: port 2: status 0501 change 0001
[    1.354771] brcmsmac 0000:02:00.0: bus 2 slot 0 func 0 irq 0
[    1.354819] brcmsmac 0000:02:00.0: enabling device (0000 -> 0002)
[    1.354832] brcmsmac 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> I=
RQ 17
[    1.354849] brcmsmac 0000:02:00.0: setting latency timer to 64
[    1.359684] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    1.359698] uhci_hcd 0000:00:1a.0: port 2 portsc 0082,00
[    1.359721] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    1.360357] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 0  ACK=
 POWER sig=3Dj CSC CONNECT
[    1.360362] hub 2-0:1.0: port 1: status 0501 change 0001
[    1.420114] applesmc: : read arg fail
[    1.445191] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    1.445202] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low)=
 -> IRQ 22
[    1.445216] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    1.445267] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    1.445295] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    1.445559] hub 1-0:1.0: state 7 ports 6 chg 0006 evt 0000
[    1.445570] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    1.496779] ehci_hcd 0000:00:1a.7: port 1 high speed
[    1.496785] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    1.508297] applesmc: key=3D349 fan=3D1 temp=3D25 acc=3D0 lux=3D2 kbd=3D1
[    1.508300] applesmc: init_smcreg() took 50 ms
[    1.508585] Registered led device: smc::kbd_backlight
[    1.547477] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.566426] Refined TSC clocksource calibration: 1800.012 MHz.
[    1.566432] Switching to clocksource tsc
[    1.598621] ehci_hcd 0000:00:1a.7: port 1 high speed
[    1.598627] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    1.661437] ehci_hcd 0000:00:1a.7: set dev address 2 for port 1
[    1.661444] ehci_hcd 0000:00:1a.7: LPM: no device attached
[    1.661726] usb 1-1: udev 2, busnum 1, minor =3D 1
[    1.661739] usb 1-1: New USB device found, idVendor=3D0424, idProduct=3D=
2513
[    1.661742] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    1.661911] usb 1-1: usb_probe_device
[    1.661917] usb 1-1: configuration #1 chosen from 1 choice
[    1.662046] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    1.662080] hub 1-1:1.0: usb_probe_interface
[    1.662084] hub 1-1:1.0: usb_probe_interface - got id
[    1.662088] hub 1-1:1.0: USB hub found
[    1.662185] hub 1-1:1.0: 3 ports detected
[    1.662194] hub 1-1:1.0: compound device; port removable status: FFR
[    1.662197] hub 1-1:1.0: individual port power switching
[    1.662199] hub 1-1:1.0: individual port over-current protection
[    1.662336] hub 1-1:1.0: TT per port
[    1.662340] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    1.662342] hub 1-1:1.0: power on to power good time: 100ms
[    1.662529] hub 1-1:1.0: local power source is good
[    1.662535] hub 1-1:1.0: enabling power on all ports
[    1.662967] drivers/usb/core/inode.c: creating file '002'
[    1.663012] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    1.713440] ehci_hcd 0000:00:1a.7: port 2 high speed
[    1.713447] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    1.762338] hub 1-1:1.0: port 1: status 0101 change 0001
[    1.762825] hub 1-1:1.0: port 2: status 0101 change 0001
[    1.764059] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[    1.815280] ehci_hcd 0000:00:1a.7: port 2 high speed
[    1.815287] ehci_hcd 0000:00:1a.7: GetStatus port:2 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    1.862961] usb 1-1: link qh256-0001/ffff880165cf7a40 start 1 [1/0 us]
[    1.878801] ehci_hcd 0000:00:1a.7: set dev address 3 for port 2
[    1.878808] ehci_hcd 0000:00:1a.7: LPM: no device attached
[    1.884996] usb 1-2: skipped 1 descriptor after configuration
[    1.885000] usb 1-2: skipped 4 descriptors after interface
[    1.885003] usb 1-2: skipped 1 descriptor after endpoint
[    1.885005] usb 1-2: skipped 9 descriptors after interface
[    1.885633] usb 1-2: default language 0x0409
[    1.889897] usb 1-2: udev 3, busnum 1, minor =3D 2
[    1.889911] usb 1-2: New USB device found, idVendor=3D05ac, idProduct=3D=
850a
[    1.889914] usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[    1.889917] usb 1-2: Product: FaceTime Camera (Built-in)
[    1.889919] usb 1-2: Manufacturer: Apple Inc.
[    1.889921] usb 1-2: SerialNumber: CCGB6L03L5DL8LFX
[    1.890121] usb 1-2: usb_probe_device
[    1.890126] usb 1-2: configuration #1 chosen from 1 choice
[    1.890888] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[    1.892940] usb 1-2: adding 1-2:1.1 (config #1, interface 1)
[    1.892988] usb 1-2: adding 1-2:1.2 (config #1, interface 2)
[    1.893021] drivers/usb/core/inode.c: creating file '003'
[    1.893056] hub 2-0:1.0: state 7 ports 8 chg 0002 evt 0000
[    1.893067] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    1.944080] ehci_hcd 0000:00:1d.7: port 1 high speed
[    1.944087] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    1.972338] HDMI status: Codec=3D3 Pin=3D5 Presence_Detect=3D0 ELD_Valid=
=3D0
[    1.972517] HDMI status: Codec=3D3 Pin=3D6 Presence_Detect=3D0 ELD_Valid=
=3D0
[    1.972724] HDMI status: Codec=3D3 Pin=3D7 Presence_Detect=3D0 ELD_Valid=
=3D0
[    1.972874] input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input5
[    1.972955] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input6
[    1.973019] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input7
[    1.994754] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.045919] ehci_hcd 0000:00:1d.7: port 1 high speed
[    2.045925] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    2.108799] ehci_hcd 0000:00:1d.7: set dev address 2 for port 1
[    2.108805] ehci_hcd 0000:00:1d.7: LPM: no device attached
[    2.109086] usb 2-1: udev 2, busnum 2, minor =3D 129
[    2.109090] usb 2-1: New USB device found, idVendor=3D0424, idProduct=3D=
2513
[    2.109092] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    2.109274] usb 2-1: usb_probe_device
[    2.109280] usb 2-1: configuration #1 chosen from 1 choice
[    2.109370] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    2.109409] hub 2-1:1.0: usb_probe_interface
[    2.109412] hub 2-1:1.0: usb_probe_interface - got id
[    2.109415] hub 2-1:1.0: USB hub found
[    2.109457] hub 2-1:1.0: 1 port detected
[    2.109459] hub 2-1:1.0: compound device; port removable status: R
[    2.109460] hub 2-1:1.0: individual port power switching
[    2.109462] hub 2-1:1.0: individual port over-current protection
[    2.109632] hub 2-1:1.0: TT per port
[    2.109636] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    2.109638] hub 2-1:1.0: power on to power good time: 100ms
[    2.109884] hub 2-1:1.0: local power source is good
[    2.109895] hub 2-1:1.0: enabling power on all ports
[    2.109977] drivers/usb/core/inode.c: creating file '002'
[    2.110027] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.110034] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.110038] hub 1-1:1.0: state 7 ports 3 chg 0006 evt 0000
[    2.110109] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    2.120783] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
[    2.182695] usb 1-1.1: new full-speed USB device number 4 using ehci_hcd
[    2.193664] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
[    2.209644] usb 2-1: link qh256-0001/ffff880165cf7e40 start 1 [1/0 us]
[    2.267333] usb 1-1.1: ep0 maxpacket =3D 8
[    2.269160] usb 1-1.1: default language 0x0409
[    2.269658] usb 1-1.1: udev 4, busnum 1, minor =3D 3
[    2.269672] usb 1-1.1: New USB device found, idVendor=3D0a5c, idProduct=
=3D4500
[    2.269675] usb 1-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    2.269678] usb 1-1.1: Product: BRCM20702 Hub
[    2.269680] usb 1-1.1: Manufacturer: Apple Inc.
[    2.269864] usb 1-1.1: usb_probe_device
[    2.269869] usb 1-1.1: configuration #1 chosen from 1 choice
[    2.270130] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    2.270171] hub 1-1.1:1.0: usb_probe_interface
[    2.270174] hub 1-1.1:1.0: usb_probe_interface - got id
[    2.270177] hub 1-1.1:1.0: USB hub found
[    2.270360] hub 1-1.1:1.0: 3 ports detected
[    2.270364] hub 1-1.1:1.0: compound device; port removable status: FFF
[    2.270366] hub 1-1.1:1.0: ganged power switching
[    2.270368] hub 1-1.1:1.0: global over-current protection
[    2.270370] hub 1-1.1:1.0: power on to power good time: 100ms
[    2.270671] hub 1-1.1:1.0: local power source is good
[    2.270688] hub 1-1.1:1.0: no over-current condition exists
[    2.270691] hub 1-1.1:1.0: enabling power on all ports
[    2.271440] drivers/usb/core/inode.c: creating file '004'
[    2.271611] hub 1-1:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    2.282526] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    2.344441] usb 1-1.2: new full-speed USB device number 5 using ehci_hcd
[    2.355413] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    2.361181] usb usb3: suspend_rh (auto-stop)
[    2.361208] usb usb4: suspend_rh (auto-stop)
[    2.371383] hub 1-1.1:1.0: port 1: status 0101 change 0001
[    2.371896] hub 1-1.1:1.0: port 2: status 0101 change 0001
[    2.372370] hub 1-1.1:1.0: port 3: status 0101 change 0001
[    2.429085] usb 1-1.2: ep0 maxpacket =3D 8
[    2.433205] usb 1-1.2: skipped 1 descriptor after interface
[    2.433209] usb 1-1.2: skipped 1 descriptor after interface
[    2.433212] usb 1-1.2: skipped 1 descriptor after interface
[    2.433527] usb 1-1.2: default language 0x0409
[    2.435664] usb 1-1.2: udev 5, busnum 1, minor =3D 4
[    2.435678] usb 1-1.2: New USB device found, idVendor=3D05ac, idProduct=
=3D0249
[    2.435680] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    2.435683] usb 1-1.2: Product: Apple Internal Keyboard / Trackpad
[    2.435685] usb 1-1.2: Manufacturer: Apple Inc.
[    2.435869] usb 1-1.2: usb_probe_device
[    2.435875] usb 1-1.2: configuration #1 chosen from 1 choice
[    2.436137] usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
[    2.437319] usb 1-1.2: adding 1-1.2:1.1 (config #1, interface 1)
[    2.437944] usb 1-1.2: adding 1-1.2:1.2 (config #1, interface 2)
[    2.438568] drivers/usb/core/inode.c: creating file '005'
[    2.438595] hub 2-1:1.0: state 7 ports 1 chg 0000 evt 0000
[    2.445394] bcm5974 1-1.2:1.2: usb_probe_interface
[    2.445399] bcm5974 1-1.2:1.2: usb_probe_interface - got id
[    2.445463] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/=
1-1.2/1-1.2:1.2/input/input8
[    2.445556] usbcore: registered new interface driver bcm5974
[    2.445976] Linux media interface: v0.10
[    2.449925] Linux video capture interface: v2.00
[    2.450620] usbhid 1-1.2:1.0: usb_probe_interface
[    2.450635] usbhid 1-1.2:1.0: usb_probe_interface - got id
[    2.450690] usbhid 1-1.2:1.1: usb_probe_interface
[    2.450692] usbhid 1-1.2:1.1: usb_probe_interface - got id
[    2.450733] usbcore: registered new interface driver usbhid
[    2.450735] usbhid: USB HID core driver
[    2.452447] uvcvideo 1-2:1.0: usb_probe_interface
[    2.452452] uvcvideo 1-2:1.0: usb_probe_interface - got id
[    2.452473] uvcvideo: Found UVC 1.00 device FaceTime Camera (Built-in) (=
05ac:850a)
[    2.457453] input: Apple Inc. Apple Internal Keyboard / Trackpad as /dev=
ices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input9
[    2.457477] usb 1-1.2: link qh8-0e01/ffff880165d8fe40 start 2 [1/2 us]
[    2.457561] apple 0003:05AC:0249.0001: input,hidraw0: USB HID v1.11 Keyb=
oard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.=
2/input0
[    2.461089] input: FaceTime Camera (Built-in) as /devices/pci0000:00/000=
0:00:1a.7/usb1/1-2/1-2:1.0/input/input10
[    2.461187] usbcore: registered new interface driver uvcvideo
[    2.461189] USB Video Class driver (1.1.1)
[    2.463278] usb 1-2: link qh4-0001/ffff88016715cf40 start 3 [1/0 us]
[    2.463319] usb 1-2: unlink qh4-0001/ffff88016715cf40 start 3 [1/0 us]
[    2.472010] usb 1-1.1: link qh128-0e01/ffff880165d8fb40 start 4 [1/2 us]
[    2.472054] hub 1-1.1:1.0: state 7 ports 3 chg 000e evt 0000
[    2.472357] hub 1-1.1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    2.534147] usb 1-1.1.1: new full-speed USB device number 6 using ehci_h=
cd
[    2.545118] hub 1-1.1:1.0: port 1 not reset yet, waiting 10ms
[    2.579936] apple 0003:05AC:0249.0002: hidraw1: USB HID v1.11 Device [Ap=
ple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1
[    2.618782] usb 1-1.1.1: ep0 maxpacket =3D 8
[    2.621998] usb 1-1.1.1: skipped 1 descriptor after interface
[    2.622004] usb 1-1.1.1: udev 6, busnum 1, minor =3D 5
[    2.622006] usb 1-1.1.1: New USB device found, idVendor=3D05ac, idProduc=
t=3D820a
[    2.622009] usb 1-1.1.1: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    2.622192] usb 1-1.1.1: usb_probe_device
[    2.622198] usb 1-1.1.1: configuration #1 chosen from 1 choice
[    2.622295] usb 1-1.1.1: adding 1-1.1.1:1.0 (config #1, interface 0)
[    2.622333] usbhid 1-1.1.1:1.0: usb_probe_interface
[    2.622337] usbhid 1-1.1.1:1.0: usb_probe_interface - got id
[    2.623677] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1a.7/usb=
1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input11
[    2.623709] usb 1-1.1.1: link qh8-0e01/ffff880165d931c0 start 5 [1/2 us]
[    2.623899] generic-usb 0003:05AC:820A.0003: input,hidraw2: USB HID v1.1=
1 Keyboard [HID 05ac:820a] on usb-0000:00:1a.7-1.1.1/input0
[    2.623931] drivers/usb/core/inode.c: creating file '006'
[    2.624245] hub 1-1.1:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    2.634988] hub 1-1.1:1.0: port 2 not reset yet, waiting 10ms
[    2.696890] usb 1-1.1.2: new full-speed USB device number 7 using ehci_h=
cd
[    2.771549] usb 1-1.1.2: ep0 maxpacket =3D 8
[    2.774528] usb 1-1.1.2: skipped 1 descriptor after interface
[    2.774533] usb 1-1.1.2: udev 7, busnum 1, minor =3D 6
[    2.774536] usb 1-1.1.2: New USB device found, idVendor=3D05ac, idProduc=
t=3D820b
[    2.774538] usb 1-1.1.2: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    2.774721] usb 1-1.1.2: usb_probe_device
[    2.774728] usb 1-1.1.2: configuration #1 chosen from 1 choice
[    2.774963] usb 1-1.1.2: adding 1-1.1.2:1.0 (config #1, interface 0)
[    2.775007] usbhid 1-1.1.2:1.0: usb_probe_interface
[    2.775011] usbhid 1-1.1.2:1.0: usb_probe_interface - got id
[    2.776408] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1a.7/usb=
1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input12
[    2.776716] generic-usb 0003:05AC:820B.0004: input,hidraw3: USB HID v1.1=
1 Mouse [HID 05ac:820b] on usb-0000:00:1a.7-1.1.2/input0
[    2.776750] drivers/usb/core/inode.c: creating file '007'
[    2.776989] hub 1-1.1:1.0: port 3, status 0101, change 0000, 12 Mb/s
[    2.787744] hub 1-1.1:1.0: port 3 not reset yet, waiting 10ms
[    2.849658] usb 1-1.1.3: new full-speed USB device number 8 using ehci_h=
cd
[    2.860634] hub 1-1.1:1.0: port 3 not reset yet, waiting 10ms
[    2.937139] usb 1-1.1.3: skipped 1 descriptor after interface
[    2.937496] usb 1-1.1.3: default language 0x0409
[    2.938252] usb 1-1.1.3: udev 8, busnum 1, minor =3D 7
[    2.938266] usb 1-1.1.3: New USB device found, idVendor=3D05ac, idProduc=
t=3D821f
[    2.938269] usb 1-1.1.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    2.938272] usb 1-1.1.3: Product: Bluetooth USB Host Controller
[    2.938274] usb 1-1.1.3: Manufacturer: Apple Inc.
[    2.938458] usb 1-1.1.3: usb_probe_device
[    2.938464] usb 1-1.1.3: configuration #1 chosen from 1 choice
[    2.938555] usb 1-1.1.3: adding 1-1.1.3:1.0 (config #1, interface 0)
[    2.938644] usb 1-1.1.3: adding 1-1.1.3:1.1 (config #1, interface 1)
[    2.938715] usb 1-1.1.3: adding 1-1.1.3:1.2 (config #1, interface 2)
[    2.938780] usb 1-1.1.3: adding 1-1.1.3:1.3 (config #1, interface 3)
[    2.938809] drivers/usb/core/inode.c: creating file '008'
[    2.938844] hub 1-1.1:1.0: state 7 ports 3 chg 0000 evt 0008
[    2.951992] Bluetooth: Core ver 2.16
[    2.952009] NET: Registered protocol family 31
[    2.952011] Bluetooth: HCI device and connection manager initialized
[    2.952014] Bluetooth: HCI socket layer initialized
[    2.952015] Bluetooth: L2CAP socket layer initialized
[    2.952020] Bluetooth: SCO socket layer initialized
[    2.953395] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    2.953416] btusb 1-1.1.3:1.0: usb_probe_interface
[    2.953419] btusb 1-1.1.3:1.0: usb_probe_interface - got id
[    2.953797] btusb 1-1.1.3:1.2: usb_probe_interface
[    2.953801] btusb 1-1.1.3:1.2: usb_probe_interface - got id
[    2.953809] btusb 1-1.1.3:1.3: usb_probe_interface
[    2.953811] btusb 1-1.1.3:1.3: usb_probe_interface - got id
[    2.953868] usb 1-1.1.3: link qh1-0e01/ffff880165cf74c0 start 0 [1/2 us]
[    2.953871] usbcore: registered new interface driver btusb
[    2.977214] usb 1-1.1.1: unlink qh8-0e01/ffff880165d931c0 start 5 [1/2 u=
s]
[    2.990207] ehci_hcd 0000:00:1a.7: reused qh ffff880165d931c0 schedule
[    2.990214] usb 1-1.1.1: link qh8-0e01/ffff880165d931c0 start 5 [1/2 us]
[    3.009048] usb 1-1.1.1: unlink qh8-0e01/ffff880165d931c0 start 5 [1/2 u=
s]
[    3.032029] hub 1-1.1:1.0: state 7 ports 3 chg 0000 evt 0006
[    3.032295] hub 1-1.1:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    3.032301] usb 1-1.1.1: USB disconnect, device number 6
[    3.032304] usb 1-1.1.1: unregistering device
[    3.032308] usb 1-1.1.1: unregistering interface 1-1.1.1:1.0
[    3.054150] usb 1-1.1.1: usb_disable_device nuking all URBs
[    3.158263] EXT3-fs (sda4): using internal journal
[    3.167087] hub 1-1.1:1.0: debounce: port 1: total 100ms stable 100ms st=
atus 0x100
[    3.167314] hub 1-1.1:1.0: port 2, status 0100, change 0001, 12 Mb/s
[    3.167318] usb 1-1.1.2: USB disconnect, device number 7
[    3.167320] usb 1-1.1.2: unregistering device
[    3.167323] usb 1-1.1.2: unregistering interface 1-1.1.2:1.0
[    3.173967] loop: module loaded
[    3.180504] usb 1-1.1.2: usb_disable_device nuking all URBs
[    3.284882] hub 1-1.1:1.0: debounce: port 2: total 100ms stable 100ms st=
atus 0x100
[    3.284889] hub 1-1.1:1.0: state 7 ports 3 chg 0000 evt 0000
[    4.290842] Adding 4194300k swap on /volatile/swapfile.  Priority:-1 ext=
ents:1178 across:7720876k SS
[    4.369125] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT =
filesystems, filesystem will be case sensitive!
[    4.550625] RPC: Registered named UNIX socket transport module.
[    4.550629] RPC: Registered udp transport module.
[    4.550632] RPC: Registered tcp transport module.
[    4.550634] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.557003] FS-Cache: Loaded
[    4.563178] FS-Cache: Netfs 'nfs' registered for caching
[    4.569979] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.685168] fuse init (API version 7.17)
[    4.939118] hub 2-1:1.0: hub_suspend
[    4.939134] usb 1-2: usb auto-suspend, wakeup 0
[    4.939152] usb 2-1: unlink qh256-0001/ffff880165cf7e40 start 1 [1/0 us]
[    4.939162] hub 3-0:1.0: hub_suspend
[    4.939169] usb usb3: bus auto-suspend, wakeup 1
[    4.939172] usb usb3: suspend_rh
[    4.939188] hub 4-0:1.0: hub_suspend
[    4.939191] usb usb4: bus auto-suspend, wakeup 1
[    4.939193] usb usb4: suspend_rh
[    4.939351] usb 2-1: usb auto-suspend, wakeup 1
[    5.067852] usb 1-1.1.3: unlink qh1-0e01/ffff880165cf74c0 start 0 [1/2 u=
s]
[    5.068068] usb 1-1: clear tt buffer port 1, a8 ep2 t04048d82
[    5.079783] usb 1-1.2: link qh1-0e01/ffff880165c112c0 start 0 [1/2 us]
[    5.079882] usb 1-1.2: link qh1-0e01/ffff880165f57f40 start 0 [1/3 us]
[    5.083904] usb 1-1.2: unlink qh1-0e01/ffff880165f57f40 start 0 [1/3 us]
[    5.083915] usb 1-1.2: unlink qh1-0e01/ffff880165c112c0 start 0 [1/2 us]
[    5.105712] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.105715] Bluetooth: BNEP filters: protocol multicast
[    5.106075] Bluetooth: RFCOMM TTY layer initialized
[    5.106079] Bluetooth: RFCOMM socket layer initialized
[    5.106081] Bluetooth: RFCOMM ver 1.11
[    5.107462] ehci_hcd 0000:00:1a.7: reused qh ffff880165cf74c0 schedule
[    5.107466] usb 1-1.1.3: link qh1-0e01/ffff880165cf74c0 start 0 [1/2 us]
[    5.271126] ieee80211 phy0: brcms_ops_config: change monitor mode: false=
 (implement)
[    5.272011] ieee80211 phy0: brcms_ops_config: change power-save mode: fa=
lse (implement)
[    5.285122] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fal=
se (implement)
[    5.286709] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    5.973837] input: ACPI Virtual Keyboard Device as /devices/virtual/inpu=
t/input13
[    6.263461] [drm] Initialized drm 1.1.0 20060810


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTuYtTTYtFsjWk68qAQjeCxAA3VlkFDSqveAsohm99DHpcu/4AbmoydOC
dd+bGrpao2TozLdU9CqHxs0rUm2qvIANAINMk9tmT5VyAsqqgyKwRbx+InPPH+uG
RQL+61fnyb0ByhC8Bc2qUmmB4kOT4WknbkYBi6GbgygIahaN9ebE3rHkRMHqYBz3
ltz9Hpz2ISOjiaVcef/tYexV6YCVPCOj1i0Bb5XAydRp45Zh1cOmKENcWNTqxQYe
mI8F1z67qT60xL8QGLtIo59C+g2orcKhXNq9z65AAMlLC8Dkag4mpDquICMXL+6M
pcG01+ebshMzhqRkpfNCEPLI3n9REAbqLSgq2K8SCd8/j67rs2+sZewMnFmFwAEH
+Dy/ddOmSQ1UCeHDlsXGzh+tm/9q5xCZ75BsHL+bB/rWXD/ktcPkDA09edGCSZwY
HENvvJUNu5aRympdH8LhORwKm5F14tulKeIatzPUV/hgGNetmymZAYjrvw86ChI8
MyXJ+6QOyB/+hQ5NhVlBe9kaIptEA6n3YCi/zwPmxwFiBI6AhbH5JKZ801QiDNaO
7LJUVK9RDHt15JUV9siJ+aNMZQWjX7Lo1/nT7+vpuqSF21E5enBewoeKYZUiZW9L
t9wHYF++suOGTMM/cAdrxVQnwwziZVgIHEMObEW104oRIimdTfreAwlb8fqx5fPn
KCeS6Rawo8c=
=LzWw
-----END PGP SIGNATURE-----
--=-=-=--
