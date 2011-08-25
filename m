Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab1HYF66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:58:58 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35697 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab1HYF6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110722154219.GA25694@elte.hu>
References: <20110722154219.GA25694@elte.hu>
Date: Thu, 25 Aug 2011 01:58:53 -0400
Message-ID: <CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>
Content-Type: multipart/mixed; boundary=000e0cd2e1f4a3cd7d04ab4e1fdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2e1f4a3cd7d04ab4e1fdb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 22, 2011 at 11:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Linus,
>
> Please pull the latest x86-vdso-for-linus git tree from:
>
> =A0 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x=
86-vdso-for-linus
>
>
> out-of-topic modifications in x86-vdso-for-linus:
> -------------------------------------------------
> arch/ia64/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0# ae7bd11: clocksour=
ce: Change __ARCH_HAS_CL
> arch/ia64/include/asm/clocksource.h# ae7bd11: clocksource: Change __ARCH_=
HAS_CL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 # 574=
c44f: ia64: Replace clocksource.fsys_mm
> arch/ia64/kernel/cyclone.c =A0 =A0 =A0 =A0 # 574c44f: ia64: Replace clock=
source.fsys_mm
> arch/ia64/kernel/time.c =A0 =A0 =A0 =A0 =A0 =A0# 574c44f: ia64: Replace c=
locksource.fsys_mm
> arch/ia64/sn/kernel/sn2/timer.c =A0 =A0# 574c44f: ia64: Replace clocksour=
ce.fsys_mm
> drivers/char/hpet.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0# 574c44f: ia64: Repla=
ce clocksource.fsys_mm
> include/linux/clocksource.h =A0 =A0 =A0 =A0# ae7bd11: clocksource: Change=
 __ARCH_HAS_CL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 # 574=
c44f: ia64: Replace clocksource.fsys_mm
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 # 433=
bd80: clocksource: Replace vread with g
> include/linux/seccomp.h =A0 =A0 =A0 =A0 =A0 =A0# 5cec93c: x86-64: Emulate=
 legacy vsyscalls
>
> =A0Thanks,
>
> =A0 =A0 =A0 =A0Ingo
>
> ------------------>
> Andy Lutomirski (17):
> =A0 =A0 =A0x86-64: Fix alignment of jiffies variable
> =A0 =A0 =A0x86-64: Document some of entry_64.S
> =A0 =A0 =A0x86-64: Give vvars their own page
> =A0 =A0 =A0x86-64: Remove kernel.vsyscall64 sysctl
> =A0 =A0 =A0x86-64: Map the HPET NX
> =A0 =A0 =A0x86-64: Remove vsyscall number 3 (venosys)
> =A0 =A0 =A0x86-64: Fill unused parts of the vsyscall page with 0xcc
> =A0 =A0 =A0x86-64: Emulate legacy vsyscalls
> =A0 =A0 =A0x86-64: Improve vsyscall emulation CS and RIP handling
> =A0 =A0 =A0x86: Make alternative instruction pointers relative

Bisecting this BUG:

CPU: Intel QEMU Virtual CPU version 0.13.0 stepping 03
BUG: unable to handle kernel paging request at 8277e54c
IP: [<c13765fb>] apply_alternatives+0xc3/0x18a
*pde =3D 00000000
Oops: 0000 [#1] DEBUG_PAGEALLOC

Pid: 0, comm: swapper Not tainted 3.1.0-rc3 #20 Bochs Bochs
EIP: 0060:[<c13765fb>] EFLAGS: 00000286 CPU: 0
EIP is at apply_alternatives+0xc3/0x18a
EAX: ffffffff EBX: c13bee40 ECX: 00000005 EDX: 8277e54c
ESI: 8277e54c EDI: c1349e9e EBP: c1349fa8 ESP: c1349e70
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=3Dc1348000 task=3Dc134e340 task.ti=3Dc1348000)
Stack:
 00000002 c135d7c0 c11418a0 00000db8 c1349e9e 82655b12 00000005 8277e54c
 c13bf6ec c1349e05 05000086 f6890046 00f69000 c1349eb0 00000086 00000000
 00000046 c1349ec0 00000046 00000000 c1349edc c101f29c 00000dc5 00000000
Call Trace:
 [<c11418a0>] ? serial8250_start_tx+0xe0/0xe0
 [<c101f29c>] ? console_unlock+0x10c/0x150
 [<c10039c3>] ? do_IRQ+0x43/0xa0
 [<c12975a9>] ? common_interrupt+0x29/0x30
 [<c1294d59>] ? printk+0x18/0x1f
 [<c139070b>] ? print_cpu_info+0x93/0x11f
 [<c13766d9>] alternative_instructions+0x17/0x32
 [<c1377552>] check_bugs+0x91/0x93
 [<c13716b6>] start_kernel+0x289/0x294
 [<c13711b7>] ? loglevel+0x1a/0x1a
 [<c13710b3>] i386_start_kernel+0xb3/0xbb
Code: ec fe ff ff 8d 0c 0b 89 8d dc fe ff ff 8d 54 13 04 8b bd d8 fe
ff ff 89 95 e4 fe ff ff 89 b5 e0 fe ff ff 8b 8d e0 fe ff ff 89 d6 <f3>
a4 80 bd f6 fe ff ff e8 75 17 80 bd ec fe ff ff 05 75 0e 89
EIP: [<c13765fb>] apply_alternatives+0xc3/0x18a SS:ESP 0068:c1349e70
CR2: 000000008277e54c
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Pid: 0, comm: swapper Tainted: G      D     3.1.0-rc3 #20
Call Trace:
 [<c1294d59>] ? printk+0x18/0x1f
 [<c1294c4a>] panic+0x57/0x14e
 [<c10221a1>] do_exit+0x201/0x290
 [<c1004ace>] oops_end+0x6e/0x90
 [<c1294d59>] ? printk+0x18/0x1f
 [<c1013efc>] no_context+0xbc/0x150
 [<c1013fc0>] __bad_area_nosemaphore+0x30/0x170
 [<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
 [<c1014112>] bad_area_nosemaphore+0x12/0x20
 [<c101466f>] do_page_fault+0x21f/0x360
 [<c105c070>] ? get_page_from_freelist+0x110/0x300
 [<c1023b24>] ? irq_exit+0x54/0x90
 [<c10039c3>] ? do_IRQ+0x43/0xa0
 [<c1140e31>] ? wait_for_xmitr+0x31/0x90
 [<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
 [<c1296df8>] error_code+0x58/0x60
 [<c1014450>] ? vmalloc_sync_all+0xf0/0xf0
 [<c13765fb>] ? apply_alternatives+0xc3/0x18a
 [<c11418a0>] ? serial8250_start_tx+0xe0/0xe0
 [<c101f29c>] ? console_unlock+0x10c/0x150
 [<c10039c3>] ? do_IRQ+0x43/0xa0
 [<c12975a9>] ? common_interrupt+0x29/0x30
 [<c1294d59>] ? printk+0x18/0x1f
 [<c139070b>] ? print_cpu_info+0x93/0x11f
 [<c13766d9>] alternative_instructions+0x17/0x32
 [<c1377552>] check_bugs+0x91/0x93
 [<c13716b6>] start_kernel+0x289/0x294
 [<c13711b7>] ? loglevel+0x1a/0x1a
 [<c13710b3>] i386_start_kernel+0xb3/0xbb
QEMU: Terminated

lead me to that commit:

commit 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
Author: Andy Lutomirski <luto@mit.edu>
Date:   Wed Jul 13 09:24:10 2011 -0400

    x86: Make alternative instruction pointers relative

    This save a few bytes on x86-64 and means that future patches can
    apply alternatives to unrelocated code.

    Signed-off-by: Andy Lutomirski <luto@mit.edu>
    Link: http://lkml.kernel.org/r/ff64a6b9a1a3860ca4a7b8b6dc7b4754f9491cd7=
.1310563276.git.luto@mit.edu
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


Here is the bisection log:


% git bisect log
git bisect start
# bad: [3ef706459b940b49e37a62c8ec720728c7260b49] acpi/acpi_drivers.h:
fix warnings when ACPI_DOCK is not enabled
this first step is an un-merged local change from next-20110824.

git bisect bad 3ef706459b940b49e37a62c8ec720728c7260b49
# bad: [fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c] Linux 3.1-rc3
git bisect bad fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
# bad: [d272281c390eb6c3f1e70ed0337c9e619d99cd9c] [SCSI] fcoe: cleanup
cpu selection for incoming requests
git bisect bad d272281c390eb6c3f1e70ed0337c9e619d99cd9c
# good: [f9035cd498486d5a82ad8ae9bcfdb91b3e57ec9d] Merge branch
'for-davem' of ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wi=
reless-next-2.6
git bisect good f9035cd498486d5a82ad8ae9bcfdb91b3e57ec9d
# bad: [c61264f98c1a974ee6f545f61a4ab33b141d6bda] Merge branch
'upstream/xen-tracing2' of
git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
git bisect bad c61264f98c1a974ee6f545f61a4ab33b141d6bda
# bad: [9d1c02135516866cbbb2f80e20cfb65c63a3ce40] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs
git bisect bad 9d1c02135516866cbbb2f80e20cfb65c63a3ce40
# good: [112ec469663e09ffc815761254b52f3ca787ce83] Merge branch
'timers-core-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 112ec469663e09ffc815761254b52f3ca787ce83
# good: [5a9a43646cf709312d71eca71cef90ad802f28f9] vfs: use ERR_CAST
for err-ptr tossing in lookup_instantiate_filp
git bisect good 5a9a43646cf709312d71eca71cef90ad802f28f9
# good: [805120795947008612ef64618bba8a6aa30cf88b] Merge branch
'x86-signal-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 805120795947008612ef64618bba8a6aa30cf88b
# bad: [e660a828f017991468ce322742586e8ebb047ae6] 9p: clean up packet dump =
code
git bisect bad e660a828f017991468ce322742586e8ebb047ae6
# bad: [8c400f6ce068366bc3517f1036bb99169cfec9cd] x86, vdso: Drop now
wrong comment
git bisect bad 8c400f6ce068366bc3517f1036bb99169cfec9cd
# good: [5cec93c216db77c45f7ce970d46283bcb1933884] x86-64: Emulate
legacy vsyscalls
git bisect good 5cec93c216db77c45f7ce970d46283bcb1933884
# bad: [7f79ad15f33cf4968cafb0e3d2beba427de01d3a] x86-64: Add
--no-undefined to vDSO build
git bisect bad 7f79ad15f33cf4968cafb0e3d2beba427de01d3a
# bad: [59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93] x86: Make
alternative instruction pointers relative
git bisect bad 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
# good: [c9712944b2a12373cb6ff8059afcfb7e826a6c54] x86-64: Improve
vsyscall emulation CS and RIP handling
git bisect good c9712944b2a12373cb6ff8059afcfb7e826a6c54

I'm trying a kernel with 59e97e4d6fb reverted on top of -rc3 to check.
Revert triggered a single conflict in `arch/x86/kernel/alternative.c'.

Config attached.

Thanks,
 - Arnaud

> =A0 =A0 =A0x86-64: Allow alternative patching in the vDSO
> =A0 =A0 =A0x86-64: Add --no-undefined to vDSO build
> =A0 =A0 =A0clocksource: Replace vread with generic arch data
> =A0 =A0 =A0x86-64: Move vread_tsc and vread_hpet into the vDSO
> =A0 =A0 =A0ia64: Replace clocksource.fsys_mmio with generic arch data
> =A0 =A0 =A0Document the vDSO and add a reference parser
> =A0 =A0 =A0x86-64, vdso: Do not allocate memory for the vDSO
>
> Borislav Petkov (1):
> =A0 =A0 =A0x86, vdso: Drop now wrong comment
>
> H. Peter Anvin (1):
> =A0 =A0 =A0clocksource: Change __ARCH_HAS_CLOCKSOURCE_DATA to a CONFIG op=
tion
>
>
> =A0Documentation/ABI/stable/vdso =A0 =A0 =A0 =A0 =A0| =A0 27 +++
> =A0Documentation/vDSO/parse_vdso.c =A0 =A0 =A0 =A0| =A0256 ++++++++++++++=
++++++++++++
> =A0Documentation/vDSO/vdso_test.c =A0 =A0 =A0 =A0 | =A0111 ++++++++++++
> =A0Documentation/x86/entry_64.txt =A0 =A0 =A0 =A0 | =A0 98 ++++++++++
> =A0arch/ia64/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0=
3 +
> =A0arch/ia64/include/asm/clocksource.h =A0 =A0| =A0 10 +
> =A0arch/ia64/kernel/cyclone.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A02 +-
> =A0arch/ia64/kernel/time.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A0arch/ia64/sn/kernel/sn2/timer.c =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A0arch/x86/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0=
4 +
> =A0arch/x86/include/asm/alternative-asm.h | =A0 =A04 +-
> =A0arch/x86/include/asm/alternative.h =A0 =A0 | =A0 =A08 +-
> =A0arch/x86/include/asm/clocksource.h =A0 =A0 | =A0 18 ++
> =A0arch/x86/include/asm/cpufeature.h =A0 =A0 =A0| =A0 =A08 +-
> =A0arch/x86/include/asm/fixmap.h =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
> =A0arch/x86/include/asm/irq_vectors.h =A0 =A0 | =A0 =A06 +-
> =A0arch/x86/include/asm/pgtable_types.h =A0 | =A0 =A06 +-
> =A0arch/x86/include/asm/traps.h =A0 =A0 =A0 =A0 =A0 | =A0 =A04 +
> =A0arch/x86/include/asm/tsc.h =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A04 -
> =A0arch/x86/include/asm/vgtod.h =A0 =A0 =A0 =A0 =A0 | =A0 =A03 +-
> =A0arch/x86/include/asm/vsyscall.h =A0 =A0 =A0 =A0| =A0 =A04 -
> =A0arch/x86/include/asm/vvar.h =A0 =A0 =A0 =A0 =A0 =A0| =A0 24 ++--
> =A0arch/x86/kernel/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A08 +-
> =A0arch/x86/kernel/alternative.c =A0 =A0 =A0 =A0 =A0| =A0 23 +--
> =A0arch/x86/kernel/entry_64.S =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A04 +
> =A0arch/x86/kernel/hpet.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 11 +-
> =A0arch/x86/kernel/traps.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A06 +
> =A0arch/x86/kernel/tsc.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A0arch/x86/kernel/vmlinux.lds.S =A0 =A0 =A0 =A0 =A0| =A0 49 +++---
> =A0arch/x86/kernel/vread_tsc_64.c =A0 =A0 =A0 =A0 | =A0 36 ----
> =A0arch/x86/kernel/vsyscall_64.c =A0 =A0 =A0 =A0 =A0| =A0310 ++++++++++++=
+++-----------------
> =A0arch/x86/kernel/vsyscall_emu_64.S =A0 =A0 =A0| =A0 27 +++
> =A0arch/x86/lib/copy_page_64.S =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A09 +-
> =A0arch/x86/lib/memmove_64.S =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 11 +-
> =A0arch/x86/vdso/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
> =A0arch/x86/vdso/vclock_gettime.c =A0 =A0 =A0 =A0 | =A0103 +++++++----
> =A0arch/x86/vdso/vdso.S =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 15 ++-
> =A0arch/x86/vdso/vma.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 58 ++=
++--
> =A0drivers/char/hpet.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 =
+-
> =A0include/linux/clocksource.h =A0 =A0 =A0 =A0 =A0 =A0| =A0 15 +-
> =A0include/linux/seccomp.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 10 +
> =A041 files changed, 927 insertions(+), 378 deletions(-)
> =A0create mode 100644 Documentation/ABI/stable/vdso
> =A0create mode 100644 Documentation/vDSO/parse_vdso.c
> =A0create mode 100644 Documentation/vDSO/vdso_test.c
> =A0create mode 100644 Documentation/x86/entry_64.txt
> =A0create mode 100644 arch/ia64/include/asm/clocksource.h
> =A0create mode 100644 arch/x86/include/asm/clocksource.h
> =A0delete mode 100644 arch/x86/kernel/vread_tsc_64.c
> =A0create mode 100644 arch/x86/kernel/vsyscall_emu_64.S
>
> diff --git a/Documentation/ABI/stable/vdso b/Documentation/ABI/stable/vds=
o
> new file mode 100644
> index 0000000..8a1cbb5
> --- /dev/null
> +++ b/Documentation/ABI/stable/vdso
> @@ -0,0 +1,27 @@
> +On some architectures, when the kernel loads any userspace program it
> +maps an ELF DSO into that program's address space. =A0This DSO is called
> +the vDSO and it often contains useful and highly-optimized alternatives
> +to real syscalls.
> +
> +These functions are called just like ordinary C function according to
> +your platform's ABI. =A0Call them from a sensible context. =A0(For examp=
le,
> +if you set CS on x86 to something strange, the vDSO functions are
> +within their rights to crash.) =A0In addition, if you pass a bad
> +pointer to a vDSO function, you might get SIGSEGV instead of -EFAULT.
> +
> +To find the DSO, parse the auxiliary vector passed to the program's
> +entry point. =A0The AT_SYSINFO_EHDR entry will point to the vDSO.
> +
> +The vDSO uses symbol versioning; whenever you request a symbol from the
> +vDSO, specify the version you are expecting.
> +
> +Programs that dynamically link to glibc will use the vDSO automatically.
> +Otherwise, you can use the reference parser in Documentation/vDSO/parse_=
vdso.c.
> +
> +Unless otherwise noted, the set of symbols with any given version and th=
e
> +ABI of those symbols is considered stable. =A0It may vary across archite=
ctures,
> +though.
> +
> +(As of this writing, this ABI documentation as been confirmed for x86_64=
.
> + The maintainers of the other vDSO-using architectures should confirm
> + that it is correct for their architecture.)
> \ No newline at end of file
> diff --git a/Documentation/vDSO/parse_vdso.c b/Documentation/vDSO/parse_v=
dso.c
> new file mode 100644
> index 0000000..8587020
> --- /dev/null
> +++ b/Documentation/vDSO/parse_vdso.c
> @@ -0,0 +1,256 @@
> +/*
> + * parse_vdso.c: Linux reference vDSO parser
> + * Written by Andrew Lutomirski, 2011.
> + *
> + * This code is meant to be linked in to various programs that run on Li=
nux.
> + * As such, it is available with as few restrictions as possible. =A0Thi=
s file
> + * is licensed under the Creative Commons Zero License, version 1.0,
> + * available at http://creativecommons.org/publicdomain/zero/1.0/legalco=
de
> + *
> + * The vDSO is a regular ELF DSO that the kernel maps into user space wh=
en
> + * it starts a program. =A0It works equally well in statically and dynam=
ically
> + * linked binaries.
> + *
> + * This code is tested on x86_64. =A0In principle it should work on any =
64-bit
> + * architecture that has a vDSO.
> + */
> +
> +#include <stdbool.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <elf.h>
> +
> +/*
> + * To use this vDSO parser, first call one of the vdso_init_* functions.
> + * If you've already parsed auxv, then pass the value of AT_SYSINFO_EHDR
> + * to vdso_init_from_sysinfo_ehdr. =A0Otherwise pass auxv to vdso_init_f=
rom_auxv.
> + * Then call vdso_sym for each symbol you want. =A0For example, to look =
up
> + * gettimeofday on x86_64, use:
> + *
> + * =A0 =A0 <some pointer> =3D vdso_sym("LINUX_2.6", "gettimeofday");
> + * or
> + * =A0 =A0 <some pointer> =3D vdso_sym("LINUX_2.6", "__vdso_gettimeofday=
");
> + *
> + * vdso_sym will return 0 if the symbol doesn't exist or if the init fun=
ction
> + * failed or was not called. =A0vdso_sym is a little slow, so its return=
 value
> + * should be cached.
> + *
> + * vdso_sym is threadsafe; the init functions are not.
> + *
> + * These are the prototypes:
> + */
> +extern void vdso_init_from_auxv(void *auxv);
> +extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
> +extern void *vdso_sym(const char *version, const char *name);
> +
> +
> +/* And here's the code. */
> +
> +#ifndef __x86_64__
> +# error Not yet ported to non-x86_64 architectures
> +#endif
> +
> +static struct vdso_info
> +{
> + =A0 =A0 =A0 bool valid;
> +
> + =A0 =A0 =A0 /* Load information */
> + =A0 =A0 =A0 uintptr_t load_addr;
> + =A0 =A0 =A0 uintptr_t load_offset; =A0/* load_addr - recorded vaddr */
> +
> + =A0 =A0 =A0 /* Symbol table */
> + =A0 =A0 =A0 Elf64_Sym *symtab;
> + =A0 =A0 =A0 const char *symstrings;
> + =A0 =A0 =A0 Elf64_Word *bucket, *chain;
> + =A0 =A0 =A0 Elf64_Word nbucket, nchain;
> +
> + =A0 =A0 =A0 /* Version table */
> + =A0 =A0 =A0 Elf64_Versym *versym;
> + =A0 =A0 =A0 Elf64_Verdef *verdef;
> +} vdso_info;
> +
> +/* Straight from the ELF specification. */
> +static unsigned long elf_hash(const unsigned char *name)
> +{
> + =A0 =A0 =A0 unsigned long h =3D 0, g;
> + =A0 =A0 =A0 while (*name)
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 h =3D (h << 4) + *name++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (g =3D h & 0xf0000000)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 h ^=3D g >> 24;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 h &=3D ~g;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return h;
> +}
> +
> +void vdso_init_from_sysinfo_ehdr(uintptr_t base)
> +{
> + =A0 =A0 =A0 size_t i;
> + =A0 =A0 =A0 bool found_vaddr =3D false;
> +
> + =A0 =A0 =A0 vdso_info.valid =3D false;
> +
> + =A0 =A0 =A0 vdso_info.load_addr =3D base;
> +
> + =A0 =A0 =A0 Elf64_Ehdr *hdr =3D (Elf64_Ehdr*)base;
> + =A0 =A0 =A0 Elf64_Phdr *pt =3D (Elf64_Phdr*)(vdso_info.load_addr + hdr-=
>e_phoff);
> + =A0 =A0 =A0 Elf64_Dyn *dyn =3D 0;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* We need two things from the segment table: the load of=
fset
> + =A0 =A0 =A0 =A0* and the dynamic table.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 for (i =3D 0; i < hdr->e_phnum; i++)
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pt[i].p_type =3D=3D PT_LOAD && !found_v=
addr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 found_vaddr =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_info.load_offset =3D b=
ase
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + (uintptr_=
t)pt[i].p_offset
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 - (uintptr_=
t)pt[i].p_vaddr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (pt[i].p_type =3D=3D PT_DYNAMIC) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dyn =3D (Elf64_Dyn*)(base +=
 pt[i].p_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (!found_vaddr || !dyn)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return; =A0/* Failed */
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Fish out the useful bits of the dynamic table.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 Elf64_Word *hash =3D 0;
> + =A0 =A0 =A0 vdso_info.symstrings =3D 0;
> + =A0 =A0 =A0 vdso_info.symtab =3D 0;
> + =A0 =A0 =A0 vdso_info.versym =3D 0;
> + =A0 =A0 =A0 vdso_info.verdef =3D 0;
> + =A0 =A0 =A0 for (i =3D 0; dyn[i].d_tag !=3D DT_NULL; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (dyn[i].d_tag) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case DT_STRTAB:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_info.symstrings =3D (c=
onst char *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((uintptr_t=
)dyn[i].d_un.d_ptr
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ vdso_i=
nfo.load_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case DT_SYMTAB:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_info.symtab =3D (Elf64=
_Sym *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((uintptr_t=
)dyn[i].d_un.d_ptr
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ vdso_i=
nfo.load_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case DT_HASH:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash =3D (Elf64_Word *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((uintptr_t=
)dyn[i].d_un.d_ptr
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ vdso_i=
nfo.load_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case DT_VERSYM:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_info.versym =3D (Elf64=
_Versym *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((uintptr_t=
)dyn[i].d_un.d_ptr
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ vdso_i=
nfo.load_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case DT_VERDEF:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_info.verdef =3D (Elf64=
_Verdef *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((uintptr_t=
)dyn[i].d_un.d_ptr
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ vdso_i=
nfo.load_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (!vdso_info.symstrings || !vdso_info.symtab || !hash)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return; =A0/* Failed */
> +
> + =A0 =A0 =A0 if (!vdso_info.verdef)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_info.versym =3D 0;
> +
> + =A0 =A0 =A0 /* Parse the hash table header. */
> + =A0 =A0 =A0 vdso_info.nbucket =3D hash[0];
> + =A0 =A0 =A0 vdso_info.nchain =3D hash[1];
> + =A0 =A0 =A0 vdso_info.bucket =3D &hash[2];
> + =A0 =A0 =A0 vdso_info.chain =3D &hash[vdso_info.nbucket + 2];
> +
> + =A0 =A0 =A0 /* That's all we need. */
> + =A0 =A0 =A0 vdso_info.valid =3D true;
> +}
> +
> +static bool vdso_match_version(Elf64_Versym ver,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *=
name, Elf64_Word hash)
> +{
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* This is a helper function to check if the version inde=
xed by
> + =A0 =A0 =A0 =A0* ver matches name (which hashes to hash).
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* The version definition table is a mess, and I don't kn=
ow how
> + =A0 =A0 =A0 =A0* to do this in better than linear time without allocati=
ng memory
> + =A0 =A0 =A0 =A0* to build an index. =A0I also don't know why the table =
has
> + =A0 =A0 =A0 =A0* variable size entries in the first place.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* For added fun, I can't find a comprehensible specifica=
tion of how
> + =A0 =A0 =A0 =A0* to parse all the weird flags in the table.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* So I just parse the whole table every time.
> + =A0 =A0 =A0 =A0*/
> +
> + =A0 =A0 =A0 /* First step: find the version definition */
> + =A0 =A0 =A0 ver &=3D 0x7fff; =A0/* Apparently bit 15 means "hidden" */
> + =A0 =A0 =A0 Elf64_Verdef *def =3D vdso_info.verdef;
> + =A0 =A0 =A0 while(true) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((def->vd_flags & VER_FLG_BASE) =3D=3D 0
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (def->vd_ndx & 0x7fff) =3D=3D ve=
r)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (def->vd_next =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false; =A0/* No defi=
nition. */
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 def =3D (Elf64_Verdef *)((char *)def + def-=
>vd_next);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Now figure out whether it matches. */
> + =A0 =A0 =A0 Elf64_Verdaux *aux =3D (Elf64_Verdaux*)((char *)def + def->=
vd_aux);
> + =A0 =A0 =A0 return def->vd_hash =3D=3D hash
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !strcmp(name, vdso_info.symstrings + aux=
->vda_name);
> +}
> +
> +void *vdso_sym(const char *version, const char *name)
> +{
> + =A0 =A0 =A0 unsigned long ver_hash;
> + =A0 =A0 =A0 if (!vdso_info.valid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 ver_hash =3D elf_hash(version);
> + =A0 =A0 =A0 Elf64_Word chain =3D vdso_info.bucket[elf_hash(name) % vdso=
_info.nbucket];
> +
> + =A0 =A0 =A0 for (; chain !=3D STN_UNDEF; chain =3D vdso_info.chain[chai=
n]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Elf64_Sym *sym =3D &vdso_info.symtab[chain]=
;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Check for a defined global or weak funct=
ion w/ right name. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ELF64_ST_TYPE(sym->st_info) !=3D STT_FU=
NC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ELF64_ST_BIND(sym->st_info) !=3D STB_GL=
OBAL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ELF64_ST_BIND(sym->st_info) !=3D ST=
B_WEAK)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sym->st_shndx =3D=3D SHN_UNDEF)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strcmp(name, vdso_info.symstrings + sym=
->st_name))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Check symbol version. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (vdso_info.versym
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !vdso_match_version(vdso_info.ve=
rsym[chain],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0version, ver_hash))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (void *)(vdso_info.load_offset + sym=
->st_value);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +void vdso_init_from_auxv(void *auxv)
> +{
> + =A0 =A0 =A0 Elf64_auxv_t *elf_auxv =3D auxv;
> + =A0 =A0 =A0 for (int i =3D 0; elf_auxv[i].a_type !=3D AT_NULL; i++)
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (elf_auxv[i].a_type =3D=3D AT_SYSINFO_EH=
DR) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_init_from_sysinfo_ehdr=
(elf_auxv[i].a_un.a_val);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 vdso_info.valid =3D false;
> +}
> diff --git a/Documentation/vDSO/vdso_test.c b/Documentation/vDSO/vdso_tes=
t.c
> new file mode 100644
> index 0000000..fff6334
> --- /dev/null
> +++ b/Documentation/vDSO/vdso_test.c
> @@ -0,0 +1,111 @@
> +/*
> + * vdso_test.c: Sample code to test parse_vdso.c on x86_64
> + * Copyright (c) 2011 Andy Lutomirski
> + * Subject to the GNU General Public License, version 2
> + *
> + * You can amuse yourself by compiling with:
> + * gcc -std=3Dgnu99 -nostdlib
> + * =A0 =A0 -Os -fno-asynchronous-unwind-tables -flto
> + * =A0 =A0 =A0vdso_test.c parse_vdso.c -o vdso_test
> + * to generate a small binary with no dependencies at all.
> + */
> +
> +#include <sys/syscall.h>
> +#include <sys/time.h>
> +#include <unistd.h>
> +#include <stdint.h>
> +
> +extern void *vdso_sym(const char *version, const char *name);
> +extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
> +extern void vdso_init_from_auxv(void *auxv);
> +
> +/* We need a libc functions... */
> +int strcmp(const char *a, const char *b)
> +{
> + =A0 =A0 =A0 /* This implementation is buggy: it never returns -1. */
> + =A0 =A0 =A0 while (*a || *b) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*a !=3D *b)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*a =3D=3D 0 || *b =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 a++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 b++;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/* ...and two syscalls. =A0This is x86_64-specific. */
> +static inline long linux_write(int fd, const void *data, size_t len)
> +{
> +
> + =A0 =A0 =A0 long ret;
> + =A0 =A0 =A0 asm volatile ("syscall" : "=3Da" (ret) : "a" (__NR_write),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "D" (fd), "S" (data), "d" (len)=
 :
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "cc", "memory", "rcx",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "r8", "r9", "r10", "r11" );
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static inline void linux_exit(int code)
> +{
> + =A0 =A0 =A0 asm volatile ("syscall" : : "a" (__NR_exit), "D" (code));
> +}
> +
> +void to_base10(char *lastdig, uint64_t n)
> +{
> + =A0 =A0 =A0 while (n) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *lastdig =3D (n % 10) + '0';
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 n /=3D 10;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lastdig--;
> + =A0 =A0 =A0 }
> +}
> +
> +__attribute__((externally_visible)) void c_main(void **stack)
> +{
> + =A0 =A0 =A0 /* Parse the stack */
> + =A0 =A0 =A0 long argc =3D (long)*stack;
> + =A0 =A0 =A0 stack +=3D argc + 2;
> +
> + =A0 =A0 =A0 /* Now we're pointing at the environment. =A0Skip it. */
> + =A0 =A0 =A0 while(*stack)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stack++;
> + =A0 =A0 =A0 stack++;
> +
> + =A0 =A0 =A0 /* Now we're pointing at auxv. =A0Initialize the vDSO parse=
r. */
> + =A0 =A0 =A0 vdso_init_from_auxv((void *)stack);
> +
> + =A0 =A0 =A0 /* Find gettimeofday. */
> + =A0 =A0 =A0 typedef long (*gtod_t)(struct timeval *tv, struct timezone =
*tz);
> + =A0 =A0 =A0 gtod_t gtod =3D (gtod_t)vdso_sym("LINUX_2.6", "__vdso_getti=
meofday");
> +
> + =A0 =A0 =A0 if (!gtod)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 linux_exit(1);
> +
> + =A0 =A0 =A0 struct timeval tv;
> + =A0 =A0 =A0 long ret =3D gtod(&tv, 0);
> +
> + =A0 =A0 =A0 if (ret =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char buf[] =3D "The time is =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 .000000\n";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_base10(buf + 31, tv.tv_sec);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 to_base10(buf + 38, tv.tv_usec);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 linux_write(1, buf, sizeof(buf) - 1);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 linux_exit(ret);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 linux_exit(0);
> +}
> +
> +/*
> + * This is the real entry point. =A0It passes the initial stack into
> + * the C entry point.
> + */
> +asm (
> + =A0 =A0 =A0 ".text\n"
> + =A0 =A0 =A0 ".global _start\n"
> + =A0 =A0 =A0 =A0".type _start,@function\n"
> + =A0 =A0 =A0 =A0"_start:\n\t"
> + =A0 =A0 =A0 =A0"mov %rsp,%rdi\n\t"
> + =A0 =A0 =A0 =A0"jmp c_main"
> + =A0 =A0 =A0 );
> diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.=
txt
> new file mode 100644
> index 0000000..7869f14
> --- /dev/null
> +++ b/Documentation/x86/entry_64.txt
> @@ -0,0 +1,98 @@
> +This file documents some of the kernel entries in
> +arch/x86/kernel/entry_64.S. =A0A lot of this explanation is adapted from
> +an email from Ingo Molnar:
> +
> +http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
> +
> +The x86 architecture has quite a few different ways to jump into
> +kernel code. =A0Most of these entry points are registered in
> +arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
> +and arch/x86/ia32/ia32entry.S.
> +
> +The IDT vector assignments are listed in arch/x86/include/irq_vectors.h.
> +
> +Some of these entries are:
> +
> + - system_call: syscall instruction from 64-bit code.
> +
> + - ia32_syscall: int 0x80 from 32-bit or 64-bit code; compat syscall
> + =A0 either way.
> +
> + - ia32_syscall, ia32_sysenter: syscall and sysenter from 32-bit
> + =A0 code
> +
> + - interrupt: An array of entries. =A0Every IDT vector that doesn't
> + =A0 explicitly point somewhere else gets set to the corresponding
> + =A0 value in interrupts. =A0These point to a whole array of
> + =A0 magically-generated functions that make their way to do_IRQ with
> + =A0 the interrupt number as a parameter.
> +
> + - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
> + =A0 vsyscall emulation.
> +
> + - APIC interrupts: Various special-purpose interrupts for things
> + =A0 like TLB shootdown.
> +
> + - Architecturally-defined exceptions like divide_error.
> +
> +There are a few complexities here. =A0The different x86-64 entries
> +have different calling conventions. =A0The syscall and sysenter
> +instructions have their own peculiar calling conventions. =A0Some of
> +the IDT entries push an error code onto the stack; others don't.
> +IDT entries using the IST alternative stack mechanism need their own
> +magic to get the stack frames right. =A0(You can find some
> +documentation in the AMD APM, Volume 2, Chapter 8 and the Intel SDM,
> +Volume 3, Chapter 6.)
> +
> +Dealing with the swapgs instruction is especially tricky. =A0Swapgs
> +toggles whether gs is the kernel gs or the user gs. =A0The swapgs
> +instruction is rather fragile: it must nest perfectly and only in
> +single depth, it should only be used if entering from user mode to
> +kernel mode and then when returning to user-space, and precisely
> +so. If we mess that up even slightly, we crash.
> +
> +So when we have a secondary entry, already in kernel mode, we *must
> +not* use SWAPGS blindly - nor must we forget doing a SWAPGS when it's
> +not switched/swapped yet.
> +
> +Now, there's a secondary complication: there's a cheap way to test
> +which mode the CPU is in and an expensive way.
> +
> +The cheap way is to pick this info off the entry frame on the kernel
> +stack, from the CS of the ptregs area of the kernel stack:
> +
> + =A0 =A0 =A0 xorl %ebx,%ebx
> + =A0 =A0 =A0 testl $3,CS+8(%rsp)
> + =A0 =A0 =A0 je error_kernelspace
> + =A0 =A0 =A0 SWAPGS
> +
> +The expensive (paranoid) way is to read back the MSR_GS_BASE value
> +(which is what SWAPGS modifies):
> +
> + =A0 =A0 =A0 movl $1,%ebx
> + =A0 =A0 =A0 movl $MSR_GS_BASE,%ecx
> + =A0 =A0 =A0 rdmsr
> + =A0 =A0 =A0 testl %edx,%edx
> + =A0 =A0 =A0 js 1f =A0 /* negative -> in kernel */
> + =A0 =A0 =A0 SWAPGS
> + =A0 =A0 =A0 xorl %ebx,%ebx
> +1: =A0 =A0 ret
> +
> +and the whole paranoid non-paranoid macro complexity is about whether
> +to suffer that RDMSR cost.
> +
> +If we are at an interrupt or user-trap/gate-alike boundary then we can
> +use the faster check: the stack will be a reliable indicator of
> +whether SWAPGS was already done: if we see that we are a secondary
> +entry interrupting kernel mode execution, then we know that the GS
> +base has already been switched. If it says that we interrupted
> +user-space execution then we must do the SWAPGS.
> +
> +But if we are in an NMI/MCE/DEBUG/whatever super-atomic entry context,
> +which might have triggered right after a normal entry wrote CS to the
> +stack but before we executed SWAPGS, then the only safe way to check
> +for GS is the slower method: the RDMSR.
> +
> +So we try only to mark those entry methods 'paranoid' that absolutely
> +need the more expensive check for the GS base - and we generate all
> +'normal' entry points with the regular (faster) entry macros.
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 38280ef..0a9820a 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -101,6 +101,9 @@ config GENERIC_IOMAP
> =A0 =A0 =A0 =A0bool
> =A0 =A0 =A0 =A0default y
>
> +config ARCH_CLOCKSOURCE_DATA
> + =A0 =A0 =A0 def_bool y
> +
> =A0config SCHED_OMIT_FRAME_POINTER
> =A0 =A0 =A0 =A0bool
> =A0 =A0 =A0 =A0default y
> diff --git a/arch/ia64/include/asm/clocksource.h b/arch/ia64/include/asm/=
clocksource.h
> new file mode 100644
> index 0000000..5c8596e
> --- /dev/null
> +++ b/arch/ia64/include/asm/clocksource.h
> @@ -0,0 +1,10 @@
> +/* IA64-specific clocksource additions */
> +
> +#ifndef _ASM_IA64_CLOCKSOURCE_H
> +#define _ASM_IA64_CLOCKSOURCE_H
> +
> +struct arch_clocksource_data {
> + =A0 =A0 =A0 void *fsys_mmio; =A0 =A0 =A0 =A0/* used by fsyscall asm cod=
e */
> +};
> +
> +#endif /* _ASM_IA64_CLOCKSOURCE_H */
> diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
> index f64097b..4826ff9 100644
> --- a/arch/ia64/kernel/cyclone.c
> +++ b/arch/ia64/kernel/cyclone.c
> @@ -115,7 +115,7 @@ int __init init_cyclone_clock(void)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/* initialize last tick */
> =A0 =A0 =A0 =A0cyclone_mc =3D cyclone_timer;
> - =A0 =A0 =A0 clocksource_cyclone.fsys_mmio =3D cyclone_timer;
> + =A0 =A0 =A0 clocksource_cyclone.archdata.fsys_mmio =3D cyclone_timer;
> =A0 =A0 =A0 =A0clocksource_register_hz(&clocksource_cyclone, CYCLONE_TIME=
R_FREQ);
>
> =A0 =A0 =A0 =A0return 0;
> diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
> index 85118df..43920de 100644
> --- a/arch/ia64/kernel/time.c
> +++ b/arch/ia64/kernel/time.c
> @@ -468,7 +468,7 @@ void update_vsyscall(struct timespec *wall, struct ti=
mespec *wtm,
> =A0 =A0 =A0 =A0 fsyscall_gtod_data.clk_mask =3D c->mask;
> =A0 =A0 =A0 =A0 fsyscall_gtod_data.clk_mult =3D mult;
> =A0 =A0 =A0 =A0 fsyscall_gtod_data.clk_shift =3D c->shift;
> - =A0 =A0 =A0 =A0fsyscall_gtod_data.clk_fsys_mmio =3D c->fsys_mmio;
> + =A0 =A0 =A0 =A0fsyscall_gtod_data.clk_fsys_mmio =3D c->archdata.fsys_mm=
io;
> =A0 =A0 =A0 =A0 fsyscall_gtod_data.clk_cycle_last =3D c->cycle_last;
>
> =A0 =A0 =A0 =A0/* copy kernel time structures */
> diff --git a/arch/ia64/sn/kernel/sn2/timer.c b/arch/ia64/sn/kernel/sn2/ti=
mer.c
> index c34efda..0f8844e 100644
> --- a/arch/ia64/sn/kernel/sn2/timer.c
> +++ b/arch/ia64/sn/kernel/sn2/timer.c
> @@ -54,7 +54,7 @@ ia64_sn_udelay (unsigned long usecs)
>
> =A0void __init sn_timer_init(void)
> =A0{
> - =A0 =A0 =A0 clocksource_sn2.fsys_mmio =3D RTC_COUNTER_ADDR;
> + =A0 =A0 =A0 clocksource_sn2.archdata.fsys_mmio =3D RTC_COUNTER_ADDR;
> =A0 =A0 =A0 =A0clocksource_register_hz(&clocksource_sn2, sn_rtc_cycles_pe=
r_second);
>
> =A0 =A0 =A0 =A0ia64_udelay =3D &ia64_sn_udelay;
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index da34972..c1e41bc 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -93,6 +93,10 @@ config CLOCKSOURCE_WATCHDOG
> =A0config GENERIC_CLOCKEVENTS
> =A0 =A0 =A0 =A0def_bool y
>
> +config ARCH_CLOCKSOURCE_DATA
> + =A0 =A0 =A0 def_bool y
> + =A0 =A0 =A0 depends on X86_64
> +
> =A0config GENERIC_CLOCKEVENTS_BROADCAST
> =A0 =A0 =A0 =A0def_bool y
> =A0 =A0 =A0 =A0depends on X86_64 || (X86_32 && X86_LOCAL_APIC)
> diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/as=
m/alternative-asm.h
> index 94d420b..4554cc6 100644
> --- a/arch/x86/include/asm/alternative-asm.h
> +++ b/arch/x86/include/asm/alternative-asm.h
> @@ -17,8 +17,8 @@
>
> =A0.macro altinstruction_entry orig alt feature orig_len alt_len
> =A0 =A0 =A0 =A0.align 8
> - =A0 =A0 =A0 .quad \orig
> - =A0 =A0 =A0 .quad \alt
> + =A0 =A0 =A0 .long \orig - .
> + =A0 =A0 =A0 .long \alt - .
> =A0 =A0 =A0 =A0.word \feature
> =A0 =A0 =A0 =A0.byte \orig_len
> =A0 =A0 =A0 =A0.byte \alt_len
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/al=
ternative.h
> index bf535f9..23fb6d7 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -43,8 +43,8 @@
> =A0#endif
>
> =A0struct alt_instr {
> - =A0 =A0 =A0 u8 *instr; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* original instructi=
on */
> - =A0 =A0 =A0 u8 *replacement;
> + =A0 =A0 =A0 s32 instr_offset; =A0 =A0 =A0 /* original instruction */
> + =A0 =A0 =A0 s32 repl_offset; =A0 =A0 =A0 =A0/* offset to replacement in=
struction */
> =A0 =A0 =A0 =A0u16 cpuid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* cpuid bit set for=
 replacement */
> =A0 =A0 =A0 =A0u8 =A0instrlen; =A0 =A0 =A0 =A0 =A0 /* length of original =
instruction */
> =A0 =A0 =A0 =A0u8 =A0replacementlen; =A0 =A0 /* length of new instruction=
, <=3D instrlen */
> @@ -84,8 +84,8 @@ static inline int alternatives_text_reserved(void *star=
t, void *end)
> =A0 =A0 =A0 "661:\n\t" oldinstr "\n662:\n" =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 ".section .altinstructions,\"a\"\n" =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 _ASM_ALIGN "\n" =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> - =A0 =A0 =A0_ASM_PTR "661b\n" =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0/* label =A0 =A0 =A0 =A0 =A0 */ =A0 \
> - =A0 =A0 =A0_ASM_PTR "663f\n" =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0/* new instruction */ =A0 \
> + =A0 =A0 =A0" =A0 =A0 =A0 =A0 .long 661b - .\n" =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0/* label =A0 =A0 =A0 =A0 =A0 */ =A0 \
> + =A0 =A0 =A0" =A0 =A0 =A0 =A0 .long 663f - .\n" =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0/* new instruction */ =A0 \
> =A0 =A0 =A0 " =A0 =A0 =A0 =A0 .word " __stringify(feature) "\n" =A0 =A0 =
=A0/* feature bit =A0 =A0 */ =A0 \
> =A0 =A0 =A0 " =A0 =A0 =A0 =A0 .byte 662b-661b\n" =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 /* sourcelen =A0 =A0 =A0 */ =A0 \
> =A0 =A0 =A0 " =A0 =A0 =A0 =A0 .byte 664f-663f\n" =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 /* replacementlen =A0*/ =A0 \
> diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/cl=
ocksource.h
> new file mode 100644
> index 0000000..0bdbbb3
> --- /dev/null
> +++ b/arch/x86/include/asm/clocksource.h
> @@ -0,0 +1,18 @@
> +/* x86-specific clocksource additions */
> +
> +#ifndef _ASM_X86_CLOCKSOURCE_H
> +#define _ASM_X86_CLOCKSOURCE_H
> +
> +#ifdef CONFIG_X86_64
> +
> +#define VCLOCK_NONE 0 =A0/* No vDSO clock available. =A0 =A0 */
> +#define VCLOCK_TSC =A01 =A0/* vDSO should use vread_tsc. =A0 */
> +#define VCLOCK_HPET 2 =A0/* vDSO should use vread_hpet. =A0*/
> +
> +struct arch_clocksource_data {
> + =A0 =A0 =A0 int vclock_mode;
> +};
> +
> +#endif /* CONFIG_X86_64 */
> +
> +#endif /* _ASM_X86_CLOCKSOURCE_H */
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpu=
feature.h
> index 71cc380..9929b35 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -331,8 +331,8 @@ static __always_inline __pure bool __static_cpu_has(u=
16 bit)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "2:\n"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ".section .altinstruction=
s,\"a\"\n"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _ASM_ALIGN "\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_ASM_PTR "1b\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_ASM_PTR "0\n" =A0 =A0 =
=A0 =A0 /* no replacement */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" .long 1b - .\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" .long 0\n" =A0 =A0 =A0=
 =A0 =A0 /* no replacement */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " .word %P0\n" =A0 =A0 =
=A0 =A0 /* feature bit */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " .byte 2b - 1b\n" =A0 =
=A0 /* source len */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " .byte 0\n" =A0 =A0 =A0 =
=A0 =A0 /* replacement len */
> @@ -349,8 +349,8 @@ static __always_inline __pure bool __static_cpu_has(u=
16 bit)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "2:\n"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ".section .altins=
tructions,\"a\"\n"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _ASM_ALIGN "\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_ASM_PTR "1b\n"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_ASM_PTR "3f\n"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" .long 1b - .\n=
"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" .long 3f - .\n=
"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " .word %P1\n" =
=A0 =A0 =A0 =A0 =A0 =A0 /* feature bit */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " .byte 2b - 1b\n=
" =A0 =A0 =A0 =A0 /* source len */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " .byte 4f - 3f\n=
" =A0 =A0 =A0 =A0 /* replacement len */
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.=
h
> index 4729b2b..460c74e 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -78,6 +78,7 @@ enum fixed_addresses {
> =A0 =A0 =A0 =A0VSYSCALL_LAST_PAGE,
> =A0 =A0 =A0 =A0VSYSCALL_FIRST_PAGE =3D VSYSCALL_LAST_PAGE
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ ((VSYSCALL_END-V=
SYSCALL_START) >> PAGE_SHIFT) - 1,
> + =A0 =A0 =A0 VVAR_PAGE,
> =A0 =A0 =A0 =A0VSYSCALL_HPET,
> =A0#endif
> =A0 =A0 =A0 =A0FIX_DBGP_BASE,
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/ir=
q_vectors.h
> index 6e976ee..a563c50 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -17,7 +17,8 @@
> =A0* =A0Vectors =A0 0 ... =A031 : system traps and exceptions - hardcoded=
 events
> =A0* =A0Vectors =A032 ... 127 : device interrupts
> =A0* =A0Vector =A0128 =A0 =A0 =A0 =A0 : legacy int80 syscall interface
> - * =A0Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts
> + * =A0Vector =A0204 =A0 =A0 =A0 =A0 : legacy x86_64 vsyscall emulation
> + * =A0Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device =
interrupts
> =A0* =A0Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
> =A0*
> =A0* 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
> @@ -50,6 +51,9 @@
> =A0#ifdef CONFIG_X86_32
> =A0# define SYSCALL_VECTOR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A00x80
> =A0#endif
> +#ifdef CONFIG_X86_64
> +# define VSYSCALL_EMU_VECTOR =A0 =A0 =A0 =A0 =A0 0xcc
> +#endif
>
> =A0/*
> =A0* Vectors 0x30-0x3f are used for ISA interrupts.
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/=
pgtable_types.h
> index d56187c..013286a 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -107,7 +107,8 @@
> =A0#define __PAGE_KERNEL_NOCACHE =A0 =A0 =A0 =A0 =A0(__PAGE_KERNEL | _PAG=
E_PCD | _PAGE_PWT)
> =A0#define __PAGE_KERNEL_UC_MINUS =A0 =A0 =A0 =A0 (__PAGE_KERNEL | _PAGE_=
PCD)
> =A0#define __PAGE_KERNEL_VSYSCALL =A0 =A0 =A0 =A0 (__PAGE_KERNEL_RX | _PA=
GE_USER)
> -#define __PAGE_KERNEL_VSYSCALL_NOCACHE (__PAGE_KERNEL_VSYSCALL | _PAGE_P=
CD | _PAGE_PWT)
> +#define __PAGE_KERNEL_VVAR =A0 =A0 =A0 =A0 =A0 =A0 (__PAGE_KERNEL_RO | _=
PAGE_USER)
> +#define __PAGE_KERNEL_VVAR_NOCACHE =A0 =A0 (__PAGE_KERNEL_VVAR | _PAGE_P=
CD | _PAGE_PWT)
> =A0#define __PAGE_KERNEL_LARGE =A0 =A0 =A0 =A0 =A0 =A0(__PAGE_KERNEL | _P=
AGE_PSE)
> =A0#define __PAGE_KERNEL_LARGE_NOCACHE =A0 =A0(__PAGE_KERNEL | _PAGE_CACH=
E_UC | _PAGE_PSE)
> =A0#define __PAGE_KERNEL_LARGE_EXEC =A0 =A0 =A0 (__PAGE_KERNEL_EXEC | _PA=
GE_PSE)
> @@ -129,7 +130,8 @@
> =A0#define PAGE_KERNEL_LARGE_NOCACHE =A0 =A0 =A0__pgprot(__PAGE_KERNEL_LA=
RGE_NOCACHE)
> =A0#define PAGE_KERNEL_LARGE_EXEC =A0 =A0 =A0 =A0 __pgprot(__PAGE_KERNEL_=
LARGE_EXEC)
> =A0#define PAGE_KERNEL_VSYSCALL =A0 =A0 =A0 =A0 =A0 __pgprot(__PAGE_KERNE=
L_VSYSCALL)
> -#define PAGE_KERNEL_VSYSCALL_NOCACHE =A0 __pgprot(__PAGE_KERNEL_VSYSCALL=
_NOCACHE)
> +#define PAGE_KERNEL_VVAR =A0 =A0 =A0 =A0 =A0 =A0 =A0 __pgprot(__PAGE_KER=
NEL_VVAR)
> +#define PAGE_KERNEL_VVAR_NOCACHE =A0 =A0 =A0 __pgprot(__PAGE_KERNEL_VVAR=
_NOCACHE)
>
> =A0#define PAGE_KERNEL_IO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __pgprot(__PAGE=
_KERNEL_IO)
> =A0#define PAGE_KERNEL_IO_NOCACHE =A0 =A0 =A0 =A0 __pgprot(__PAGE_KERNEL_=
IO_NOCACHE)
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 0310da6..2bae0a5 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -1,6 +1,8 @@
> =A0#ifndef _ASM_X86_TRAPS_H
> =A0#define _ASM_X86_TRAPS_H
>
> +#include <linux/kprobes.h>
> +
> =A0#include <asm/debugreg.h>
> =A0#include <asm/siginfo.h> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /=
* TRAP_TRACE, ... */
>
> @@ -38,6 +40,7 @@ asmlinkage void alignment_check(void);
> =A0asmlinkage void machine_check(void);
> =A0#endif /* CONFIG_X86_MCE */
> =A0asmlinkage void simd_coprocessor_error(void);
> +asmlinkage void emulate_vsyscall(void);
>
> =A0dotraplinkage void do_divide_error(struct pt_regs *, long);
> =A0dotraplinkage void do_debug(struct pt_regs *, long);
> @@ -64,6 +67,7 @@ dotraplinkage void do_alignment_check(struct pt_regs *,=
 long);
> =A0dotraplinkage void do_machine_check(struct pt_regs *, long);
> =A0#endif
> =A0dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
> +dotraplinkage void do_emulate_vsyscall(struct pt_regs *, long);
> =A0#ifdef CONFIG_X86_32
> =A0dotraplinkage void do_iret_error(struct pt_regs *, long);
> =A0#endif
> diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
> index 9db5583..83e2efd 100644
> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -51,10 +51,6 @@ extern int unsynchronized_tsc(void);
> =A0extern int check_tsc_unstable(void);
> =A0extern unsigned long native_calibrate_tsc(void);
>
> -#ifdef CONFIG_X86_64
> -extern cycles_t vread_tsc(void);
> -#endif
> -
> =A0/*
> =A0* Boot-time check whether the TSCs are synchronized across
> =A0* all CPUs/cores:
> diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
> index 646b4c1..815285b 100644
> --- a/arch/x86/include/asm/vgtod.h
> +++ b/arch/x86/include/asm/vgtod.h
> @@ -11,10 +11,9 @@ struct vsyscall_gtod_data {
> =A0 =A0 =A0 =A0time_t =A0 =A0 =A0 =A0 =A0wall_time_sec;
> =A0 =A0 =A0 =A0u32 =A0 =A0 =A0 =A0 =A0 =A0 wall_time_nsec;
>
> - =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 sysctl_enabled;
> =A0 =A0 =A0 =A0struct timezone sys_tz;
> =A0 =A0 =A0 =A0struct { /* extract of a clocksource struct */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cycle_t (*vread)(void);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int vclock_mode;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cycle_t cycle_last;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cycle_t mask;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u32 =A0 =A0 mult;
> diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsysc=
all.h
> index d555973..6010707 100644
> --- a/arch/x86/include/asm/vsyscall.h
> +++ b/arch/x86/include/asm/vsyscall.h
> @@ -16,10 +16,6 @@ enum vsyscall_num {
> =A0#ifdef __KERNEL__
> =A0#include <linux/seqlock.h>
>
> -/* Definitions for CONFIG_GENERIC_TIME definitions */
> -#define __vsyscall_fn \
> - =A0 =A0 =A0 __attribute__ ((unused, __section__(".vsyscall_fn"))) notra=
ce
> -
> =A0#define VGETCPU_RDTSCP 1
> =A0#define VGETCPU_LSL =A0 =A02
>
> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> index 341b355..de656ac 100644
> --- a/arch/x86/include/asm/vvar.h
> +++ b/arch/x86/include/asm/vvar.h
> @@ -10,15 +10,14 @@
> =A0* In normal kernel code, they are used like any other variable.
> =A0* In user code, they are accessed through the VVAR macro.
> =A0*
> - * Each of these variables lives in the vsyscall page, and each
> - * one needs a unique offset within the little piece of the page
> - * reserved for vvars. =A0Specify that offset in DECLARE_VVAR.
> - * (There are 896 bytes available. =A0If you mess up, the linker will
> - * catch it.)
> + * These variables live in a page of kernel data that has an extra RO
> + * mapping for userspace. =A0Each variable needs a unique offset within
> + * that page; specify that offset with the DECLARE_VVAR macro. =A0(If
> + * you mess up, the linker will catch it.)
> =A0*/
>
> -/* Offset of vars within vsyscall page */
> -#define VSYSCALL_VARS_OFFSET (3072 + 128)
> +/* Base address of vvars. =A0This is not ABI. */
> +#define VVAR_ADDRESS (-10*1024*1024 - 4096)
>
> =A0#if defined(__VVAR_KERNEL_LDS)
>
> @@ -26,17 +25,17 @@
> =A0* right place.
> =A0*/
> =A0#define DECLARE_VVAR(offset, type, name) \
> - =A0 =A0 =A0 EMIT_VVAR(name, VSYSCALL_VARS_OFFSET + offset)
> + =A0 =A0 =A0 EMIT_VVAR(name, offset)
>
> =A0#else
>
> =A0#define DECLARE_VVAR(offset, type, name) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0static type const * const vvaraddr_ ## name =3D =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void *)(VSYSCALL_START + VSYSCALL_VARS_OFF=
SET + (offset));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void *)(VVAR_ADDRESS + (offset));
>
> =A0#define DEFINE_VVAR(type, name) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> - =A0 =A0 =A0 type __vvar_ ## name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> - =A0 =A0 =A0 __attribute__((section(".vsyscall_var_" #name), aligned(16)=
))
> + =A0 =A0 =A0 type name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 __attribute__((section(".vvar_" #name), aligned(16)))
>
> =A0#define VVAR(name) (*vvaraddr_ ## name)
>
> @@ -45,8 +44,7 @@
> =A0/* DECLARE_VVAR(offset, type, name) */
>
> =A0DECLARE_VVAR(0, volatile unsigned long, jiffies)
> -DECLARE_VVAR(8, int, vgetcpu_mode)
> +DECLARE_VVAR(16, int, vgetcpu_mode)
> =A0DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
>
> =A0#undef DECLARE_VVAR
> -#undef VSYSCALL_VARS_OFFSET
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 90b06d4..2deef3d 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -24,17 +24,12 @@ endif
> =A0nostackp :=3D $(call cc-option, -fno-stack-protector)
> =A0CFLAGS_vsyscall_64.o =A0 :=3D $(PROFILING) -g0 $(nostackp)
> =A0CFLAGS_hpet.o =A0 =A0 =A0 =A0 =A0:=3D $(nostackp)
> -CFLAGS_vread_tsc_64.o =A0:=3D $(nostackp)
> =A0CFLAGS_paravirt.o =A0 =A0 =A0:=3D $(nostackp)
> =A0GCOV_PROFILE_vsyscall_64.o =A0 =A0 :=3D n
> =A0GCOV_PROFILE_hpet.o =A0 =A0 =A0 =A0 =A0 =A0:=3D n
> =A0GCOV_PROFILE_tsc.o =A0 =A0 =A0 =A0 =A0 =A0 :=3D n
> -GCOV_PROFILE_vread_tsc_64.o =A0 =A0:=3D n
> =A0GCOV_PROFILE_paravirt.o =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=3D n
>
> -# vread_tsc_64 is hot and should be fully optimized:
> -CFLAGS_REMOVE_vread_tsc_64.o =3D -pg -fno-optimize-sibling-calls
> -
> =A0obj-y =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=3D process_$(BITS).o signal=
.o entry_$(BITS).o
> =A0obj-y =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D traps.o irq.o irq_$(BITS=
).o dumpstack_$(BITS).o
> =A0obj-y =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D time.o ioport.o ldt.o du=
mpstack.o
> @@ -43,7 +38,8 @@ obj-$(CONFIG_IRQ_WORK) =A0+=3D irq_work.o
> =A0obj-y =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D probe_roms.o
> =A0obj-$(CONFIG_X86_32) =A0 +=3D sys_i386_32.o i386_ksyms_32.o
> =A0obj-$(CONFIG_X86_64) =A0 +=3D sys_x86_64.o x8664_ksyms_64.o
> -obj-$(CONFIG_X86_64) =A0 +=3D syscall_64.o vsyscall_64.o vread_tsc_64.o
> +obj-$(CONFIG_X86_64) =A0 +=3D syscall_64.o vsyscall_64.o
> +obj-$(CONFIG_X86_64) =A0 +=3D vsyscall_emu_64.o
> =A0obj-y =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D bootflag.o e820.o
> =A0obj-y =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D pci-dma.o quirks.o topol=
ogy.o kdebugfs.o
> =A0obj-y =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D alternative.o i8253.o pc=
i-nommu.o hw_breakpoint.o
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.=
c
> index a81f2d5..c638228 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -14,7 +14,6 @@
> =A0#include <asm/pgtable.h>
> =A0#include <asm/mce.h>
> =A0#include <asm/nmi.h>
> -#include <asm/vsyscall.h>
> =A0#include <asm/cacheflush.h>
> =A0#include <asm/tlbflush.h>
> =A0#include <asm/io.h>
> @@ -250,7 +249,6 @@ static void __init_or_module add_nops(void *insns, un=
signed int len)
>
> =A0extern struct alt_instr __alt_instructions[], __alt_instructions_end[]=
;
> =A0extern s32 __smp_locks[], __smp_locks_end[];
> -extern char __vsyscall_0;
> =A0void *text_poke_early(void *addr, const void *opcode, size_t len);
>
> =A0/* Replace instructions with better alternatives for this CPU type.
> @@ -263,6 +261,7 @@ void __init_or_module apply_alternatives(struct alt_i=
nstr *start,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct alt_instr *end)
> =A0{
> =A0 =A0 =A0 =A0struct alt_instr *a;
> + =A0 =A0 =A0 u8 *instr, *replacement;
> =A0 =A0 =A0 =A0u8 insnbuf[MAX_PATCH_LEN];
>
> =A0 =A0 =A0 =A0DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
> @@ -276,25 +275,23 @@ void __init_or_module apply_alternatives(struct alt=
_instr *start,
> =A0 =A0 =A0 =A0 * order.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0for (a =3D start; a < end; a++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 *instr =3D a->instr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 instr =3D (u8 *)&a->instr_offset + a->instr=
_offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 replacement =3D (u8 *)&a->repl_offset + a->=
repl_offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(a->replacementlen > a->instrlen);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(a->instrlen > sizeof(insnbuf));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(a->cpuid >=3D NCAPINTS*32);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!boot_cpu_has(a->cpuid))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> -#ifdef CONFIG_X86_64
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* vsyscall code is not mapped yet. resolve=
 it manually. */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (instr >=3D (u8 *)VSYSCALL_START && inst=
r < (u8*)VSYSCALL_END) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 instr =3D __va(instr - (u8*=
)VSYSCALL_START + (u8*)__pa_symbol(&__vsyscall_0));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DPRINTK("%s: vsyscall fixup=
: %p =3D> %p\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, a=
->instr, instr);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -#endif
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(insnbuf, a->replacement, a->replacem=
entlen);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(insnbuf, replacement, a->replacement=
len);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 0xe8 is a relative jump; fix the offset.=
 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (*insnbuf =3D=3D 0xe8 && a->replacement=
len =3D=3D 5)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(s32 *)(insnbuf + 1) +=3D a->repla=
cement - a->instr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(s32 *)(insnbuf + 1) +=3D replacem=
ent - instr;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0add_nops(insnbuf + a->replacementlen,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 a->instrlen - a->replacem=
entlen);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0text_poke_early(instr, insnbuf, a->instrle=
n);
> =A0 =A0 =A0 =A0}
> =A0}
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 8a445a0..e949793 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -9,6 +9,8 @@
> =A0/*
> =A0* entry.S contains the system-call and fault low-level handling routin=
es.
> =A0*
> + * Some of this is documented in Documentation/x86/entry_64.txt
> + *
> =A0* NOTE: This code handles signal-recognition, which happens every time
> =A0* after an interrupt and after each system call.
> =A0*
> @@ -1121,6 +1123,8 @@ zeroentry spurious_interrupt_bug do_spurious_interr=
upt_bug
> =A0zeroentry coprocessor_error do_coprocessor_error
> =A0errorentry alignment_check do_alignment_check
> =A0zeroentry simd_coprocessor_error do_simd_coprocessor_error
> +zeroentry emulate_vsyscall do_emulate_vsyscall
> +
>
> =A0 =A0 =A0 =A0/* Reload gs selector with exception handling */
> =A0 =A0 =A0 =A0/* edi: =A0new selector */
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 6781765..d10cc00 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -71,7 +71,7 @@ static inline void hpet_set_mapping(void)
> =A0{
> =A0 =A0 =A0 =A0hpet_virt_address =3D ioremap_nocache(hpet_address, HPET_M=
MAP_SIZE);
> =A0#ifdef CONFIG_X86_64
> - =A0 =A0 =A0 __set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSC=
ALL_NOCACHE);
> + =A0 =A0 =A0 __set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_=
NOCACHE);
> =A0#endif
> =A0}
>
> @@ -738,13 +738,6 @@ static cycle_t read_hpet(struct clocksource *cs)
> =A0 =A0 =A0 =A0return (cycle_t)hpet_readl(HPET_COUNTER);
> =A0}
>
> -#ifdef CONFIG_X86_64
> -static cycle_t __vsyscall_fn vread_hpet(void)
> -{
> - =A0 =A0 =A0 return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPE=
T) + 0xf0);
> -}
> -#endif
> -
> =A0static struct clocksource clocksource_hpet =3D {
> =A0 =A0 =A0 =A0.name =A0 =A0 =A0 =A0 =A0 =3D "hpet",
> =A0 =A0 =A0 =A0.rating =A0 =A0 =A0 =A0 =3D 250,
> @@ -753,7 +746,7 @@ static struct clocksource clocksource_hpet =3D {
> =A0 =A0 =A0 =A0.flags =A0 =A0 =A0 =A0 =A0=3D CLOCK_SOURCE_IS_CONTINUOUS,
> =A0 =A0 =A0 =A0.resume =A0 =A0 =A0 =A0 =3D hpet_resume_counter,
> =A0#ifdef CONFIG_X86_64
> - =A0 =A0 =A0 .vread =A0 =A0 =A0 =A0 =A0=3D vread_hpet,
> + =A0 =A0 =A0 .archdata =A0 =A0 =A0 =3D { .vclock_mode =3D VCLOCK_HPET },
> =A0#endif
> =A0};
>
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index b9b6716..fbc097a 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -872,6 +872,12 @@ void __init trap_init(void)
> =A0 =A0 =A0 =A0set_bit(SYSCALL_VECTOR, used_vectors);
> =A0#endif
>
> +#ifdef CONFIG_X86_64
> + =A0 =A0 =A0 BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
> + =A0 =A0 =A0 set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall=
);
> + =A0 =A0 =A0 set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
> +#endif
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Should be a barrier for any external CPU state:
> =A0 =A0 =A0 =A0 */
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 6cc6922..56c633a 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -777,7 +777,7 @@ static struct clocksource clocksource_tsc =3D {
> =A0 =A0 =A0 =A0.flags =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D CLOCK_SOURCE=
_IS_CONTINUOUS |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CLOCK_=
SOURCE_MUST_VERIFY,
> =A0#ifdef CONFIG_X86_64
> - =A0 =A0 =A0 .vread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D vread_tsc,
> + =A0 =A0 =A0 .archdata =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D { .vclock_mode =
=3D VCLOCK_TSC },
> =A0#endif
> =A0};
>
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.=
S
> index 89aed99..4aa9c54 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -161,50 +161,47 @@ SECTIONS
>
> =A0#define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
> =A0#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
> -#define EMIT_VVAR(x, offset) .vsyscall_var_ ## x =A0 =A0 =A0 \
> - =A0 =A0 =A0 ADDR(.vsyscall_0) + offset =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0\
> - =A0 =A0 =A0 : AT(VLOAD(.vsyscall_var_ ## x)) { =A0 =A0 =A0 =A0 =A0 =A0 =
=A0\
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(.vsyscall_var_ ## x) =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0\
> - =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> - =A0 =A0 =A0 x =3D VVIRT(.vsyscall_var_ ## x);
>
> =A0 =A0 =A0 =A0. =3D ALIGN(4096);
> =A0 =A0 =A0 =A0__vsyscall_0 =3D .;
>
> =A0 =A0 =A0 =A0. =3D VSYSCALL_ADDR;
> - =A0 =A0 =A0 .vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
> + =A0 =A0 =A0 .vsyscall : AT(VLOAD(.vsyscall)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*(.vsyscall_0)
> - =A0 =A0 =A0 } :user
>
> - =A0 =A0 =A0 . =3D ALIGN(L1_CACHE_BYTES);
> - =A0 =A0 =A0 .vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(.vsyscall_fn)
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 . =3D 1024;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*(.vsyscall_1)
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)=
) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(.vsyscall_2)
> - =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)=
) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(.vsyscall_3)
> - =A0 =A0 =A0 }
> -
> -#define __VVAR_KERNEL_LDS
> -#include <asm/vvar.h>
> -#undef __VVAR_KERNEL_LDS
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 . =3D 2048;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(.vsyscall_2)
>
> - =A0 =A0 =A0 . =3D __vsyscall_0 + PAGE_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 . =3D 4096; =A0/* Pad the whole page. */
> + =A0 =A0 =A0 } :user =3D0xcc
> + =A0 =A0 =A0 . =3D ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
>
> =A0#undef VSYSCALL_ADDR
> =A0#undef VLOAD_OFFSET
> =A0#undef VLOAD
> =A0#undef VVIRT_OFFSET
> =A0#undef VVIRT
> +
> + =A0 =A0 =A0 __vvar_page =3D .;
> +
> + =A0 =A0 =A0 .vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 /* Place all vvars at the offsets in asm/vvar.h=
. */
> +#define EMIT_VVAR(name, offset) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 . =3D offset; =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(.vvar_ ## name)
> +#define __VVAR_KERNEL_LDS
> +#include <asm/vvar.h>
> +#undef __VVAR_KERNEL_LDS
> =A0#undef EMIT_VVAR
>
> + =A0 =A0 =A0 } :data
> +
> + =A0 =A0 =A0 . =3D ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
> +
> =A0#endif /* CONFIG_X86_64 */
>
> =A0 =A0 =A0 =A0/* Init code and data - will be freed after init */
> diff --git a/arch/x86/kernel/vread_tsc_64.c b/arch/x86/kernel/vread_tsc_6=
4.c
> deleted file mode 100644
> index a81aa9e..0000000
> --- a/arch/x86/kernel/vread_tsc_64.c
> +++ /dev/null
> @@ -1,36 +0,0 @@
> -/* This code runs in userspace. */
> -
> -#define DISABLE_BRANCH_PROFILING
> -#include <asm/vgtod.h>
> -
> -notrace cycle_t __vsyscall_fn vread_tsc(void)
> -{
> - =A0 =A0 =A0 cycle_t ret;
> - =A0 =A0 =A0 u64 last;
> -
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* Empirically, a fence (of type that depends on the CPU)
> - =A0 =A0 =A0 =A0* before rdtsc is enough to ensure that rdtsc is ordered
> - =A0 =A0 =A0 =A0* with respect to loads. =A0The various CPU manuals are =
unclear
> - =A0 =A0 =A0 =A0* as to whether rdtsc can be reordered with later loads,
> - =A0 =A0 =A0 =A0* but no one has ever seen it happen.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 rdtsc_barrier();
> - =A0 =A0 =A0 ret =3D (cycle_t)vget_cycles();
> -
> - =A0 =A0 =A0 last =3D VVAR(vsyscall_gtod_data).clock.cycle_last;
> -
> - =A0 =A0 =A0 if (likely(ret >=3D last))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> -
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* GCC likes to generate cmov here, but this branch is ex=
tremely
> - =A0 =A0 =A0 =A0* predictable (it's just a funciton of time and the like=
ly is
> - =A0 =A0 =A0 =A0* very likely) and there's a data dependence, so force G=
CC
> - =A0 =A0 =A0 =A0* to generate a branch instead. =A0I don't barrier() bec=
ause
> - =A0 =A0 =A0 =A0* we don't actually need a barrier, and if this function
> - =A0 =A0 =A0 =A0* ever gets inlined it will generate worse code.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 asm volatile ("");
> - =A0 =A0 =A0 return last;
> -}
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.=
c
> index 3e68218..dda7dff 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -2,6 +2,8 @@
> =A0* =A0Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
> =A0* =A0Copyright 2003 Andi Kleen, SuSE Labs.
> =A0*
> + * =A0[ NOTE: this mechanism is now deprecated in favor of the vDSO. ]
> + *
> =A0* =A0Thanks to hpa@transmeta.com for some useful hint.
> =A0* =A0Special thanks to Ingo Molnar for his early experience with
> =A0* =A0a different vsyscall implementation for Linux/IA32 and for the na=
me.
> @@ -11,10 +13,9 @@
> =A0* =A0vsyscalls. One vsyscall can reserve more than 1 slot to avoid
> =A0* =A0jumping out of line if necessary. We cannot add more with this
> =A0* =A0mechanism because older kernels won't return -ENOSYS.
> - * =A0If we want more than four we need a vDSO.
> =A0*
> - * =A0Note: the concept clashes with user mode linux. If you use UML and
> - * =A0want per guest time just set the kernel.vsyscall64 sysctl to 0.
> + * =A0Note: the concept clashes with user mode linux. =A0UML users shoul=
d
> + * =A0use the vDSO.
> =A0*/
>
> =A0/* Disable profiling for userspace code: */
> @@ -32,9 +33,12 @@
> =A0#include <linux/cpu.h>
> =A0#include <linux/smp.h>
> =A0#include <linux/notifier.h>
> +#include <linux/syscalls.h>
> +#include <linux/ratelimit.h>
>
> =A0#include <asm/vsyscall.h>
> =A0#include <asm/pgtable.h>
> +#include <asm/compat.h>
> =A0#include <asm/page.h>
> =A0#include <asm/unistd.h>
> =A0#include <asm/fixmap.h>
> @@ -44,16 +48,12 @@
> =A0#include <asm/desc.h>
> =A0#include <asm/topology.h>
> =A0#include <asm/vgtod.h>
> -
> -#define __vsyscall(nr) \
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __attribute__ ((unused, __section__(".vsysc=
all_" #nr))) notrace
> -#define __syscall_clobber "r11","cx","memory"
> +#include <asm/traps.h>
>
> =A0DEFINE_VVAR(int, vgetcpu_mode);
> =A0DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =3D
> =A0{
> =A0 =A0 =A0 =A0.lock =3D __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
> - =A0 =A0 =A0 .sysctl_enabled =3D 1,
> =A0};
>
> =A0void update_vsyscall_tz(void)
> @@ -72,179 +72,149 @@ void update_vsyscall(struct timespec *wall_time, st=
ruct timespec *wtm,
> =A0 =A0 =A0 =A0unsigned long flags;
>
> =A0 =A0 =A0 =A0write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
> +
> =A0 =A0 =A0 =A0/* copy vsyscall data */
> - =A0 =A0 =A0 vsyscall_gtod_data.clock.vread =3D clock->vread;
> - =A0 =A0 =A0 vsyscall_gtod_data.clock.cycle_last =3D clock->cycle_last;
> - =A0 =A0 =A0 vsyscall_gtod_data.clock.mask =3D clock->mask;
> - =A0 =A0 =A0 vsyscall_gtod_data.clock.mult =3D mult;
> - =A0 =A0 =A0 vsyscall_gtod_data.clock.shift =3D clock->shift;
> - =A0 =A0 =A0 vsyscall_gtod_data.wall_time_sec =3D wall_time->tv_sec;
> - =A0 =A0 =A0 vsyscall_gtod_data.wall_time_nsec =3D wall_time->tv_nsec;
> - =A0 =A0 =A0 vsyscall_gtod_data.wall_to_monotonic =3D *wtm;
> - =A0 =A0 =A0 vsyscall_gtod_data.wall_time_coarse =3D __current_kernel_ti=
me();
> + =A0 =A0 =A0 vsyscall_gtod_data.clock.vclock_mode =A0 =A0=3D clock->arch=
data.vclock_mode;
> + =A0 =A0 =A0 vsyscall_gtod_data.clock.cycle_last =A0 =A0 =3D clock->cycl=
e_last;
> + =A0 =A0 =A0 vsyscall_gtod_data.clock.mask =A0 =A0 =A0 =A0 =A0 =3D clock=
->mask;
> + =A0 =A0 =A0 vsyscall_gtod_data.clock.mult =A0 =A0 =A0 =A0 =A0 =3D mult;
> + =A0 =A0 =A0 vsyscall_gtod_data.clock.shift =A0 =A0 =A0 =A0 =A0=3D clock=
->shift;
> + =A0 =A0 =A0 vsyscall_gtod_data.wall_time_sec =A0 =A0 =A0 =A0=3D wall_ti=
me->tv_sec;
> + =A0 =A0 =A0 vsyscall_gtod_data.wall_time_nsec =A0 =A0 =A0 =3D wall_time=
->tv_nsec;
> + =A0 =A0 =A0 vsyscall_gtod_data.wall_to_monotonic =A0 =A0=3D *wtm;
> + =A0 =A0 =A0 vsyscall_gtod_data.wall_time_coarse =A0 =A0 =3D __current_k=
ernel_time();
> +
> =A0 =A0 =A0 =A0write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags=
);
> =A0}
>
> -/* RED-PEN may want to readd seq locking, but then the variable should b=
e
> - * write-once.
> - */
> -static __always_inline void do_get_tz(struct timezone * tz)
> +static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *mes=
sage)
> =A0{
> - =A0 =A0 =A0 *tz =3D VVAR(vsyscall_gtod_data).sys_tz;
> -}
> + =A0 =A0 =A0 static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVA=
L, DEFAULT_RATELIMIT_BURST);
> + =A0 =A0 =A0 struct task_struct *tsk;
>
> -static __always_inline int gettimeofday(struct timeval *tv, struct timez=
one *tz)
> -{
> - =A0 =A0 =A0 int ret;
> - =A0 =A0 =A0 asm volatile("syscall"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 : "=3Da" (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 : "0" (__NR_gettimeofday),"D" (tv),"S" (tz)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 : __syscall_clobber );
> - =A0 =A0 =A0 return ret;
> -}
> + =A0 =A0 =A0 if (!show_unhandled_signals || !__ratelimit(&rs))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>
> -static __always_inline long time_syscall(long *t)
> -{
> - =A0 =A0 =A0 long secs;
> - =A0 =A0 =A0 asm volatile("syscall"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 : "=3Da" (secs)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 : "0" (__NR_time),"D" (t) : __syscall_clobb=
er);
> - =A0 =A0 =A0 return secs;
> -}
> + =A0 =A0 =A0 tsk =3D current;
>
> -static __always_inline void do_vgettimeofday(struct timeval * tv)
> -{
> - =A0 =A0 =A0 cycle_t now, base, mask, cycle_delta;
> - =A0 =A0 =A0 unsigned seq;
> - =A0 =A0 =A0 unsigned long mult, shift, nsec;
> - =A0 =A0 =A0 cycle_t (*vread)(void);
> - =A0 =A0 =A0 do {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq =3D read_seqbegin(&VVAR(vsyscall_gtod_d=
ata).lock);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 vread =3D VVAR(vsyscall_gtod_data).clock.vr=
ead;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!VVAR(vsyscall_gtod_data).sysc=
tl_enabled ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!vread)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gettimeofday(tv,NULL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 now =3D vread();
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 base =3D VVAR(vsyscall_gtod_data).clock.cyc=
le_last;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mask =3D VVAR(vsyscall_gtod_data).clock.mas=
k;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mult =3D VVAR(vsyscall_gtod_data).clock.mul=
t;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 shift =3D VVAR(vsyscall_gtod_data).clock.sh=
ift;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv->tv_sec =3D VVAR(vsyscall_gtod_data).wal=
l_time_sec;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nsec =3D VVAR(vsyscall_gtod_data).wall_time=
_nsec;
> - =A0 =A0 =A0 } while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq)=
);
> -
> - =A0 =A0 =A0 /* calculate interval: */
> - =A0 =A0 =A0 cycle_delta =3D (now - base) & mask;
> - =A0 =A0 =A0 /* convert to nsecs: */
> - =A0 =A0 =A0 nsec +=3D (cycle_delta * mult) >> shift;
> -
> - =A0 =A0 =A0 while (nsec >=3D NSEC_PER_SEC) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv->tv_sec +=3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nsec -=3D NSEC_PER_SEC;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 tv->tv_usec =3D nsec / NSEC_PER_USEC;
> + =A0 =A0 =A0 printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%=
lx\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0level, tsk->comm, task_pid_nr(tsk),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0message, regs->ip - 2, regs->cs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0regs->sp, regs->ax, regs->si, regs->di);
> =A0}
>
> -int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * t=
z)
> +static int addr_to_vsyscall_nr(unsigned long addr)
> =A0{
> - =A0 =A0 =A0 if (tv)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_vgettimeofday(tv);
> - =A0 =A0 =A0 if (tz)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_get_tz(tz);
> - =A0 =A0 =A0 return 0;
> -}
> + =A0 =A0 =A0 int nr;
>
> -/* This will break when the xtime seconds get inaccurate, but that is
> - * unlikely */
> -time_t __vsyscall(1) vtime(time_t *t)
> -{
> - =A0 =A0 =A0 unsigned seq;
> - =A0 =A0 =A0 time_t result;
> - =A0 =A0 =A0 if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return time_syscall(t);
> + =A0 =A0 =A0 if ((addr & ~0xC00UL) !=3D VSYSCALL_START)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> - =A0 =A0 =A0 do {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq =3D read_seqbegin(&VVAR(vsyscall_gtod_d=
ata).lock);
> + =A0 =A0 =A0 nr =3D (addr & 0xC00UL) >> 10;
> + =A0 =A0 =A0 if (nr >=3D 3)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D VVAR(vsyscall_gtod_data).wall_ti=
me_sec;
> + =A0 =A0 =A0 return nr;
> +}
>
> - =A0 =A0 =A0 } while (read_seqretry(&VVAR(vsyscall_gtod_data).lock, seq)=
);
> +void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_=
code)
> +{
> + =A0 =A0 =A0 struct task_struct *tsk;
> + =A0 =A0 =A0 unsigned long caller;
> + =A0 =A0 =A0 int vsyscall_nr;
> + =A0 =A0 =A0 long ret;
> +
> + =A0 =A0 =A0 local_irq_enable();
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Real 64-bit user mode code has cs =3D=3D __USER_CS. =
=A0Anything else
> + =A0 =A0 =A0 =A0* is bogus.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (regs->cs !=3D __USER_CS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If we trapped from kernel mode, we mig=
ht as well OOPS now
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* instead of returning to some random ad=
dress and OOPSing
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* then.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!user_mode(regs));
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Compat mode and non-compat 32-bit CS sho=
uld both segfault. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 warn_bad_vsyscall(KERN_WARNING, regs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "illega=
l int 0xcc from 32-bit mode");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto sigsegv;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if (t)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *t =3D result;
> - =A0 =A0 =A0 return result;
> -}
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* x86-ism here: regs->ip points to the instruction after=
 the int 0xcc,
> + =A0 =A0 =A0 =A0* and int 0xcc is two bytes long.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 vsyscall_nr =3D addr_to_vsyscall_nr(regs->ip - 2);
> + =A0 =A0 =A0 if (vsyscall_nr < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 warn_bad_vsyscall(KERN_WARNING, regs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "illega=
l int 0xcc (exploit attempt?)");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto sigsegv;
> + =A0 =A0 =A0 }
>
> -/* Fast way to get current CPU and node.
> - =A0 This helps to do per node and per CPU caches in user space.
> - =A0 The result is not guaranteed without CPU affinity, but usually
> - =A0 works out because the scheduler tries to keep a thread on the same
> - =A0 CPU.
> + =A0 =A0 =A0 if (get_user(caller, (unsigned long __user *)regs->sp) !=3D=
 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 warn_bad_vsyscall(KERN_WARNING, regs, "int =
0xcc with bad stack (exploit attempt?)");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto sigsegv;
> + =A0 =A0 =A0 }
>
> - =A0 tcache must point to a two element sized long array.
> - =A0 All arguments can be NULL. */
> -long __vsyscall(2)
> -vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
> -{
> - =A0 =A0 =A0 unsigned int p;
> - =A0 =A0 =A0 unsigned long j =3D 0;
> -
> - =A0 =A0 =A0 /* Fast cache - only recompute value once per jiffies and a=
void
> - =A0 =A0 =A0 =A0 =A0relatively costly rdtscp/cpuid otherwise.
> - =A0 =A0 =A0 =A0 =A0This works because the scheduler usually keeps the p=
rocess
> - =A0 =A0 =A0 =A0 =A0on the same CPU and this syscall doesn't guarantee i=
ts
> - =A0 =A0 =A0 =A0 =A0results anyways.
> - =A0 =A0 =A0 =A0 =A0We do this here because otherwise user space would d=
o it on
> - =A0 =A0 =A0 =A0 =A0its own in a likely inferior way (no access to jiffi=
es).
> - =A0 =A0 =A0 =A0 =A0If you don't like it pass NULL. */
> - =A0 =A0 =A0 if (tcache && tcache->blob[0] =3D=3D (j =3D VVAR(jiffies)))=
 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D tcache->blob[1];
> - =A0 =A0 =A0 } else if (VVAR(vgetcpu_mode) =3D=3D VGETCPU_RDTSCP) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Load per CPU data from RDTSCP */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 native_read_tscp(&p);
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Load per CPU data from GDT */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 asm("lsl %1,%0" : "=3Dr" (p) : "r" (__PER_C=
PU_SEG));
> + =A0 =A0 =A0 tsk =3D current;
> + =A0 =A0 =A0 if (seccomp_mode(&tsk->seccomp))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_exit(SIGKILL);
> +
> + =A0 =A0 =A0 switch (vsyscall_nr) {
> + =A0 =A0 =A0 case 0:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_gettimeofday(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct timeval __user *)re=
gs->di,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct timezone __user *)r=
egs->si);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case 1:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_time((time_t __user *)regs->di)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case 2:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sys_getcpu((unsigned __user *)regs-=
>di,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigne=
d __user *)regs->si,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (tcache) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcache->blob[0] =3D j;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcache->blob[1] =3D p;
> +
> + =A0 =A0 =A0 if (ret =3D=3D -EFAULT) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Bad news -- userspace fed a bad pointe=
r to a vsyscall.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* With a real vsyscall, that would have =
caused SIGSEGV.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* To make writing reliable exploits usin=
g the emulated
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* vsyscalls harder, generate SIGSEGV her=
e as well.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 warn_bad_vsyscall(KERN_INFO, regs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "vsysca=
ll fault (exploit attempt?)");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto sigsegv;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (cpu)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *cpu =3D p & 0xfff;
> - =A0 =A0 =A0 if (node)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *node =3D p >> 12;
> - =A0 =A0 =A0 return 0;
> -}
>
> -static long __vsyscall(3) venosys_1(void)
> -{
> - =A0 =A0 =A0 return -ENOSYS;
> -}
> + =A0 =A0 =A0 regs->ax =3D ret;
>
> -#ifdef CONFIG_SYSCTL
> -static ctl_table kernel_table2[] =3D {
> - =A0 =A0 =A0 { .procname =3D "vsyscall64",
> - =A0 =A0 =A0 =A0 .data =3D &vsyscall_gtod_data.sysctl_enabled, .maxlen =
=3D sizeof(int),
> - =A0 =A0 =A0 =A0 .mode =3D 0644,
> - =A0 =A0 =A0 =A0 .proc_handler =3D proc_dointvec },
> - =A0 =A0 =A0 {}
> -};
> + =A0 =A0 =A0 /* Emulate a ret instruction. */
> + =A0 =A0 =A0 regs->ip =3D caller;
> + =A0 =A0 =A0 regs->sp +=3D 8;
>
> -static ctl_table kernel_root_table2[] =3D {
> - =A0 =A0 =A0 { .procname =3D "kernel", .mode =3D 0555,
> - =A0 =A0 =A0 =A0 .child =3D kernel_table2 },
> - =A0 =A0 =A0 {}
> -};
> -#endif
> + =A0 =A0 =A0 local_irq_disable();
> + =A0 =A0 =A0 return;
> +
> +sigsegv:
> + =A0 =A0 =A0 regs->ip -=3D 2; =A0/* The faulting instruction should be t=
he int 0xcc. */
> + =A0 =A0 =A0 force_sig(SIGSEGV, current);
> + =A0 =A0 =A0 local_irq_disable();
> +}
>
> -/* Assume __initcall executes before all user space. Hopefully kmod
> - =A0 doesn't violate that. We'll find out if it does. */
> +/*
> + * Assume __initcall executes before all user space. Hopefully kmod
> + * doesn't violate that. We'll find out if it does.
> + */
> =A0static void __cpuinit vsyscall_set_cpu(int cpu)
> =A0{
> =A0 =A0 =A0 =A0unsigned long d;
> @@ -255,13 +225,15 @@ static void __cpuinit vsyscall_set_cpu(int cpu)
> =A0 =A0 =A0 =A0if (cpu_has(&cpu_data(cpu), X86_FEATURE_RDTSCP))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write_rdtscp_aux((node << 12) | cpu);
>
> - =A0 =A0 =A0 /* Store cpu number in limit so that it can be loaded quick=
ly
> - =A0 =A0 =A0 =A0 =A0in user space in vgetcpu.
> - =A0 =A0 =A0 =A0 =A012 bits for the CPU and 8 bits for the node. */
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Store cpu number in limit so that it can be loaded qui=
ckly
> + =A0 =A0 =A0 =A0* in user space in vgetcpu. (12 bits for the CPU and 8 b=
its for the node)
> + =A0 =A0 =A0 =A0*/
> =A0 =A0 =A0 =A0d =3D 0x0f40000000000ULL;
> =A0 =A0 =A0 =A0d |=3D cpu;
> =A0 =A0 =A0 =A0d |=3D (node & 0xf) << 12;
> =A0 =A0 =A0 =A0d |=3D (node >> 4) << 48;
> +
> =A0 =A0 =A0 =A0write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU,=
 &d, DESCTYPE_S);
> =A0}
>
> @@ -275,8 +247,10 @@ static int __cpuinit
> =A0cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, =
void *arg)
> =A0{
> =A0 =A0 =A0 =A0long cpu =3D (long)arg;
> +
> =A0 =A0 =A0 =A0if (action =3D=3D CPU_ONLINE || action =3D=3D CPU_ONLINE_F=
ROZEN)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smp_call_function_single(cpu, cpu_vsyscall=
_init, NULL, 1);
> +
> =A0 =A0 =A0 =A0return NOTIFY_DONE;
> =A0}
>
> @@ -284,25 +258,23 @@ void __init map_vsyscall(void)
> =A0{
> =A0 =A0 =A0 =A0extern char __vsyscall_0;
> =A0 =A0 =A0 =A0unsigned long physaddr_page0 =3D __pa_symbol(&__vsyscall_0=
);
> + =A0 =A0 =A0 extern char __vvar_page;
> + =A0 =A0 =A0 unsigned long physaddr_vvar_page =3D __pa_symbol(&__vvar_pa=
ge);
>
> =A0 =A0 =A0 =A0/* Note that VSYSCALL_MAPPED_PAGES must agree with the cod=
e below. */
> =A0 =A0 =A0 =A0__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KER=
NEL_VSYSCALL);
> + =A0 =A0 =A0 __set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVA=
R);
> + =A0 =A0 =A0 BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=3D (=
unsigned long)VVAR_ADDRESS);
> =A0}
>
> =A0static int __init vsyscall_init(void)
> =A0{
> - =A0 =A0 =A0 BUG_ON(((unsigned long) &vgettimeofday !=3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 VSYSCALL_ADDR(__NR_vgettime=
ofday)));
> - =A0 =A0 =A0 BUG_ON((unsigned long) &vtime !=3D VSYSCALL_ADDR(__NR_vtime=
));
> - =A0 =A0 =A0 BUG_ON((VSYSCALL_ADDR(0) !=3D __fix_to_virt(VSYSCALL_FIRST_=
PAGE)));
> - =A0 =A0 =A0 BUG_ON((unsigned long) &vgetcpu !=3D VSYSCALL_ADDR(__NR_vge=
tcpu));
> -#ifdef CONFIG_SYSCTL
> - =A0 =A0 =A0 register_sysctl_table(kernel_root_table2);
> -#endif
> + =A0 =A0 =A0 BUG_ON(VSYSCALL_ADDR(0) !=3D __fix_to_virt(VSYSCALL_FIRST_P=
AGE));
> +
> =A0 =A0 =A0 =A0on_each_cpu(cpu_vsyscall_init, NULL, 1);
> =A0 =A0 =A0 =A0/* notifier priority > KVM */
> =A0 =A0 =A0 =A0hotcpu_notifier(cpu_vsyscall_notifier, 30);
> +
> =A0 =A0 =A0 =A0return 0;
> =A0}
> -
> =A0__initcall(vsyscall_init);
> diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall=
_emu_64.S
> new file mode 100644
> index 0000000..ffa845e
> --- /dev/null
> +++ b/arch/x86/kernel/vsyscall_emu_64.S
> @@ -0,0 +1,27 @@
> +/*
> + * vsyscall_emu_64.S: Vsyscall emulation page
> + *
> + * Copyright (c) 2011 Andy Lutomirski
> + *
> + * Subject to the GNU General Public License, version 2
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/irq_vectors.h>
> +
> +/* The unused parts of the page are filled with 0xcc by the linker scrip=
t. */
> +
> +.section .vsyscall_0, "a"
> +ENTRY(vsyscall_0)
> + =A0 =A0 =A0 int $VSYSCALL_EMU_VECTOR
> +END(vsyscall_0)
> +
> +.section .vsyscall_1, "a"
> +ENTRY(vsyscall_1)
> + =A0 =A0 =A0 int $VSYSCALL_EMU_VECTOR
> +END(vsyscall_1)
> +
> +.section .vsyscall_2, "a"
> +ENTRY(vsyscall_2)
> + =A0 =A0 =A0 int $VSYSCALL_EMU_VECTOR
> +END(vsyscall_2)
> diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
> index 6fec2d1..01c805b 100644
> --- a/arch/x86/lib/copy_page_64.S
> +++ b/arch/x86/lib/copy_page_64.S
> @@ -2,6 +2,7 @@
>
> =A0#include <linux/linkage.h>
> =A0#include <asm/dwarf2.h>
> +#include <asm/alternative-asm.h>
>
> =A0 =A0 =A0 =A0ALIGN
> =A0copy_page_c:
> @@ -110,10 +111,6 @@ ENDPROC(copy_page)
> =A02:
> =A0 =A0 =A0 =A0.previous
> =A0 =A0 =A0 =A0.section .altinstructions,"a"
> - =A0 =A0 =A0 .align 8
> - =A0 =A0 =A0 .quad copy_page
> - =A0 =A0 =A0 .quad 1b
> - =A0 =A0 =A0 .word X86_FEATURE_REP_GOOD
> - =A0 =A0 =A0 .byte .Lcopy_page_end - copy_page
> - =A0 =A0 =A0 .byte 2b - 1b
> + =A0 =A0 =A0 altinstruction_entry copy_page, 1b, X86_FEATURE_REP_GOOD, =
=A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .Lcopy_page_end-copy_page, 2b-1b
> =A0 =A0 =A0 =A0.previous
> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> index d0ec9c2..ee16461 100644
> --- a/arch/x86/lib/memmove_64.S
> +++ b/arch/x86/lib/memmove_64.S
> @@ -9,6 +9,7 @@
> =A0#include <linux/linkage.h>
> =A0#include <asm/dwarf2.h>
> =A0#include <asm/cpufeature.h>
> +#include <asm/alternative-asm.h>
>
> =A0#undef memmove
>
> @@ -214,11 +215,9 @@ ENTRY(memmove)
> =A0 =A0 =A0 =A0.previous
>
> =A0 =A0 =A0 =A0.section .altinstructions,"a"
> - =A0 =A0 =A0 .align 8
> - =A0 =A0 =A0 .quad .Lmemmove_begin_forward
> - =A0 =A0 =A0 .quad .Lmemmove_begin_forward_efs
> - =A0 =A0 =A0 .word X86_FEATURE_ERMS
> - =A0 =A0 =A0 .byte .Lmemmove_end_forward-.Lmemmove_begin_forward
> - =A0 =A0 =A0 .byte .Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
> + =A0 =A0 =A0 altinstruction_entry .Lmemmove_begin_forward, =A0 =A0 =A0 =
=A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .Lmemmove_begin_forward_efs,X86_FEATURE_ERM=
S, =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .Lmemmove_end_forward-.Lmemmove_begin_forwa=
rd, =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .Lmemmove_end_forward_efs-.Lmemmove_begin_f=
orward_efs
> =A0 =A0 =A0 =A0.previous
> =A0ENDPROC(memmove)
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index bef0bc9..5d17950 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -26,6 +26,7 @@ targets +=3D vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
> =A0export CPPFLAGS_vdso.lds +=3D -P -C
>
> =A0VDSO_LDFLAGS_vdso.lds =3D -m64 -Wl,-soname=3Dlinux-vdso.so.1 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -Wl,--no-undefined \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-Wl,-z,max-page-size=3D409=
6 -Wl,-z,common-page-size=3D4096
>
> =A0$(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettim=
e.c
> index a724905..6bc0e72 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -6,7 +6,6 @@
> =A0*
> =A0* The code should have no internal unresolved relocations.
> =A0* Check with readelf after changing.
> - * Also alternative() doesn't work.
> =A0*/
>
> =A0/* Disable profiling for userspace code: */
> @@ -17,6 +16,7 @@
> =A0#include <linux/time.h>
> =A0#include <linux/string.h>
> =A0#include <asm/vsyscall.h>
> +#include <asm/fixmap.h>
> =A0#include <asm/vgtod.h>
> =A0#include <asm/timex.h>
> =A0#include <asm/hpet.h>
> @@ -25,6 +25,43 @@
>
> =A0#define gtod (&VVAR(vsyscall_gtod_data))
>
> +notrace static cycle_t vread_tsc(void)
> +{
> + =A0 =A0 =A0 cycle_t ret;
> + =A0 =A0 =A0 u64 last;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Empirically, a fence (of type that depends on the CPU)
> + =A0 =A0 =A0 =A0* before rdtsc is enough to ensure that rdtsc is ordered
> + =A0 =A0 =A0 =A0* with respect to loads. =A0The various CPU manuals are =
unclear
> + =A0 =A0 =A0 =A0* as to whether rdtsc can be reordered with later loads,
> + =A0 =A0 =A0 =A0* but no one has ever seen it happen.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 rdtsc_barrier();
> + =A0 =A0 =A0 ret =3D (cycle_t)vget_cycles();
> +
> + =A0 =A0 =A0 last =3D VVAR(vsyscall_gtod_data).clock.cycle_last;
> +
> + =A0 =A0 =A0 if (likely(ret >=3D last))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* GCC likes to generate cmov here, but this branch is ex=
tremely
> + =A0 =A0 =A0 =A0* predictable (it's just a funciton of time and the like=
ly is
> + =A0 =A0 =A0 =A0* very likely) and there's a data dependence, so force G=
CC
> + =A0 =A0 =A0 =A0* to generate a branch instead. =A0I don't barrier() bec=
ause
> + =A0 =A0 =A0 =A0* we don't actually need a barrier, and if this function
> + =A0 =A0 =A0 =A0* ever gets inlined it will generate worse code.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 asm volatile ("");
> + =A0 =A0 =A0 return last;
> +}
> +
> +static notrace cycle_t vread_hpet(void)
> +{
> + =A0 =A0 =A0 return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPE=
T) + 0xf0);
> +}
> +
> =A0notrace static long vdso_fallback_gettime(long clock, struct timespec =
*ts)
> =A0{
> =A0 =A0 =A0 =A0long ret;
> @@ -36,9 +73,12 @@ notrace static long vdso_fallback_gettime(long clock, =
struct timespec *ts)
> =A0notrace static inline long vgetns(void)
> =A0{
> =A0 =A0 =A0 =A0long v;
> - =A0 =A0 =A0 cycles_t (*vread)(void);
> - =A0 =A0 =A0 vread =3D gtod->clock.vread;
> - =A0 =A0 =A0 v =3D (vread() - gtod->clock.cycle_last) & gtod->clock.mask=
;
> + =A0 =A0 =A0 cycles_t cycles;
> + =A0 =A0 =A0 if (gtod->clock.vclock_mode =3D=3D VCLOCK_TSC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cycles =3D vread_tsc();
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cycles =3D vread_hpet();
> + =A0 =A0 =A0 v =3D (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
> =A0 =A0 =A0 =A0return (v * gtod->clock.mult) >> gtod->clock.shift;
> =A0}
>
> @@ -116,21 +156,21 @@ notrace static noinline int do_monotonic_coarse(str=
uct timespec *ts)
>
> =A0notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
> =A0{
> - =A0 =A0 =A0 if (likely(gtod->sysctl_enabled))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (clock) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CLOCK_REALTIME:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(gtod->clock.vrea=
d))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_r=
ealtime(ts);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CLOCK_MONOTONIC:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(gtod->clock.vrea=
d))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_m=
onotonic(ts);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CLOCK_REALTIME_COARSE:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_realtime_coarse(t=
s);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CLOCK_MONOTONIC_COARSE:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_monotonic_coarse(=
ts);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 switch (clock) {
> + =A0 =A0 =A0 case CLOCK_REALTIME:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(gtod->clock.vclock_mode !=3D VCL=
OCK_NONE))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_realtime(ts);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case CLOCK_MONOTONIC:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(gtod->clock.vclock_mode !=3D VCL=
OCK_NONE))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_monotonic(ts);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case CLOCK_REALTIME_COARSE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_realtime_coarse(ts);
> + =A0 =A0 =A0 case CLOCK_MONOTONIC_COARSE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_monotonic_coarse(ts);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0return vdso_fallback_gettime(clock, ts);
> =A0}
> =A0int clock_gettime(clockid_t, struct timespec *)
> @@ -139,7 +179,7 @@ int clock_gettime(clockid_t, struct timespec *)
> =A0notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *t=
z)
> =A0{
> =A0 =A0 =A0 =A0long ret;
> - =A0 =A0 =A0 if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
> + =A0 =A0 =A0 if (likely(gtod->clock.vclock_mode !=3D VCLOCK_NONE)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (likely(tv !=3D NULL)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUILD_BUG_ON(offsetof(stru=
ct timeval, tv_usec) !=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 o=
ffsetof(struct timespec, tv_nsec) ||
> @@ -161,27 +201,14 @@ notrace int __vdso_gettimeofday(struct timeval *tv,=
 struct timezone *tz)
> =A0int gettimeofday(struct timeval *, struct timezone *)
> =A0 =A0 =A0 =A0__attribute__((weak, alias("__vdso_gettimeofday")));
>
> -/* This will break when the xtime seconds get inaccurate, but that is
> - * unlikely */
> -
> -static __always_inline long time_syscall(long *t)
> -{
> - =A0 =A0 =A0 long secs;
> - =A0 =A0 =A0 asm volatile("syscall"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0: "=3Da" (secs)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0: "0" (__NR_time), "D" (t) : "cc=
", "r11", "cx", "memory");
> - =A0 =A0 =A0 return secs;
> -}
> -
> +/*
> + * This will break when the xtime seconds get inaccurate, but that is
> + * unlikely
> + */
> =A0notrace time_t __vdso_time(time_t *t)
> =A0{
> - =A0 =A0 =A0 time_t result;
> -
> - =A0 =A0 =A0 if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return time_syscall(t);
> -
> =A0 =A0 =A0 =A0/* This is atomic on x86_64 so we don't need any locks. */
> - =A0 =A0 =A0 result =3D ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_s=
ec);
> + =A0 =A0 =A0 time_t result =3D ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall=
_time_sec);
>
> =A0 =A0 =A0 =A0if (t)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*t =3D result;
> diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
> index 1d3aa6b..1b979c1 100644
> --- a/arch/x86/vdso/vdso.S
> +++ b/arch/x86/vdso/vdso.S
> @@ -1,10 +1,21 @@
> +#include <asm/page_types.h>
> +#include <linux/linkage.h>
> =A0#include <linux/init.h>
>
> -__INITDATA
> +__PAGE_ALIGNED_DATA
>
> =A0 =A0 =A0 =A0.globl vdso_start, vdso_end
> + =A0 =A0 =A0 .align PAGE_SIZE
> =A0vdso_start:
> =A0 =A0 =A0 =A0.incbin "arch/x86/vdso/vdso.so"
> =A0vdso_end:
>
> -__FINIT
> +.previous
> +
> + =A0 =A0 =A0 .globl vdso_pages
> + =A0 =A0 =A0 .bss
> + =A0 =A0 =A0 .align 8
> + =A0 =A0 =A0 .type vdso_pages, @object
> +vdso_pages:
> + =A0 =A0 =A0 .zero (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE *=
 8
> + =A0 =A0 =A0 .size vdso_pages, .-vdso_pages
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 7abd2be..316fbca 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -14,41 +14,61 @@
> =A0#include <asm/vgtod.h>
> =A0#include <asm/proto.h>
> =A0#include <asm/vdso.h>
> +#include <asm/page.h>
>
> =A0unsigned int __read_mostly vdso_enabled =3D 1;
>
> =A0extern char vdso_start[], vdso_end[];
> =A0extern unsigned short vdso_sync_cpuid;
>
> -static struct page **vdso_pages;
> +extern struct page *vdso_pages[];
> =A0static unsigned vdso_size;
>
> -static int __init init_vdso_vars(void)
> +static void __init patch_vdso(void *vdso, size_t len)
> +{
> + =A0 =A0 =A0 Elf64_Ehdr *hdr =3D vdso;
> + =A0 =A0 =A0 Elf64_Shdr *sechdrs, *alt_sec =3D 0;
> + =A0 =A0 =A0 char *secstrings;
> + =A0 =A0 =A0 void *alt_data;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 BUG_ON(len < sizeof(Elf64_Ehdr));
> + =A0 =A0 =A0 BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) !=3D 0);
> +
> + =A0 =A0 =A0 sechdrs =3D (void *)hdr + hdr->e_shoff;
> + =A0 =A0 =A0 secstrings =3D (void *)hdr + sechdrs[hdr->e_shstrndx].sh_of=
fset;
> +
> + =A0 =A0 =A0 for (i =3D 1; i < hdr->e_shnum; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Elf64_Shdr *shdr =3D &sechdrs[i];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strcmp(secstrings + shdr->sh_name, ".a=
ltinstructions")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 alt_sec =3D shdr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto found;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* If we get here, it's probably a bug. */
> + =A0 =A0 =A0 pr_warning("patch_vdso: .altinstructions not found\n");
> + =A0 =A0 =A0 return; =A0/* nothing to patch */
> +
> +found:
> + =A0 =A0 =A0 alt_data =3D (void *)hdr + alt_sec->sh_offset;
> + =A0 =A0 =A0 apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
> +}
> +
> +static int __init init_vdso(void)
> =A0{
> =A0 =A0 =A0 =A0int npages =3D (vdso_end - vdso_start + PAGE_SIZE - 1) / P=
AGE_SIZE;
> =A0 =A0 =A0 =A0int i;
>
> + =A0 =A0 =A0 patch_vdso(vdso_start, vdso_end - vdso_start);
> +
> =A0 =A0 =A0 =A0vdso_size =3D npages << PAGE_SHIFT;
> - =A0 =A0 =A0 vdso_pages =3D kmalloc(sizeof(struct page *) * npages, GFP_=
KERNEL);
> - =A0 =A0 =A0 if (!vdso_pages)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto oom;
> - =A0 =A0 =A0 for (i =3D 0; i < npages; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *p;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D alloc_page(GFP_KERNEL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!p)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto oom;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_pages[i] =3D p;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 copy_page(page_address(p), vdso_start + i*P=
AGE_SIZE);
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 for (i =3D 0; i < npages; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdso_pages[i] =3D virt_to_page(vdso_start +=
 i*PAGE_SIZE);
>
> =A0 =A0 =A0 =A0return 0;
> -
> - oom:
> - =A0 =A0 =A0 printk("Cannot allocate vdso\n");
> - =A0 =A0 =A0 vdso_enabled =3D 0;
> - =A0 =A0 =A0 return -ENOMEM;
> =A0}
> -subsys_initcall(init_vdso_vars);
> +subsys_initcall(init_vdso);
>
> =A0struct linux_binprm;
>
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 051474c..0557651 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -931,7 +931,7 @@ int hpet_alloc(struct hpet_data *hdp)
> =A0#ifdef CONFIG_IA64
> =A0 =A0 =A0 =A0if (!hpet_clocksource) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hpet_mctr =3D (void __iomem *)&hpetp->hp_h=
pet->hpet_mc;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_=
mmio, hpet_mctr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clocksource_hpet.archdata.fsys_mmio =3D hpe=
t_mctr;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clocksource_register_hz(&clocksource_hpet,=
 hpetp->hp_tick_freq);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hpetp->hp_clocksource =3D &clocksource_hpe=
t;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hpet_clocksource =3D &clocksource_hpet;
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index d4646b4..59ee970 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -22,6 +22,10 @@
> =A0typedef u64 cycle_t;
> =A0struct clocksource;
>
> +#ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
> +#include <asm/clocksource.h>
> +#endif
> +
> =A0/**
> =A0* struct cyclecounter - hardware abstraction for a free running counte=
r
> =A0* =A0 =A0 Provides completely state-free accessors to the underlying h=
ardware.
> @@ -153,7 +157,7 @@ extern u64 timecounter_cyc2time(struct timecounter *t=
c,
> =A0* @shift: =A0 =A0 =A0 =A0 =A0 =A0 cycle to nanosecond divisor (power o=
f two)
> =A0* @max_idle_ns: =A0 =A0 =A0 max idle time permitted by the clocksource=
 (nsecs)
> =A0* @flags: =A0 =A0 =A0 =A0 =A0 =A0 flags describing special properties
> - * @vread: =A0 =A0 =A0 =A0 =A0 =A0 vsyscall based read
> + * @archdata: =A0 =A0 =A0 =A0 =A0arch-specific data
> =A0* @suspend: =A0 =A0 =A0 =A0 =A0 suspend function for the clocksource, =
if necessary
> =A0* @resume: =A0 =A0 =A0 =A0 =A0 =A0resume function for the clocksource,=
 if necessary
> =A0*/
> @@ -169,16 +173,13 @@ struct clocksource {
> =A0 =A0 =A0 =A0u32 shift;
> =A0 =A0 =A0 =A0u64 max_idle_ns;
>
> -#ifdef CONFIG_IA64
> - =A0 =A0 =A0 void *fsys_mmio; =A0 =A0 =A0 =A0/* used by fsyscall asm cod=
e */
> -#define CLKSRC_FSYS_MMIO_SET(mmio, addr) =A0 =A0 =A0((mmio) =3D (addr))
> -#else
> -#define CLKSRC_FSYS_MMIO_SET(mmio, addr) =A0 =A0 =A0do { } while (0)
> +#ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
> + =A0 =A0 =A0 struct arch_clocksource_data archdata;
> =A0#endif
> +
> =A0 =A0 =A0 =A0const char *name;
> =A0 =A0 =A0 =A0struct list_head list;
> =A0 =A0 =A0 =A0int rating;
> - =A0 =A0 =A0 cycle_t (*vread)(void);
> =A0 =A0 =A0 =A0int (*enable)(struct clocksource *cs);
> =A0 =A0 =A0 =A0void (*disable)(struct clocksource *cs);
> =A0 =A0 =A0 =A0unsigned long flags;
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index 167c333..cc7a4e9 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -19,6 +19,11 @@ static inline void secure_computing(int this_syscall)
> =A0extern long prctl_get_seccomp(void);
> =A0extern long prctl_set_seccomp(unsigned long);
>
> +static inline int seccomp_mode(seccomp_t *s)
> +{
> + =A0 =A0 =A0 return s->mode;
> +}
> +
> =A0#else /* CONFIG_SECCOMP */
>
> =A0#include <linux/errno.h>
> @@ -37,6 +42,11 @@ static inline long prctl_set_seccomp(unsigned long arg=
2)
> =A0 =A0 =A0 =A0return -EINVAL;
> =A0}
>
> +static inline int seccomp_mode(seccomp_t *s)
> +{
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0#endif /* CONFIG_SECCOMP */
>
> =A0#endif /* _LINUX_SECCOMP_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>

--000e0cd2e1f4a3cd7d04ab4e1fdb
Content-Type: application/octet-stream; name=".config"
Content-Disposition: attachment; filename=".config"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grrbnm4w0

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4L2kz
ODYgMy4xLjAtcmMyIEtlcm5lbCBDb25maWd1cmF0aW9uCiMKIyBDT05GSUdfNjRCSVQgaXMgbm90
IHNldApDT05GSUdfWDg2XzMyPXkKIyBDT05GSUdfWDg2XzY0IGlzIG5vdCBzZXQKQ09ORklHX1g4
Nj15CkNPTkZJR19JTlNUUlVDVElPTl9ERUNPREVSPXkKQ09ORklHX09VVFBVVF9GT1JNQVQ9ImVs
ZjMyLWkzODYiCkNPTkZJR19BUkNIX0RFRkNPTkZJRz0iYXJjaC94ODYvY29uZmlncy9pMzg2X2Rl
ZmNvbmZpZyIKQ09ORklHX0dFTkVSSUNfQ01PU19VUERBVEU9eQpDT05GSUdfQ0xPQ0tTT1VSQ0Vf
V0FUQ0hET0c9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNPTkZJR19HRU5FUklDX0NM
T0NLRVZFTlRTX0JST0FEQ0FTVD15CkNPTkZJR19MT0NLREVQX1NVUFBPUlQ9eQpDT05GSUdfU1RB
Q0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfTEFURU5DWVRPUF9TVVBQT1JUPXkKQ09ORklH
X01NVT15CkNPTkZJR19aT05FX0RNQT15CiMgQ09ORklHX05FRURfRE1BX01BUF9TVEFURSBpcyBu
b3Qgc2V0CkNPTkZJR19ORUVEX1NHX0RNQV9MRU5HVEg9eQpDT05GSUdfR0VORVJJQ19JU0FfRE1B
PXkKQ09ORklHX0dFTkVSSUNfSU9NQVA9eQpDT05GSUdfR0VORVJJQ19CVUc9eQpDT05GSUdfR0VO
RVJJQ19IV0VJR0hUPXkKQ09ORklHX0FSQ0hfTUFZX0hBVkVfUENfRkRDPXkKIyBDT05GSUdfUldT
RU1fR0VORVJJQ19TUElOTE9DSyBpcyBub3Qgc2V0CkNPTkZJR19SV1NFTV9YQ0hHQUREX0FMR09S
SVRITT15CkNPTkZJR19BUkNIX0hBU19DUFVfSURMRV9XQUlUPXkKQ09ORklHX0dFTkVSSUNfQ0FM
SUJSQVRFX0RFTEFZPXkKIyBDT05GSUdfR0VORVJJQ19USU1FX1ZTWVNDQUxMIGlzIG5vdCBzZXQK
Q09ORklHX0FSQ0hfSEFTX0NQVV9SRUxBWD15CkNPTkZJR19BUkNIX0hBU19ERUZBVUxUX0lETEU9
eQpDT05GSUdfQVJDSF9IQVNfQ0FDSEVfTElORV9TSVpFPXkKQ09ORklHX0hBVkVfU0VUVVBfUEVS
X0NQVV9BUkVBPXkKQ09ORklHX05FRURfUEVSX0NQVV9FTUJFRF9GSVJTVF9DSFVOSz15CkNPTkZJ
R19ORUVEX1BFUl9DUFVfUEFHRV9GSVJTVF9DSFVOSz15CiMgQ09ORklHX0hBVkVfQ1BVTUFTS19P
Rl9DUFVfTUFQIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSElCRVJOQVRJT05fUE9TU0lCTEU9eQpD
T05GSUdfQVJDSF9TVVNQRU5EX1BPU1NJQkxFPXkKIyBDT05GSUdfWk9ORV9ETUEzMiBpcyBub3Qg
c2V0CkNPTkZJR19BUkNIX1BPUFVMQVRFU19OT0RFX01BUD15CiMgQ09ORklHX0FVRElUX0FSQ0gg
aXMgbm90IHNldApDT05GSUdfQVJDSF9TVVBQT1JUU19PUFRJTUlaRURfSU5MSU5JTkc9eQpDT05G
SUdfQVJDSF9TVVBQT1JUU19ERUJVR19QQUdFQUxMT0M9eQpDT05GSUdfWDg2XzMyX1NNUD15CkNP
TkZJR19YODZfSFQ9eQpDT05GSUdfWDg2XzMyX0xBWllfR1M9eQpDT05GSUdfQVJDSF9IV0VJR0hU
X0NGTEFHUz0iLWZjYWxsLXNhdmVkLWVjeCAtZmNhbGwtc2F2ZWQtZWR4IgpDT05GSUdfS1RJTUVf
U0NBTEFSPXkKQ09ORklHX0FSQ0hfQ1BVX1BST0JFX1JFTEVBU0U9eQpDT05GSUdfREVGQ09ORklH
X0xJU1Q9Ii9saWIvbW9kdWxlcy8kVU5BTUVfUkVMRUFTRS8uY29uZmlnIgpDT05GSUdfSEFWRV9J
UlFfV09SSz15CkNPTkZJR19JUlFfV09SSz15CgojCiMgR2VuZXJhbCBzZXR1cAojCkNPTkZJR19F
WFBFUklNRU5UQUw9eQpDT05GSUdfSU5JVF9FTlZfQVJHX0xJTUlUPTMyCkNPTkZJR19DUk9TU19D
T01QSUxFPSIiCkNPTkZJR19MT0NBTFZFUlNJT049IiIKIyBDT05GSUdfTE9DQUxWRVJTSU9OX0FV
VE8gaXMgbm90IHNldApDT05GSUdfSEFWRV9LRVJORUxfR1pJUD15CkNPTkZJR19IQVZFX0tFUk5F
TF9CWklQMj15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk1BPXkKQ09ORklHX0hBVkVfS0VSTkVMX1ha
PXkKQ09ORklHX0hBVkVfS0VSTkVMX0xaTz15CkNPTkZJR19LRVJORUxfR1pJUD15CiMgQ09ORklH
X0tFUk5FTF9CWklQMiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9MWk1BIGlzIG5vdCBzZXQK
IyBDT05GSUdfS0VSTkVMX1haIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VSTkVMX0xaTyBpcyBub3Qg
c2V0CkNPTkZJR19ERUZBVUxUX0hPU1ROQU1FPSIobm9uZSkiCkNPTkZJR19TV0FQPXkKQ09ORklH
X1NZU1ZJUEM9eQpDT05GSUdfU1lTVklQQ19TWVNDVEw9eQpDT05GSUdfUE9TSVhfTVFVRVVFPXkK
Q09ORklHX1BPU0lYX01RVUVVRV9TWVNDVEw9eQpDT05GSUdfQlNEX1BST0NFU1NfQUNDVD15CiMg
Q09ORklHX0JTRF9QUk9DRVNTX0FDQ1RfVjMgaXMgbm90IHNldAojIENPTkZJR19GSEFORExFIGlz
IG5vdCBzZXQKQ09ORklHX1RBU0tTVEFUUz15CkNPTkZJR19UQVNLX0RFTEFZX0FDQ1Q9eQpDT05G
SUdfVEFTS19YQUNDVD15CkNPTkZJR19UQVNLX0lPX0FDQ09VTlRJTkc9eQpDT05GSUdfQVVESVQ9
eQpDT05GSUdfQVVESVRTWVNDQUxMPXkKQ09ORklHX0FVRElUX1dBVENIPXkKQ09ORklHX0FVRElU
X1RSRUU9eQpDT05GSUdfSEFWRV9HRU5FUklDX0hBUkRJUlFTPXkKCiMKIyBJUlEgc3Vic3lzdGVt
CiMKQ09ORklHX0dFTkVSSUNfSEFSRElSUVM9eQpDT05GSUdfSEFWRV9TUEFSU0VfSVJRPXkKQ09O
RklHX0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX0dFTkVSSUNfSVJRX1NIT1c9eQpDT05GSUdf
R0VORVJJQ19QRU5ESU5HX0lSUT15CkNPTkZJR19JUlFfRk9SQ0VEX1RIUkVBRElORz15CkNPTkZJ
R19TUEFSU0VfSVJRPXkKCiMKIyBSQ1UgU3Vic3lzdGVtCiMKQ09ORklHX1RSRUVfUkNVPXkKIyBD
T05GSUdfUFJFRU1QVF9SQ1UgaXMgbm90IHNldAojIENPTkZJR19SQ1VfVFJBQ0UgaXMgbm90IHNl
dApDT05GSUdfUkNVX0ZBTk9VVD0zMgojIENPTkZJR19SQ1VfRkFOT1VUX0VYQUNUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkNVX0ZBU1RfTk9fSFogaXMgbm90IHNldAojIENPTkZJR19UUkVFX1JDVV9U
UkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lLQ09ORklHIGlzIG5vdCBzZXQKQ09ORklHX0xPR19C
VUZfU0hJRlQ9MTgKQ09ORklHX0hBVkVfVU5TVEFCTEVfU0NIRURfQ0xPQ0s9eQpDT05GSUdfQ0dS
T1VQUz15CiMgQ09ORklHX0NHUk9VUF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19DR1JPVVBfRlJF
RVpFUj15CiMgQ09ORklHX0NHUk9VUF9ERVZJQ0UgaXMgbm90IHNldApDT05GSUdfQ1BVU0VUUz15
CkNPTkZJR19QUk9DX1BJRF9DUFVTRVQ9eQpDT05GSUdfQ0dST1VQX0NQVUFDQ1Q9eQpDT05GSUdf
UkVTT1VSQ0VfQ09VTlRFUlM9eQojIENPTkZJR19DR1JPVVBfTUVNX1JFU19DVExSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ0dST1VQX1BFUkYgaXMgbm90IHNldApDT05GSUdfQ0dST1VQX1NDSEVEPXkK
Q09ORklHX0ZBSVJfR1JPVVBfU0NIRUQ9eQojIENPTkZJR19SVF9HUk9VUF9TQ0hFRCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JMS19DR1JPVVAgaXMgbm90IHNldApDT05GSUdfTkFNRVNQQUNFUz15CkNP
TkZJR19VVFNfTlM9eQpDT05GSUdfSVBDX05TPXkKQ09ORklHX1VTRVJfTlM9eQpDT05GSUdfUElE
X05TPXkKQ09ORklHX05FVF9OUz15CiMgQ09ORklHX1NDSEVEX0FVVE9HUk9VUCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NZU0ZTX0RFUFJFQ0FURUQgaXMgbm90IHNldApDT05GSUdfUkVMQVk9eQpDT05G
SUdfQkxLX0RFVl9JTklUUkQ9eQpDT05GSUdfSU5JVFJBTUZTX1NPVVJDRT0iIgpDT05GSUdfUkRf
R1pJUD15CkNPTkZJR19SRF9CWklQMj15CkNPTkZJR19SRF9MWk1BPXkKQ09ORklHX1JEX1haPXkK
Q09ORklHX1JEX0xaTz15CiMgQ09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFIGlzIG5vdCBzZXQK
Q09ORklHX1NZU0NUTD15CkNPTkZJR19BTk9OX0lOT0RFUz15CiMgQ09ORklHX0VYUEVSVCBpcyBu
b3Qgc2V0CkNPTkZJR19VSUQxNj15CkNPTkZJR19TWVNDVExfU1lTQ0FMTD15CkNPTkZJR19LQUxM
U1lNUz15CiMgQ09ORklHX0tBTExTWU1TX0FMTCBpcyBub3Qgc2V0CkNPTkZJR19IT1RQTFVHPXkK
Q09ORklHX1BSSU5USz15CkNPTkZJR19CVUc9eQpDT05GSUdfRUxGX0NPUkU9eQpDT05GSUdfUENT
UEtSX1BMQVRGT1JNPXkKQ09ORklHX0hBVkVfUENTUEtSX1BMQVRGT1JNPXkKQ09ORklHX0JBU0Vf
RlVMTD15CkNPTkZJR19GVVRFWD15CkNPTkZJR19FUE9MTD15CkNPTkZJR19TSUdOQUxGRD15CkNP
TkZJR19USU1FUkZEPXkKQ09ORklHX0VWRU5URkQ9eQpDT05GSUdfU0hNRU09eQpDT05GSUdfQUlP
PXkKIyBDT05GSUdfRU1CRURERUQgaXMgbm90IHNldApDT05GSUdfSEFWRV9QRVJGX0VWRU5UUz15
CgojCiMgS2VybmVsIFBlcmZvcm1hbmNlIEV2ZW50cyBBbmQgQ291bnRlcnMKIwpDT05GSUdfUEVS
Rl9FVkVOVFM9eQojIENPTkZJR19QRVJGX0NPVU5URVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfUEVSRl9VU0VfVk1BTExPQyBpcyBub3Qgc2V0CkNPTkZJR19WTV9FVkVOVF9DT1VOVEVSUz15
CkNPTkZJR19QQ0lfUVVJUktTPXkKQ09ORklHX1NMVUJfREVCVUc9eQojIENPTkZJR19DT01QQVRf
QlJLIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xBQiBpcyBub3Qgc2V0CkNPTkZJR19TTFVCPXkKQ09O
RklHX1BST0ZJTElORz15CkNPTkZJR19UUkFDRVBPSU5UUz15CiMgQ09ORklHX09QUk9GSUxFIGlz
IG5vdCBzZXQKQ09ORklHX0hBVkVfT1BST0ZJTEU9eQpDT05GSUdfS1BST0JFUz15CiMgQ09ORklH
X0pVTVBfTEFCRUwgaXMgbm90IHNldApDT05GSUdfT1BUUFJPQkVTPXkKQ09ORklHX0hBVkVfRUZG
SUNJRU5UX1VOQUxJR05FRF9BQ0NFU1M9eQpDT05GSUdfS1JFVFBST0JFUz15CkNPTkZJR19IQVZF
X0lPUkVNQVBfUFJPVD15CkNPTkZJR19IQVZFX0tQUk9CRVM9eQpDT05GSUdfSEFWRV9LUkVUUFJP
QkVTPXkKQ09ORklHX0hBVkVfT1BUUFJPQkVTPXkKQ09ORklHX0hBVkVfQVJDSF9UUkFDRUhPT0s9
eQpDT05GSUdfSEFWRV9ETUFfQVRUUlM9eQpDT05GSUdfVVNFX0dFTkVSSUNfU01QX0hFTFBFUlM9
eQpDT05GSUdfSEFWRV9SRUdTX0FORF9TVEFDS19BQ0NFU1NfQVBJPXkKQ09ORklHX0hBVkVfRE1B
X0FQSV9ERUJVRz15CkNPTkZJR19IQVZFX0hXX0JSRUFLUE9JTlQ9eQpDT05GSUdfSEFWRV9NSVhF
RF9CUkVBS1BPSU5UU19SRUdTPXkKQ09ORklHX0hBVkVfVVNFUl9SRVRVUk5fTk9USUZJRVI9eQpD
T05GSUdfSEFWRV9QRVJGX0VWRU5UU19OTUk9eQpDT05GSUdfSEFWRV9BUkNIX0pVTVBfTEFCRUw9
eQpDT05GSUdfQVJDSF9IQVZFX05NSV9TQUZFX0NNUFhDSEc9eQoKIwojIEdDT1YtYmFzZWQga2Vy
bmVsIHByb2ZpbGluZwojCiMgQ09ORklHX0dDT1ZfS0VSTkVMIGlzIG5vdCBzZXQKQ09ORklHX0hB
VkVfR0VORVJJQ19ETUFfQ09IRVJFTlQ9eQpDT05GSUdfU0xBQklORk89eQpDT05GSUdfUlRfTVVU
RVhFUz15CkNPTkZJR19CQVNFX1NNQUxMPTAKQ09ORklHX01PRFVMRVM9eQojIENPTkZJR19NT0RV
TEVfRk9SQ0VfTE9BRCBpcyBub3Qgc2V0CkNPTkZJR19NT0RVTEVfVU5MT0FEPXkKQ09ORklHX01P
RFVMRV9GT1JDRV9VTkxPQUQ9eQojIENPTkZJR19NT0RWRVJTSU9OUyBpcyBub3Qgc2V0CiMgQ09O
RklHX01PRFVMRV9TUkNWRVJTSU9OX0FMTCBpcyBub3Qgc2V0CkNPTkZJR19TVE9QX01BQ0hJTkU9
eQpDT05GSUdfQkxPQ0s9eQpDT05GSUdfTEJEQUY9eQpDT05GSUdfQkxLX0RFVl9CU0c9eQojIENP
TkZJR19CTEtfREVWX0JTR0xJQiBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSU5URUdSSVRZ
IGlzIG5vdCBzZXQKCiMKIyBJTyBTY2hlZHVsZXJzCiMKQ09ORklHX0lPU0NIRURfTk9PUD15CkNP
TkZJR19JT1NDSEVEX0RFQURMSU5FPXkKQ09ORklHX0lPU0NIRURfQ0ZRPXkKIyBDT05GSUdfREVG
QVVMVF9ERUFETElORSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0NGUT15CiMgQ09ORklHX0RF
RkFVTFRfTk9PUCBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0lPU0NIRUQ9ImNmcSIKIyBDT05G
SUdfSU5MSU5FX1NQSU5fVFJZTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX1RS
WUxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9MT0NLIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DS19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9T
UElOX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DS19JUlFTQVZF
IGlzIG5vdCBzZXQKQ09ORklHX0lOTElORV9TUElOX1VOTE9DSz15CiMgQ09ORklHX0lOTElORV9T
UElOX1VOTE9DS19CSCBpcyBub3Qgc2V0CkNPTkZJR19JTkxJTkVfU1BJTl9VTkxPQ0tfSVJRPXkK
IyBDT05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLX0lSUVJFU1RPUkUgaXMgbm90IHNldAojIENPTkZJ
R19JTkxJTkVfUkVBRF9UUllMT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfTE9D
SyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX0xPQ0tfQkggaXMgbm90IHNldAojIENP
TkZJR19JTkxJTkVfUkVBRF9MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFE
X0xPQ0tfSVJRU0FWRSBpcyBub3Qgc2V0CkNPTkZJR19JTkxJTkVfUkVBRF9VTkxPQ0s9eQojIENP
TkZJR19JTkxJTkVfUkVBRF9VTkxPQ0tfQkggaXMgbm90IHNldApDT05GSUdfSU5MSU5FX1JFQURf
VU5MT0NLX0lSUT15CiMgQ09ORklHX0lOTElORV9SRUFEX1VOTE9DS19JUlFSRVNUT1JFIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5MSU5FX1dSSVRFX1RSWUxPQ0sgaXMgbm90IHNldAojIENPTkZJR19J
TkxJTkVfV1JJVEVfTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9MT0NLX0JI
IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1dSSVRFX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5MSU5FX1dSSVRFX0xPQ0tfSVJRU0FWRSBpcyBub3Qgc2V0CkNPTkZJR19JTkxJTkVf
V1JJVEVfVU5MT0NLPXkKIyBDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DS19CSCBpcyBub3Qgc2V0
CkNPTkZJR19JTkxJTkVfV1JJVEVfVU5MT0NLX0lSUT15CiMgQ09ORklHX0lOTElORV9XUklURV9V
TkxPQ0tfSVJRUkVTVE9SRSBpcyBub3Qgc2V0CkNPTkZJR19NVVRFWF9TUElOX09OX09XTkVSPXkK
Q09ORklHX0ZSRUVaRVI9eQoKIwojIFByb2Nlc3NvciB0eXBlIGFuZCBmZWF0dXJlcwojCkNPTkZJ
R19USUNLX09ORVNIT1Q9eQpDT05GSUdfTk9fSFo9eQpDT05GSUdfSElHSF9SRVNfVElNRVJTPXkK
Q09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlVJTEQ9eQpDT05GSUdfU01QPXkKQ09ORklHX1g4
Nl9NUFBBUlNFPXkKIyBDT05GSUdfWDg2X0JJR1NNUCBpcyBub3Qgc2V0CkNPTkZJR19YODZfRVhU
RU5ERURfUExBVEZPUk09eQojIENPTkZJR19YODZfSU5URUxfTUlEIGlzIG5vdCBzZXQKIyBDT05G
SUdfWDg2X1JEQzMyMVggaXMgbm90IHNldAojIENPTkZJR19YODZfMzJfTk9OX1NUQU5EQVJEIGlz
IG5vdCBzZXQKQ09ORklHX1g4Nl9TVVBQT1JUU19NRU1PUllfRkFJTFVSRT15CiMgQ09ORklHX1g4
Nl8zMl9JUklTIGlzIG5vdCBzZXQKQ09ORklHX1NDSEVEX09NSVRfRlJBTUVfUE9JTlRFUj15CiMg
Q09ORklHX1BBUkFWSVJUX0dVRVNUIGlzIG5vdCBzZXQKQ09ORklHX05PX0JPT1RNRU09eQojIENP
TkZJR19NRU1URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfTTM4NiBpcyBub3Qgc2V0CiMgQ09ORklH
X000ODYgaXMgbm90IHNldAojIENPTkZJR19NNTg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTTU4NlRT
QyBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZNTVggaXMgbm90IHNldApDT05GSUdfTTY4Nj15CiMg
Q09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTUlJSSBpcyBub3Qg
c2V0CiMgQ09ORklHX01QRU5USVVNTSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNNCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01LNiBpcyBub3Qgc2V0CiMgQ09ORklHX01LNyBpcyBub3Qgc2V0CiMg
Q09ORklHX01LOCBpcyBub3Qgc2V0CiMgQ09ORklHX01DUlVTT0UgaXMgbm90IHNldAojIENPTkZJ
R19NRUZGSUNFT04gaXMgbm90IHNldAojIENPTkZJR19NV0lOQ0hJUEM2IGlzIG5vdCBzZXQKIyBD
T05GSUdfTVdJTkNISVAzRCBpcyBub3Qgc2V0CiMgQ09ORklHX01FTEFOIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUdFT0RFR1gxIGlzIG5vdCBzZXQKIyBDT05GSUdfTUdFT0RFX0xYIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUNZUklYSUlJIGlzIG5vdCBzZXQKIyBDT05GSUdfTVZJQUMzXzIgaXMgbm90IHNl
dAojIENPTkZJR19NVklBQzcgaXMgbm90IHNldAojIENPTkZJR19NQ09SRTIgaXMgbm90IHNldAoj
IENPTkZJR19NQVRPTSBpcyBub3Qgc2V0CkNPTkZJR19YODZfR0VORVJJQz15CkNPTkZJR19YODZf
SU5URVJOT0RFX0NBQ0hFX1NISUZUPTYKQ09ORklHX1g4Nl9DTVBYQ0hHPXkKQ09ORklHX0NNUFhD
SEdfTE9DQUw9eQpDT05GSUdfQ01QWENIR19ET1VCTEU9eQpDT05GSUdfWDg2X0wxX0NBQ0hFX1NI
SUZUPTYKQ09ORklHX1g4Nl9YQUREPXkKIyBDT05GSUdfWDg2X1BQUk9fRkVOQ0UgaXMgbm90IHNl
dApDT05GSUdfWDg2X1dQX1dPUktTX09LPXkKQ09ORklHX1g4Nl9JTlZMUEc9eQpDT05GSUdfWDg2
X0JTV0FQPXkKQ09ORklHX1g4Nl9QT1BBRF9PSz15CkNPTkZJR19YODZfSU5URUxfVVNFUkNPUFk9
eQpDT05GSUdfWDg2X1VTRV9QUFJPX0NIRUNLU1VNPXkKQ09ORklHX1g4Nl9UU0M9eQpDT05GSUdf
WDg2X0NNUFhDSEc2ND15CkNPTkZJR19YODZfQ01PVj15CkNPTkZJR19YODZfTUlOSU1VTV9DUFVf
RkFNSUxZPTUKQ09ORklHX1g4Nl9ERUJVR0NUTE1TUj15CkNPTkZJR19DUFVfU1VQX0lOVEVMPXkK
Q09ORklHX0NQVV9TVVBfQ1lSSVhfMzI9eQpDT05GSUdfQ1BVX1NVUF9BTUQ9eQpDT05GSUdfQ1BV
X1NVUF9DRU5UQVVSPXkKQ09ORklHX0NQVV9TVVBfVFJBTlNNRVRBXzMyPXkKQ09ORklHX0NQVV9T
VVBfVU1DXzMyPXkKQ09ORklHX0hQRVRfVElNRVI9eQpDT05GSUdfSFBFVF9FTVVMQVRFX1JUQz15
CkNPTkZJR19ETUk9eQojIENPTkZJR19JT01NVV9IRUxQRVIgaXMgbm90IHNldApDT05GSUdfTlJf
Q1BVUz04CkNPTkZJR19TQ0hFRF9TTVQ9eQpDT05GSUdfU0NIRURfTUM9eQojIENPTkZJR19JUlFf
VElNRV9BQ0NPVU5USU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJFRU1QVF9OT05FIGlzIG5vdCBz
ZXQKQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZPXkKIyBDT05GSUdfUFJFRU1QVCBpcyBub3Qgc2V0
CkNPTkZJR19YODZfTE9DQUxfQVBJQz15CkNPTkZJR19YODZfSU9fQVBJQz15CkNPTkZJR19YODZf
UkVST1VURV9GT1JfQlJPS0VOX0JPT1RfSVJRUz15CkNPTkZJR19YODZfTUNFPXkKQ09ORklHX1g4
Nl9NQ0VfSU5URUw9eQpDT05GSUdfWDg2X01DRV9BTUQ9eQojIENPTkZJR19YODZfQU5DSUVOVF9N
Q0UgaXMgbm90IHNldApDT05GSUdfWDg2X01DRV9USFJFU0hPTEQ9eQojIENPTkZJR19YODZfTUNF
X0lOSkVDVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfVEhFUk1BTF9WRUNUT1I9eQpDT05GSUdfVk04
Nj15CiMgQ09ORklHX1RPU0hJQkEgaXMgbm90IHNldAojIENPTkZJR19JOEsgaXMgbm90IHNldApD
T05GSUdfWDg2X1JFQk9PVEZJWFVQUz15CkNPTkZJR19NSUNST0NPREU9eQpDT05GSUdfTUlDUk9D
T0RFX0lOVEVMPXkKQ09ORklHX01JQ1JPQ09ERV9BTUQ9eQpDT05GSUdfTUlDUk9DT0RFX09MRF9J
TlRFUkZBQ0U9eQpDT05GSUdfWDg2X01TUj15CkNPTkZJR19YODZfQ1BVSUQ9eQojIENPTkZJR19O
T0hJR0hNRU0gaXMgbm90IHNldApDT05GSUdfSElHSE1FTTRHPXkKIyBDT05GSUdfSElHSE1FTTY0
RyBpcyBub3Qgc2V0CkNPTkZJR19QQUdFX09GRlNFVD0weEMwMDAwMDAwCkNPTkZJR19ISUdITUVN
PXkKIyBDT05GSUdfQVJDSF9QSFlTX0FERFJfVF82NEJJVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfRE1BX0FERFJfVF82NEJJVCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0ZMQVRNRU1fRU5BQkxF
PXkKQ09ORklHX0FSQ0hfU1BBUlNFTUVNX0VOQUJMRT15CkNPTkZJR19BUkNIX1NFTEVDVF9NRU1P
UllfTU9ERUw9eQpDT05GSUdfSUxMRUdBTF9QT0lOVEVSX1ZBTFVFPTAKQ09ORklHX1NFTEVDVF9N
RU1PUllfTU9ERUw9eQpDT05GSUdfRkxBVE1FTV9NQU5VQUw9eQojIENPTkZJR19TUEFSU0VNRU1f
TUFOVUFMIGlzIG5vdCBzZXQKQ09ORklHX0ZMQVRNRU09eQpDT05GSUdfRkxBVF9OT0RFX01FTV9N
QVA9eQpDT05GSUdfU1BBUlNFTUVNX1NUQVRJQz15CkNPTkZJR19IQVZFX01FTUJMT0NLPXkKQ09O
RklHX1BBR0VGTEFHU19FWFRFTkRFRD15CkNPTkZJR19TUExJVF9QVExPQ0tfQ1BVUz00CiMgQ09O
RklHX0NPTVBBQ1RJT04gaXMgbm90IHNldAojIENPTkZJR19QSFlTX0FERFJfVF82NEJJVCBpcyBu
b3Qgc2V0CkNPTkZJR19aT05FX0RNQV9GTEFHPTEKQ09ORklHX0JPVU5DRT15CkNPTkZJR19WSVJU
X1RPX0JVUz15CiMgQ09ORklHX0tTTSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX01NQVBfTUlO
X0FERFI9NDA5NgpDT05GSUdfQVJDSF9TVVBQT1JUU19NRU1PUllfRkFJTFVSRT15CiMgQ09ORklH
X01FTU9SWV9GQUlMVVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0Ug
aXMgbm90IHNldAojIENPTkZJR19DTEVBTkNBQ0hFIGlzIG5vdCBzZXQKIyBDT05GSUdfRlJPTlRT
V0FQIGlzIG5vdCBzZXQKQ09ORklHX0hJR0hQVEU9eQpDT05GSUdfWDg2X0NIRUNLX0JJT1NfQ09S
UlVQVElPTj15CkNPTkZJR19YODZfQk9PVFBBUkFNX01FTU9SWV9DT1JSVVBUSU9OX0NIRUNLPXkK
Q09ORklHX1g4Nl9SRVNFUlZFX0xPVz02NAojIENPTkZJR19NQVRIX0VNVUxBVElPTiBpcyBub3Qg
c2V0CkNPTkZJR19NVFJSPXkKIyBDT05GSUdfTVRSUl9TQU5JVElaRVIgaXMgbm90IHNldApDT05G
SUdfWDg2X1BBVD15CkNPTkZJR19BUkNIX1VTRVNfUEdfVU5DQUNIRUQ9eQpDT05GSUdfQVJDSF9S
QU5ET009eQpDT05GSUdfRUZJPXkKQ09ORklHX1NFQ0NPTVA9eQojIENPTkZJR19DQ19TVEFDS1BS
T1RFQ1RPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0ha
XzI1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzMwMCBpcyBub3Qgc2V0CkNPTkZJR19IWl8xMDAw
PXkKQ09ORklHX0haPTEwMDAKQ09ORklHX1NDSEVEX0hSVElDSz15CkNPTkZJR19LRVhFQz15CkNP
TkZJR19DUkFTSF9EVU1QPXkKIyBDT05GSUdfS0VYRUNfSlVNUCBpcyBub3Qgc2V0CkNPTkZJR19Q
SFlTSUNBTF9TVEFSVD0weDEwMDAwMDAKQ09ORklHX1JFTE9DQVRBQkxFPXkKQ09ORklHX1g4Nl9O
RUVEX1JFTE9DUz15CkNPTkZJR19QSFlTSUNBTF9BTElHTj0weDEwMDAwMDAKQ09ORklHX0hPVFBM
VUdfQ1BVPXkKIyBDT05GSUdfQ09NUEFUX1ZEU08gaXMgbm90IHNldAojIENPTkZJR19DTURMSU5F
X0JPT0wgaXMgbm90IHNldApDT05GSUdfQVJDSF9FTkFCTEVfTUVNT1JZX0hPVFBMVUc9eQoKIwoj
IFBvd2VyIG1hbmFnZW1lbnQgYW5kIEFDUEkgb3B0aW9ucwojCkNPTkZJR19TVVNQRU5EPXkKQ09O
RklHX1NVU1BFTkRfRlJFRVpFUj15CkNPTkZJR19ISUJFUk5BVEVfQ0FMTEJBQ0tTPXkKQ09ORklH
X0hJQkVSTkFUSU9OPXkKQ09ORklHX1BNX1NURF9QQVJUSVRJT049IiIKQ09ORklHX1BNX1NMRUVQ
PXkKQ09ORklHX1BNX1NMRUVQX1NNUD15CiMgQ09ORklHX1BNX1JVTlRJTUUgaXMgbm90IHNldApD
T05GSUdfUE09eQpDT05GSUdfUE1fREVCVUc9eQojIENPTkZJR19QTV9BRFZBTkNFRF9ERUJVRyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BNX1RFU1RfU1VTUEVORCBpcyBub3Qgc2V0CkNPTkZJR19DQU5f
UE1fVFJBQ0U9eQpDT05GSUdfUE1fVFJBQ0U9eQpDT05GSUdfUE1fVFJBQ0VfUlRDPXkKQ09ORklH
X0FDUEk9eQpDT05GSUdfQUNQSV9TTEVFUD15CkNPTkZJR19BQ1BJX1BST0NGUz15CiMgQ09ORklH
X0FDUElfUFJPQ0ZTX1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9FQ19ERUJVR0ZTIGlz
IG5vdCBzZXQKQ09ORklHX0FDUElfUFJPQ19FVkVOVD15CkNPTkZJR19BQ1BJX0FDPXkKQ09ORklH
X0FDUElfQkFUVEVSWT15CkNPTkZJR19BQ1BJX0JVVFRPTj15CkNPTkZJR19BQ1BJX1ZJREVPPXkK
Q09ORklHX0FDUElfRkFOPXkKQ09ORklHX0FDUElfRE9DSz15CkNPTkZJR19BQ1BJX1BST0NFU1NP
Uj15CkNPTkZJR19BQ1BJX0hPVFBMVUdfQ1BVPXkKIyBDT05GSUdfQUNQSV9QUk9DRVNTT1JfQUdH
UkVHQVRPUiBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX1RIRVJNQUw9eQojIENPTkZJR19BQ1BJX0NV
U1RPTV9EU0RUIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQkxBQ0tMSVNUX1lFQVI9MAojIENPTkZJ
R19BQ1BJX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9QQ0lfU0xPVCBpcyBub3Qgc2V0
CkNPTkZJR19YODZfUE1fVElNRVI9eQpDT05GSUdfQUNQSV9DT05UQUlORVI9eQojIENPTkZJR19B
Q1BJX1NCUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfSEVEIGlzIG5vdCBzZXQKIyBDT05GSUdf
QUNQSV9DVVNUT01fTUVUSE9EIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9BUEVJIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0ZJIGlzIG5vdCBzZXQKIyBDT05GSUdfQVBNIGlzIG5vdCBzZXQKCiMKIyBD
UFUgRnJlcXVlbmN5IHNjYWxpbmcKIwpDT05GSUdfQ1BVX0ZSRVE9eQpDT05GSUdfQ1BVX0ZSRVFf
VEFCTEU9eQojIENPTkZJR19DUFVfRlJFUV9TVEFUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1BVX0ZS
RVFfREVGQVVMVF9HT1ZfUEVSRk9STUFOQ0UgaXMgbm90IHNldApDT05GSUdfQ1BVX0ZSRVFfREVG
QVVMVF9HT1ZfVVNFUlNQQUNFPXkKIyBDT05GSUdfQ1BVX0ZSRVFfREVGQVVMVF9HT1ZfT05ERU1B
TkQgaXMgbm90IHNldAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9DT05TRVJWQVRJVkUg
aXMgbm90IHNldApDT05GSUdfQ1BVX0ZSRVFfR09WX1BFUkZPUk1BTkNFPXkKIyBDT05GSUdfQ1BV
X0ZSRVFfR09WX1BPV0VSU0FWRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9HT1ZfVVNFUlNQ
QUNFPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9PTkRFTUFORD15CiMgQ09ORklHX0NQVV9GUkVRX0dP
Vl9DT05TRVJWQVRJVkUgaXMgbm90IHNldAoKIwojIHg4NiBDUFUgZnJlcXVlbmN5IHNjYWxpbmcg
ZHJpdmVycwojCiMgQ09ORklHX1g4Nl9QQ0NfQ1BVRlJFUSBpcyBub3Qgc2V0CkNPTkZJR19YODZf
QUNQSV9DUFVGUkVRPXkKIyBDT05GSUdfWDg2X1BPV0VSTk9XX0s2IGlzIG5vdCBzZXQKIyBDT05G
SUdfWDg2X1BPV0VSTk9XX0s3IGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1BPV0VSTk9XX0s4IGlz
IG5vdCBzZXQKIyBDT05GSUdfWDg2X0dYX1NVU1BNT0QgaXMgbm90IHNldAojIENPTkZJR19YODZf
U1BFRURTVEVQX0NFTlRSSU5PIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1NQRUVEU1RFUF9JQ0gg
aXMgbm90IHNldAojIENPTkZJR19YODZfU1BFRURTVEVQX1NNSSBpcyBub3Qgc2V0CiMgQ09ORklH
X1g4Nl9QNF9DTE9DS01PRCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9DUFVGUkVRX05GT1JDRTIg
aXMgbm90IHNldAojIENPTkZJR19YODZfTE9OR1JVTiBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9M
T05HSEFVTCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9FX1BPV0VSU0FWRVIgaXMgbm90IHNldAoK
IwojIHNoYXJlZCBvcHRpb25zCiMKIyBDT05GSUdfWDg2X1NQRUVEU1RFUF9MSUIgaXMgbm90IHNl
dApDT05GSUdfQ1BVX0lETEU9eQpDT05GSUdfQ1BVX0lETEVfR09WX0xBRERFUj15CkNPTkZJR19D
UFVfSURMRV9HT1ZfTUVOVT15CiMgQ09ORklHX0lOVEVMX0lETEUgaXMgbm90IHNldAoKIwojIEJ1
cyBvcHRpb25zIChQQ0kgZXRjLikKIwpDT05GSUdfUENJPXkKIyBDT05GSUdfUENJX0dPQklPUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BDSV9HT01NQ09ORklHIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJ
X0dPRElSRUNUIGlzIG5vdCBzZXQKQ09ORklHX1BDSV9HT0FOWT15CkNPTkZJR19QQ0lfQklPUz15
CkNPTkZJR19QQ0lfRElSRUNUPXkKQ09ORklHX1BDSV9NTUNPTkZJRz15CkNPTkZJR19QQ0lfRE9N
QUlOUz15CiMgQ09ORklHX1BDSV9DTkIyMExFX1FVSVJLIGlzIG5vdCBzZXQKQ09ORklHX1BDSUVQ
T1JUQlVTPXkKIyBDT05GSUdfSE9UUExVR19QQ0lfUENJRSBpcyBub3Qgc2V0CkNPTkZJR19QQ0lF
QUVSPXkKIyBDT05GSUdfUENJRV9FQ1JDIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJRUFFUl9JTkpF
Q1QgaXMgbm90IHNldApDT05GSUdfUENJRUFTUE09eQojIENPTkZJR19QQ0lFQVNQTV9ERUJVRyBp
cyBub3Qgc2V0CkNPTkZJR19BUkNIX1NVUFBPUlRTX01TST15CkNPTkZJR19QQ0lfTVNJPXkKIyBD
T05GSUdfUENJX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX1NUVUIgaXMgbm90IHNldApD
T05GSUdfSFRfSVJRPXkKIyBDT05GSUdfUENJX0lPViBpcyBub3Qgc2V0CkNPTkZJR19QQ0lfSU9B
UElDPXkKQ09ORklHX1BDSV9MQUJFTD15CkNPTkZJR19JU0FfRE1BX0FQST15CiMgQ09ORklHX0lT
QSBpcyBub3Qgc2V0CiMgQ09ORklHX01DQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDeDIwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX09MUEMgaXMgbm90IHNldAojIENPTkZJR19BTElYIGlzIG5vdCBzZXQK
Q09ORklHX0FNRF9OQj15CkNPTkZJR19QQ0NBUkQ9eQpDT05GSUdfUENNQ0lBPXkKQ09ORklHX1BD
TUNJQV9MT0FEX0NJUz15CkNPTkZJR19DQVJEQlVTPXkKCiMKIyBQQy1jYXJkIGJyaWRnZXMKIwpD
T05GSUdfWUVOVEE9eQpDT05GSUdfWUVOVEFfTzI9eQpDT05GSUdfWUVOVEFfUklDT0g9eQpDT05G
SUdfWUVOVEFfVEk9eQpDT05GSUdfWUVOVEFfRU5FX1RVTkU9eQpDT05GSUdfWUVOVEFfVE9TSElC
QT15CiMgQ09ORklHX1BENjcyOSBpcyBub3Qgc2V0CiMgQ09ORklHX0k4MjA5MiBpcyBub3Qgc2V0
CkNPTkZJR19QQ0NBUkRfTk9OU1RBVElDPXkKQ09ORklHX0hPVFBMVUdfUENJPXkKIyBDT05GSUdf
SE9UUExVR19QQ0lfRkFLRSBpcyBub3Qgc2V0CiMgQ09ORklHX0hPVFBMVUdfUENJX0NPTVBBUSBp
cyBub3Qgc2V0CiMgQ09ORklHX0hPVFBMVUdfUENJX0lCTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hP
VFBMVUdfUENJX0FDUEkgaXMgbm90IHNldAojIENPTkZJR19IT1RQTFVHX1BDSV9DUENJIGlzIG5v
dCBzZXQKIyBDT05GSUdfSE9UUExVR19QQ0lfU0hQQyBpcyBub3Qgc2V0CiMgQ09ORklHX1JBUElE
SU8gaXMgbm90IHNldAoKIwojIEV4ZWN1dGFibGUgZmlsZSBmb3JtYXRzIC8gRW11bGF0aW9ucwoj
CkNPTkZJR19CSU5GTVRfRUxGPXkKQ09ORklHX0NPUkVfRFVNUF9ERUZBVUxUX0VMRl9IRUFERVJT
PXkKQ09ORklHX0hBVkVfQU9VVD15CiMgQ09ORklHX0JJTkZNVF9BT1VUIGlzIG5vdCBzZXQKQ09O
RklHX0JJTkZNVF9NSVNDPXkKQ09ORklHX0hBVkVfQVRPTUlDX0lPTUFQPXkKQ09ORklHX0hBVkVf
VEVYVF9QT0tFX1NNUD15CkNPTkZJR19ORVQ9eQoKIwojIE5ldHdvcmtpbmcgb3B0aW9ucwojCkNP
TkZJR19QQUNLRVQ9eQpDT05GSUdfVU5JWD15CkNPTkZJR19YRlJNPXkKQ09ORklHX1hGUk1fVVNF
Uj15CiMgQ09ORklHX1hGUk1fU1VCX1BPTElDWSBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fTUlH
UkFURSBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fU1RBVElTVElDUyBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9LRVkgaXMgbm90IHNldApDT05GSUdfSU5FVD15CkNPTkZJR19JUF9NVUxUSUNBU1Q9
eQpDT05GSUdfSVBfQURWQU5DRURfUk9VVEVSPXkKIyBDT05GSUdfSVBfRklCX1RSSUVfU1RBVFMg
aXMgbm90IHNldApDT05GSUdfSVBfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1JPVVRFX01V
TFRJUEFUSD15CkNPTkZJR19JUF9ST1VURV9WRVJCT1NFPXkKQ09ORklHX0lQX1BOUD15CkNPTkZJ
R19JUF9QTlBfREhDUD15CkNPTkZJR19JUF9QTlBfQk9PVFA9eQpDT05GSUdfSVBfUE5QX1JBUlA9
eQojIENPTkZJR19ORVRfSVBJUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9JUEdSRV9ERU1VWCBp
cyBub3Qgc2V0CkNPTkZJR19JUF9NUk9VVEU9eQojIENPTkZJR19JUF9NUk9VVEVfTVVMVElQTEVf
VEFCTEVTIGlzIG5vdCBzZXQKQ09ORklHX0lQX1BJTVNNX1YxPXkKQ09ORklHX0lQX1BJTVNNX1Yy
PXkKIyBDT05GSUdfQVJQRCBpcyBub3Qgc2V0CkNPTkZJR19TWU5fQ09PS0lFUz15CiMgQ09ORklH
X0lORVRfQUggaXMgbm90IHNldAojIENPTkZJR19JTkVUX0VTUCBpcyBub3Qgc2V0CiMgQ09ORklH
X0lORVRfSVBDT01QIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9YRlJNX1RVTk5FTCBpcyBub3Qg
c2V0CkNPTkZJR19JTkVUX1RVTk5FTD15CiMgQ09ORklHX0lORVRfWEZSTV9NT0RFX1RSQU5TUE9S
VCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfWEZSTV9NT0RFX1RVTk5FTCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lORVRfWEZSTV9NT0RFX0JFRVQgaXMgbm90IHNldApDT05GSUdfSU5FVF9MUk89eQoj
IENPTkZJR19JTkVUX0RJQUcgaXMgbm90IHNldApDT05GSUdfVENQX0NPTkdfQURWQU5DRUQ9eQoj
IENPTkZJR19UQ1BfQ09OR19CSUMgaXMgbm90IHNldApDT05GSUdfVENQX0NPTkdfQ1VCSUM9eQoj
IENPTkZJR19UQ1BfQ09OR19XRVNUV09PRCBpcyBub3Qgc2V0CiMgQ09ORklHX1RDUF9DT05HX0hU
Q1AgaXMgbm90IHNldAojIENPTkZJR19UQ1BfQ09OR19IU1RDUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1RDUF9DT05HX0hZQkxBIGlzIG5vdCBzZXQKIyBDT05GSUdfVENQX0NPTkdfVkVHQVMgaXMgbm90
IHNldAojIENPTkZJR19UQ1BfQ09OR19TQ0FMQUJMRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RDUF9D
T05HX0xQIGlzIG5vdCBzZXQKIyBDT05GSUdfVENQX0NPTkdfVkVOTyBpcyBub3Qgc2V0CiMgQ09O
RklHX1RDUF9DT05HX1lFQUggaXMgbm90IHNldAojIENPTkZJR19UQ1BfQ09OR19JTExJTk9JUyBp
cyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX0NVQklDPXkKIyBDT05GSUdfREVGQVVMVF9SRU5PIGlz
IG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfVENQX0NPTkc9ImN1YmljIgpDT05GSUdfVENQX01ENVNJ
Rz15CkNPTkZJR19JUFY2PXkKIyBDT05GSUdfSVBWNl9QUklWQUNZIGlzIG5vdCBzZXQKIyBDT05G
SUdfSVBWNl9ST1VURVJfUFJFRiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfT1BUSU1JU1RJQ19E
QUQgaXMgbm90IHNldApDT05GSUdfSU5FVDZfQUg9eQpDT05GSUdfSU5FVDZfRVNQPXkKIyBDT05G
SUdfSU5FVDZfSVBDT01QIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NSVA2IGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5FVDZfWEZSTV9UVU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUNl9UVU5O
RUwgaXMgbm90IHNldApDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1RSQU5TUE9SVD15CkNPTkZJR19J
TkVUNl9YRlJNX01PREVfVFVOTkVMPXkKQ09ORklHX0lORVQ2X1hGUk1fTU9ERV9CRUVUPXkKIyBD
T05GSUdfSU5FVDZfWEZSTV9NT0RFX1JPVVRFT1BUSU1JWkFUSU9OIGlzIG5vdCBzZXQKQ09ORklH
X0lQVjZfU0lUPXkKIyBDT05GSUdfSVBWNl9TSVRfNlJEIGlzIG5vdCBzZXQKQ09ORklHX0lQVjZf
TkRJU0NfTk9ERVRZUEU9eQojIENPTkZJR19JUFY2X1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklH
X0lQVjZfTVVMVElQTEVfVEFCTEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNl9NUk9VVEUgaXMg
bm90IHNldApDT05GSUdfTkVUTEFCRUw9eQpDT05GSUdfTkVUV09SS19TRUNNQVJLPXkKIyBDT05G
SUdfTkVUV09SS19QSFlfVElNRVNUQU1QSU5HIGlzIG5vdCBzZXQKQ09ORklHX05FVEZJTFRFUj15
CiMgQ09ORklHX05FVEZJTFRFUl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9B
RFZBTkNFRCBpcyBub3Qgc2V0CgojCiMgQ29yZSBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCkNP
TkZJR19ORVRGSUxURVJfTkVUTElOSz15CkNPTkZJR19ORVRGSUxURVJfTkVUTElOS19MT0c9eQpD
T05GSUdfTkZfQ09OTlRSQUNLPXkKQ09ORklHX05GX0NPTk5UUkFDS19TRUNNQVJLPXkKQ09ORklH
X05GX0NPTk5UUkFDS19GVFA9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0lSQz15CkNPTkZJR19ORl9D
T05OVFJBQ0tfU0lQPXkKQ09ORklHX05GX0NUX05FVExJTks9eQpDT05GSUdfTkVURklMVEVSX1hU
QUJMRVM9eQoKIwojIFh0YWJsZXMgY29tYmluZWQgbW9kdWxlcwojCkNPTkZJR19ORVRGSUxURVJf
WFRfTUFSSz1tCgojCiMgWHRhYmxlcyB0YXJnZXRzCiMKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJH
RVRfQ09OTlNFQ01BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORkxPRz15CkNPTkZJ
R19ORVRGSUxURVJfWFRfVEFSR0VUX1NFQ01BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdF
VF9UQ1BNU1M9eQoKIwojIFh0YWJsZXMgbWF0Y2hlcwojCkNPTkZJR19ORVRGSUxURVJfWFRfTUFU
Q0hfQ09OTlRSQUNLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9QT0xJQ1k9eQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX1NUQVRFPXkKIyBDT05GSUdfSVBfU0VUIGlzIG5vdCBzZXQKIyBD
T05GSUdfSVBfVlMgaXMgbm90IHNldAoKIwojIElQOiBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgoj
CkNPTkZJR19ORl9ERUZSQUdfSVBWND15CkNPTkZJR19ORl9DT05OVFJBQ0tfSVBWND15CkNPTkZJ
R19ORl9DT05OVFJBQ0tfUFJPQ19DT01QQVQ9eQpDT05GSUdfSVBfTkZfSVBUQUJMRVM9eQpDT05G
SUdfSVBfTkZfRklMVEVSPXkKQ09ORklHX0lQX05GX1RBUkdFVF9SRUpFQ1Q9eQpDT05GSUdfSVBf
TkZfVEFSR0VUX0xPRz15CkNPTkZJR19JUF9ORl9UQVJHRVRfVUxPRz15CkNPTkZJR19ORl9OQVQ9
eQpDT05GSUdfTkZfTkFUX05FRURFRD15CkNPTkZJR19JUF9ORl9UQVJHRVRfTUFTUVVFUkFERT15
CkNPTkZJR19ORl9OQVRfRlRQPXkKQ09ORklHX05GX05BVF9JUkM9eQojIENPTkZJR19ORl9OQVRf
VEZUUCBpcyBub3Qgc2V0CiMgQ09ORklHX05GX05BVF9BTUFOREEgaXMgbm90IHNldAojIENPTkZJ
R19ORl9OQVRfUFBUUCBpcyBub3Qgc2V0CiMgQ09ORklHX05GX05BVF9IMzIzIGlzIG5vdCBzZXQK
Q09ORklHX05GX05BVF9TSVA9eQpDT05GSUdfSVBfTkZfTUFOR0xFPXkKCiMKIyBJUHY2OiBOZXRm
aWx0ZXIgQ29uZmlndXJhdGlvbgojCkNPTkZJR19ORl9ERUZSQUdfSVBWNj15CkNPTkZJR19ORl9D
T05OVFJBQ0tfSVBWNj15CkNPTkZJR19JUDZfTkZfSVBUQUJMRVM9eQpDT05GSUdfSVA2X05GX01B
VENIX0lQVjZIRUFERVI9eQpDT05GSUdfSVA2X05GX1RBUkdFVF9MT0c9eQpDT05GSUdfSVA2X05G
X0ZJTFRFUj15CkNPTkZJR19JUDZfTkZfVEFSR0VUX1JFSkVDVD15CkNPTkZJR19JUDZfTkZfTUFO
R0xFPXkKIyBDT05GSUdfSVBfRENDUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX1NDVFAgaXMgbm90
IHNldAojIENPTkZJR19SRFMgaXMgbm90IHNldAojIENPTkZJR19USVBDIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVRNIGlzIG5vdCBzZXQKIyBDT05GSUdfTDJUUCBpcyBub3Qgc2V0CiMgQ09ORklHX0JS
SURHRSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9EU0EgaXMgbm90IHNldAojIENPTkZJR19WTEFO
XzgwMjFRIGlzIG5vdCBzZXQKIyBDT05GSUdfREVDTkVUIGlzIG5vdCBzZXQKQ09ORklHX0xMQz15
CiMgQ09ORklHX0xMQzIgaXMgbm90IHNldAojIENPTkZJR19JUFggaXMgbm90IHNldAojIENPTkZJ
R19BVEFMSyBpcyBub3Qgc2V0CiMgQ09ORklHX1gyNSBpcyBub3Qgc2V0CiMgQ09ORklHX0xBUEIg
aXMgbm90IHNldAojIENPTkZJR19FQ09ORVQgaXMgbm90IHNldAojIENPTkZJR19XQU5fUk9VVEVS
IGlzIG5vdCBzZXQKIyBDT05GSUdfUEhPTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfSUVFRTgwMjE1
NCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfU0NIRUQ9eQoKIwojIFF1ZXVlaW5nL1NjaGVkdWxpbmcK
IwojIENPTkZJR19ORVRfU0NIX0NCUSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfSFRCIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9IRlNDIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ND
SF9QUklPIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9NVUxUSVEgaXMgbm90IHNldAojIENP
TkZJR19ORVRfU0NIX1JFRCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfU0ZCIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX1NDSF9TRlEgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX1RFUUwg
aXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX1RCRiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9T
Q0hfR1JFRCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfRFNNQVJLIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX1NDSF9ORVRFTSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfRFJSIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX1NDSF9NUVBSSU8gaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NI
X0NIT0tFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9RRlEgaXMgbm90IHNldAojIENPTkZJ
R19ORVRfU0NIX0lOR1JFU1MgaXMgbm90IHNldAoKIwojIENsYXNzaWZpY2F0aW9uCiMKQ09ORklH
X05FVF9DTFM9eQojIENPTkZJR19ORVRfQ0xTX0JBU0lDIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
X0NMU19UQ0lOREVYIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0NMU19ST1VURTQgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfQ0xTX0ZXIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0NMU19VMzIgaXMg
bm90IHNldAojIENPTkZJR19ORVRfQ0xTX1JTVlAgaXMgbm90IHNldAojIENPTkZJR19ORVRfQ0xT
X1JTVlA2IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0NMU19GTE9XIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUX0NMU19DR1JPVVAgaXMgbm90IHNldApDT05GSUdfTkVUX0VNQVRDSD15CkNPTkZJR19O
RVRfRU1BVENIX1NUQUNLPTMyCiMgQ09ORklHX05FVF9FTUFUQ0hfQ01QIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX0VNQVRDSF9OQllURSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9FTUFUQ0hfVTMy
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0VNQVRDSF9NRVRBIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVUX0VNQVRDSF9URVhUIGlzIG5vdCBzZXQKQ09ORklHX05FVF9DTFNfQUNUPXkKIyBDT05GSUdf
TkVUX0FDVF9QT0xJQ0UgaXMgbm90IHNldAojIENPTkZJR19ORVRfQUNUX0dBQ1QgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfQUNUX01JUlJFRCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9BQ1RfSVBU
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0FDVF9OQVQgaXMgbm90IHNldAojIENPTkZJR19ORVRf
QUNUX1BFRElUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0FDVF9TSU1QIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX0FDVF9TS0JFRElUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0FDVF9DU1VNIGlz
IG5vdCBzZXQKQ09ORklHX05FVF9TQ0hfRklGTz15CiMgQ09ORklHX0RDQiBpcyBub3Qgc2V0CkNP
TkZJR19ETlNfUkVTT0xWRVI9eQojIENPTkZJR19CQVRNQU5fQURWIGlzIG5vdCBzZXQKQ09ORklH
X1JQUz15CkNPTkZJR19SRlNfQUNDRUw9eQpDT05GSUdfWFBTPXkKCiMKIyBOZXR3b3JrIHRlc3Rp
bmcKIwojIENPTkZJR19ORVRfUEtUR0VOIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1RDUFBST0JF
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0RST1BfTU9OSVRPUiBpcyBub3Qgc2V0CkNPTkZJR19I
QU1SQURJTz15CgojCiMgUGFja2V0IFJhZGlvIHByb3RvY29scwojCiMgQ09ORklHX0FYMjUgaXMg
bm90IHNldAojIENPTkZJR19DQU4gaXMgbm90IHNldAojIENPTkZJR19JUkRBIGlzIG5vdCBzZXQK
IyBDT05GSUdfQlQgaXMgbm90IHNldAojIENPTkZJR19BRl9SWFJQQyBpcyBub3Qgc2V0CkNPTkZJ
R19GSUJfUlVMRVM9eQpDT05GSUdfV0lSRUxFU1M9eQpDT05GSUdfV0VYVF9DT1JFPXkKQ09ORklH
X1dFWFRfUFJPQz15CkNPTkZJR19DRkc4MDIxMT15CiMgQ09ORklHX05MODAyMTFfVEVTVE1PREUg
aXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9ERVZFTE9QRVJfV0FSTklOR1MgaXMgbm90IHNl
dAojIENPTkZJR19DRkc4MDIxMV9SRUdfREVCVUcgaXMgbm90IHNldApDT05GSUdfQ0ZHODAyMTFf
REVGQVVMVF9QUz15CiMgQ09ORklHX0NGRzgwMjExX0RFQlVHRlMgaXMgbm90IHNldAojIENPTkZJ
R19DRkc4MDIxMV9JTlRFUk5BTF9SRUdEQiBpcyBub3Qgc2V0CkNPTkZJR19DRkc4MDIxMV9XRVhU
PXkKQ09ORklHX1dJUkVMRVNTX0VYVF9TWVNGUz15CiMgQ09ORklHX0xJQjgwMjExIGlzIG5vdCBz
ZXQKQ09ORklHX01BQzgwMjExPXkKQ09ORklHX01BQzgwMjExX0hBU19SQz15CkNPTkZJR19NQUM4
MDIxMV9SQ19NSU5TVFJFTD15CkNPTkZJR19NQUM4MDIxMV9SQ19NSU5TVFJFTF9IVD15CkNPTkZJ
R19NQUM4MDIxMV9SQ19ERUZBVUxUX01JTlNUUkVMPXkKQ09ORklHX01BQzgwMjExX1JDX0RFRkFV
TFQ9Im1pbnN0cmVsX2h0IgojIENPTkZJR19NQUM4MDIxMV9NRVNIIGlzIG5vdCBzZXQKQ09ORklH
X01BQzgwMjExX0xFRFM9eQojIENPTkZJR19NQUM4MDIxMV9ERUJVR0ZTIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUFDODAyMTFfREVCVUdfTUVOVSBpcyBub3Qgc2V0CiMgQ09ORklHX1dJTUFYIGlzIG5v
dCBzZXQKQ09ORklHX1JGS0lMTD15CkNPTkZJR19SRktJTExfTEVEUz15CkNPTkZJR19SRktJTExf
SU5QVVQ9eQojIENPTkZJR19ORVRfOVAgaXMgbm90IHNldAojIENPTkZJR19DQUlGIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ0VQSF9MSUIgaXMgbm90IHNldAojIENPTkZJR19ORkMgaXMgbm90IHNldAoK
IwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBHZW5lcmljIERyaXZlciBPcHRpb25zCiMKQ09ORklH
X1VFVkVOVF9IRUxQRVJfUEFUSD0iL3NiaW4vaG90cGx1ZyIKIyBDT05GSUdfREVWVE1QRlMgaXMg
bm90IHNldApDT05GSUdfU1RBTkRBTE9ORT15CkNPTkZJR19QUkVWRU5UX0ZJUk1XQVJFX0JVSUxE
PXkKQ09ORklHX0ZXX0xPQURFUj15CkNPTkZJR19GSVJNV0FSRV9JTl9LRVJORUw9eQpDT05GSUdf
RVhUUkFfRklSTVdBUkU9IiIKIyBDT05GSUdfREVCVUdfRFJJVkVSIGlzIG5vdCBzZXQKQ09ORklH
X0RFQlVHX0RFVlJFUz15CiMgQ09ORklHX1NZU19IWVBFUlZJU09SIGlzIG5vdCBzZXQKQ09ORklH
X0NPTk5FQ1RPUj15CkNPTkZJR19QUk9DX0VWRU5UUz15CiMgQ09ORklHX01URCBpcyBub3Qgc2V0
CiMgQ09ORklHX1BBUlBPUlQgaXMgbm90IHNldApDT05GSUdfUE5QPXkKQ09ORklHX1BOUF9ERUJV
R19NRVNTQUdFUz15CgojCiMgUHJvdG9jb2xzCiMKQ09ORklHX1BOUEFDUEk9eQpDT05GSUdfQkxL
X0RFVj15CiMgQ09ORklHX0JMS19ERVZfRkQgaXMgbm90IHNldAojIENPTkZJR19CTEtfQ1BRX0RB
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0NQUV9DSVNTX0RBIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkxLX0RFVl9EQUM5NjAgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1VNRU0gaXMgbm90IHNl
dAojIENPTkZJR19CTEtfREVWX0NPV19DT01NT04gaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9M
T09QPXkKQ09ORklHX0JMS19ERVZfTE9PUF9NSU5fQ09VTlQ9OAojIENPTkZJR19CTEtfREVWX0NS
WVBUT0xPT1AgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RSQkQgaXMgbm90IHNldAojIENP
TkZJR19CTEtfREVWX05CRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfU1g4IGlzIG5vdCBz
ZXQKIyBDT05GSUdfQkxLX0RFVl9VQiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX1JBTT15CkNP
TkZJR19CTEtfREVWX1JBTV9DT1VOVD0xNgpDT05GSUdfQkxLX0RFVl9SQU1fU0laRT0xNjM4NAoj
IENPTkZJR19CTEtfREVWX1hJUCBpcyBub3Qgc2V0CiMgQ09ORklHX0NEUk9NX1BLVENEVkQgaXMg
bm90IHNldAojIENPTkZJR19BVEFfT1ZFUl9FVEggaXMgbm90IHNldAojIENPTkZJR19CTEtfREVW
X0hEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9SQkQgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0xJUzNMVjAyRCBpcyBub3Qgc2V0CiMgQ09ORklHX01JU0NfREVWSUNFUyBpcyBub3Qg
c2V0CkNPTkZJR19IQVZFX0lERT15CiMgQ09ORklHX0lERSBpcyBub3Qgc2V0CgojCiMgU0NTSSBk
ZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19TQ1NJX01PRD15CiMgQ09ORklHX1JBSURfQVRUUlMgaXMg
bm90IHNldApDT05GSUdfU0NTST15CkNPTkZJR19TQ1NJX0RNQT15CiMgQ09ORklHX1NDU0lfVEdU
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9ORVRMSU5LIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lf
UFJPQ19GUz15CgojCiMgU0NTSSBzdXBwb3J0IHR5cGUgKGRpc2ssIHRhcGUsIENELVJPTSkKIwpD
T05GSUdfQkxLX0RFVl9TRD15CiMgQ09ORklHX0NIUl9ERVZfU1QgaXMgbm90IHNldAojIENPTkZJ
R19DSFJfREVWX09TU1QgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9TUj15CkNPTkZJR19CTEtf
REVWX1NSX1ZFTkRPUj15CkNPTkZJR19DSFJfREVWX1NHPXkKIyBDT05GSUdfQ0hSX0RFVl9TQ0gg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX01VTFRJX0xVTiBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJ
X0NPTlNUQU5UUz15CiMgQ09ORklHX1NDU0lfTE9HR0lORyBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
U0lfU0NBTl9BU1lOQyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX1dBSVRfU0NBTj1tCgojCiMgU0NT
SSBUcmFuc3BvcnRzCiMKQ09ORklHX1NDU0lfU1BJX0FUVFJTPXkKIyBDT05GSUdfU0NTSV9GQ19B
VFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSVNDU0lfQVRUUlMgaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX1NBU19BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU0FTX0xJQlNBUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU1JQX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9MT1dMRVZFTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTE9XTEVWRUxfUENNQ0lBIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9ESCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfT1NEX0lOSVRJ
QVRPUiBpcyBub3Qgc2V0CkNPTkZJR19BVEE9eQojIENPTkZJR19BVEFfTk9OU1RBTkRBUkQgaXMg
bm90IHNldApDT05GSUdfQVRBX1ZFUkJPU0VfRVJST1I9eQpDT05GSUdfQVRBX0FDUEk9eQpDT05G
SUdfU0FUQV9QTVA9eQoKIwojIENvbnRyb2xsZXJzIHdpdGggbm9uLVNGRiBuYXRpdmUgaW50ZXJm
YWNlCiMKQ09ORklHX1NBVEFfQUhDST15CiMgQ09ORklHX1NBVEFfQUhDSV9QTEFURk9STSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NBVEFfSU5JQzE2MlggaXMgbm90IHNldAojIENPTkZJR19TQVRBX0FD
QVJEX0FIQ0kgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NJTDI0IGlzIG5vdCBzZXQKQ09ORklH
X0FUQV9TRkY9eQoKIwojIFNGRiBjb250cm9sbGVycyB3aXRoIGN1c3RvbSBETUEgaW50ZXJmYWNl
CiMKIyBDT05GSUdfUERDX0FETUEgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1FTVE9SIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0FUQV9TWDQgaXMgbm90IHNldApDT05GSUdfQVRBX0JNRE1BPXkKCiMK
IyBTQVRBIFNGRiBjb250cm9sbGVycyB3aXRoIEJNRE1BCiMKQ09ORklHX0FUQV9QSUlYPXkKIyBD
T05GSUdfU0FUQV9NViBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfTlYgaXMgbm90IHNldAojIENP
TkZJR19TQVRBX1BST01JU0UgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1NJTCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NBVEFfU0lTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TVlcgaXMgbm90IHNl
dAojIENPTkZJR19TQVRBX1VMSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfVklBIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0FUQV9WSVRFU1NFIGlzIG5vdCBzZXQKCiMKIyBQQVRBIFNGRiBjb250cm9s
bGVycyB3aXRoIEJNRE1BCiMKIyBDT05GSUdfUEFUQV9BTEkgaXMgbm90IHNldApDT05GSUdfUEFU
QV9BTUQ9eQojIENPTkZJR19QQVRBX0FSQVNBTl9DRiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
QVJUT1AgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0FUSUlYUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBVEFfQVRQODY3WCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQ01ENjRYIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEFUQV9DUzU1MjAgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NTNTUzMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfQ1M1NTM1IGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DUzU1
MzYgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0NZUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX0VGQVIgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDM2NiBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfSFBUMzdYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9IUFQzWDJOIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUEFUQV9IUFQzWDMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0lUODIxMyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSVQ4MjFYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9K
TUlDUk9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9NQVJWRUxMIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFUQV9ORVRDRUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9OSU5KQTMyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUEFUQV9OUzg3NDE1IGlzIG5vdCBzZXQKQ09ORklHX1BBVEFfT0xEUElJWD15
CiMgQ09ORklHX1BBVEFfT1BUSURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUERDMjAyN1gg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX1BEQ19PTEQgaXMgbm90IHNldAojIENPTkZJR19QQVRB
X1JBRElTWVMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JEQyBpcyBub3Qgc2V0CiMgQ09ORklH
X1BBVEFfU0MxMjAwIGlzIG5vdCBzZXQKQ09ORklHX1BBVEFfU0NIPXkKIyBDT05GSUdfUEFUQV9T
RVJWRVJXT1JLUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0lMNjgwIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFUQV9TSVMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1RPU0hJQkEgaXMgbm90IHNl
dAojIENPTkZJR19QQVRBX1RSSUZMRVggaXMgbm90IHNldAojIENPTkZJR19QQVRBX1ZJQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfV0lOQk9ORCBpcyBub3Qgc2V0CgojCiMgUElPLW9ubHkgU0ZG
IGNvbnRyb2xsZXJzCiMKIyBDT05GSUdfUEFUQV9DTUQ2NDBfUENJIGlzIG5vdCBzZXQKQ09ORklH
X1BBVEFfTVBJSVg9eQojIENPTkZJR19QQVRBX05TODc0MTAgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX09QVEkgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1BDTUNJQSBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfUloxMDAwIGlzIG5vdCBzZXQKCiMKIyBHZW5lcmljIGZhbGxiYWNrIC8gbGVnYWN5
IGRyaXZlcnMKIwojIENPTkZJR19QQVRBX0FDUEkgaXMgbm90IHNldApDT05GSUdfQVRBX0dFTkVS
SUM9eQojIENPTkZJR19QQVRBX0xFR0FDWSBpcyBub3Qgc2V0CkNPTkZJR19NRD15CkNPTkZJR19C
TEtfREVWX01EPXkKQ09ORklHX01EX0FVVE9ERVRFQ1Q9eQojIENPTkZJR19NRF9MSU5FQVIgaXMg
bm90IHNldAojIENPTkZJR19NRF9SQUlEMCBpcyBub3Qgc2V0CiMgQ09ORklHX01EX1JBSUQxIGlz
IG5vdCBzZXQKIyBDT05GSUdfTURfUkFJRDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfTURfUkFJRDQ1
NiBpcyBub3Qgc2V0CiMgQ09ORklHX01EX01VTFRJUEFUSCBpcyBub3Qgc2V0CiMgQ09ORklHX01E
X0ZBVUxUWSBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0RNPXkKIyBDT05GSUdfRE1fREVCVUcg
aXMgbm90IHNldAojIENPTkZJR19ETV9QRVJTSVNURU5UX0RBVEEgaXMgbm90IHNldAojIENPTkZJ
R19ETV9DUllQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX1NOQVBTSE9UIGlzIG5vdCBzZXQKIyBD
T05GSUdfRE1fVEhJTl9QUk9WSVNJT05JTkcgaXMgbm90IHNldApDT05GSUdfRE1fTUlSUk9SPXkK
IyBDT05GSUdfRE1fUkFJRCBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX0xPR19VU0VSU1BBQ0UgaXMg
bm90IHNldApDT05GSUdfRE1fWkVSTz15CiMgQ09ORklHX0RNX01VTFRJUEFUSCBpcyBub3Qgc2V0
CiMgQ09ORklHX0RNX0RFTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1fVUVWRU5UIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRE1fRkxBS0VZIGlzIG5vdCBzZXQKIyBDT05GSUdfVEFSR0VUX0NPUkUgaXMg
bm90IHNldAojIENPTkZJR19GVVNJT04gaXMgbm90IHNldAoKIwojIElFRUUgMTM5NCAoRmlyZVdp
cmUpIHN1cHBvcnQKIwojIENPTkZJR19GSVJFV0lSRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZJUkVX
SVJFX05PU1kgaXMgbm90IHNldAojIENPTkZJR19JMk8gaXMgbm90IHNldApDT05GSUdfTUFDSU5U
T1NIX0RSSVZFUlM9eQpDT05GSUdfTUFDX0VNVU1PVVNFQlROPXkKQ09ORklHX05FVERFVklDRVM9
eQojIENPTkZJR19JRkIgaXMgbm90IHNldAojIENPTkZJR19EVU1NWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0JPTkRJTkcgaXMgbm90IHNldAojIENPTkZJR19NQUNWTEFOIGlzIG5vdCBzZXQKIyBDT05G
SUdfRVFVQUxJWkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfVFVOIGlzIG5vdCBzZXQKIyBDT05GSUdf
VkVUSCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQjEwMDAgaXMgbm90IHNldAojIENPTkZJR19B
UkNORVQgaXMgbm90IHNldAojIENPTkZJR19NSUkgaXMgbm90IHNldAojIENPTkZJR19QSFlMSUIg
aXMgbm90IHNldApDT05GSUdfRVRIRVJORVQ9eQpDT05GSUdfTkVUX1ZFTkRPUl8zQ09NPXkKIyBD
T05GSUdfUENNQ0lBXzNDNTc0IGlzIG5vdCBzZXQKIyBDT05GSUdfUENNQ0lBXzNDNTg5IGlzIG5v
dCBzZXQKIyBDT05GSUdfVk9SVEVYIGlzIG5vdCBzZXQKIyBDT05GSUdfVFlQSE9PTiBpcyBub3Qg
c2V0CiMgQ09ORklHX05FVF9WRU5ET1JfQURBUFRFQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9W
RU5ET1JfQUxURU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9BTUQgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfVkVORE9SX0FUSEVST1MgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVO
RE9SX0JST0FEQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9CUk9DQURFIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9DSEVMU0lPIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
X1ZFTkRPUl9DSVNDTyBpcyBub3Qgc2V0CiMgQ09ORklHX0RORVQgaXMgbm90IHNldAojIENPTkZJ
R19ORVRfVkVORE9SX0RFQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfRExJTksgaXMg
bm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX0VNVUxFWCBpcyBub3Qgc2V0CiMgQ09ORklHX05F
VF9WRU5ET1JfRVhBUiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfRlVKSVRTVSBpcyBu
b3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfSFAgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVO
RE9SX0lOVEVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSVAxMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
Sk1FIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9NQVJWRUxMIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX1ZFTkRPUl9NRUxMQU5PWCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1Jf
TUlDUkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9NWVJJIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkVBTE5YIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9OQVRTRU1JIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9OVklESUEgaXMgbm90IHNldAojIENPTkZJR19ORVRf
VkVORE9SX09LSSBpcyBub3Qgc2V0CiMgQ09ORklHX0VUSE9DIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVUX1BBQ0tFVF9FTkdJTkUgaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX1FMT0dJQyBp
cyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfUkVBTFRFSyBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9WRU5ET1JfUkRDIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9TRUVRIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX1ZFTkRPUl9TSVMgaXMgbm90IHNldAojIENPTkZJR19TRkMgaXMg
bm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX1NNU0MgaXMgbm90IHNldAojIENPTkZJR19ORVRf
VkVORE9SX1NUTUlDUk8gaXMgbm90IHNldAojIENPTkZJR19ORVRfVkVORE9SX1NVTiBpcyBub3Qg
c2V0CiMgQ09ORklHX05FVF9WRU5ET1JfVEVIVVRJIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ZF
TkRPUl9USSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9WRU5ET1JfVklBIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX1ZFTkRPUl9YSVJDT00gaXMgbm90IHNldApDT05GSUdfVFI9eQojIENPTkZJR19J
Qk1PTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTUxTIGlzIG5vdCBzZXQKIyBDT05GSUdfM0MzNTkg
aXMgbm90IHNldAojIENPTkZJR19UTVMzODBUUiBpcyBub3Qgc2V0CkNPTkZJR19XTEFOPXkKIyBD
T05GSUdfUENNQ0lBX1JBWUNTIGlzIG5vdCBzZXQKIyBDT05GSUdfTElCRVJUQVNfVEhJTkZJUk0g
aXMgbm90IHNldAojIENPTkZJR19BSVJPIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNRUwgaXMgbm90
IHNldAojIENPTkZJR19BVDc2QzUwWF9VU0IgaXMgbm90IHNldAojIENPTkZJR19BSVJPX0NTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUENNQ0lBX1dMMzUwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1BSSVNN
NTQgaXMgbm90IHNldAojIENPTkZJR19VU0JfWkQxMjAxIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X05FVF9STkRJU19XTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE4MCBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUTDgxODcgaXMgbm90IHNldAojIENPTkZJR19BRE04MjExIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUFDODAyMTFfSFdTSU0gaXMgbm90IHNldAojIENPTkZJR19NV0w4SyBpcyBub3Qgc2V0
CiMgQ09ORklHX0FUSF9DT01NT04gaXMgbm90IHNldAojIENPTkZJR19CNDMgaXMgbm90IHNldAoj
IENPTkZJR19CNDNMRUdBQ1kgaXMgbm90IHNldAojIENPTkZJR19IT1NUQVAgaXMgbm90IHNldAoj
IENPTkZJR19JUFcyMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBXMjIwMCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lXTEFHTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lXTDQ5NjUgaXMgbm90IHNldAojIENP
TkZJR19JV0wzOTQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfTElCRVJUQVMgaXMgbm90IHNldAojIENP
TkZJR19IRVJNRVMgaXMgbm90IHNldAojIENPTkZJR19QNTRfQ09NTU9OIGlzIG5vdCBzZXQKIyBD
T05GSUdfUlQyWDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE5MkNFIGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRMODE5MlNFIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE5MkRFIGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRMODE5MkNVIGlzIG5vdCBzZXQKIyBDT05GSUdfV0wxMjUxIGlzIG5vdCBzZXQK
IyBDT05GSUdfV0wxMlhYX01FTlUgaXMgbm90IHNldAojIENPTkZJR19aRDEyMTFSVyBpcyBub3Qg
c2V0CiMgQ09ORklHX01XSUZJRVggaXMgbm90IHNldAoKIwojIEVuYWJsZSBXaU1BWCAoTmV0d29y
a2luZyBvcHRpb25zKSB0byBzZWUgdGhlIFdpTUFYIGRyaXZlcnMKIwoKIwojIFVTQiBOZXR3b3Jr
IEFkYXB0ZXJzCiMKIyBDT05GSUdfVVNCX0NBVEMgaXMgbm90IHNldAojIENPTkZJR19VU0JfS0FX
RVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BFR0FTVVMgaXMgbm90IHNldAojIENPTkZJR19V
U0JfUlRMODE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9VU0JORVQgaXMgbm90IHNldAojIENP
TkZJR19VU0JfSFNPIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lQSEVUSCBpcyBub3Qgc2V0CkNP
TkZJR19ORVRfUENNQ0lBPXkKIyBDT05GSUdfUENNQ0lBX0lCTVRSIGlzIG5vdCBzZXQKIyBDT05G
SUdfV0FOIGlzIG5vdCBzZXQKCiMKIyBDQUlGIHRyYW5zcG9ydCBkcml2ZXJzCiMKQ09ORklHX0ZE
REk9eQojIENPTkZJR19ERUZYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NLRlAgaXMgbm90IHNldAoj
IENPTkZJR19ISVBQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BQUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NMSVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfRkMgaXMgbm90IHNldApDT05GSUdfTkVUQ09O
U09MRT15CkNPTkZJR19ORVRQT0xMPXkKIyBDT05GSUdfTkVUUE9MTF9UUkFQIGlzIG5vdCBzZXQK
Q09ORklHX05FVF9QT0xMX0NPTlRST0xMRVI9eQojIENPTkZJR19WTVhORVQzIGlzIG5vdCBzZXQK
IyBDT05GSUdfSVNETiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05FIGlzIG5vdCBzZXQKCiMKIyBJ
bnB1dCBkZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19JTlBVVD15CkNPTkZJR19JTlBVVF9GRl9NRU1M
RVNTPXkKQ09ORklHX0lOUFVUX1BPTExERVY9eQpDT05GSUdfSU5QVVRfU1BBUlNFS01BUD15Cgoj
CiMgVXNlcmxhbmQgaW50ZXJmYWNlcwojCkNPTkZJR19JTlBVVF9NT1VTRURFVj15CiMgQ09ORklH
X0lOUFVUX01PVVNFREVWX1BTQVVYIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX01PVVNFREVWX1ND
UkVFTl9YPTEwMjQKQ09ORklHX0lOUFVUX01PVVNFREVWX1NDUkVFTl9ZPTc2OAojIENPTkZJR19J
TlBVVF9KT1lERVYgaXMgbm90IHNldApDT05GSUdfSU5QVVRfRVZERVY9eQojIENPTkZJR19JTlBV
VF9FVkJVRyBpcyBub3Qgc2V0CgojCiMgSW5wdXQgRGV2aWNlIERyaXZlcnMKIwpDT05GSUdfSU5Q
VVRfS0VZQk9BUkQ9eQojIENPTkZJR19LRVlCT0FSRF9BRFA1NTg4IGlzIG5vdCBzZXQKIyBDT05G
SUdfS0VZQk9BUkRfQURQNTU4OSBpcyBub3Qgc2V0CkNPTkZJR19LRVlCT0FSRF9BVEtCRD15CiMg
Q09ORklHX0tFWUJPQVJEX1FUMTA3MCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1FUMjE2
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdf
S0VZQk9BUkRfVENBNjQxNiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xNODMyMyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX01BWDczNTkgaXMgbm90IHNldAojIENPTkZJR19LRVlC
T0FSRF9NQ1MgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9NUFIxMjEgaXMgbm90IHNldAoj
IENPTkZJR19LRVlCT0FSRF9ORVdUT04gaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9PUEVO
Q09SRVMgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9TVE9XQVdBWSBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFWUJPQVJEX1NVTktCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1hUS0JE
IGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX01PVVNFPXkKQ09ORklHX01PVVNFX1BTMj15CkNPTkZJ
R19NT1VTRV9QUzJfQUxQUz15CkNPTkZJR19NT1VTRV9QUzJfTE9HSVBTMlBQPXkKQ09ORklHX01P
VVNFX1BTMl9TWU5BUFRJQ1M9eQpDT05GSUdfTU9VU0VfUFMyX0xJRkVCT09LPXkKQ09ORklHX01P
VVNFX1BTMl9UUkFDS1BPSU5UPXkKIyBDT05GSUdfTU9VU0VfUFMyX0VMQU5URUNIIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTU9VU0VfUFMyX1NFTlRFTElDIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0Vf
UFMyX1RPVUNIS0lUIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfU0VSSUFMIGlzIG5vdCBzZXQK
IyBDT05GSUdfTU9VU0VfQVBQTEVUT1VDSCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0JDTTU5
NzQgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9WU1hYWEFBIGlzIG5vdCBzZXQKIyBDT05GSUdf
TU9VU0VfU1lOQVBUSUNTX0kyQyBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9KT1lTVElDSz15CiMg
Q09ORklHX0pPWVNUSUNLX0FOQUxPRyBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX0EzRCBp
cyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX0FESSBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNU
SUNLX0NPQlJBIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfR0YySyBpcyBub3Qgc2V0CiMg
Q09ORklHX0pPWVNUSUNLX0dSSVAgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19HUklQX01Q
IGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfR1VJTExFTU9UIGlzIG5vdCBzZXQKIyBDT05G
SUdfSk9ZU1RJQ0tfSU5URVJBQ1QgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19TSURFV0lO
REVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfVE1EQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0pPWVNUSUNLX0lGT1JDRSBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1dBUlJJT1IgaXMg
bm90IHNldAojIENPTkZJR19KT1lTVElDS19NQUdFTExBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0pP
WVNUSUNLX1NQQUNFT1JCIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfU1BBQ0VCQUxMIGlz
IG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfU1RJTkdFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0pP
WVNUSUNLX1RXSURKT1kgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19aSEVOSFVBIGlzIG5v
dCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfQVM1MDExIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJ
Q0tfSk9ZRFVNUCBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1hQQUQgaXMgbm90IHNldApD
T05GSUdfSU5QVVRfVEFCTEVUPXkKIyBDT05GSUdfVEFCTEVUX1VTQl9BQ0VDQUQgaXMgbm90IHNl
dAojIENPTkZJR19UQUJMRVRfVVNCX0FJUFRFSyBpcyBub3Qgc2V0CiMgQ09ORklHX1RBQkxFVF9V
U0JfR1RDTyBpcyBub3Qgc2V0CiMgQ09ORklHX1RBQkxFVF9VU0JfSEFOV0FORyBpcyBub3Qgc2V0
CiMgQ09ORklHX1RBQkxFVF9VU0JfS0JUQUIgaXMgbm90IHNldAojIENPTkZJR19UQUJMRVRfVVNC
X1dBQ09NIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX1RPVUNIU0NSRUVOPXkKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fQUQ3ODc5IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQVRNRUxfTVhU
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQlUyMTAxMyBpcyBub3Qgc2V0CiMgQ09O
RklHX1RPVUNIU0NSRUVOX0RZTkFQUk8gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9I
QU1QU0hJUkUgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9FRVRJIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fRlVKSVRTVSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NS
RUVOX0dVTlpFIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fRUxPIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fV0FDT01fVzgwMDEgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9NQVgxMTgwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01DUzUwMDAg
aXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9NVE9VQ0ggaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9JTkVYSU8gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9NSzcx
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1BFTk1PVU5UIGlzIG5vdCBzZXQKIyBD
T05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hSSUdIVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NS
RUVOX1RPVUNIV0lOIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0NPTVBPU0lU
RSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1RPVUNISVQyMTMgaXMgbm90IHNldAoj
IENPTkZJR19UT1VDSFNDUkVFTl9UU0MyMDA3IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JF
RU5fU1QxMjMyIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFBTNjUwN1ggaXMgbm90
IHNldApDT05GSUdfSU5QVVRfTUlTQz15CiMgQ09ORklHX0lOUFVUX0FENzE0WCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lOUFVUX0JNQTE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1BDU1BLUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01NQTg0NTAgaXMgbm90IHNldAojIENPTkZJR19JTlBV
VF9NUFUzMDUwIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVBBTkVMIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5QVVRfV0lTVFJPTl9CVE5TIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVRMQVNf
QlROUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0FUSV9SRU1PVEUgaXMgbm90IHNldAojIENP
TkZJR19JTlBVVF9BVElfUkVNT1RFMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0tFWVNQQU5f
UkVNT1RFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfS1hUSjkgaXMgbm90IHNldAojIENPTkZJ
R19JTlBVVF9QT1dFUk1BVEUgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9ZRUFMSU5LIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5QVVRfQ00xMDkgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9VSU5Q
VVQgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9QQ0Y4NTc0IGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfQURYTDM0WCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0NNQTMwMDAgaXMgbm90IHNl
dAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNPTkZJR19TRVJJTz15CkNPTkZJR19TRVJJT19J
ODA0Mj15CkNPTkZJR19TRVJJT19TRVJQT1JUPXkKIyBDT05GSUdfU0VSSU9fQ1Q4MkM3MTAgaXMg
bm90IHNldAojIENPTkZJR19TRVJJT19QQ0lQUzIgaXMgbm90IHNldApDT05GSUdfU0VSSU9fTElC
UFMyPXkKIyBDT05GSUdfU0VSSU9fUkFXIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fQUxURVJB
X1BTMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklPX1BTMk1VTFQgaXMgbm90IHNldAojIENPTkZJ
R19HQU1FUE9SVCBpcyBub3Qgc2V0CgojCiMgQ2hhcmFjdGVyIGRldmljZXMKIwpDT05GSUdfVlQ9
eQpDT05GSUdfQ09OU09MRV9UUkFOU0xBVElPTlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJ
R19IV19DT05TT0xFPXkKQ09ORklHX1ZUX0hXX0NPTlNPTEVfQklORElORz15CkNPTkZJR19VTklY
OThfUFRZUz15CiMgQ09ORklHX0RFVlBUU19NVUxUSVBMRV9JTlNUQU5DRVMgaXMgbm90IHNldAoj
IENPTkZJR19MRUdBQ1lfUFRZUyBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfTk9OU1RBTkRBUkQ9
eQojIENPTkZJR19ST0NLRVRQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1lDTEFERVMgaXMgbm90
IHNldAojIENPTkZJR19NT1hBX0lOVEVMTElPIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9YQV9TTUFS
VElPIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lOQ0xJTksgaXMgbm90IHNldAojIENPTkZJR19TWU5D
TElOS01QIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lOQ0xJTktfR1QgaXMgbm90IHNldAojIENPTkZJ
R19OT1pPTUkgaXMgbm90IHNldAojIENPTkZJR19JU0kgaXMgbm90IHNldAojIENPTkZJR19OX0hE
TEMgaXMgbm90IHNldAojIENPTkZJR19OX0dTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQUNFX1NJ
TksgaXMgbm90IHNldApDT05GSUdfREVWS01FTT15CiMgQ09ORklHX1NUQUxEUlYgaXMgbm90IHNl
dAoKIwojIFNlcmlhbCBkcml2ZXJzCiMKQ09ORklHX1NFUklBTF84MjUwPXkKQ09ORklHX1NFUklB
TF84MjUwX0NPTlNPTEU9eQpDT05GSUdfRklYX0VBUkxZQ09OX01FTT15CkNPTkZJR19TRVJJQUxf
ODI1MF9QQ0k9eQpDT05GSUdfU0VSSUFMXzgyNTBfUE5QPXkKIyBDT05GSUdfU0VSSUFMXzgyNTBf
Q1MgaXMgbm90IHNldApDT05GSUdfU0VSSUFMXzgyNTBfTlJfVUFSVFM9MzIKQ09ORklHX1NFUklB
TF84MjUwX1JVTlRJTUVfVUFSVFM9NApDT05GSUdfU0VSSUFMXzgyNTBfRVhURU5ERUQ9eQpDT05G
SUdfU0VSSUFMXzgyNTBfTUFOWV9QT1JUUz15CkNPTkZJR19TRVJJQUxfODI1MF9TSEFSRV9JUlE9
eQpDT05GSUdfU0VSSUFMXzgyNTBfREVURUNUX0lSUT15CkNPTkZJR19TRVJJQUxfODI1MF9SU0E9
eQoKIwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1cHBvcnQKIwojIENPTkZJR19TRVJJQUxfTUZE
X0hTVSBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfQ09SRT15CkNPTkZJR19TRVJJQUxfQ09SRV9D
T05TT0xFPXkKIyBDT05GSUdfU0VSSUFMX0pTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9U
SU1CRVJEQUxFIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0FMVEVSQV9KVEFHVUFSVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFUklBTF9BTFRFUkFfVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
UklBTF9QQ0hfVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9YSUxJTlhfUFNfVUFSVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0lQTUlfSEFORExFUiBpcyBub3Qgc2V0CkNPTkZJR19IV19SQU5E
T009eQojIENPTkZJR19IV19SQU5ET01fVElNRVJJT01FTSBpcyBub3Qgc2V0CkNPTkZJR19IV19S
QU5ET01fSU5URUw9eQpDT05GSUdfSFdfUkFORE9NX0FNRD15CkNPTkZJR19IV19SQU5ET01fR0VP
REU9eQpDT05GSUdfSFdfUkFORE9NX1ZJQT15CkNPTkZJR19OVlJBTT15CiMgQ09ORklHX1IzOTY0
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVBQTElDT00gaXMgbm90IHNldAojIENPTkZJR19TT05ZUEkg
aXMgbm90IHNldAoKIwojIFBDTUNJQSBjaGFyYWN0ZXIgZGV2aWNlcwojCiMgQ09ORklHX1NZTkNM
SU5LX0NTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FSRE1BTl80MDAwIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ0FSRE1BTl80MDQwIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBXSVJFTEVTUyBpcyBub3Qgc2V0
CiMgQ09ORklHX01XQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfUEM4NzM2eF9HUElPIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTlNDX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19SQVdfRFJJVkVSIGlzIG5v
dCBzZXQKQ09ORklHX0hQRVQ9eQojIENPTkZJR19IUEVUX01NQVAgaXMgbm90IHNldAojIENPTkZJ
R19IQU5HQ0hFQ0tfVElNRVIgaXMgbm90IHNldAojIENPTkZJR19UQ0dfVFBNIGlzIG5vdCBzZXQK
IyBDT05GSUdfVEVMQ0xPQ0sgaXMgbm90IHNldApDT05GSUdfREVWUE9SVD15CiMgQ09ORklHX1JB
TU9PUFMgaXMgbm90IHNldApDT05GSUdfSTJDPXkKQ09ORklHX0kyQ19CT0FSRElORk89eQpDT05G
SUdfSTJDX0NPTVBBVD15CiMgQ09ORklHX0kyQ19DSEFSREVWIGlzIG5vdCBzZXQKIyBDT05GSUdf
STJDX01VWCBpcyBub3Qgc2V0CkNPTkZJR19JMkNfSEVMUEVSX0FVVE89eQpDT05GSUdfSTJDX0FM
R09CSVQ9eQoKIwojIEkyQyBIYXJkd2FyZSBCdXMgc3VwcG9ydAojCgojCiMgUEMgU01CdXMgaG9z
dCBjb250cm9sbGVyIGRyaXZlcnMKIwojIENPTkZJR19JMkNfQUxJMTUzNSBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19BTEkxNTYzIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FMSTE1WDMgaXMgbm90
IHNldAojIENPTkZJR19JMkNfQU1ENzU2IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FNRDgxMTEg
aXMgbm90IHNldApDT05GSUdfSTJDX0k4MDE9eQojIENPTkZJR19JMkNfSVNDSCBpcyBub3Qgc2V0
CiMgQ09ORklHX0kyQ19QSUlYNCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ORk9SQ0UyIGlzIG5v
dCBzZXQKIyBDT05GSUdfSTJDX1NJUzU1OTUgaXMgbm90IHNldAojIENPTkZJR19JMkNfU0lTNjMw
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJUzk2WCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19W
SUEgaXMgbm90IHNldAojIENPTkZJR19JMkNfVklBUFJPIGlzIG5vdCBzZXQKCiMKIyBBQ1BJIGRy
aXZlcnMKIwojIENPTkZJR19JMkNfU0NNSSBpcyBub3Qgc2V0CgojCiMgSTJDIHN5c3RlbSBidXMg
ZHJpdmVycyAobW9zdGx5IGVtYmVkZGVkIC8gc3lzdGVtLW9uLWNoaXApCiMKIyBDT05GSUdfSTJD
X0lOVEVMX01JRCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19PQ09SRVMgaXMgbm90IHNldAojIENP
TkZJR19JMkNfUENBX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1BYQV9QQ0kgaXMg
bm90IHNldAojIENPTkZJR19JMkNfU0lNVEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1hJTElO
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19FRzIwVCBpcyBub3Qgc2V0CgojCiMgRXh0ZXJuYWwg
STJDL1NNQnVzIGFkYXB0ZXIgZHJpdmVycwojCiMgQ09ORklHX0kyQ19ESU9MQU5fVTJDIGlzIG5v
dCBzZXQKIyBDT05GSUdfSTJDX1BBUlBPUlRfTElHSFQgaXMgbm90IHNldAojIENPTkZJR19JMkNf
VEFPU19FVk0gaXMgbm90IHNldAojIENPTkZJR19JMkNfVElOWV9VU0IgaXMgbm90IHNldAoKIwoj
IE90aGVyIEkyQy9TTUJ1cyBidXMgZHJpdmVycwojCiMgQ09ORklHX0kyQ19TVFVCIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0N4MjAwX0FDQiBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19DT1JF
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0FMR08gaXMgbm90IHNldAojIENPTkZJR19J
MkNfREVCVUdfQlVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJIGlzIG5vdCBzZXQKCiMKIyBQUFMg
c3VwcG9ydAojCiMgQ09ORklHX1BQUyBpcyBub3Qgc2V0CgojCiMgUFBTIGdlbmVyYXRvcnMgc3Vw
cG9ydAojCgojCiMgUFRQIGNsb2NrIHN1cHBvcnQKIwoKIwojIEVuYWJsZSBEZXZpY2UgRHJpdmVy
cyAtPiBQUFMgdG8gc2VlIHRoZSBQVFAgY2xvY2sgb3B0aW9ucy4KIwpDT05GSUdfQVJDSF9XQU5U
X09QVElPTkFMX0dQSU9MSUI9eQojIENPTkZJR19HUElPTElCIGlzIG5vdCBzZXQKIyBDT05GSUdf
VzEgaXMgbm90IHNldApDT05GSUdfUE9XRVJfU1VQUExZPXkKIyBDT05GSUdfUE9XRVJfU1VQUExZ
X0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUERBX1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdf
VEVTVF9QT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfRFMyNzgwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQkFUVEVSWV9EUzI3ODIgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX0JRMjBa
NzUgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX0JRMjd4MDAgaXMgbm90IHNldAojIENPTkZJ
R19CQVRURVJZX01BWDE3MDQwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9NQVgxNzA0MiBp
cyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfTUFYODkwMyBpcyBub3Qgc2V0CkNPTkZJR19IV01P
Tj15CiMgQ09ORklHX0hXTU9OX1ZJRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hXTU9OX0RFQlVHX0NI
SVAgaXMgbm90IHNldAoKIwojIE5hdGl2ZSBkcml2ZXJzCiMKIyBDT05GSUdfU0VOU09SU19BQklU
VUdVUlUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FCSVRVR1VSVTMgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0FENzQxNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQUQ3NDE4
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDIxIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19BRE0xMDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI2IGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BRE0xMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE05MjQwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BRFQ3NDExIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3
NDYyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDcwIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BU0M3NjIxIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19LOFRFTVAgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX0sxMFRFTVAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0ZBTTE1SF9QT1dFUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVNCMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BVFhQMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRFM2MjAgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0RTMTYyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSTVLX0FNQiBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODA1RiBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfRjcxODgyRkcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0Y3NTM3NVMgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0ZTQ0hNRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
Rzc2MEEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0dMNTE4U00gaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0dMNTIwU00gaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0NPUkVURU1Q
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JVDg3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19KQzQyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSU5FQUdFIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19MTTYzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTczIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTc1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19MTTc3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTc4IGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19MTTgwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTgzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19MTTg1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTg3
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTkwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19MTTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTkzIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MVEM0MTUxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0MjE1
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0MjQ1IGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19MVEM0MjYxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTk1MjQxIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTk1MjQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19NQVgxNjA2NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTYxOSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTUFYMTY2OCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFY
NjYzOSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjY0MiBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTUFYNjY1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTlRDX1RIRVJN
SVNUT1IgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDODczNjAgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1BDODc0MjcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDRjg1OTEg
aXMgbm90IHNldAojIENPTkZJR19QTUJVUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0hU
MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NJUzU1OTUgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX1NNTTY2NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRE1FMTczNyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRU1DMTQwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfRU1DMjEwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRU1DNlcyMDEgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1NNU0M0N00xIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19T
TVNDNDdNMTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TTVNDNDdCMzk3IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19TQ0g1NlhYX0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfU0NINTYyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0NINTYzNiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfQURTMTAxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
QURTNzgyOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQU1DNjgyMSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfVEhNQzUwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVAxMDIg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RNUDQwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfVE1QNDIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19WSUFfQ1BVVEVNUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVklBNjg2QSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfVlQxMjExIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19WVDgyMzEgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX1c4Mzc4MUQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc5
MUQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc5MkQgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX1c4Mzc5MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzk1IGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19XODNMNzg1VFMgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX1c4M0w3ODZORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNjI3SEYgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX1c4MzYyN0VIRiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfQVBQTEVTTUMgaXMgbm90IHNldAoKIwojIEFDUEkgZHJpdmVycwojCiMgQ09ORklHX1NFTlNP
UlNfQUNQSV9QT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVRLMDExMCBpcyBub3Qg
c2V0CkNPTkZJR19USEVSTUFMPXkKQ09ORklHX1RIRVJNQUxfSFdNT049eQpDT05GSUdfV0FUQ0hE
T0c9eQojIENPTkZJR19XQVRDSERPR19DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfV0FUQ0hET0df
Tk9XQVlPVVQgaXMgbm90IHNldAoKIwojIFdhdGNoZG9nIERldmljZSBEcml2ZXJzCiMKIyBDT05G
SUdfU09GVF9XQVRDSERPRyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUVVJUkVfV0RUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQURWQU5URUNIX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FMSU0xNTM1X1dE
VCBpcyBub3Qgc2V0CiMgQ09ORklHX0FMSU03MTAxX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0Y3
MTgwOEVfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfU1A1MTAwX1RDTyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NDNTIwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NCQ19GSVRQQzJfV0FUQ0hET0cgaXMg
bm90IHNldAojIENPTkZJR19FVVJPVEVDSF9XRFQgaXMgbm90IHNldAojIENPTkZJR19JQjcwMF9X
RFQgaXMgbm90IHNldAojIENPTkZJR19JQk1BU1IgaXMgbm90IHNldAojIENPTkZJR19XQUZFUl9X
RFQgaXMgbm90IHNldAojIENPTkZJR19JNjMwMEVTQl9XRFQgaXMgbm90IHNldAojIENPTkZJR19J
VENPX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lUODcxMkZfV0RUIGlzIG5vdCBzZXQKIyBDT05G
SUdfSVQ4N19XRFQgaXMgbm90IHNldAojIENPTkZJR19IUF9XQVRDSERPRyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NDMTIwMF9XRFQgaXMgbm90IHNldAojIENPTkZJR19QQzg3NDEzX1dEVCBpcyBub3Qg
c2V0CiMgQ09ORklHX05WX1RDTyBpcyBub3Qgc2V0CiMgQ09ORklHXzYwWFhfV0RUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0JDODM2MF9XRFQgaXMgbm90IHNldAojIENPTkZJR19TQkM3MjQwX1dEVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0NQVTVfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfU01TQ19TQ0gz
MTFYX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NNU0MzN0I3ODdfV0RUIGlzIG5vdCBzZXQKIyBD
T05GSUdfVzgzNjI3SEZfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzNjk3SEZfV0RUIGlzIG5v
dCBzZXQKIyBDT05GSUdfVzgzNjk3VUdfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzODc3Rl9X
RFQgaXMgbm90IHNldAojIENPTkZJR19XODM5NzdGX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX01B
Q0haX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NCQ19FUFhfQzNfV0FUQ0hET0cgaXMgbm90IHNl
dAoKIwojIFBDSS1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCiMgQ09ORklHX1BDSVBDV0FUQ0hET0cg
aXMgbm90IHNldAojIENPTkZJR19XRFRQQ0kgaXMgbm90IHNldAoKIwojIFVTQi1iYXNlZCBXYXRj
aGRvZyBDYXJkcwojCiMgQ09ORklHX1VTQlBDV0FUQ0hET0cgaXMgbm90IHNldApDT05GSUdfU1NC
X1BPU1NJQkxFPXkKCiMKIyBTb25pY3MgU2lsaWNvbiBCYWNrcGxhbmUKIwojIENPTkZJR19TU0Ig
aXMgbm90IHNldApDT05GSUdfQkNNQV9QT1NTSUJMRT15CgojCiMgQnJvYWRjb20gc3BlY2lmaWMg
QU1CQQojCiMgQ09ORklHX0JDTUEgaXMgbm90IHNldApDT05GSUdfTUZEX1NVUFBPUlQ9eQojIENP
TkZJR19NRkRfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF84OFBNODYwWCBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9TTTUwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0hUQ19QQVNJQzMgaXMgbm90
IHNldAojIENPTkZJR19UUFM2MTA1WCBpcyBub3Qgc2V0CiMgQ09ORklHX1RQUzY1MDdYIGlzIG5v
dCBzZXQKIyBDT05GSUdfVFdMNDAzMF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1NUTVBF
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RDMzU4OVggaXMgbm90IHNldAojIENPTkZJR19NRkRf
VE1JTyBpcyBub3Qgc2V0CiMgQ09ORklHX1BNSUNfREE5MDNYIGlzIG5vdCBzZXQKIyBDT05GSUdf
UE1JQ19BRFA1NTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDg5MjUgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfTUFYODk5NyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg4OTk4IGlzIG5v
dCBzZXQKIyBDT05GSUdfTUZEX1dNODQwMCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9XTTgzMVhf
STJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODM1MF9JMkMgaXMgbm90IHNldAojIENPTkZJ
R19NRkRfV004OTk0IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1BDRjUwNjMzIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUJYNTAwX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19NRkRfQ1M1NTM1IGlzIG5v
dCBzZXQKIyBDT05GSUdfTFBDX1NDSCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9SREMzMjFYIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEX0pBTlpfQ01PRElPIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZE
X1ZYODU1IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dMMTI3M19DT1JFIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVHVUxBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVESUFfU1VQUE9SVCBpcyBub3Qg
c2V0CgojCiMgR3JhcGhpY3Mgc3VwcG9ydAojCkNPTkZJR19BR1A9eQojIENPTkZJR19BR1BfQUxJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfQUdQX0FUSSBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9BTUQg
aXMgbm90IHNldApDT05GSUdfQUdQX0FNRDY0PXkKQ09ORklHX0FHUF9JTlRFTD15CiMgQ09ORklH
X0FHUF9OVklESUEgaXMgbm90IHNldAojIENPTkZJR19BR1BfU0lTIGlzIG5vdCBzZXQKIyBDT05G
SUdfQUdQX1NXT1JLUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FHUF9WSUEgaXMgbm90IHNldAojIENP
TkZJR19BR1BfRUZGSUNFT04gaXMgbm90IHNldApDT05GSUdfVkdBX0FSQj15CkNPTkZJR19WR0Ff
QVJCX01BWF9HUFVTPTE2CiMgQ09ORklHX1ZHQV9TV0lUQ0hFUk9PIGlzIG5vdCBzZXQKQ09ORklH
X0RSTT15CkNPTkZJR19EUk1fS01TX0hFTFBFUj15CiMgQ09ORklHX0RSTV9UREZYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFJNX1IxMjggaXMgbm90IHNldAojIENPTkZJR19EUk1fUkFERU9OIGlzIG5v
dCBzZXQKIyBDT05GSUdfRFJNX0k4MTAgaXMgbm90IHNldApDT05GSUdfRFJNX0k5MTU9eQojIENP
TkZJR19EUk1fSTkxNV9LTVMgaXMgbm90IHNldAojIENPTkZJR19EUk1fTUdBIGlzIG5vdCBzZXQK
IyBDT05GSUdfRFJNX1NJUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9WSUEgaXMgbm90IHNldAoj
IENPTkZJR19EUk1fU0FWQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RVQl9QT1VMU0JPIGlzIG5v
dCBzZXQKIyBDT05GSUdfVkdBU1RBVEUgaXMgbm90IHNldApDT05GSUdfVklERU9fT1VUUFVUX0NP
TlRST0w9eQpDT05GSUdfRkI9eQojIENPTkZJR19GSVJNV0FSRV9FRElEIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfRERDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQk9PVF9WRVNBX1NVUFBPUlQgaXMg
bm90IHNldApDT05GSUdfRkJfQ0ZCX0ZJTExSRUNUPXkKQ09ORklHX0ZCX0NGQl9DT1BZQVJFQT15
CkNPTkZJR19GQl9DRkJfSU1BR0VCTElUPXkKIyBDT05GSUdfRkJfQ0ZCX1JFVl9QSVhFTFNfSU5f
QllURSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1NZU19GSUxMUkVDVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZCX1NZU19DT1BZQVJFQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1NZU19JTUFHRUJMSVQg
aXMgbm90IHNldAojIENPTkZJR19GQl9GT1JFSUdOX0VORElBTiBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX1NZU19GT1BTIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfV01UX0dFX1JPUFMgaXMgbm90IHNl
dAojIENPTkZJR19GQl9TVkdBTElCIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUFDTU9ERVMgaXMg
bm90IHNldAojIENPTkZJR19GQl9CQUNLTElHSFQgaXMgbm90IHNldApDT05GSUdfRkJfTU9ERV9I
RUxQRVJTPXkKQ09ORklHX0ZCX1RJTEVCTElUVElORz15CgojCiMgRnJhbWUgYnVmZmVyIGhhcmR3
YXJlIGRyaXZlcnMKIwojIENPTkZJR19GQl9DSVJSVVMgaXMgbm90IHNldAojIENPTkZJR19GQl9Q
TTIgaXMgbm90IHNldAojIENPTkZJR19GQl9DWUJFUjIwMDAgaXMgbm90IHNldAojIENPTkZJR19G
Ql9BUkMgaXMgbm90IHNldAojIENPTkZJR19GQl9BU0lMSUFOVCBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0lNU1RUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVkdBMTYgaXMgbm90IHNldAojIENPTkZJ
R19GQl9VVkVTQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZFU0EgaXMgbm90IHNldApDT05GSUdf
RkJfRUZJPXkKIyBDT05GSUdfRkJfTjQxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0hHQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZCX1MxRDEzWFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTlZJRElB
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUklWQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0k4MTAg
aXMgbm90IHNldAojIENPTkZJR19GQl9MRTgwNTc4IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUFU
Uk9YIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUkFERU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
QVRZMTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
UzMgaXMgbm90IHNldAojIENPTkZJR19GQl9TQVZBR0UgaXMgbm90IHNldAojIENPTkZJR19GQl9T
SVMgaXMgbm90IHNldAojIENPTkZJR19GQl9WSUEgaXMgbm90IHNldAojIENPTkZJR19GQl9ORU9N
QUdJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0tZUk8gaXMgbm90IHNldAojIENPTkZJR19GQl8z
REZYIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVk9PRE9PMSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
X1ZUODYyMyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1RSSURFTlQgaXMgbm90IHNldAojIENPTkZJ
R19GQl9BUksgaXMgbm90IHNldAojIENPTkZJR19GQl9QTTMgaXMgbm90IHNldAojIENPTkZJR19G
Ql9DQVJNSU5FIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfR0VPREUgaXMgbm90IHNldAojIENPTkZJ
R19GQl9VREwgaXMgbm90IHNldAojIENPTkZJR19GQl9WSVJUVUFMIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfTUVUUk9OT01FIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUI4NjJYWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZCX0JST0FEU0hFRVQgaXMgbm90IHNldApDT05GSUdfQkFDS0xJR0hUX0xDRF9T
VVBQT1JUPXkKIyBDT05GSUdfTENEX0NMQVNTX0RFVklDRSBpcyBub3Qgc2V0CkNPTkZJR19CQUNL
TElHSFRfQ0xBU1NfREVWSUNFPXkKQ09ORklHX0JBQ0tMSUdIVF9HRU5FUklDPXkKIyBDT05GSUdf
QkFDS0xJR0hUX1BST0dFQVIgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfQVBQTEUgaXMg
bm90IHNldAojIENPTkZJR19CQUNLTElHSFRfU0FIQVJBIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFD
S0xJR0hUX0FEUDg4NjAgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfQURQODg3MCBpcyBu
b3Qgc2V0CgojCiMgRGlzcGxheSBkZXZpY2Ugc3VwcG9ydAojCiMgQ09ORklHX0RJU1BMQVlfU1VQ
UE9SVCBpcyBub3Qgc2V0CgojCiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09O
RklHX1ZHQV9DT05TT0xFPXkKQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9MTEJBQ0s9eQpDT05GSUdf
VkdBQ09OX1NPRlRfU0NST0xMQkFDS19TSVpFPTY0CkNPTkZJR19EVU1NWV9DT05TT0xFPXkKQ09O
RklHX0ZSQU1FQlVGRkVSX0NPTlNPTEU9eQpDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ERVRF
Q1RfUFJJTUFSWT15CiMgQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEVfUk9UQVRJT04gaXMgbm90
IHNldAojIENPTkZJR19GT05UUyBpcyBub3Qgc2V0CkNPTkZJR19GT05UXzh4OD15CkNPTkZJR19G
T05UXzh4MTY9eQpDT05GSUdfTE9HTz15CiMgQ09ORklHX0xPR09fTElOVVhfTU9OTyBpcyBub3Qg
c2V0CiMgQ09ORklHX0xPR09fTElOVVhfVkdBMTYgaXMgbm90IHNldApDT05GSUdfTE9HT19MSU5V
WF9DTFVUMjI0PXkKQ09ORklHX1NPVU5EPXkKQ09ORklHX1NPVU5EX09TU19DT1JFPXkKQ09ORklH
X1NPVU5EX09TU19DT1JFX1BSRUNMQUlNPXkKQ09ORklHX1NORD15CkNPTkZJR19TTkRfVElNRVI9
eQpDT05GSUdfU05EX1BDTT15CkNPTkZJR19TTkRfSFdERVA9eQpDT05GSUdfU05EX1NFUVVFTkNF
Uj15CkNPTkZJR19TTkRfU0VRX0RVTU1ZPXkKQ09ORklHX1NORF9PU1NFTVVMPXkKQ09ORklHX1NO
RF9NSVhFUl9PU1M9eQpDT05GSUdfU05EX1BDTV9PU1M9eQpDT05GSUdfU05EX1BDTV9PU1NfUExV
R0lOUz15CkNPTkZJR19TTkRfU0VRVUVOQ0VSX09TUz15CkNPTkZJR19TTkRfSFJUSU1FUj15CkNP
TkZJR19TTkRfU0VRX0hSVElNRVJfREVGQVVMVD15CkNPTkZJR19TTkRfRFlOQU1JQ19NSU5PUlM9
eQpDT05GSUdfU05EX1NVUFBPUlRfT0xEX0FQST15CkNPTkZJR19TTkRfVkVSQk9TRV9QUk9DRlM9
eQojIENPTkZJR19TTkRfVkVSQk9TRV9QUklOVEsgaXMgbm90IHNldAojIENPTkZJR19TTkRfREVC
VUcgaXMgbm90IHNldApDT05GSUdfU05EX1ZNQVNURVI9eQpDT05GSUdfU05EX0RNQV9TR0JVRj15
CiMgQ09ORklHX1NORF9SQVdNSURJX1NFUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9PUEwzX0xJ
Ql9TRVEgaXMgbm90IHNldAojIENPTkZJR19TTkRfT1BMNF9MSUJfU0VRIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX1NCQVdFX1NFUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FTVUxMEsxX1NFUSBp
cyBub3Qgc2V0CkNPTkZJR19TTkRfRFJJVkVSUz15CiMgQ09ORklHX1NORF9QQ1NQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0RVTU1ZIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FMT09QIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX1ZJUk1JREkgaXMgbm90IHNldAojIENPTkZJR19TTkRfTVRQQVYg
aXMgbm90IHNldAojIENPTkZJR19TTkRfU0VSSUFMX1UxNjU1MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9NUFU0MDEgaXMgbm90IHNldApDT05GSUdfU05EX1BDST15CiMgQ09ORklHX1NORF9BRDE4
ODkgaXMgbm90IHNldAojIENPTkZJR19TTkRfQUxTMzAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0FMUzQwMDAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQUxJNTQ1MSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9BU0lIUEkgaXMgbm90IHNldAojIENPTkZJR19TTkRfQVRJSVhQIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX0FUSUlYUF9NT0RFTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BVTg4MTAg
aXMgbm90IHNldAojIENPTkZJR19TTkRfQVU4ODIwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FV
ODgzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BVzIgaXMgbm90IHNldAojIENPTkZJR19TTkRf
QVpUMzMyOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9CVDg3WCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9DQTAxMDYgaXMgbm90IHNldAojIENPTkZJR19TTkRfQ01JUENJIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX09YWUdFTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9DUzQyODEgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfQ1M0NlhYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0NTNTUzMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9DUzU1MzVBVURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9D
VFhGSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9EQVJMQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX0dJTkEyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9MQVlMQTIwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX0RBUkxBMjQgaXMgbm90IHNldAojIENPTkZJR19TTkRfR0lOQTI0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0xBWUxBMjQgaXMgbm90IHNldAojIENPTkZJR19TTkRfTU9OQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NORF9NSUEgaXMgbm90IHNldAojIENPTkZJR19TTkRfRUNITzNHIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0lORElHTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTkRJ
R09JTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTkRJR09ESiBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9JTkRJR09JT1ggaXMgbm90IHNldAojIENPTkZJR19TTkRfSU5ESUdPREpYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0VNVTEwSzEgaXMgbm90IHNldAojIENPTkZJR19TTkRfRU1VMTBLMVgg
aXMgbm90IHNldAojIENPTkZJR19TTkRfRU5TMTM3MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9F
TlMxMzcxIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0VTMTkzOCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9FUzE5NjggaXMgbm90IHNldAojIENPTkZJR19TTkRfRk04MDEgaXMgbm90IHNldApDT05G
SUdfU05EX0hEQV9JTlRFTD15CkNPTkZJR19TTkRfSERBX1BSRUFMTE9DX1NJWkU9NjQKQ09ORklH
X1NORF9IREFfSFdERVA9eQojIENPTkZJR19TTkRfSERBX1JFQ09ORklHIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX0hEQV9JTlBVVF9CRUVQIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9JTlBV
VF9KQUNLIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9QQVRDSF9MT0FERVIgaXMgbm90IHNl
dApDT05GSUdfU05EX0hEQV9DT0RFQ19SRUFMVEVLPXkKQ09ORklHX1NORF9IREFfRU5BQkxFX1JF
QUxURUtfUVVJUktTPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQU5BTE9HPXkKQ09ORklHX1NORF9I
REFfQ09ERUNfU0lHTUFURUw9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19WSUE9eQpDT05GSUdfU05E
X0hEQV9DT0RFQ19IRE1JPXkKQ09ORklHX1NORF9IREFfQ09ERUNfQ0lSUlVTPXkKQ09ORklHX1NO
RF9IREFfQ09ERUNfQ09ORVhBTlQ9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19DQTAxMTA9eQpDT05G
SUdfU05EX0hEQV9DT0RFQ19DQTAxMzI9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19DTUVESUE9eQpD
T05GSUdfU05EX0hEQV9DT0RFQ19TSTMwNTQ9eQpDT05GSUdfU05EX0hEQV9HRU5FUklDPXkKIyBD
T05GSUdfU05EX0hEQV9QT1dFUl9TQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEU1AgaXMg
bm90IHNldAojIENPTkZJR19TTkRfSERTUE0gaXMgbm90IHNldAojIENPTkZJR19TTkRfSUNFMTcx
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9JQ0UxNzI0IGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0lOVEVMOFgwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0lOVEVMOFgwTSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9LT1JHMTIxMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9MT0xBIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0xYNjQ2NEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01BRVNUUk8z
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01JWEFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9O
TTI1NiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9QQ1hIUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9SSVBUSURFIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1JNRTMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX1JNRTk2IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1JNRTk2NTIgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfU0lTNzAxOSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TT05JQ1ZJQkVTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX1RSSURFTlQgaXMgbm90IHNldAojIENPTkZJR19TTkRfVklB
ODJYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9WSUE4MlhYX01PREVNIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX1ZJUlRVT1NPIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1ZYMjIyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX1lNRlBDSSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfVVNCPXkKIyBDT05G
SUdfU05EX1VTQl9BVURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfVUExMDEgaXMgbm90
IHNldAojIENPTkZJR19TTkRfVVNCX1VTWDJZIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1VTQl9D
QUlBUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0JfVVMxMjJMIGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX1VTQl82RklSRSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfUENNQ0lBPXkKIyBDT05GSUdf
U05EX1ZYUE9DS0VUIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1BEQVVESU9DRiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9TT0MgaXMgbm90IHNldAojIENPTkZJR19TT1VORF9QUklNRSBpcyBub3Qg
c2V0CkNPTkZJR19ISURfU1VQUE9SVD15CkNPTkZJR19ISUQ9eQpDT05GSUdfSElEUkFXPXkKCiMK
IyBVU0IgSW5wdXQgRGV2aWNlcwojCkNPTkZJR19VU0JfSElEPXkKQ09ORklHX0hJRF9QSUQ9eQpD
T05GSUdfVVNCX0hJRERFVj15CgojCiMgU3BlY2lhbCBISUQgZHJpdmVycwojCkNPTkZJR19ISURf
QTRURUNIPXkKIyBDT05GSUdfSElEX0FDUlVYIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9BUFBMRT15
CkNPTkZJR19ISURfQkVMS0lOPXkKQ09ORklHX0hJRF9DSEVSUlk9eQpDT05GSUdfSElEX0NISUNP
Tlk9eQojIENPTkZJR19ISURfUFJPRElLRVlTIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9DWVBSRVNT
PXkKIyBDT05GSUdfSElEX0RSQUdPTlJJU0UgaXMgbm90IHNldAojIENPTkZJR19ISURfRU1TX0ZG
IGlzIG5vdCBzZXQKQ09ORklHX0hJRF9FWktFWT15CiMgQ09ORklHX0hJRF9IT0xURUsgaXMgbm90
IHNldAojIENPTkZJR19ISURfS0VZVE9VQ0ggaXMgbm90IHNldApDT05GSUdfSElEX0tZRT15CiMg
Q09ORklHX0hJRF9VQ0xPR0lDIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1dBTFRPUCBpcyBub3Qg
c2V0CkNPTkZJR19ISURfR1lSQVRJT049eQojIENPTkZJR19ISURfVFdJTkhBTiBpcyBub3Qgc2V0
CkNPTkZJR19ISURfS0VOU0lOR1RPTj15CiMgQ09ORklHX0hJRF9MQ1BPV0VSIGlzIG5vdCBzZXQK
Q09ORklHX0hJRF9MT0dJVEVDSD15CkNPTkZJR19MT0dJVEVDSF9GRj15CiMgQ09ORklHX0xPR0lS
VU1CTEVQQUQyX0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9HSUc5NDBfRkYgaXMgbm90IHNldApD
T05GSUdfTE9HSVdIRUVMU19GRj15CkNPTkZJR19ISURfTUlDUk9TT0ZUPXkKQ09ORklHX0hJRF9N
T05URVJFWT15CiMgQ09ORklHX0hJRF9NVUxUSVRPVUNIIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9O
VFJJRz15CiMgQ09ORklHX0hJRF9PUlRFSyBpcyBub3Qgc2V0CkNPTkZJR19ISURfUEFOVEhFUkxP
UkQ9eQpDT05GSUdfUEFOVEhFUkxPUkRfRkY9eQpDT05GSUdfSElEX1BFVEFMWU5YPXkKIyBDT05G
SUdfSElEX1BJQ09MQ0QgaXMgbm90IHNldAojIENPTkZJR19ISURfUVVBTlRBIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX1JPQ0NBVCBpcyBub3Qgc2V0CkNPTkZJR19ISURfU0FNU1VORz15CkNPTkZJ
R19ISURfU09OWT15CiMgQ09ORklHX0hJRF9TUEVFRExJTksgaXMgbm90IHNldApDT05GSUdfSElE
X1NVTlBMVVM9eQojIENPTkZJR19ISURfR1JFRU5BU0lBIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X1NNQVJUSk9ZUExVUyBpcyBub3Qgc2V0CkNPTkZJR19ISURfVE9QU0VFRD15CiMgQ09ORklHX0hJ
RF9USFJVU1RNQVNURVIgaXMgbm90IHNldAojIENPTkZJR19ISURfWkVST1BMVVMgaXMgbm90IHNl
dAojIENPTkZJR19ISURfWllEQUNST04gaXMgbm90IHNldApDT05GSUdfVVNCX1NVUFBPUlQ9eQpD
T05GSUdfVVNCX0FSQ0hfSEFTX0hDRD15CkNPTkZJR19VU0JfQVJDSF9IQVNfT0hDST15CkNPTkZJ
R19VU0JfQVJDSF9IQVNfRUhDST15CkNPTkZJR19VU0I9eQpDT05GSUdfVVNCX0RFQlVHPXkKQ09O
RklHX1VTQl9BTk5PVU5DRV9ORVdfREVWSUNFUz15CgojCiMgTWlzY2VsbGFuZW91cyBVU0Igb3B0
aW9ucwojCkNPTkZJR19VU0JfREVWSUNFRlM9eQojIENPTkZJR19VU0JfREVWSUNFX0NMQVNTIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0RZTkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9NT049eQojIENPTkZJR19VU0JfV1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9XVVNCX0NC
QUYgaXMgbm90IHNldAoKIwojIFVTQiBIb3N0IENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklH
X1VTQl9DNjdYMDBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1hIQ0lfSENEIGlzIG5vdCBz
ZXQKQ09ORklHX1VTQl9FSENJX0hDRD15CiMgQ09ORklHX1VTQl9FSENJX1JPT1RfSFVCX1RUIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0VIQ0lfVFRfTkVXU0NIRUQgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfT1hVMjEwSFBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDExNlhfSENEIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDE3NjBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNC
X0lTUDEzNjJfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9PSENJX0hDRD15CiMgQ09ORklHX1VT
Ql9PSENJX0JJR19FTkRJQU5fREVTQyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PSENJX0JJR19F
TkRJQU5fTU1JTyBpcyBub3Qgc2V0CkNPTkZJR19VU0JfT0hDSV9MSVRUTEVfRU5ESUFOPXkKQ09O
RklHX1VTQl9VSENJX0hDRD15CiMgQ09ORklHX1VTQl9TTDgxMV9IQ0QgaXMgbm90IHNldAojIENP
TkZJR19VU0JfUjhBNjY1OTdfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1dIQ0lfSENEIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0hXQV9IQ0QgaXMgbm90IHNldAoKIwojIFVTQiBEZXZpY2Ug
Q2xhc3MgZHJpdmVycwojCiMgQ09ORklHX1VTQl9BQ00gaXMgbm90IHNldApDT05GSUdfVVNCX1BS
SU5URVI9eQojIENPTkZJR19VU0JfV0RNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1RNQyBpcyBu
b3Qgc2V0CgojCiMgTk9URTogVVNCX1NUT1JBR0UgZGVwZW5kcyBvbiBTQ1NJIGJ1dCBCTEtfREVW
X1NEIG1heQojCgojCiMgYWxzbyBiZSBuZWVkZWQ7IHNlZSBVU0JfU1RPUkFHRSBIZWxwIGZvciBt
b3JlIGluZm8KIwpDT05GSUdfVVNCX1NUT1JBR0U9eQojIENPTkZJR19VU0JfU1RPUkFHRV9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX1JFQUxURUsgaXMgbm90IHNldAojIENP
TkZJR19VU0JfU1RPUkFHRV9EQVRBRkFCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0Vf
RlJFRUNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0lTRDIwMCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TVE9SQUdFX1VTQkFUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JB
R0VfU0REUjA5IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfU0REUjU1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfSlVNUFNIT1QgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U1RPUkFHRV9BTEFVREEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9PTkVUT1VDSCBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0tBUk1BIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1NUT1JBR0VfQ1lQUkVTU19BVEFDQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdF
X0VORV9VQjYyNTAgaXMgbm90IHNldAojIENPTkZJR19VU0JfVUFTIGlzIG5vdCBzZXQKQ09ORklH
X1VTQl9MSUJVU1VBTD15CgojCiMgVVNCIEltYWdpbmcgZGV2aWNlcwojCiMgQ09ORklHX1VTQl9N
REM4MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTUlDUk9URUsgaXMgbm90IHNldAoKIwojIFVT
QiBwb3J0IGRyaXZlcnMKIwojIENPTkZJR19VU0JfU0VSSUFMIGlzIG5vdCBzZXQKCiMKIyBVU0Ig
TWlzY2VsbGFuZW91cyBkcml2ZXJzCiMKIyBDT05GSUdfVVNCX0VNSTYyIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX0VNSTI2IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FEVVRVWCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TRVZTRUcgaXMgbm90IHNldAojIENPTkZJR19VU0JfUklPNTAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0xFR09UT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MQ0Qg
aXMgbm90IHNldAojIENPTkZJR19VU0JfTEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZUFJF
U1NfQ1k3QzYzIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZVEhFUk0gaXMgbm90IHNldAojIENP
TkZJR19VU0JfSURNT1VTRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9GVERJX0VMQU4gaXMgbm90
IHNldAojIENPTkZJR19VU0JfQVBQTEVESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NJ
U1VTQlZHQSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9UUkFOQ0VWSUJSQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JT1dBUlJJT1IgaXMgbm90
IHNldAojIENPTkZJR19VU0JfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU0lHSFRGVyBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9ZVVJFWCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURH
RVQgaXMgbm90IHNldAoKIwojIE9URyBhbmQgcmVsYXRlZCBpbmZyYXN0cnVjdHVyZQojCiMgQ09O
RklHX05PUF9VU0JfWENFSVYgaXMgbm90IHNldAojIENPTkZJR19VV0IgaXMgbm90IHNldAojIENP
TkZJR19NTUMgaXMgbm90IHNldAojIENPTkZJR19NRU1TVElDSyBpcyBub3Qgc2V0CkNPTkZJR19O
RVdfTEVEUz15CkNPTkZJR19MRURTX0NMQVNTPXkKCiMKIyBMRUQgZHJpdmVycwojCiMgQ09ORklH
X0xFRFNfTE0zNTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19QQ0E5NTMyIGlzIG5vdCBzZXQK
IyBDT05GSUdfTEVEU19MUDM5NDQgaXMgbm90IHNldAojIENPTkZJR19MRURTX0xQNTUyMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0xFRFNfTFA1NTIzIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19DTEVW
T19NQUlMIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19QQ0E5NTVYIGlzIG5vdCBzZXQKIyBDT05G
SUdfTEVEU19CRDI4MDIgaXMgbm90IHNldAojIENPTkZJR19MRURTX0lOVEVMX1NTNDIwMCBpcyBu
b3Qgc2V0CkNPTkZJR19MRURTX1RSSUdHRVJTPXkKCiMKIyBMRUQgVHJpZ2dlcnMKIwojIENPTkZJ
R19MRURTX1RSSUdHRVJfVElNRVIgaXMgbm90IHNldAojIENPTkZJR19MRURTX1RSSUdHRVJfSEVB
UlRCRUFUIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX0JBQ0tMSUdIVCBpcyBub3Qg
c2V0CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9ERUZBVUxUX09OIGlzIG5vdCBzZXQKCiMKIyBpcHRh
YmxlcyB0cmlnZ2VyIGlzIHVuZGVyIE5ldGZpbHRlciBjb25maWcgKExFRCB0YXJnZXQpCiMKIyBD
T05GSUdfQUNDRVNTSUJJTElUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lORklOSUJBTkQgaXMgbm90
IHNldApDT05GSUdfRURBQz15CgojCiMgUmVwb3J0aW5nIHN1YnN5c3RlbXMKIwojIENPTkZJR19F
REFDX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0VEQUNfREVDT0RFX01DRT15CiMgQ09ORklHX0VE
QUNfTUNFX0lOSiBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUNfTU1fRURBQyBpcyBub3Qgc2V0CkNP
TkZJR19SVENfTElCPXkKQ09ORklHX1JUQ19DTEFTUz15CiMgQ09ORklHX1JUQ19IQ1RPU1lTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBSVEMgaW50ZXJmYWNl
cwojCkNPTkZJR19SVENfSU5URl9TWVNGUz15CkNPTkZJR19SVENfSU5URl9QUk9DPXkKQ09ORklH
X1JUQ19JTlRGX0RFVj15CiMgQ09ORklHX1JUQ19JTlRGX0RFVl9VSUVfRU1VTCBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfVEVTVCBpcyBub3Qgc2V0CgojCiMgSTJDIFJUQyBkcml2ZXJzCiMK
IyBDT05GSUdfUlRDX0RSVl9EUzEzMDcgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTM3
NCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNjcyIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9EUzMyMzIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX01BWDY5MDAgaXMgbm90
IHNldAojIENPTkZJR19SVENfRFJWX1JTNUMzNzIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJW
X0lTTDEyMDggaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0lTTDEyMDIyIGlzIG5vdCBzZXQK
IyBDT05GSUdfUlRDX0RSVl9YMTIwNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU2
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU4MyBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfTTQxVDgwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9CUTMySyBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfUzM1MzkwQSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZf
Rk0zMTMwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SWDg1ODEgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX1JYODAyNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRU0zMDI3IGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SVjMwMjlDMiBpcyBub3Qgc2V0CgojCiMgU1BJIFJU
QyBkcml2ZXJzCiMKCiMKIyBQbGF0Zm9ybSBSVEMgZHJpdmVycwojCkNPTkZJR19SVENfRFJWX0NN
T1M9eQojIENPTkZJR19SVENfRFJWX0RTMTI4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZf
RFMxNTExIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE1NTMgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX0RTMTc0MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfU1RLMTdUQTgg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000OFQ4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfTTQ4VDM1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDhUNTkgaXMgbm90IHNl
dAojIENPTkZJR19SVENfRFJWX01TTTYyNDIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0JR
NDgwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlA1QzAxIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9WMzAyMCBpcyBub3Qgc2V0CgojCiMgb24tQ1BVIFJUQyBkcml2ZXJzCiMKQ09O
RklHX0RNQURFVklDRVM9eQojIENPTkZJR19ETUFERVZJQ0VTX0RFQlVHIGlzIG5vdCBzZXQKCiMK
IyBETUEgRGV2aWNlcwojCiMgQ09ORklHX0lOVEVMX01JRF9ETUFDIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5URUxfSU9BVERNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTUJfRE1BIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENIX0RNQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FVWERJU1BMQVkgaXMgbm90IHNl
dAojIENPTkZJR19VSU8gaXMgbm90IHNldAoKIwojIFZpcnRpbyBkcml2ZXJzCiMKIyBDT05GSUdf
VklSVElPX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJUlRJT19CQUxMT09OIGlzIG5vdCBzZXQK
IyBDT05GSUdfU1RBR0lORyBpcyBub3Qgc2V0CkNPTkZJR19YODZfUExBVEZPUk1fREVWSUNFUz15
CiMgQ09ORklHX0FDRVJIREYgaXMgbm90IHNldAojIENPTkZJR19BU1VTX0xBUFRPUCBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZVSklUU1VfTEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfSFBfQUNDRUwg
aXMgbm90IHNldAojIENPTkZJR19NU0lfTEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFOQVNP
TklDX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTVBBTF9MQVBUT1AgaXMgbm90IHNldAoj
IENPTkZJR19TT05ZX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lERUFQQURfTEFQVE9QIGlz
IG5vdCBzZXQKIyBDT05GSUdfVEhJTktQQURfQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfSERBUFMgaXMgbm90IHNldAojIENPTkZJR19JTlRFTF9NRU5MT1cgaXMgbm90IHNldApDT05G
SUdfRUVFUENfTEFQVE9QPXkKIyBDT05GSUdfQUNQSV9XTUkgaXMgbm90IHNldAojIENPTkZJR19B
Q1BJX0FTVVMgaXMgbm90IHNldAojIENPTkZJR19UT1BTVEFSX0xBUFRPUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0FDUElfVE9TSElCQSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPU0hJQkFfQlRfUkZLSUxM
IGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9DTVBDIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URUxf
SVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX1JUTCBpcyBub3Qgc2V0CiMgQ09ORklHX1hPMTVf
RUJPT0sgaXMgbm90IHNldAojIENPTkZJR19TQU1TVU5HX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOVEVMX09BS1RSQUlMIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FNU1VOR19RMTAgaXMgbm90
IHNldApDT05GSUdfQ0xLU1JDX0k4MjUzPXkKQ09ORklHX0NMS0VWVF9JODI1Mz15CkNPTkZJR19J
ODI1M19MT0NLPXkKQ09ORklHX0NMS0JMRF9JODI1Mz15CkNPTkZJR19JT01NVV9TVVBQT1JUPXkK
IyBDT05GSUdfRE1BUiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJUlRfRFJJVkVSUyBpcyBub3Qgc2V0
CgojCiMgRmlybXdhcmUgRHJpdmVycwojCiMgQ09ORklHX0VERCBpcyBub3Qgc2V0CkNPTkZJR19G
SVJNV0FSRV9NRU1NQVA9eQpDT05GSUdfRUZJX1ZBUlM9eQojIENPTkZJR19ERUxMX1JCVSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0CkNPTkZJR19ETUlJRD15CiMgQ09ORklH
X0RNSV9TWVNGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lTQ1NJX0lCRlRfRklORCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NJR01BIGlzIG5vdCBzZXQKIyBDT05GSUdfR09PR0xFX0ZJUk1XQVJFIGlzIG5v
dCBzZXQKCiMKIyBGaWxlIHN5c3RlbXMKIwojIENPTkZJR19FWFQyX0ZTIGlzIG5vdCBzZXQKQ09O
RklHX0VYVDNfRlM9eQojIENPTkZJR19FWFQzX0RFRkFVTFRTX1RPX09SREVSRUQgaXMgbm90IHNl
dApDT05GSUdfRVhUM19GU19YQVRUUj15CkNPTkZJR19FWFQzX0ZTX1BPU0lYX0FDTD15CkNPTkZJ
R19FWFQzX0ZTX1NFQ1VSSVRZPXkKIyBDT05GSUdfRVhUNF9GUyBpcyBub3Qgc2V0CkNPTkZJR19K
QkQ9eQojIENPTkZJR19KQkRfREVCVUcgaXMgbm90IHNldApDT05GSUdfRlNfTUJDQUNIRT15CiMg
Q09ORklHX1JFSVNFUkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSkZTX0ZTIGlzIG5vdCBzZXQK
IyBDT05GSUdfWEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfR0ZTMl9GUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0JUUkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTklMRlMyX0ZTIGlzIG5vdCBzZXQK
Q09ORklHX0ZTX1BPU0lYX0FDTD15CkNPTkZJR19GSUxFX0xPQ0tJTkc9eQpDT05GSUdfRlNOT1RJ
Rlk9eQpDT05GSUdfRE5PVElGWT15CkNPTkZJR19JTk9USUZZX1VTRVI9eQojIENPTkZJR19GQU5P
VElGWSBpcyBub3Qgc2V0CkNPTkZJR19RVU9UQT15CkNPTkZJR19RVU9UQV9ORVRMSU5LX0lOVEVS
RkFDRT15CiMgQ09ORklHX1BSSU5UX1FVT1RBX1dBUk5JTkcgaXMgbm90IHNldAojIENPTkZJR19R
VU9UQV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19RVU9UQV9UUkVFPXkKIyBDT05GSUdfUUZNVF9W
MSBpcyBub3Qgc2V0CkNPTkZJR19RRk1UX1YyPXkKQ09ORklHX1FVT1RBQ1RMPXkKQ09ORklHX0FV
VE9GUzRfRlM9eQojIENPTkZJR19GVVNFX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0dFTkVSSUNfQUNM
PXkKCiMKIyBDYWNoZXMKIwojIENPTkZJR19GU0NBQ0hFIGlzIG5vdCBzZXQKCiMKIyBDRC1ST00v
RFZEIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0lTTzk2NjBfRlM9eQpDT05GSUdfSk9MSUVUPXkKQ09O
RklHX1pJU09GUz15CiMgQ09ORklHX1VERl9GUyBpcyBub3Qgc2V0CgojCiMgRE9TL0ZBVC9OVCBG
aWxlc3lzdGVtcwojCkNPTkZJR19GQVRfRlM9eQpDT05GSUdfTVNET1NfRlM9eQpDT05GSUdfVkZB
VF9GUz15CkNPTkZJR19GQVRfREVGQVVMVF9DT0RFUEFHRT00MzcKQ09ORklHX0ZBVF9ERUZBVUxU
X0lPQ0hBUlNFVD0iaXNvODg1OS0xIgojIENPTkZJR19OVEZTX0ZTIGlzIG5vdCBzZXQKCiMKIyBQ
c2V1ZG8gZmlsZXN5c3RlbXMKIwpDT05GSUdfUFJPQ19GUz15CkNPTkZJR19QUk9DX0tDT1JFPXkK
Q09ORklHX1BST0NfVk1DT1JFPXkKQ09ORklHX1BST0NfU1lTQ1RMPXkKQ09ORklHX1BST0NfUEFH
RV9NT05JVE9SPXkKQ09ORklHX1NZU0ZTPXkKQ09ORklHX1RNUEZTPXkKQ09ORklHX1RNUEZTX1BP
U0lYX0FDTD15CkNPTkZJR19UTVBGU19YQVRUUj15CkNPTkZJR19IVUdFVExCRlM9eQpDT05GSUdf
SFVHRVRMQl9QQUdFPXkKIyBDT05GSUdfQ09ORklHRlNfRlMgaXMgbm90IHNldApDT05GSUdfTUlT
Q19GSUxFU1lTVEVNUz15CiMgQ09ORklHX0FERlNfRlMgaXMgbm90IHNldAojIENPTkZJR19BRkZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRUNSWVBUX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSEZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSEZTUExVU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0JF
RlNfRlMgaXMgbm90IHNldAojIENPTkZJR19CRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19FRlNf
RlMgaXMgbm90IHNldAojIENPTkZJR19MT0dGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQU1GUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NRVUFTSEZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVlhGU19GUyBp
cyBub3Qgc2V0CiMgQ09ORklHX01JTklYX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfT01GU19GUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0hQRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19RTlg0RlNfRlMg
aXMgbm90IHNldAojIENPTkZJR19ST01GU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BTVE9SRSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NZU1ZfRlMgaXMgbm90IHNldAojIENPTkZJR19VRlNfRlMgaXMg
bm90IHNldApDT05GSUdfTkVUV09SS19GSUxFU1lTVEVNUz15CkNPTkZJR19ORlNfRlM9eQpDT05G
SUdfTkZTX1YzPXkKQ09ORklHX05GU19WM19BQ0w9eQpDT05GSUdfTkZTX1Y0PXkKIyBDT05GSUdf
TkZTX1Y0XzEgaXMgbm90IHNldApDT05GSUdfUk9PVF9ORlM9eQojIENPTkZJR19ORlNfVVNFX0xF
R0FDWV9ETlMgaXMgbm90IHNldApDT05GSUdfTkZTX1VTRV9LRVJORUxfRE5TPXkKIyBDT05GSUdf
TkZTX1VTRV9ORVdfSURNQVBQRVIgaXMgbm90IHNldAojIENPTkZJR19ORlNEIGlzIG5vdCBzZXQK
Q09ORklHX0xPQ0tEPXkKQ09ORklHX0xPQ0tEX1Y0PXkKQ09ORklHX05GU19BQ0xfU1VQUE9SVD15
CkNPTkZJR19ORlNfQ09NTU9OPXkKQ09ORklHX1NVTlJQQz15CkNPTkZJR19TVU5SUENfR1NTPXkK
IyBDT05GSUdfQ0VQSF9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NJRlMgaXMgbm90IHNldAojIENP
TkZJR19OQ1BfRlMgaXMgbm90IHNldAojIENPTkZJR19DT0RBX0ZTIGlzIG5vdCBzZXQKIyBDT05G
SUdfQUZTX0ZTIGlzIG5vdCBzZXQKCiMKIyBQYXJ0aXRpb24gVHlwZXMKIwpDT05GSUdfUEFSVElU
SU9OX0FEVkFOQ0VEPXkKIyBDT05GSUdfQUNPUk5fUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklH
X09TRl9QQVJUSVRJT049eQpDT05GSUdfQU1JR0FfUEFSVElUSU9OPXkKIyBDT05GSUdfQVRBUklf
UEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklHX01BQ19QQVJUSVRJT049eQpDT05GSUdfTVNET1Nf
UEFSVElUSU9OPXkKQ09ORklHX0JTRF9ESVNLTEFCRUw9eQpDT05GSUdfTUlOSVhfU1VCUEFSVElU
SU9OPXkKQ09ORklHX1NPTEFSSVNfWDg2X1BBUlRJVElPTj15CkNPTkZJR19VTklYV0FSRV9ESVNL
TEFCRUw9eQojIENPTkZJR19MRE1fUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklHX1NHSV9QQVJU
SVRJT049eQojIENPTkZJR19VTFRSSVhfUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklHX1NVTl9Q
QVJUSVRJT049eQpDT05GSUdfS0FSTUFfUEFSVElUSU9OPXkKQ09ORklHX0VGSV9QQVJUSVRJT049
eQojIENPTkZJR19TWVNWNjhfUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklHX05MUz15CkNPTkZJ
R19OTFNfREVGQVVMVD0idXRmOCIKQ09ORklHX05MU19DT0RFUEFHRV80Mzc9eQojIENPTkZJR19O
TFNfQ09ERVBBR0VfNzM3IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNf
Q09ERVBBR0VfODUyIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NSBpcyBub3Qg
c2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09E
RVBBR0VfODYwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MSBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBB
R0VfODYzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NCBpcyBub3Qgc2V0CiMg
Q09ORklHX05MU19DT0RFUEFHRV84NjUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
ODY2IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2OSBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19DT0RFUEFHRV85MzYgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTUw
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzkzMiBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODc0IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfOCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19D
T0RFUEFHRV8xMjUwIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzEyNTEgaXMgbm90
IHNldApDT05GSUdfTkxTX0FTQ0lJPXkKQ09ORklHX05MU19JU084ODU5XzE9eQojIENPTkZJR19O
TFNfSVNPODg1OV8yIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMyBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19JU084ODU5XzQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV81
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNiBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19JU084ODU5XzcgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV85IGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0lTTzg4NTlfMTMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8x
NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzE1IGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0tPSThfUiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19LT0k4X1UgaXMgbm90IHNldApDT05G
SUdfTkxTX1VURjg9eQoKIwojIEtlcm5lbCBoYWNraW5nCiMKQ09ORklHX1RSQUNFX0lSUUZMQUdT
X1NVUFBPUlQ9eQpDT05GSUdfUFJJTlRLX1RJTUU9eQpDT05GSUdfREVGQVVMVF9NRVNTQUdFX0xP
R0xFVkVMPTQKIyBDT05GSUdfRU5BQkxFX1dBUk5fREVQUkVDQVRFRCBpcyBub3Qgc2V0CkNPTkZJ
R19FTkFCTEVfTVVTVF9DSEVDSz15CkNPTkZJR19GUkFNRV9XQVJOPTIwNDgKQ09ORklHX01BR0lD
X1NZU1JRPXkKIyBDT05GSUdfU1RSSVBfQVNNX1NZTVMgaXMgbm90IHNldAojIENPTkZJR19VTlVT
RURfU1lNQk9MUyBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19GUz15CiMgQ09ORklHX0hFQURFUlNf
Q0hFQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRUNUSU9OX01JU01BVENIIGlzIG5vdCBz
ZXQKQ09ORklHX0RFQlVHX0tFUk5FTD15CiMgQ09ORklHX0RFQlVHX1NISVJRIGlzIG5vdCBzZXQK
IyBDT05GSUdfTE9DS1VQX0RFVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFSRExPQ0tVUF9E
RVRFQ1RPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFVEVDVF9IVU5HX1RBU0sgaXMgbm90IHNldAoj
IENPTkZJR19TQ0hFRF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19TQ0hFRFNUQVRTPXkKQ09ORklH
X1RJTUVSX1NUQVRTPXkKIyBDT05GSUdfREVCVUdfT0JKRUNUUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NMVUJfREVCVUdfT04gaXMgbm90IHNldAojIENPTkZJR19TTFVCX1NUQVRTIGlzIG5vdCBzZXQK
IyBDT05GSUdfREVCVUdfS01FTUxFQUsgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19SVF9NVVRF
WEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRfTVVURVhfVEVTVEVSIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfU1BJTkxPQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19NVVRFWEVTIGlzIG5v
dCBzZXQKIyBDT05GSUdfREVCVUdfTE9DS19BTExPQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BST1ZF
X0xPQ0tJTkcgaXMgbm90IHNldAojIENPTkZJR19TUEFSU0VfUkNVX1BPSU5URVIgaXMgbm90IHNl
dAojIENPTkZJR19MT0NLX1NUQVQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19BVE9NSUNfU0xF
RVAgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19MT0NLSU5HX0FQSV9TRUxGVEVTVFMgaXMgbm90
IHNldApDT05GSUdfU1RBQ0tUUkFDRT15CkNPTkZJR19ERUJVR19TVEFDS19VU0FHRT15CiMgQ09O
RklHX0RFQlVHX0tPQkpFQ1QgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19ISUdITUVNIGlzIG5v
dCBzZXQKQ09ORklHX0RFQlVHX0JVR1ZFUkJPU0U9eQojIENPTkZJR19ERUJVR19JTkZPIGlzIG5v
dCBzZXQKIyBDT05GSUdfREVCVUdfVk0gaXMgbm90IHNldAojIENPTkZJR19ERUJVR19WSVJUVUFM
IGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfV1JJVEVDT1VOVCBpcyBub3Qgc2V0CkNPTkZJR19E
RUJVR19NRU1PUllfSU5JVD15CiMgQ09ORklHX0RFQlVHX0xJU1QgaXMgbm90IHNldAojIENPTkZJ
R19URVNUX0xJU1RfU09SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NHIGlzIG5vdCBzZXQK
IyBDT05GSUdfREVCVUdfTk9USUZJRVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfQ1JFREVO
VElBTFMgaXMgbm90IHNldApDT05GSUdfQVJDSF9XQU5UX0ZSQU1FX1BPSU5URVJTPXkKQ09ORklH
X0ZSQU1FX1BPSU5URVI9eQojIENPTkZJR19CT09UX1BSSU5US19ERUxBWSBpcyBub3Qgc2V0CiMg
Q09ORklHX1JDVV9UT1JUVVJFX1RFU1QgaXMgbm90IHNldApDT05GSUdfUkNVX0NQVV9TVEFMTF9U
SU1FT1VUPTYwCiMgQ09ORklHX0tQUk9CRVNfU0FOSVRZX1RFU1QgaXMgbm90IHNldAojIENPTkZJ
R19CQUNLVFJBQ0VfU0VMRl9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfQkxPQ0tfRVhU
X0RFVlQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19GT1JDRV9XRUFLX1BFUl9DUFUgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19QRVJfQ1BVX01BUFMgaXMgbm90IHNldAojIENPTkZJR19MS0RU
TSBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9OT1RJRklFUl9FUlJPUl9JTkpFQ1QgaXMgbm90IHNl
dAojIENPTkZJR19GQVVMVF9JTkpFQ1RJT04gaXMgbm90IHNldAojIENPTkZJR19MQVRFTkNZVE9Q
IGlzIG5vdCBzZXQKQ09ORklHX1NZU0NUTF9TWVNDQUxMX0NIRUNLPXkKQ09ORklHX0FSQ0hfSEFT
X0RFQlVHX1NUUklDVF9VU0VSX0NPUFlfQ0hFQ0tTPXkKIyBDT05GSUdfREVCVUdfU1RSSUNUX1VT
RVJfQ09QWV9DSEVDS1MgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19QQUdFQUxMT0MgaXMgbm90
IHNldApDT05GSUdfVVNFUl9TVEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfTk9QX1RSQUNFUj15
CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNFUj15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX0dSQVBI
X1RSQUNFUj15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX0dSQVBIX0ZQX1RFU1Q9eQpDT05GSUdfSEFW
RV9GVU5DVElPTl9UUkFDRV9NQ09VTlRfVEVTVD15CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRSQUNF
PXkKQ09ORklHX0hBVkVfRlRSQUNFX01DT1VOVF9SRUNPUkQ9eQpDT05GSUdfSEFWRV9TWVNDQUxM
X1RSQUNFUE9JTlRTPXkKQ09ORklHX0hBVkVfQ19SRUNPUkRNQ09VTlQ9eQpDT05GSUdfUklOR19C
VUZGRVI9eQpDT05GSUdfRVZFTlRfVFJBQ0lORz15CkNPTkZJR19FVkVOVF9QT1dFUl9UUkFDSU5H
X0RFUFJFQ0FURUQ9eQpDT05GSUdfQ09OVEVYVF9TV0lUQ0hfVFJBQ0VSPXkKQ09ORklHX1RSQUNJ
Tkc9eQpDT05GSUdfR0VORVJJQ19UUkFDRVI9eQpDT05GSUdfVFJBQ0lOR19TVVBQT1JUPXkKQ09O
RklHX0ZUUkFDRT15CiMgQ09ORklHX0ZVTkNUSU9OX1RSQUNFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X0lSUVNPRkZfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NIRURfVFJBQ0VSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRlRSQUNFX1NZU0NBTExTIGlzIG5vdCBzZXQKQ09ORklHX0JSQU5DSF9QUk9G
SUxFX05PTkU9eQojIENPTkZJR19QUk9GSUxFX0FOTk9UQVRFRF9CUkFOQ0hFUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1BST0ZJTEVfQUxMX0JSQU5DSEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RBQ0tf
VFJBQ0VSIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfSU9fVFJBQ0U9eQpDT05GSUdfS1BST0JF
X0VWRU5UPXkKIyBDT05GSUdfRlRSQUNFX1NUQVJUVVBfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklH
X01NSU9UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1JJTkdfQlVGRkVSX0JFTkNITUFSSyBpcyBu
b3Qgc2V0CkNPTkZJR19QUk9WSURFX09IQ0kxMzk0X0RNQV9JTklUPXkKIyBDT05GSUdfRFlOQU1J
Q19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNQV9BUElfREVCVUcgaXMgbm90IHNldAojIENP
TkZJR19BVE9NSUM2NF9TRUxGVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRVMgaXMgbm90
IHNldApDT05GSUdfSEFWRV9BUkNIX0tHREI9eQojIENPTkZJR19LR0RCIGlzIG5vdCBzZXQKQ09O
RklHX0hBVkVfQVJDSF9LTUVNQ0hFQ0s9eQojIENPTkZJR19LTUVNQ0hFQ0sgaXMgbm90IHNldAoj
IENPTkZJR19URVNUX0tTVFJUT1ggaXMgbm90IHNldAojIENPTkZJR19TVFJJQ1RfREVWTUVNIGlz
IG5vdCBzZXQKQ09ORklHX1g4Nl9WRVJCT1NFX0JPT1RVUD15CkNPTkZJR19FQVJMWV9QUklOVEs9
eQpDT05GSUdfRUFSTFlfUFJJTlRLX0RCR1A9eQpDT05GSUdfREVCVUdfU1RBQ0tPVkVSRkxPVz15
CiMgQ09ORklHX1g4Nl9QVERVTVAgaXMgbm90IHNldApDT05GSUdfREVCVUdfUk9EQVRBPXkKIyBD
T05GSUdfREVCVUdfUk9EQVRBX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TRVRfTU9E
VUxFX1JPTlggaXMgbm90IHNldApDT05GSUdfREVCVUdfTlhfVEVTVD1tCkNPTkZJR19ET1VCTEVG
QVVMVD15CiMgQ09ORklHX0lPTU1VX1NUUkVTUyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX01NSU9U
UkFDRV9TVVBQT1JUPXkKIyBDT05GSUdfWDg2X0RFQ09ERVJfU0VMRlRFU1QgaXMgbm90IHNldApD
T05GSUdfSU9fREVMQVlfVFlQRV8wWDgwPTAKQ09ORklHX0lPX0RFTEFZX1RZUEVfMFhFRD0xCkNP
TkZJR19JT19ERUxBWV9UWVBFX1VERUxBWT0yCkNPTkZJR19JT19ERUxBWV9UWVBFX05PTkU9MwpD
T05GSUdfSU9fREVMQVlfMFg4MD15CiMgQ09ORklHX0lPX0RFTEFZXzBYRUQgaXMgbm90IHNldAoj
IENPTkZJR19JT19ERUxBWV9VREVMQVkgaXMgbm90IHNldAojIENPTkZJR19JT19ERUxBWV9OT05F
IGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSU9fREVMQVlfVFlQRT0wCkNPTkZJR19ERUJVR19C
T09UX1BBUkFNUz15CiMgQ09ORklHX0NQQV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19PUFRJTUla
RV9JTkxJTklORz15CgojCiMgU2VjdXJpdHkgb3B0aW9ucwojCkNPTkZJR19LRVlTPXkKQ09ORklH
X0tFWVNfREVCVUdfUFJPQ19LRVlTPXkKIyBDT05GSUdfU0VDVVJJVFlfRE1FU0dfUkVTVFJJQ1Qg
aXMgbm90IHNldApDT05GSUdfU0VDVVJJVFk9eQojIENPTkZJR19TRUNVUklUWUZTIGlzIG5vdCBz
ZXQKQ09ORklHX1NFQ1VSSVRZX05FVFdPUks9eQojIENPTkZJR19TRUNVUklUWV9ORVRXT1JLX1hG
Uk0gaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9QQVRIIGlzIG5vdCBzZXQKQ09ORklHX0xT
TV9NTUFQX01JTl9BRERSPTY1NTM2CkNPTkZJR19TRUNVUklUWV9TRUxJTlVYPXkKQ09ORklHX1NF
Q1VSSVRZX1NFTElOVVhfQk9PVFBBUkFNPXkKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfQk9PVFBB
UkFNX1ZBTFVFPTEKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfRElTQUJMRT15CkNPTkZJR19TRUNV
UklUWV9TRUxJTlVYX0RFVkVMT1A9eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9BVkNfU1RBVFM9
eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9DSEVDS1JFUVBST1RfVkFMVUU9MQojIENPTkZJR19T
RUNVUklUWV9TRUxJTlVYX1BPTElDWURCX1ZFUlNJT05fTUFYIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VDVVJJVFlfU01BQ0sgaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9UT01PWU8gaXMgbm90
IHNldAojIENPTkZJR19TRUNVUklUWV9BUFBBUk1PUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lNQSBp
cyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX1NFTElOVVg9eQojIENPTkZJR19ERUZB
VUxUX1NFQ1VSSVRZX0RBQyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZPSJzZWxp
bnV4IgpDT05GSUdfQ1JZUFRPPXkKCiMKIyBDcnlwdG8gY29yZSBvciBoZWxwZXIKIwpDT05GSUdf
Q1JZUFRPX0FMR0FQST15CkNPTkZJR19DUllQVE9fQUxHQVBJMj15CkNPTkZJR19DUllQVE9fQUVB
RD15CkNPTkZJR19DUllQVE9fQUVBRDI9eQpDT05GSUdfQ1JZUFRPX0JMS0NJUEhFUj15CkNPTkZJ
R19DUllQVE9fQkxLQ0lQSEVSMj15CkNPTkZJR19DUllQVE9fSEFTSD15CkNPTkZJR19DUllQVE9f
SEFTSDI9eQpDT05GSUdfQ1JZUFRPX1JORzI9eQpDT05GSUdfQ1JZUFRPX1BDT01QMj15CkNPTkZJ
R19DUllQVE9fTUFOQUdFUj15CkNPTkZJR19DUllQVE9fTUFOQUdFUjI9eQpDT05GSUdfQ1JZUFRP
X01BTkFHRVJfRElTQUJMRV9URVNUUz15CiMgQ09ORklHX0NSWVBUT19HRjEyOE1VTCBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19OVUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1BDUllQ
VCBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fV09SS1FVRVVFPXkKIyBDT05GSUdfQ1JZUFRPX0NS
WVBURCBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fQVVUSEVOQz15CiMgQ09ORklHX0NSWVBUT19U
RVNUIGlzIG5vdCBzZXQKCiMKIyBBdXRoZW50aWNhdGVkIEVuY3J5cHRpb24gd2l0aCBBc3NvY2lh
dGVkIERhdGEKIwojIENPTkZJR19DUllQVE9fQ0NNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRP
X0dDTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TRVFJViBpcyBub3Qgc2V0CgojCiMgQmxv
Y2sgbW9kZXMKIwpDT05GSUdfQ1JZUFRPX0NCQz15CiMgQ09ORklHX0NSWVBUT19DVFIgaXMgbm90
IHNldAojIENPTkZJR19DUllQVE9fQ1RTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0VDQiBp
cyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19MUlcgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
UENCQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19YVFMgaXMgbm90IHNldAoKIwojIEhhc2gg
bW9kZXMKIwpDT05GSUdfQ1JZUFRPX0hNQUM9eQojIENPTkZJR19DUllQVE9fWENCQyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19WTUFDIGlzIG5vdCBzZXQKCiMKIyBEaWdlc3QKIwojIENPTkZJ
R19DUllQVE9fQ1JDMzJDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NSQzMyQ19JTlRFTCBp
cyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19HSEFTSCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBU
T19NRDQgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX01ENT15CiMgQ09ORklHX0NSWVBUT19NSUNI
QUVMX01JQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQxMjggaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fUk1EMTYwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDI1NiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQzMjAgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX1NI
QTE9eQojIENPTkZJR19DUllQVE9fU0hBMjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NI
QTUxMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19UR1IxOTIgaXMgbm90IHNldAojIENPTkZJ
R19DUllQVE9fV1A1MTIgaXMgbm90IHNldAoKIwojIENpcGhlcnMKIwpDT05GSUdfQ1JZUFRPX0FF
Uz15CkNPTkZJR19DUllQVE9fQUVTXzU4Nj15CiMgQ09ORklHX0NSWVBUT19BRVNfTklfSU5URUwg
aXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQU5VQklTIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBU
T19BUkM0PXkKIyBDT05GSUdfQ1JZUFRPX0JMT1dGSVNIIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZ
UFRPX0NBTUVMTElBIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NBU1Q1IGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1JZUFRPX0NBU1Q2IGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19ERVM9eQojIENP
TkZJR19DUllQVE9fRkNSWVBUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0tIQVpBRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TQUxTQTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRP
X1NBTFNBMjBfNTg2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFRUQgaXMgbm90IHNldAoj
IENPTkZJR19DUllQVE9fU0VSUEVOVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19URUEgaXMg
bm90IHNldAojIENPTkZJR19DUllQVE9fVFdPRklTSCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBU
T19UV09GSVNIXzU4NiBpcyBub3Qgc2V0CgojCiMgQ29tcHJlc3Npb24KIwojIENPTkZJR19DUllQ
VE9fREVGTEFURSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19aTElCIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX0xaTyBpcyBub3Qgc2V0CgojCiMgUmFuZG9tIE51bWJlciBHZW5lcmF0aW9u
CiMKIyBDT05GSUdfQ1JZUFRPX0FOU0lfQ1BSTkcgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
VVNFUl9BUElfSEFTSCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19VU0VSX0FQSV9TS0NJUEhF
UiBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fSFc9eQojIENPTkZJR19DUllQVE9fREVWX1BBRExP
Q0sgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX0dFT0RFIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX0RFVl9ISUZOXzc5NVggaXMgbm90IHNldApDT05GSUdfSEFWRV9LVk09eQpDT05G
SUdfVklSVFVBTElaQVRJT049eQojIENPTkZJR19LVk0gaXMgbm90IHNldAojIENPTkZJR19WSE9T
VF9ORVQgaXMgbm90IHNldAojIENPTkZJR19MR1VFU1QgaXMgbm90IHNldApDT05GSUdfQklOQVJZ
X1BSSU5URj15CgojCiMgTGlicmFyeSByb3V0aW5lcwojCkNPTkZJR19CSVRSRVZFUlNFPXkKQ09O
RklHX0dFTkVSSUNfRklORF9GSVJTVF9CSVQ9eQojIENPTkZJR19DUkNfQ0NJVFQgaXMgbm90IHNl
dAojIENPTkZJR19DUkMxNiBpcyBub3Qgc2V0CkNPTkZJR19DUkNfVDEwRElGPXkKIyBDT05GSUdf
Q1JDX0lUVV9UIGlzIG5vdCBzZXQKQ09ORklHX0NSQzMyPXkKIyBDT05GSUdfQ1JDNyBpcyBub3Qg
c2V0CiMgQ09ORklHX0xJQkNSQzMyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQzggaXMgbm90IHNl
dApDT05GSUdfQVVESVRfR0VORVJJQz15CkNPTkZJR19aTElCX0lORkxBVEU9eQpDT05GSUdfTFpP
X0NPTVBSRVNTPXkKQ09ORklHX0xaT19ERUNPTVBSRVNTPXkKQ09ORklHX1haX0RFQz15CkNPTkZJ
R19YWl9ERUNfWDg2PXkKQ09ORklHX1haX0RFQ19QT1dFUlBDPXkKQ09ORklHX1haX0RFQ19JQTY0
PXkKQ09ORklHX1haX0RFQ19BUk09eQpDT05GSUdfWFpfREVDX0FSTVRIVU1CPXkKQ09ORklHX1ha
X0RFQ19TUEFSQz15CkNPTkZJR19YWl9ERUNfQkNKPXkKIyBDT05GSUdfWFpfREVDX1RFU1QgaXMg
bm90IHNldApDT05GSUdfREVDT01QUkVTU19HWklQPXkKQ09ORklHX0RFQ09NUFJFU1NfQlpJUDI9
eQpDT05GSUdfREVDT01QUkVTU19MWk1BPXkKQ09ORklHX0RFQ09NUFJFU1NfWFo9eQpDT05GSUdf
REVDT01QUkVTU19MWk89eQpDT05GSUdfSEFTX0lPTUVNPXkKQ09ORklHX0hBU19JT1BPUlQ9eQpD
T05GSUdfSEFTX0RNQT15CkNPTkZJR19DSEVDS19TSUdOQVRVUkU9eQpDT05GSUdfQ1BVX1JNQVA9
eQpDT05GSUdfTkxBVFRSPXkKQ09ORklHX0FWRVJBR0U9eQojIENPTkZJR19DT1JESUMgaXMgbm90
IHNldAo=
--000e0cd2e1f4a3cd7d04ab4e1fdb--
