Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2CEKqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:46:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab2CEKqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:46:01 -0500
Date: Mon, 5 Mar 2012 11:45:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>, Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        matt.fleming@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
Message-ID: <20120305104538.GC18556@elte.hu>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
 <86zkbxusu2.fsf@sumi.keithp.com>
 <4F52B6F0.6060902@zytor.com>
 <86wr71up4j.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wr71up4j.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( Cc:-ed Yinghai - he can spot memory layout related bugs with
  amazing efficiency. )

 n/t

* Keith Packard <keithp@keithp.com> wrote:

> <#part sign=pgpmime>
> On Sat, 03 Mar 2012 16:27:28 -0800, "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Do you have the dmesg from your MBA?  I'm wondering what the memory map
> > looks like...
> 
> Here's the first part of dmesg from a running kernel (3.3-rc1 plus some
> DRM patches). Let me know if I cut this off too soon...
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.3.0-rc1-00289-ga4ea430 (keithp@sumi) (gcc version 4.6.2 (Debian 4.6.2-11) ) #252 SMP Mon Jan 30 19:49:20 PST 2012
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.3.0-rc1-00289-ga4ea430 root=/dev/sda4 ro
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
> [    0.000000]  BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000090000 - 00000000000a0000 (usable)
> [    0.000000]  BIOS-e820: 00000000000a0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
> [    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
> [    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
> [    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
> [    0.000000]  BIOS-e820: 0000000040200000 - 000000008ad36000 (usable)
> [    0.000000]  BIOS-e820: 000000008ad36000 - 000000008ad5f000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000008ad5f000 - 000000008ad6f000 (usable)
> [    0.000000]  BIOS-e820: 000000008ad6f000 - 000000008ad8f000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000008ad8f000 - 000000008ae33000 (usable)
> [    0.000000]  BIOS-e820: 000000008ae33000 - 000000008ae8f000 (reserved)
> [    0.000000]  BIOS-e820: 000000008ae8f000 - 000000008aed2000 (usable)
> [    0.000000]  BIOS-e820: 000000008aed2000 - 000000008aeff000 (reserved)
> [    0.000000]  BIOS-e820: 000000008aeff000 - 000000008afa2000 (usable)
> [    0.000000]  BIOS-e820: 000000008afa2000 - 000000008fa00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e00f8000 - 00000000e00f9000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffed0000 - 00000000fff00000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 000000016fe00000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] EFI v1.10 by Apple
> [    0.000000]  ACPI=0x8ad8e000  ACPI 2.0=0x8ad8e014  SMBIOS=0x8ad3d000 
> [    0.000000] Kernel-defined memdesc doesn't match the one from EFI!
> [    0.000000] EFI: mem00: type=7, attr=0x80000000000000f, range=[0x0000000000000000-0x000000000008f000) (0MB)
> [    0.000000] EFI: mem01: type=0, attr=0x80000000000000f, range=[0x000000000008f000-0x0000000000090000) (0MB)
> [    0.000000] EFI: mem02: type=7, attr=0x80000000000000f, range=[0x0000000000090000-0x00000000000a0000) (0MB)
> [    0.000000] EFI: mem03: type=2, attr=0xf, range=[0x0000000000100000-0x000000000044f000) (3MB)
> [    0.000000] EFI: mem04: type=7, attr=0xf, range=[0x000000000044f000-0x0000000020000000) (507MB)
> [    0.000000] EFI: mem05: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
> [    0.000000] EFI: mem06: type=7, attr=0xf, range=[0x0000000020200000-0x0000000040000000) (510MB)
> [    0.000000] EFI: mem07: type=0, attr=0xf, range=[0x0000000040000000-0x0000000040200000) (2MB)
> [    0.000000] EFI: mem08: type=7, attr=0xf, range=[0x0000000040200000-0x0000000065b77000) (601MB)
> [    0.000000] EFI: mem09: type=2, attr=0xf, range=[0x0000000065b77000-0x0000000087d1e000) (545MB)
> [    0.000000] EFI: mem10: type=4, attr=0xf, range=[0x0000000087d1e000-0x0000000087d30000) (0MB)
> [    0.000000] EFI: mem11: type=7, attr=0xf, range=[0x0000000087d30000-0x00000000889d2000) (12MB)
> [    0.000000] EFI: mem12: type=1, attr=0xf, range=[0x00000000889d2000-0x00000000889f3000) (0MB)
> [    0.000000] EFI: mem13: type=7, attr=0xf, range=[0x00000000889f3000-0x0000000088a10000) (0MB)
> [    0.000000] EFI: mem14: type=4, attr=0xf, range=[0x0000000088a10000-0x0000000088a23000) (0MB)
> [    0.000000] EFI: mem15: type=2, attr=0xf, range=[0x0000000088a23000-0x0000000088a82000) (0MB)
> [    0.000000] EFI: mem16: type=4, attr=0xf, range=[0x0000000088a82000-0x0000000088a85000) (0MB)
> [    0.000000] EFI: mem17: type=2, attr=0xf, range=[0x0000000088a85000-0x0000000088acd000) (0MB)
> [    0.000000] EFI: mem18: type=4, attr=0xf, range=[0x0000000088acd000-0x0000000088ad4000) (0MB)
> [    0.000000] EFI: mem19: type=2, attr=0xf, range=[0x0000000088ad4000-0x0000000088ad6000) (0MB)
> [    0.000000] EFI: mem20: type=4, attr=0xf, range=[0x0000000088ad6000-0x0000000088af3000) (0MB)
> [    0.000000] EFI: mem21: type=1, attr=0xf, range=[0x0000000088af3000-0x0000000088b10000) (0MB)
> [    0.000000] EFI: mem22: type=4, attr=0xf, range=[0x0000000088b10000-0x0000000088b28000) (0MB)
> [    0.000000] EFI: mem23: type=2, attr=0xf, range=[0x0000000088b28000-0x0000000088b2d000) (0MB)
> [    0.000000] EFI: mem24: type=4, attr=0xf, range=[0x0000000088b2d000-0x0000000088b3b000) (0MB)
> [    0.000000] EFI: mem25: type=2, attr=0xf, range=[0x0000000088b3b000-0x0000000088b3c000) (0MB)
> [    0.000000] EFI: mem26: type=4, attr=0xf, range=[0x0000000088b3c000-0x0000000088b3d000) (0MB)
> [    0.000000] EFI: mem27: type=2, attr=0xf, range=[0x0000000088b3d000-0x0000000088b45000) (0MB)
> [    0.000000] EFI: mem28: type=4, attr=0xf, range=[0x0000000088b45000-0x0000000089491000) (9MB)
> [    0.000000] EFI: mem29: type=3, attr=0xf, range=[0x0000000089491000-0x0000000089492000) (0MB)
> [    0.000000] EFI: mem30: type=4, attr=0xf, range=[0x0000000089492000-0x000000008960b000) (1MB)
> [    0.000000] EFI: mem31: type=3, attr=0xf, range=[0x000000008960b000-0x0000000089610000) (0MB)
> [    0.000000] EFI: mem32: type=4, attr=0xf, range=[0x0000000089610000-0x000000008962c000) (0MB)
> [    0.000000] EFI: mem33: type=3, attr=0xf, range=[0x000000008962c000-0x0000000089635000) (0MB)
> [    0.000000] EFI: mem34: type=4, attr=0xf, range=[0x0000000089635000-0x0000000089637000) (0MB)
> [    0.000000] EFI: mem35: type=3, attr=0xf, range=[0x0000000089637000-0x0000000089638000) (0MB)
> [    0.000000] EFI: mem36: type=4, attr=0xf, range=[0x0000000089638000-0x0000000089639000) (0MB)
> [    0.000000] EFI: mem37: type=3, attr=0xf, range=[0x0000000089639000-0x000000008963a000) (0MB)
> [    0.000000] EFI: mem38: type=4, attr=0xf, range=[0x000000008963a000-0x000000008963c000) (0MB)
> [    0.000000] EFI: mem39: type=3, attr=0xf, range=[0x000000008963c000-0x0000000089641000) (0MB)
> [    0.000000] EFI: mem40: type=4, attr=0xf, range=[0x0000000089641000-0x0000000089655000) (0MB)
> [    0.000000] EFI: mem41: type=3, attr=0xf, range=[0x0000000089655000-0x0000000089659000) (0MB)
> [    0.000000] EFI: mem42: type=4, attr=0xf, range=[0x0000000089659000-0x0000000089660000) (0MB)
> [    0.000000] EFI: mem43: type=3, attr=0xf, range=[0x0000000089660000-0x0000000089661000) (0MB)
> [    0.000000] EFI: mem44: type=4, attr=0xf, range=[0x0000000089661000-0x0000000089664000) (0MB)
> [    0.000000] EFI: mem45: type=3, attr=0xf, range=[0x0000000089664000-0x000000008966e000) (0MB)
> [    0.000000] EFI: mem46: type=4, attr=0xf, range=[0x000000008966e000-0x0000000089673000) (0MB)
> [    0.000000] EFI: mem47: type=3, attr=0xf, range=[0x0000000089673000-0x0000000089675000) (0MB)
> [    0.000000] EFI: mem48: type=4, attr=0xf, range=[0x0000000089675000-0x000000008969a000) (0MB)
> [    0.000000] EFI: mem49: type=3, attr=0xf, range=[0x000000008969a000-0x000000008969d000) (0MB)
> [    0.000000] EFI: mem50: type=4, attr=0xf, range=[0x000000008969d000-0x00000000896ad000) (0MB)
> [    0.000000] EFI: mem51: type=3, attr=0xf, range=[0x00000000896ad000-0x00000000896b1000) (0MB)
> [    0.000000] EFI: mem52: type=4, attr=0xf, range=[0x00000000896b1000-0x00000000896d6000) (0MB)
> [    0.000000] EFI: mem53: type=3, attr=0xf, range=[0x00000000896d6000-0x00000000896eb000) (0MB)
> [    0.000000] EFI: mem54: type=4, attr=0xf, range=[0x00000000896eb000-0x00000000896f6000) (0MB)
> [    0.000000] EFI: mem55: type=3, attr=0xf, range=[0x00000000896f6000-0x000000008970b000) (0MB)
> [    0.000000] EFI: mem56: type=4, attr=0xf, range=[0x000000008970b000-0x0000000089710000) (0MB)
> [    0.000000] EFI: mem57: type=3, attr=0xf, range=[0x0000000089710000-0x0000000089719000) (0MB)
> [    0.000000] EFI: mem58: type=4, attr=0xf, range=[0x0000000089719000-0x0000000089726000) (0MB)
> [    0.000000] EFI: mem59: type=3, attr=0xf, range=[0x0000000089726000-0x0000000089739000) (0MB)
> [    0.000000] EFI: mem60: type=4, attr=0xf, range=[0x0000000089739000-0x000000008973a000) (0MB)
> [    0.000000] EFI: mem61: type=3, attr=0xf, range=[0x000000008973a000-0x000000008973c000) (0MB)
> [    0.000000] EFI: mem62: type=4, attr=0xf, range=[0x000000008973c000-0x0000000089742000) (0MB)
> [    0.000000] EFI: mem63: type=3, attr=0xf, range=[0x0000000089742000-0x0000000089743000) (0MB)
> [    0.000000] EFI: mem64: type=4, attr=0xf, range=[0x0000000089743000-0x0000000089744000) (0MB)
> [    0.000000] EFI: mem65: type=3, attr=0xf, range=[0x0000000089744000-0x0000000089748000) (0MB)
> [    0.000000] EFI: mem66: type=4, attr=0xf, range=[0x0000000089748000-0x000000008974a000) (0MB)
> [    0.000000] EFI: mem67: type=3, attr=0xf, range=[0x000000008974a000-0x000000008974b000) (0MB)
> [    0.000000] EFI: mem68: type=4, attr=0xf, range=[0x000000008974b000-0x000000008974f000) (0MB)
> [    0.000000] EFI: mem69: type=3, attr=0xf, range=[0x000000008974f000-0x0000000089752000) (0MB)
> [    0.000000] EFI: mem70: type=4, attr=0xf, range=[0x0000000089752000-0x0000000089753000) (0MB)
> [    0.000000] EFI: mem71: type=3, attr=0xf, range=[0x0000000089753000-0x0000000089754000) (0MB)
> [    0.000000] EFI: mem72: type=4, attr=0xf, range=[0x0000000089754000-0x0000000089755000) (0MB)
> [    0.000000] EFI: mem73: type=3, attr=0xf, range=[0x0000000089755000-0x0000000089759000) (0MB)
> [    0.000000] EFI: mem74: type=4, attr=0xf, range=[0x0000000089759000-0x000000008975c000) (0MB)
> [    0.000000] EFI: mem75: type=3, attr=0xf, range=[0x000000008975c000-0x000000008975d000) (0MB)
> [    0.000000] EFI: mem76: type=4, attr=0xf, range=[0x000000008975d000-0x000000008975f000) (0MB)
> [    0.000000] EFI: mem77: type=3, attr=0xf, range=[0x000000008975f000-0x0000000089761000) (0MB)
> [    0.000000] EFI: mem78: type=4, attr=0xf, range=[0x0000000089761000-0x0000000089765000) (0MB)
> [    0.000000] EFI: mem79: type=3, attr=0xf, range=[0x0000000089765000-0x0000000089769000) (0MB)
> [    0.000000] EFI: mem80: type=4, attr=0xf, range=[0x0000000089769000-0x000000008976a000) (0MB)
> [    0.000000] EFI: mem81: type=3, attr=0xf, range=[0x000000008976a000-0x000000008976b000) (0MB)
> [    0.000000] EFI: mem82: type=4, attr=0xf, range=[0x000000008976b000-0x000000008976e000) (0MB)
> [    0.000000] EFI: mem83: type=3, attr=0xf, range=[0x000000008976e000-0x0000000089775000) (0MB)
> [    0.000000] EFI: mem84: type=4, attr=0xf, range=[0x0000000089775000-0x0000000089776000) (0MB)
> [    0.000000] EFI: mem85: type=3, attr=0xf, range=[0x0000000089776000-0x000000008977b000) (0MB)
> [    0.000000] EFI: mem86: type=4, attr=0xf, range=[0x000000008977b000-0x000000008977f000) (0MB)
> [    0.000000] EFI: mem87: type=3, attr=0xf, range=[0x000000008977f000-0x0000000089780000) (0MB)
> [    0.000000] EFI: mem88: type=4, attr=0xf, range=[0x0000000089780000-0x0000000089781000) (0MB)
> [    0.000000] EFI: mem89: type=3, attr=0xf, range=[0x0000000089781000-0x0000000089786000) (0MB)
> [    0.000000] EFI: mem90: type=4, attr=0xf, range=[0x0000000089786000-0x0000000089788000) (0MB)
> [    0.000000] EFI: mem91: type=3, attr=0xf, range=[0x0000000089788000-0x000000008978a000) (0MB)
> [    0.000000] EFI: mem92: type=4, attr=0xf, range=[0x000000008978a000-0x000000008978b000) (0MB)
> [    0.000000] EFI: mem93: type=3, attr=0xf, range=[0x000000008978b000-0x000000008978f000) (0MB)
> [    0.000000] EFI: mem94: type=4, attr=0xf, range=[0x000000008978f000-0x00000000897a7000) (0MB)
> [    0.000000] EFI: mem95: type=3, attr=0xf, range=[0x00000000897a7000-0x00000000897bb000) (0MB)
> [    0.000000] EFI: mem96: type=4, attr=0xf, range=[0x00000000897bb000-0x00000000897be000) (0MB)
> [    0.000000] EFI: mem97: type=3, attr=0xf, range=[0x00000000897be000-0x00000000897c2000) (0MB)
> [    0.000000] EFI: mem98: type=4, attr=0xf, range=[0x00000000897c2000-0x00000000897c3000) (0MB)
> [    0.000000] EFI: mem99: type=3, attr=0xf, range=[0x00000000897c3000-0x00000000897c5000) (0MB)
> [    0.000000] EFI: mem100: type=4, attr=0xf, range=[0x00000000897c5000-0x00000000897c7000) (0MB)
> [    0.000000] EFI: mem101: type=3, attr=0xf, range=[0x00000000897c7000-0x00000000897c9000) (0MB)
> [    0.000000] EFI: mem102: type=4, attr=0xf, range=[0x00000000897c9000-0x00000000897ca000) (0MB)
> [    0.000000] EFI: mem103: type=3, attr=0xf, range=[0x00000000897ca000-0x00000000897d7000) (0MB)
> [    0.000000] EFI: mem104: type=4, attr=0xf, range=[0x00000000897d7000-0x00000000897d9000) (0MB)
> [    0.000000] EFI: mem105: type=3, attr=0xf, range=[0x00000000897d9000-0x00000000897db000) (0MB)
> [    0.000000] EFI: mem106: type=4, attr=0xf, range=[0x00000000897db000-0x00000000897e3000) (0MB)
> [    0.000000] EFI: mem107: type=3, attr=0xf, range=[0x00000000897e3000-0x00000000897e6000) (0MB)
> [    0.000000] EFI: mem108: type=4, attr=0xf, range=[0x00000000897e6000-0x00000000897e8000) (0MB)
> [    0.000000] EFI: mem109: type=3, attr=0xf, range=[0x00000000897e8000-0x00000000897ea000) (0MB)
> [    0.000000] EFI: mem110: type=4, attr=0xf, range=[0x00000000897ea000-0x00000000897ef000) (0MB)
> [    0.000000] EFI: mem111: type=3, attr=0xf, range=[0x00000000897ef000-0x00000000897f5000) (0MB)
> [    0.000000] EFI: mem112: type=4, attr=0xf, range=[0x00000000897f5000-0x00000000897f7000) (0MB)
> [    0.000000] EFI: mem113: type=3, attr=0xf, range=[0x00000000897f7000-0x00000000897fe000) (0MB)
> [    0.000000] EFI: mem114: type=4, attr=0xf, range=[0x00000000897fe000-0x0000000089800000) (0MB)
> [    0.000000] EFI: mem115: type=3, attr=0xf, range=[0x0000000089800000-0x0000000089806000) (0MB)
> [    0.000000] EFI: mem116: type=4, attr=0xf, range=[0x0000000089806000-0x000000008980a000) (0MB)
> [    0.000000] EFI: mem117: type=3, attr=0xf, range=[0x000000008980a000-0x000000008980b000) (0MB)
> [    0.000000] EFI: mem118: type=4, attr=0xf, range=[0x000000008980b000-0x000000008980c000) (0MB)
> [    0.000000] EFI: mem119: type=3, attr=0xf, range=[0x000000008980c000-0x0000000089813000) (0MB)
> [    0.000000] EFI: mem120: type=4, attr=0xf, range=[0x0000000089813000-0x0000000089815000) (0MB)
> [    0.000000] EFI: mem121: type=3, attr=0xf, range=[0x0000000089815000-0x000000008981b000) (0MB)
> [    0.000000] EFI: mem122: type=4, attr=0xf, range=[0x000000008981b000-0x000000008981f000) (0MB)
> [    0.000000] EFI: mem123: type=3, attr=0xf, range=[0x000000008981f000-0x000000008982e000) (0MB)
> [    0.000000] EFI: mem124: type=4, attr=0xf, range=[0x000000008982e000-0x000000008982f000) (0MB)
> [    0.000000] EFI: mem125: type=3, attr=0xf, range=[0x000000008982f000-0x0000000089848000) (0MB)
> [    0.000000] EFI: mem126: type=4, attr=0xf, range=[0x0000000089848000-0x0000000089849000) (0MB)
> [    0.000000] EFI: mem127: type=3, attr=0xf, range=[0x0000000089849000-0x000000008984f000) (0MB)
> [    0.000000] EFI: mem128: type=4, attr=0xf, range=[0x000000008984f000-0x0000000089853000) (0MB)
> [    0.000000] EFI: mem129: type=3, attr=0xf, range=[0x0000000089853000-0x0000000089859000) (0MB)
> [    0.000000] EFI: mem130: type=4, attr=0xf, range=[0x0000000089859000-0x000000008985a000) (0MB)
> [    0.000000] EFI: mem131: type=3, attr=0xf, range=[0x000000008985a000-0x000000008985b000) (0MB)
> [    0.000000] EFI: mem132: type=4, attr=0xf, range=[0x000000008985b000-0x000000008985f000) (0MB)
> [    0.000000] EFI: mem133: type=3, attr=0xf, range=[0x000000008985f000-0x0000000089860000) (0MB)
> [    0.000000] EFI: mem134: type=4, attr=0xf, range=[0x0000000089860000-0x0000000089865000) (0MB)
> [    0.000000] EFI: mem135: type=3, attr=0xf, range=[0x0000000089865000-0x0000000089867000) (0MB)
> [    0.000000] EFI: mem136: type=4, attr=0xf, range=[0x0000000089867000-0x0000000089869000) (0MB)
> [    0.000000] EFI: mem137: type=3, attr=0xf, range=[0x0000000089869000-0x000000008986a000) (0MB)
> [    0.000000] EFI: mem138: type=4, attr=0xf, range=[0x000000008986a000-0x000000008986d000) (0MB)
> [    0.000000] EFI: mem139: type=3, attr=0xf, range=[0x000000008986d000-0x000000008986e000) (0MB)
> [    0.000000] EFI: mem140: type=4, attr=0xf, range=[0x000000008986e000-0x000000008986f000) (0MB)
> [    0.000000] EFI: mem141: type=3, attr=0xf, range=[0x000000008986f000-0x0000000089871000) (0MB)
> [    0.000000] EFI: mem142: type=4, attr=0xf, range=[0x0000000089871000-0x0000000089873000) (0MB)
> [    0.000000] EFI: mem143: type=3, attr=0xf, range=[0x0000000089873000-0x0000000089875000) (0MB)
> [    0.000000] EFI: mem144: type=4, attr=0xf, range=[0x0000000089875000-0x0000000089877000) (0MB)
> [    0.000000] EFI: mem145: type=3, attr=0xf, range=[0x0000000089877000-0x0000000089880000) (0MB)
> [    0.000000] EFI: mem146: type=4, attr=0xf, range=[0x0000000089880000-0x0000000089881000) (0MB)
> [    0.000000] EFI: mem147: type=3, attr=0xf, range=[0x0000000089881000-0x0000000089883000) (0MB)
> [    0.000000] EFI: mem148: type=4, attr=0xf, range=[0x0000000089883000-0x0000000089884000) (0MB)
> [    0.000000] EFI: mem149: type=3, attr=0xf, range=[0x0000000089884000-0x0000000089885000) (0MB)
> [    0.000000] EFI: mem150: type=4, attr=0xf, range=[0x0000000089885000-0x000000008988a000) (0MB)
> [    0.000000] EFI: mem151: type=3, attr=0xf, range=[0x000000008988a000-0x000000008988b000) (0MB)
> [    0.000000] EFI: mem152: type=4, attr=0xf, range=[0x000000008988b000-0x0000000089890000) (0MB)
> [    0.000000] EFI: mem153: type=3, attr=0xf, range=[0x0000000089890000-0x0000000089891000) (0MB)
> [    0.000000] EFI: mem154: type=4, attr=0xf, range=[0x0000000089891000-0x0000000089892000) (0MB)
> [    0.000000] EFI: mem155: type=3, attr=0xf, range=[0x0000000089892000-0x0000000089899000) (0MB)
> [    0.000000] EFI: mem156: type=4, attr=0xf, range=[0x0000000089899000-0x000000008989e000) (0MB)
> [    0.000000] EFI: mem157: type=3, attr=0xf, range=[0x000000008989e000-0x00000000898a0000) (0MB)
> [    0.000000] EFI: mem158: type=4, attr=0xf, range=[0x00000000898a0000-0x00000000898a6000) (0MB)
> [    0.000000] EFI: mem159: type=3, attr=0xf, range=[0x00000000898a6000-0x00000000898a7000) (0MB)
> [    0.000000] EFI: mem160: type=4, attr=0xf, range=[0x00000000898a7000-0x00000000898a9000) (0MB)
> [    0.000000] EFI: mem161: type=3, attr=0xf, range=[0x00000000898a9000-0x00000000898aa000) (0MB)
> [    0.000000] EFI: mem162: type=4, attr=0xf, range=[0x00000000898aa000-0x00000000898db000) (0MB)
> [    0.000000] EFI: mem163: type=3, attr=0xf, range=[0x00000000898db000-0x00000000898ee000) (0MB)
> [    0.000000] EFI: mem164: type=4, attr=0xf, range=[0x00000000898ee000-0x0000000089934000) (0MB)
> [    0.000000] EFI: mem165: type=3, attr=0xf, range=[0x0000000089934000-0x0000000089948000) (0MB)
> [    0.000000] EFI: mem166: type=4, attr=0xf, range=[0x0000000089948000-0x0000000089949000) (0MB)
> [    0.000000] EFI: mem167: type=3, attr=0xf, range=[0x0000000089949000-0x000000008994c000) (0MB)
> [    0.000000] EFI: mem168: type=4, attr=0xf, range=[0x000000008994c000-0x0000000089968000) (0MB)
> [    0.000000] EFI: mem169: type=3, attr=0xf, range=[0x0000000089968000-0x000000008996d000) (0MB)
> [    0.000000] EFI: mem170: type=4, attr=0xf, range=[0x000000008996d000-0x000000008997a000) (0MB)
> [    0.000000] EFI: mem171: type=3, attr=0xf, range=[0x000000008997a000-0x000000008997b000) (0MB)
> [    0.000000] EFI: mem172: type=4, attr=0xf, range=[0x000000008997b000-0x000000008997c000) (0MB)
> [    0.000000] EFI: mem173: type=3, attr=0xf, range=[0x000000008997c000-0x000000008997d000) (0MB)
> [    0.000000] EFI: mem174: type=4, attr=0xf, range=[0x000000008997d000-0x000000008998f000) (0MB)
> [    0.000000] EFI: mem175: type=3, attr=0xf, range=[0x000000008998f000-0x00000000899a4000) (0MB)
> [    0.000000] EFI: mem176: type=4, attr=0xf, range=[0x00000000899a4000-0x00000000899a5000) (0MB)
> [    0.000000] EFI: mem177: type=3, attr=0xf, range=[0x00000000899a5000-0x00000000899b1000) (0MB)
> [    0.000000] EFI: mem178: type=4, attr=0xf, range=[0x00000000899b1000-0x00000000899b4000) (0MB)
> [    0.000000] EFI: mem179: type=3, attr=0xf, range=[0x00000000899b4000-0x00000000899b8000) (0MB)
> [    0.000000] EFI: mem180: type=4, attr=0xf, range=[0x00000000899b8000-0x0000000089dd9000) (4MB)
> [    0.000000] EFI: mem181: type=3, attr=0xf, range=[0x0000000089dd9000-0x0000000089dde000) (0MB)
> [    0.000000] EFI: mem182: type=4, attr=0xf, range=[0x0000000089dde000-0x0000000089ddf000) (0MB)
> [    0.000000] EFI: mem183: type=3, attr=0xf, range=[0x0000000089ddf000-0x0000000089de1000) (0MB)
> [    0.000000] EFI: mem184: type=4, attr=0xf, range=[0x0000000089de1000-0x0000000089de2000) (0MB)
> [    0.000000] EFI: mem185: type=3, attr=0xf, range=[0x0000000089de2000-0x0000000089de5000) (0MB)
> [    0.000000] EFI: mem186: type=4, attr=0xf, range=[0x0000000089de5000-0x0000000089de6000) (0MB)
> [    0.000000] EFI: mem187: type=3, attr=0xf, range=[0x0000000089de6000-0x0000000089df3000) (0MB)
> [    0.000000] EFI: mem188: type=4, attr=0xf, range=[0x0000000089df3000-0x0000000089df5000) (0MB)
> [    0.000000] EFI: mem189: type=3, attr=0xf, range=[0x0000000089df5000-0x0000000089e02000) (0MB)
> [    0.000000] EFI: mem190: type=4, attr=0xf, range=[0x0000000089e02000-0x0000000089e03000) (0MB)
> [    0.000000] EFI: mem191: type=3, attr=0xf, range=[0x0000000089e03000-0x0000000089e06000) (0MB)
> [    0.000000] EFI: mem192: type=4, attr=0xf, range=[0x0000000089e06000-0x0000000089e07000) (0MB)
> [    0.000000] EFI: mem193: type=3, attr=0xf, range=[0x0000000089e07000-0x0000000089e08000) (0MB)
> [    0.000000] EFI: mem194: type=4, attr=0xf, range=[0x0000000089e08000-0x000000008ad0f000) (15MB)
> [    0.000000] EFI: mem195: type=7, attr=0xf, range=[0x000000008ad0f000-0x000000008ad36000) (0MB)
> [    0.000000] EFI: mem196: type=10, attr=0xf, range=[0x000000008ad36000-0x000000008ad5f000) (0MB)
> [    0.000000] EFI: mem197: type=7, attr=0xf, range=[0x000000008ad5f000-0x000000008ad6f000) (0MB)
> [    0.000000] EFI: mem198: type=9, attr=0xf, range=[0x000000008ad6f000-0x000000008ad8f000) (0MB)
> [    0.000000] EFI: mem199: type=7, attr=0xf, range=[0x000000008ad8f000-0x000000008ae33000) (0MB)
> [    0.000000] EFI: mem200: type=6, attr=0x800000000000000f, range=[0x000000008ae33000-0x000000008ae8f000) (0MB)
> [    0.000000] EFI: mem201: type=7, attr=0xf, range=[0x000000008ae8f000-0x000000008aed2000) (0MB)
> [    0.000000] EFI: mem202: type=5, attr=0x800000000000000f, range=[0x000000008aed2000-0x000000008aeff000) (0MB)
> [    0.000000] EFI: mem203: type=7, attr=0xf, range=[0x000000008aeff000-0x000000008af9a000) (0MB)
> [    0.000000] EFI: mem204: type=2, attr=0xf, range=[0x000000008af9a000-0x000000008afa2000) (0MB)
> [    0.000000] EFI: mem205: type=0, attr=0xf, range=[0x000000008afa2000-0x000000008afff000) (0MB)
> [    0.000000] EFI: mem206: type=6, attr=0x800000000000000f, range=[0x000000008afff000-0x000000008b000000) (0MB)
> [    0.000000] EFI: mem207: type=7, attr=0xf, range=[0x0000000100000000-0x000000016fe00000) (1790MB)
> [    0.000000] EFI: mem208: type=0, attr=0x8000000000000000, range=[0x00000000000a0000-0x0000000000100000) (0MB)
> [    0.000000] EFI: mem209: type=0, attr=0x8000000000000000, range=[0x000000008b000000-0x000000008fa00000) (74MB)
> [    0.000000] EFI: mem210: type=11, attr=0x8000000000000000, range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
> [    0.000000] EFI: mem211: type=11, attr=0x8000000000000000, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
> [    0.000000] EFI: mem212: type=11, attr=0x8000000000000000, range=[0x00000000ffed0000-0x00000000fff00000) (0MB)
> [    0.000000] DMI 2.4 present.
> [    0.000000] DMI: Apple Inc. MacBookAir4,1/Mac-C08A6BB70A942AC2, BIOS MBA41.88Z.0077.B00.1106300929 06/30/2011
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0x16fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-DFFFF write-protect
> [    0.000000]   E0000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
> [    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
> [    0.000000]   2 base 090000000 mask FF0000000 uncachable
> [    0.000000]   3 base 08C000000 mask FFC000000 uncachable
> [    0.000000]   4 base 08B800000 mask FFF800000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] last_pfn = 0x8afa2 max_arch_pfn = 0x400000000
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
> [    0.000000] init_memory_mapping: 0000000000000000-000000008afa2000
> [    0.000000]  0000000000 - 008ae00000 page 2M
> [    0.000000]  008ae00000 - 008afa2000 page 4k
> [    0.000000] kernel direct mapping tables up to 8afa2000 @ 1fffb000-20000000
> [    0.000000] init_memory_mapping: 0000000100000000-000000016fe00000
> [    0.000000]  0100000000 - 016fe00000 page 2M
> [    0.000000] kernel direct mapping tables up to 16fe00000 @ 8af9b000-8afa2000
> 
> -- 
> keith.packard@intel.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks,

	Ingo
