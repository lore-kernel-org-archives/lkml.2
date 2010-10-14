Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0JNGAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:00:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab0JNGAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:00:09 -0400
Date: Thu, 14 Oct 2010 07:59:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com, Yinghai Lu <yinghai@kernel.org>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] x86-64: Only set max_pfn_mapped to 512 MiB
 if we enter via head_64.S
Message-ID: <20101014055945.GA3534@elte.hu>
References: <4CB641F7.9040103@goop.org>
 <tip-859ee4f57fb4e91de8439496f62eb996f4a28ca8@git.kernel.org>
 <20101014055714.GA3329@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014055714.GA3329@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> These two commits are a boot crasher on x86 defconfig (64-bit):

Below is the full bootlog, with memory layout info.

Thanks,

	Ingo

---------------->

  Booting 'test-64 (test-64)'

root (hd0,5)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/bzImage-64 root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,1
15200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_w
atchdog=0 panic=1 3
   [Linux-bzImage, setup=0x3400, size=0x402be0]

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-rc7-tip+ (mingo@sirius) (gcc version 4.4.4 20100514 (Red Hat 4.4.4-3) (GCC) ) #49192 SMP Thu Oct 14 09:00:39 CEST 2010
[    0.000000] Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 00000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] Kernel panic - not syncing: Cannot find space for the kernel page tables
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc7-tip+ #49192
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8156c73f>] panic+0x8c/0x192
[    0.000000]  [<ffffffff8156c881>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8154ec40>] init_memory_mapping+0x372/0x506
[    0.000000]  [<ffffffff819053ed>] ? memblock_x86_reserve_range+0x7c/0x83
[    0.000000]  [<ffffffff818f2f3d>] setup_arch+0x5a3/0xa68
[    0.000000]  [<ffffffff8156c881>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff81061135>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff818ef9e1>] start_kernel+0x83/0x36e
[    0.000000]  [<ffffffff818ef2a8>] x86_64_start_reservations+0xb8/0xbc
[    0.000000]  [<ffffffff818ef393>] x86_64_start_kernel+0xe7/0xee
