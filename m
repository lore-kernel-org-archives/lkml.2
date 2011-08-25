Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1HYGFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:05:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44589 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1HYGFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
References: <20110722154219.GA25694@elte.hu>
	<CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
Date: Thu, 25 Aug 2011 02:05:20 -0400
Message-ID: <CACqU3MWPEBe1yFA=zBJos++VQhCnMSbEmnRP9X7O-DyzUKWtnw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 25, 2011 at 1:58 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Fri, Jul 22, 2011 at 11:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> Linus,
>>
>> Please pull the latest x86-vdso-for-linus git tree from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-vdso-for-linus
>>
>>
>> out-of-topic modifications in x86-vdso-for-linus:
>> -------------------------------------------------
>> arch/ia64/Kconfig                  # ae7bd11: clocksource: Change __ARCH_HAS_CL
>> arch/ia64/include/asm/clocksource.h# ae7bd11: clocksource: Change __ARCH_HAS_CL
>>                                   # 574c44f: ia64: Replace clocksource.fsys_mm
>> arch/ia64/kernel/cyclone.c         # 574c44f: ia64: Replace clocksource.fsys_mm
>> arch/ia64/kernel/time.c            # 574c44f: ia64: Replace clocksource.fsys_mm
>> arch/ia64/sn/kernel/sn2/timer.c    # 574c44f: ia64: Replace clocksource.fsys_mm
>> drivers/char/hpet.c                # 574c44f: ia64: Replace clocksource.fsys_mm
>> include/linux/clocksource.h        # ae7bd11: clocksource: Change __ARCH_HAS_CL
>>                                   # 574c44f: ia64: Replace clocksource.fsys_mm
>>                                   # 433bd80: clocksource: Replace vread with g
>> include/linux/seccomp.h            # 5cec93c: x86-64: Emulate legacy vsyscalls
>>
>>  Thanks,
>>
>>        Ingo
>>
>> ------------------>
>> Andy Lutomirski (17):
>>      x86-64: Fix alignment of jiffies variable
>>      x86-64: Document some of entry_64.S
>>      x86-64: Give vvars their own page
>>      x86-64: Remove kernel.vsyscall64 sysctl
>>      x86-64: Map the HPET NX
>>      x86-64: Remove vsyscall number 3 (venosys)
>>      x86-64: Fill unused parts of the vsyscall page with 0xcc
>>      x86-64: Emulate legacy vsyscalls
>>      x86-64: Improve vsyscall emulation CS and RIP handling
>>      x86: Make alternative instruction pointers relative
>
> Bisecting this BUG:
>
> CPU: Intel QEMU Virtual CPU version 0.13.0 stepping 03
> BUG: unable to handle kernel paging request at 8277e54c
> IP: [<c13765fb>] apply_alternatives+0xc3/0x18a
> *pde = 00000000
> Oops: 0000 [#1] DEBUG_PAGEALLOC
>
> Pid: 0, comm: swapper Not tainted 3.1.0-rc3 #20 Bochs Bochs
> EIP: 0060:[<c13765fb>] EFLAGS: 00000286 CPU: 0
> EIP is at apply_alternatives+0xc3/0x18a
> EAX: ffffffff EBX: c13bee40 ECX: 00000005 EDX: 8277e54c
> ESI: 8277e54c EDI: c1349e9e EBP: c1349fa8 ESP: c1349e70
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=c1348000 task=c134e340 task.ti=c1348000)
> Stack:
>  00000002 c135d7c0 c11418a0 00000db8 c1349e9e 82655b12 00000005 8277e54c
>  c13bf6ec c1349e05 05000086 f6890046 00f69000 c1349eb0 00000086 00000000
>  00000046 c1349ec0 00000046 00000000 c1349edc c101f29c 00000dc5 00000000
> Call Trace:
>  [<c11418a0>] ? serial8250_start_tx+0xe0/0xe0
>  [<c101f29c>] ? console_unlock+0x10c/0x150
>  [<c10039c3>] ? do_IRQ+0x43/0xa0
>  [<c12975a9>] ? common_interrupt+0x29/0x30
>  [<c1294d59>] ? printk+0x18/0x1f
>  [<c139070b>] ? print_cpu_info+0x93/0x11f
>  [<c13766d9>] alternative_instructions+0x17/0x32
>  [<c1377552>] check_bugs+0x91/0x93
>  [<c13716b6>] start_kernel+0x289/0x294
>  [<c13711b7>] ? loglevel+0x1a/0x1a
>  [<c13710b3>] i386_start_kernel+0xb3/0xbb
> Code: ec fe ff ff 8d 0c 0b 89 8d dc fe ff ff 8d 54 13 04 8b bd d8 fe
> ff ff 89 95 e4 fe ff ff 89 b5 e0 fe ff ff 8b 8d e0 fe ff ff 89 d6 <f3>
> a4 80 bd f6 fe ff ff e8 75 17 80 bd ec fe ff ff 05 75 0e 89
> EIP: [<c13765fb>] apply_alternatives+0xc3/0x18a SS:ESP 0068:c1349e70
> CR2: 000000008277e54c
> ---[ end trace 4eaa2a86a8e2da22 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> Pid: 0, comm: swapper Tainted: G      D     3.1.0-rc3 #20
> Call Trace:
>  [<c1294d59>] ? printk+0x18/0x1f
>  [<c1294c4a>] panic+0x57/0x14e
>  [<c10221a1>] do_exit+0x201/0x290
>  [<c1004ace>] oops_end+0x6e/0x90
>  [<c1294d59>] ? printk+0x18/0x1f
>  [<c1013efc>] no_context+0xbc/0x150
>  [<c1013fc0>] __bad_area_nosemaphore+0x30/0x170
>  [<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
>  [<c1014112>] bad_area_nosemaphore+0x12/0x20
>  [<c101466f>] do_page_fault+0x21f/0x360
>  [<c105c070>] ? get_page_from_freelist+0x110/0x300
>  [<c1023b24>] ? irq_exit+0x54/0x90
>  [<c10039c3>] ? do_IRQ+0x43/0xa0
>  [<c1140e31>] ? wait_for_xmitr+0x31/0x90
>  [<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
>  [<c1296df8>] error_code+0x58/0x60
>  [<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
>  [<c13765fb>] ? apply_alternatives+0xc3/0x18a
>  [<c11418a0>] ? serial8250_start_tx+0xe0/0xe0
>  [<c101f29c>] ? console_unlock+0x10c/0x150
>  [<c10039c3>] ? do_IRQ+0x43/0xa0
>  [<c12975a9>] ? common_interrupt+0x29/0x30
>  [<c1294d59>] ? printk+0x18/0x1f
>  [<c139070b>] ? print_cpu_info+0x93/0x11f
>  [<c13766d9>] alternative_instructions+0x17/0x32
>  [<c1377552>] check_bugs+0x91/0x93
>  [<c13716b6>] start_kernel+0x289/0x294
>  [<c13711b7>] ? loglevel+0x1a/0x1a
>  [<c13710b3>] i386_start_kernel+0xb3/0xbb
> QEMU: Terminated
>
> lead me to that commit:
>
> commit 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
> Author: Andy Lutomirski <luto@mit.edu>
> Date:   Wed Jul 13 09:24:10 2011 -0400
>
>    x86: Make alternative instruction pointers relative
>
>    This save a few bytes on x86-64 and means that future patches can
>    apply alternatives to unrelocated code.
>
>    Signed-off-by: Andy Lutomirski <luto@mit.edu>
>    Link: http://lkml.kernel.org/r/ff64a6b9a1a3860ca4a7b8b6dc7b4754f9491cd7.1310563276.git.luto@mit.edu
>    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>
>
> Here is the bisection log:
>
>
> % git bisect log
> git bisect start
> # bad: [3ef706459b940b49e37a62c8ec720728c7260b49] acpi/acpi_drivers.h:
> fix warnings when ACPI_DOCK is not enabled
> this first step is an un-merged local change from next-20110824.
>
> git bisect bad 3ef706459b940b49e37a62c8ec720728c7260b49
> # bad: [fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c] Linux 3.1-rc3
> git bisect bad fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c
> # good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
> git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
> # bad: [d272281c390eb6c3f1e70ed0337c9e619d99cd9c] [SCSI] fcoe: cleanup
> cpu selection for incoming requests
> git bisect bad d272281c390eb6c3f1e70ed0337c9e619d99cd9c
> # good: [f9035cd498486d5a82ad8ae9bcfdb91b3e57ec9d] Merge branch
> 'for-davem' of ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
> git bisect good f9035cd498486d5a82ad8ae9bcfdb91b3e57ec9d
> # bad: [c61264f98c1a974ee6f545f61a4ab33b141d6bda] Merge branch
> 'upstream/xen-tracing2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
> git bisect bad c61264f98c1a974ee6f545f61a4ab33b141d6bda
> # bad: [9d1c02135516866cbbb2f80e20cfb65c63a3ce40] Merge branch
> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs
> git bisect bad 9d1c02135516866cbbb2f80e20cfb65c63a3ce40
> # good: [112ec469663e09ffc815761254b52f3ca787ce83] Merge branch
> 'timers-core-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect good 112ec469663e09ffc815761254b52f3ca787ce83
> # good: [5a9a43646cf709312d71eca71cef90ad802f28f9] vfs: use ERR_CAST
> for err-ptr tossing in lookup_instantiate_filp
> git bisect good 5a9a43646cf709312d71eca71cef90ad802f28f9
> # good: [805120795947008612ef64618bba8a6aa30cf88b] Merge branch
> 'x86-signal-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect good 805120795947008612ef64618bba8a6aa30cf88b
> # bad: [e660a828f017991468ce322742586e8ebb047ae6] 9p: clean up packet dump code
> git bisect bad e660a828f017991468ce322742586e8ebb047ae6
> # bad: [8c400f6ce068366bc3517f1036bb99169cfec9cd] x86, vdso: Drop now
> wrong comment
> git bisect bad 8c400f6ce068366bc3517f1036bb99169cfec9cd
> # good: [5cec93c216db77c45f7ce970d46283bcb1933884] x86-64: Emulate
> legacy vsyscalls
> git bisect good 5cec93c216db77c45f7ce970d46283bcb1933884
> # bad: [7f79ad15f33cf4968cafb0e3d2beba427de01d3a] x86-64: Add
> --no-undefined to vDSO build
> git bisect bad 7f79ad15f33cf4968cafb0e3d2beba427de01d3a
> # bad: [59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93] x86: Make
> alternative instruction pointers relative
> git bisect bad 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
> # good: [c9712944b2a12373cb6ff8059afcfb7e826a6c54] x86-64: Improve
> vsyscall emulation CS and RIP handling
> git bisect good c9712944b2a12373cb6ff8059afcfb7e826a6c54
>
> I'm trying a kernel with 59e97e4d6fb reverted on top of -rc3 to check.
> Revert triggered a single conflict in `arch/x86/kernel/alternative.c'.
>
After the revert, -rc3 boots successfully:

# uname -a
Linux OpenWrt 3.1.0-rc3+ #21 Thu Aug 25 01:57:26 EDT 2011 i686 GNU/Linux

That's one bug for the night, now 'got to catch a mouse hiding in my kitchen.

 - Arnaud
