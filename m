Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1E3QKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:10:22 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:58566 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab1E3QKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:10:19 -0400
From: "Witold Baryluk" <baryluk@smp.if.uj.edu.pl>
Date: Mon, 30 May 2011 18:10:14 +0200
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Kernel OOPS in function_graph_tracer due to the
 44259b1abfaa8bb819d25d41d71e8e33e25dd36a commit (x86-64: Move vread_tsc
 into a new file with sensible options)
Message-ID: <20110530161014.GS25813@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-27823-1306771816-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-27823-1306771816-0001-2
Content-Type: multipart/mixed; boundary="MdJ3p2aQbVp3YFXz"
Content-Disposition: inline


--MdJ3p2aQbVp3YFXz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I found yesterday a problem when booting system on Pentium-M, 32-bit.

I got approximetly this

[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3199.363 MHz processor.
[    0.020197] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6398.72 BogoMIPS (lpj=3D31993630)
[    0.020763] pid_max: default: 32768 minimum: 301
[    0.022972] Mount-cache hash table entries: 512
[    0.040440] CPU: Intel Pentium III (Katmai) stepping 03
[    0.042789] ftrace: allocating 6263 entries in 13 pages
[    0.062128] Performance Events:=20
[    0.062505] no APIC, boot with the "lapic" boot parameter to force-enabl=
e it.
[    0.062818] no hardware sampling interrupt available.
[    0.063038] Broken PMU hardware detected, using software events only.
[    0.072671] Testing tracer nop: PASSED
[    0.073477] NMI watchdog disabled (cpu0): hardware events not enabled
[    0.077682] devtmpfs: initialized
[    0.090118] kworker/u:0 used greatest stack depth: 6840 bytes left
[    0.105247] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.112515] kworker/u:0 used greatest stack depth: 6700 bytes left
[    0.198527] bio: create slab <bio-0> at 0
[    0.212671] Switching to clocksource pit
[    0.882202] kworker/u:0 used greatest stack depth: 6636 bytes left
[    1.070749] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)
[    1.114000] Initializing RT-Tester: OK
[    1.119256] Testing tracer function: PASSED
[    1.268289] Testing dynamic ftrace: PASSED
[    1.517992] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 35342) (2 2 4 1 35634) PASSED
[    1.591847] Testing dynamic ftrace ops #2: (1 0 1 35341 0) (1 1 2 35612 =
0) (2 1 3 1 8) (2 2 4 249 256) PASSED
[    1.707799] Testing tracer irqsoff: PASSED
[    1.733435] Testing tracer preemptoff: PASSED
[    1.752663] Testing tracer preemptirqsoff: PASSED
[    1.769764] Testing tracer wakeup:=20
[    2.068581] Switching to clocksource tsc
[    2.108718] PASSED
[    2.108928] Testing tracer wakeup_rt: PASSED
[    2.459170] Testing tracer function_graph:=20
[    2.466979] BUG: unable to handle kernel paging request at e421cc10
[    2.466979] IP: [<c10850bc>] ftrace_push_return_trace+0x6c/0xd0
[    2.466979] *pdpt =3D 00000000013b4001 *pde =3D 0000000000000000=20
[    2.466979] Thread overran stack, or stack corrupted
[    2.466979] Oops: 0002 [#1] PREEMPT=20
[    2.466979]=20
[    2.466979] Pid: 1, comm: swapper Not tainted 2.6.39-t43+ #40 Bochs Bochs
[    2.466979] EIP: 0060:[<c10850bc>] EFLAGS: 00000006 CPU: 0
[    2.466979] EIP is at ftrace_push_return_trace+0x6c/0xd0
[    2.466979] EAX: c7833480 EBX: c7832020 ECX: c1070aac EDX: 1c9e9790
[    2.466979] ESI: 986b5466 EDI: 00000000 EBP: c78335ac ESP: c7833590
[    2.466979]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.466979] Process swapper (pid: 1, ti=3Dc7832000 task=3Dc7832020 task.=
ti=3Dc7834000)
[    2.466979] Stack:
[    2.466979]  c105a9fc c78335c0 c1007d26 c1070aac c78335f4 c1007d26 c1070=
aac c78335d0
[    2.466979]  c10150a2 c7833600 c7833600 c1007d26 00000000 c7832020 c1007=
d26 c7910800
[    2.466979]  c78335f0 c117e212 c1007d26 c7833638 c7832000 c1007d2b 00000=
046 c13551c0
[    2.466979] Call Trace:
[    2.466979]  [<c105a9fc>] ? trace_hardirqs_off+0xc/0x10
[    2.466979]  [<c1007d26>] ? native_sched_clock+0x6/0x70
[    2.466979]  [<c1070aac>] ? trace_clock_local+0x1c/0x50
[    2.466979]  [<c1007d26>] ? native_sched_clock+0x6/0x70
[    2.466979]  [<c1070aac>] ? trace_clock_local+0x1c/0x50
[    2.466979]  [<c10150a2>] prepare_ftrace_return+0x72/0xa0
[    2.466979]  [<c1007d26>] ? native_sched_clock+0x6/0x70
[    2.466979]  [<c1007d26>] ? native_sched_clock+0x6/0x70
[    2.466979]  [<c117e212>] ftrace_graph_caller+0x22/0x26
[    2.466979]  [<c1007d26>] ? native_sched_clock+0x6/0x70
[    2.466979]  [<c1007d2b>] ? native_sched_clock+0xb/0x70
[    2.466979]  [<c117e216>] ftrace_graph_caller+0x26/0x26
[    2.466979] BUG: unable to handle kernel NULL pointer dereference at 000=
0032d
[    2.466979] IP: [<c1005529>] print_context_stack+0xd9/0x110
[    2.466979] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    2.466979] Thread overran stack, or stack corrupted
[    2.466979] Oops: 0000 [#2] PREEMPT=20
[    2.466979]=20
[    2.466979] Pid: 1, comm: swapper Not tainted 2.6.39-t43+ #40 Bochs Bochs
[    2.466979] EIP: 0060:[<c1005529>] EFLAGS: 00000002 CPU: 0
[    2.466979] EIP is at print_context_stack+0xd9/0x110
[    2.466979] EAX: 0000001d EBX: c78335f4 ECX: 00000001 EDX: 00000310
[    2.466979] ESI: 00000000 EDI: c11806d4 EBP: c7833380 ESP: c783335c
[    2.466979]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.466979] Process swapper (pid: 1, ti=3Dc7832000 task=3Dc7832020 task.=
ti=3Dc7834000)
[    2.466979] Stack:
[    2.466979]  c117e216 c7833ffc c7833600 ffffe000 c7832000 c7833600 c7833=
590 c11806d4
[    2.466979]  c7832000 c78333ac c10040dd c11806d4 c11d6c66 00000000 c7833=
39c 00000018
[    2.466979]  00000000 00000000 c11806d4 00000018 c78333d0 c10052ec c7833=
5ac c11806d4
[    2.466979] Call Trace:
[    2.466979]  [<c117e216>] ? ftrace_graph_caller+0x26/0x26
[    2.466979] BUG: unable to handle kernel NULL pointer dereference at 000=
0032d
[    2.466979] IP: [<c1005529>] print_context_stack+0xd9/0x110
[    2.466979] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    2.466979] Thread overran stack, or stack corrupted
[    2.466979] Oops: 0000 [#3] PREEMPT=20
[    2.466979]=20
[    2.466979] Pid: 1, comm: swapper Not tainted 2.6.39-t43+ #40 Bochs Bochs
[    2.466979] EIP: 0060:[<c1005529>] EFLAGS: 00000002 CPU: 0
[    2.466979] EIP is at print_context_stack+0xd9/0x110
[    2.466979] EAX: 0000001d EBX: c783335c ECX: 00000001 EDX: 00000310
[    2.466979] ESI: 00000000 EDI: c11806d4 EBP: c783314c ESP: c7833128
[    2.466979]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.466979] Process swapper (pid: 1, ti=3Dc7832000 task=3Dc7832020 task.=
ti=3Dc7834000)
[    2.466979] Stack:
[    2.466979]  c117e216 c7833ffc c7833380 ffffe000 c7832000 c7833380 c7833=
35c c11806d4
[    2.466979]  c7832000 c7833178 c10040dd c11806d4 c11d6c66 00000000 c7833=
168 00000018
[    2.466979]  00000000 00000000 c11806d4 00000018 c783319c c10052ec c7833=
380 c11806d4
[    2.466979] Call Trace:
[    2.466979]  [<c117e216>] ? ftrace_graph_caller+0x26/0x26
[    2.466979] BUG: unable to handle kernel NULL pointer dereference at 000=
0032d
[    2.466979] IP: [<c1005529>] print_context_stack+0xd9/0x110
[    2.466979] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    2.466979] Thread overran stack, or stack corrupted
[    2.466979] Oops: 0000 [#4] PREEMPT=20
[    2.466979]=20
[    2.466979] Pid: 1, comm: swapper Not tainted 2.6.39-t43+ #40 Bochs Bochs
[    2.466979] EIP: 0060:[<c1005529>] EFLAGS: 00000002 CPU: 0
[    2.466979] EIP is at print_context_stack+0xd9/0x110
[    2.466979] EAX: 0000001d EBX: c7833128 ECX: 00000001 EDX: 00000310
[    2.466979] ESI: 00000000 EDI: c11806d4 EBP: c7832f18 ESP: c7832ef4
[    2.466979]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    2.466979] Process swapper (pid: 1, ti=3Dc7832000 task=3Dc7832020 task.=
ti=3Dc7834000)
[    2.466979] Stack:
[    2.466979]  c117e216 c7833ffc c783314c ffffe000 c7832000 c783314c c7833=
128 c11806d4
[    2.466979]  c7832000 c7832f44 c10040dd c11806d4 c11d6c66 00000000 c7832=
f34 00000018


full kernel log in attachment.

By bisection I got=20

commit 44259b1abfaa8bb819d25d41d71e8e33e25dd36a
Author: Andy Lutomirski <luto@MIT.EDU>
Date:   Mon May 23 09:31:28 2011 -0400

    x86-64: Move vread_tsc into a new file with sensible options


I tested on i386, 32-bit architecture. Both gcc 4.4 and 4.6 result
in same problem. Also -O2 vs -O2 doesn't change anything.

Sometimes bug doesn't appear, or appear differently, for example

[    1.114660] Initializing RT-Tester: OK
[    1.118077] Testing tracer function: PASSED
[    1.272665] Testing dynamic ftrace: PASSED
[    1.524057] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 44876) (2 2 4 1 45184) PASSED
[    1.600066] Testing dynamic ftrace ops #2: (1 0 1 44944 0) (1 1 2 45228 =
0) (2 1 3 1 8) (2 2 4 265 272) PASSED
[    1.717279] Testing tracer irqsoff: PASSED
[    1.737368] Testing tracer preemptoff: PASSED
[    1.759463] Testing tracer preemptirqsoff:=20
[    1.773645] ------------[ cut here ]------------
[    1.774220] WARNING: at kernel/lockdep.c:3351 check_flags+0x126/0x157()
[    1.774723] Hardware name: Bochs
[    1.775020] Pid: 1, comm: swapper Not tainted 2.6.39-t43+ #42
[    1.775332] Call Trace:
[    1.775560]  [<c102213e>] warn_slowpath_common+0x77/0x8c
[    1.775862]  [<c104728d>] ? check_flags+0x126/0x157
[    1.776138]  [<c104728d>] ? check_flags+0x126/0x157
[    1.776411]  [<c1064f5a>] ? T.482+0x114/0x16e
[    1.776664]  [<c1022175>] warn_slowpath_null+0x22/0x24
[    1.776950]  [<c104728d>] check_flags+0x126/0x157
[    1.777236]  [<c104b0a6>] lock_acquire+0x34/0xe7
[    1.777541]  [<c1126672>] _raw_spin_lock_irqsave+0x4e/0x7e
[    1.777839]  [<c1064f5a>] ? T.482+0x114/0x16e
[    1.778092]  [<c1064f5a>] T.482+0x114/0x16e
[    1.778341]  [<c105d62c>] ? ring_buffer_unlock_commit+0x21/0x2e
[    1.778654]  [<c1026ff6>] ? __do_softirq+0x17e/0x191
[    1.778931]  [<c1026ff6>] ? __do_softirq+0x17e/0x191
[    1.779208]  [<c106502a>] stop_critical_timing+0x76/0x87
[    1.779497]  [<c1026d47>] ? __local_bh_enable+0x82/0x85
[    1.779784]  [<c106505a>] trace_preempt_on+0x1f/0x21
[    1.780061]  [<c101c17d>] sub_preempt_count+0x8b/0x98
[    1.780341]  [<c1026d47>] __local_bh_enable+0x82/0x85
[    1.780621]  [<c1026ff6>] __do_softirq+0x17e/0x191
[    1.780892]  [<c1026e78>] ? local_bh_enable+0x12/0x12
[    1.781160]  <IRQ>  [<c1026c06>] ? irq_exit+0x44/0x66
[    1.781536]  [<c1003589>] ? do_IRQ+0x75/0x88
[    1.781789]  [<c1127b6e>] ? common_interrupt+0x2e/0x34
[    1.782076]  [<c106151c>] ? trace_selftest_startup_preemptirqsoff+0xae/0=
x1a9
[    1.782435]  [<c1061914>] ? register_tracer+0x12d/0x1fe
[    1.782724]  [<c1310344>] ? setup_command_line+0x73/0x73
[    1.783066]  [<c131c1b4>] ? init_irqsoff_tracer+0x21/0x25
[    1.783390]  [<c13101fa>] ? do_one_initcall+0x86/0x138
[    1.783390]  [<c131c193>] ? init_function_trace+0x35/0x35
[    1.783390]  [<c1310344>] ? setup_command_line+0x73/0x73
[    1.783390]  [<c13103cb>] ? kernel_init+0x87/0x11b
[    1.783390]  [<c1127b7a>] ? kernel_thread_helper+0x6/0x10
[    1.783390] ---[ end trace 4eaa2a86a8e2da22 ]---
[    1.783390] irq event stamp: 133534
[    1.783390] hardirqs last  enabled at (133532): [<c1126cbd>] _raw_spin_u=
nlock_irq+0x27/0x4a
[    1.783390] hardirqs last disabled at (133533): [<c1026fbf>] __do_softir=
q+0x147/0x191
[    1.783390] softirqs last  enabled at (133534): [<c1026ff6>] __do_softir=
q+0x17e/0x191
[    1.783390] softirqs last disabled at (133529): [<c10037b7>] do_softirq+=
0x55/0xa6
[    1.798767] PASSED
[    1.798767] Testing tracer wakeup:=20
[    2.063646] Switching to clocksource tsc
[    2.133963] PASSED


On recent kernels it looks like

[    1.159875] Switching to clocksource tsc
[    1.439760] PASSED
[    1.440212] Testing tracer function_graph:=20
[    1.449049] BUG: unable to handle kernel paging request at e42d01bc
[    1.449049] IP: [<c107586c>] ftrace_push_return_trace+0x6c/0xd0
[    1.449049] *pdpt =3D 0000000001221001 *pde =3D 0000000000000000=20
[    1.449049] Thread overran stack, or stack corrupted
[    1.449049] Oops: 0002 [#1] PREEMPT=20
[    1.449049]=20
[    1.449049] Pid: -947754028, comm:=20
[    1.449049] =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDk=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD Not tainted 3.0.0-rc1-t=
43 #45 Bochs Bochs
[    1.449049] EIP: 0060:[<c107586c>] EFLAGS: 00000016 CPU: 0
[    1.449049] EIP is at ftrace_push_return_trace+0x6c/0xd0
[    1.449049] EAX: c7826e50 EBX: c7826ae0 ECX: c106178c EDX: 1caa936c
[    1.449049] ESI: 5656002d EDI: 00000000 EBP: c7826f84 ESP: c7826f68
[    1.449049]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.449049] Process =EF=BF=BD (pid: -947753988, ti=3Dc7826000 task=3Dc78=
26ae0 task.ti=3Dc7828000)
[    1.449049] Stack:
[    1.449049]  c106178d c7826f98 c1007a26 c106178c c7826fcc c1007a26 c1061=
78c c7826fa8
[    1.449049]  c1014982 c7826fd8 c7826fd8 c1007a26 00000000 c7826ae0 c1007=
a26 c7941800
[    1.449049]  c7826fc8 c1162192 c1007a26 c7827010 c7826000 c1007a2b c783e=
95c 00000021
[    1.449049] Call Trace:
[    1.449049]  [<c106178d>] ? trace_clock_local+0x1d/0x50
[    1.449049]  [<c1007a26>] ? native_sched_clock+0x6/0x70
[    1.449049]  [<c106178c>] ? trace_clock_local+0x1c/0x50
[    1.449049]  [<c1007a26>] ? native_sched_clock+0x6/0x70
[    1.449049]  [<c106178c>] ? trace_clock_local+0x1c/0x50
[    1.449049]  [<c1014982>] prepare_ftrace_return+0x72/0xa0
[    1.449049]  [<c1007a26>] ? native_sched_clock+0x6/0x70
[    1.449049]  [<c1007a26>] ? native_sched_clock+0x6/0x70
=2E..

or

[    0.126297] Testing tracer function: PASSED
[    0.260366] Testing dynamic ftrace: PASSED
[    0.498381] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 6015) (2 2 4 1 6190) PASSED
[    0.557775] Testing dynamic ftrace ops #2: (1 0 1 6069 0) (1 1 2 6234 0)=
 (2 1 3 1 2) (2 2 4 152 153) PASSED
[    0.637461] Testing tracer irqsoff: PASSED
[    0.650073] Testing tracer wakeup: PASSED
[    0.979100] Testing tracer wakeup_rt:=20
[    1.118393] Switching to clocksource tsc
[    1.308726] PASSED
[    1.309162] Testing tracer function_graph:=20
[    1.317873] Tracing recursion: depth[576]:HC[1023]:SC[255]:NMI[67108864]
[    1.317873] ------------[ cut here ]------------
[    1.317873] WARNING: at kernel/trace/ring_buffer.c:2224 trace_recursive_=
fail+0x30/0x90()
[    1.317873] Hardware name: Bochs
[    1.317873] Pid: 1, comm:  Not tainted 3.0.0-rc1-t43 #46
[    1.317873] Call Trace:
[    1.317873]  [<c1022fbd>] warn_slowpath_common+0x6d/0xa0
[    1.317873]  [<c105b3c0>] ? trace_recursive_fail+0x30/0x90
[    1.317873]  [<c105b3c0>] ? trace_recursive_fail+0x30/0x90
[    1.317873]  [<c1023010>] warn_slowpath_null+0x20/0x30
[    1.317873]  [<c105b3c0>] trace_recursive_fail+0x30/0x90
[    1.317873]  [<c105ce8c>] ring_buffer_lock_reserve+0x8c/0xc0
[    1.317873]  [<c106177a>] trace_buffer_lock_reserve+0x1a/0x50
[    1.317873]  [<c1069357>] __trace_graph_return+0x37/0x90
[    1.317873]  <IRQ>=20
[    1.317873] BUG: unable to handle kernel NULL pointer dereference at 000=
00040
[    1.317873] IP: [<c1004f95>] print_context_stack+0x55/0x110
[    1.317873] *pde =3D 00000000=20
[    1.317873] BUG: unable to handle kernel NULL pointer dereference at 000=
0004a
[    1.317873] IP: [<c1015e0e>] no_context+0x6e/0x160
[    1.317873] *pde =3D 00000000=20
[    1.317873] Thread overran stack, or stack corrupted
[    1.317873] Oops: 0000 [#1]=20
[    1.317873]=20
[    1.317873] Pid: -947741524, comm:  Not tainted 3.0.0-rc1-t43 #46 Bochs =
Bochs
[    1.317873] EIP: 0060:[<c1015e0e>] EFLAGS: 00000006 CPU: 0
[    1.317873] EIP is at no_context+0x6e/0x160
[    1.317873] EAX: 00000002 EBX: c7829e78 ECX: c1023e56 EDX: c7829bc0
[    1.317873] ESI: 00000040 EDI: 00000000 EBP: c7829da8 ESP: c7829d88
[    1.317873]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    1.317873] Process  (pid: -947741524, ti=3Dc7828000 task=3Dc7829bc0 tas=
k.ti=3Dc10019a0)
[    1.317873] Stack:
[    1.317873]  c117be6d 00000040 00000046 c7829bc0 c7829de8 00000000 00000=
040 c7829bc0
[    1.317873]  c7829de8 c1015f98 c1143805 c7829dd8 c1013c3d 00000000 00000=
04a 0000000e
[    1.317873]  00000000 c1408242 00000040 c140820e c7829e78 c1408242 00000=
040 c140820e
[    1.317873] Call Trace:
[    1.317873]  [<c1015f98>] __bad_area_nosemaphore+0x98/0x140
[    1.317873]  [<c1143805>] ? error_code+0x5d/0x64
[    1.317873]  [<c1013c3d>] ? prepare_ftrace_return+0x4d/0xa0
[    1.317873]  [<c1016057>] bad_area_nosemaphore+0x17/0x20
[    1.317873]  [<c10164ae>] do_page_fault+0x27e/0x410
[    1.317873]  [<c1023928>] ? console_unlock+0x1c8/0x1f0
[    1.317873]  [<c1016230>] ? mm_fault_error+0x130/0x130
[    1.317873]  [<c1016230>] ? mm_fault_error+0x130/0x130
=2E..

Depending on the luck and boot time. All above was registered using qemu.
But I have this (or slightly different - depdnding on boot,
or kernel configuration - messages, just after trace function_graph testing
started) alsoon my laptop.

Reverting commit 44259b1abfaa8bb819d25d41d71e8e33e25dd36a on top of current
kernel make bug disapear.

Disabling CONFIG_FUNCTION_GRAPH_TRACER also make bug dispear.

Bug is preserved at multiple kernel configs.
I send one which is pretty minimized.


Regards,
Witek

--=20
Witold Baryluk

--MdJ3p2aQbVp3YFXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-minimized.txt"

#
# Automatically generated make config: don't edit
# Linux/i386 3.0.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
# CONFIG_NEED_DMA_MAP_STATE is not set
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-t43"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_FORCED_THREADING=y
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
# CONFIG_PCI is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set

#
# Executable file formats / Emulations
#
# CONFIG_BINFMT_ELF is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
# CONFIG_NET is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
# CONFIG_BLK_DEV is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_RAMOOPS is not set
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CLKSRC_I8253=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=3
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_LKDTM is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
# CONFIG_CRYPTO is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_GENERIC_FIND_FIRST_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
# CONFIG_CRC32 is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_AVERAGE is not set

--MdJ3p2aQbVp3YFXz
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="oops-at-44259b1abfaa8bb819d25d41d71e8e33e25dd36a.txt.gz"
Content-Transfer-Encoding: base64

H4sICKm0400CA29vcHMtYXQtNDQyNTliMWFiZmFhOGJiODE5ZDI1ZDQxZDcxZThlMzNlMjVk
ZDM2YS50eHQA7Z1bc9vIlcer8pCHVOUxj6k6iV+ktUijGyAIsMbOSrJss2zJWkve8cblYjVx
EbEiAQYAdZmat3yHfJN8gHma75Evsnsa4E0EKYk2Nevx/qmyRQB9Tp9f97ng0iI/Er+MulG8
PtGbKB5d0UWQZlESk6zbddOt5Zb5mLa6Kr3uj87/Pb/OR9k2bZ153rShVbfqDdp6HnQjNd6q
Odu0TY8sg47fHRwcHp/SITc8VNdkGiSaLcNqCZv2D05OSRpC/O7jTUP22m9PasM0uYj8wKdh
7zqLPNWnd7uHNFDD1mLzsn3gSKNFxsKLavO73NDiXVujTHX7wfY99ZRCN/SoQvVWGmRBehH4
99UUViwSxmdpEhW2Zhj6xrpsE6E5PY7xORaFYejdtEhMJ2C1pqMkj7ygRUcfaOvgKvBGeUDP
o9J+4unPAy/XDjaIsiyKzyiKaf/4/Z8W1Tw/bLOzWizBHcV5ffF4X2V5ZxjG9JSMK43MTnTV
UanXm+4dW7soebx7SnGSUzYaDpM0Z1/sXmsTKl1EcZR3BsEgSa877KFDtrbqirXFcV/UYhzu
0av2y1eHB4ekLlTU1yNR6UvIJrd78/b725uRDpUhm9xPLilVA7ZHz86Krul+zf6axAEdvzji
lvFZkFUjkSdjl4qXcTVxBKo9G2+JpT0fJemAo5vmGs1EtCFVkVfRWe8wGBAFg2F+vXj8MLnQ
Q0I/aGuzXKV5YXOYpBQor8dT6geLMoFK+9cdfURP4Ef5iRQ738U8bdUM3motBdVJ4/bm4i7I
3X4/8VSu/f54v03s28ko9YKsBNK7VU7TaD3jtDjZaoXNMhorAbc3ivo5iWJg+lGWZzqkijlN
Uj9Id2iQdKN+lF/TWZqMtBdTEteJTpOcJ2io9JSTKU3XXtT8OkhZJXnJYKBi9rko5rjmzThL
+sHTPL8+MXaEaEjDiJ353dWQaz+nnsp6lBdTyPGcRrrXhpC0VVjZoprY4bJhORyNeZBVKJ9r
oWvyeKqDpbqEbTrWVJu1Q3ajYdortLW1T9RWK3OEO7PM3OHhadrOSl1RHql+9IMeWc4jj4xb
W0y8XDuutoJDc2uSQlqTN5VODos0xJSiaVrG+RNhCsM2zmepgrZEwxTndD6ZMz/YIWFK2zmn
Sa7mHa7jnpOvcsWDrQ/pHLdDrKjHZnGuq3R8EaX5iP1krLdMh5x9r5NR3loWDWF0xbFGpIMi
LBNOkXz0RqhrJbfZIuE4dL63vUzB8LyQHyvwjDkFQbnBCgpPWaHgghMPh1mhwHOa02rICrqF
isICh73lcLkCzpoDnYcKBXOnHFfepLYWCLK5SgFRXQ9sqUCYTTFVIMyuNVHAE7AKgRXoSRor
EM3As8yJgmaRZliBnsxbFOTB1cSCeYSJNio9ZpmC/V7gnRe1OaS8F2W6bHOSythje0nMGSvj
3QF9f0xdhgwuglinHK6n7GWRbjVg76vX62/PKwXsOA10do+0x/aiINUFuzwN3H9P0WDYDwYc
hEqfIVRkdRM/6I7OwqzWVRlXwTxVXmFnxqGro8CvCO2/PXrRftlh2c6L3aO3708pC3LKE469
uOYHoRpx8rxQ/RGny5CsytnMu0773X+c8IltRXGZ71ocan0eEvrPl7uPOVlfycZiy3FmpI86
NX6aWHpbq5PVzd4kHgdwMAxiP4i9a216xK6ScJ7aT4bXKYdxTlveNudSw6Z3PEivFEd4O/bq
+v+zhAtpP1bpol6eLjrc/dB583b/9fOD487J+739N7snJwcnnPKd21p3uPnpqxZNX5Zzl/LX
B/91MhXgXCuWCRTdv9o9edU5af/1YF6/US1Viz0cHJ2+ax+MOylKw10S+69220cTq4p8v9Qo
3WqZUUv7mKTLUVaeZfYXJi+Kw4TriyNNDsOKMIcT16XsvJbl6cjLJ8rCJMmHaRTnXA1caZRV
aVG4tuK12O7HwqF0DO0et4kV5dkoyoPWffV9zmt5vrrl9SNlfNpCP14W4/djWv4a8JXFFR+7
zDhX/0hp8auq+xe2e7e2yzOsfG0ju0dyrs2/+9edundre/yzed2l3n3+eRjdrFf/v1HdM5uf
88/uxnVrvXsPqnt/47rnXn4y0uV1FG9cdzQ5keXiHfT9TeruKn9sMY1Pu79A9y8V82ng8cmQ
vqBMeSpr4/G+kbkmli7ZeYvuJYrpkdyMbhpEV1yOCsWXKSf7Ddo91l2q3cyYPPBc9lTq16L0
b1ktiekx8btapsKgtvtEyNb9XTlLwnwDalZbI8VGrFlLDSuaidLTZ3zGXupcD2q1mjWtGY/P
WFHB9TnWjMfny9Ust2ZtqOXWrKPmpiGjuHi7R48EM5n3V3PTkM9Wc4s1ptyINeuoWW2NFBsZ
m7XU3GKNKTZijbkRvzHFRmZqLTW3WCM3MjbmJmJKbiam5GZiSm4mpuRmYkpuJqbkZmJKbiam
5GZiSm4mpuRmYkpuJqbWVDM7wSluhdSiePy4eb1gmJ3gfKGaldaYciPWrKdmlTVrBcNqa9ZU
s9IaU2zEGnMjfmOKjczUmmpWWiM3MjafG1PFBdf40vFmMNzR/7qCK3ucOfyaPd4luKrHOade
r8c7BVf2OHPcNXu8S3BVj3POuV6Pdwqu7FF+JuMtghu6aH+ZJP4OqX6fpHCKG9aeyoKMhirL
Av9Pn9HvosDb5wd771+2KAv6odY/Vr3Y7IXiQ6cn++SpftRNi0dWNCqWtBy3T39ffX6tF74E
PpnCdeumbdLhqx9mD9bqMwFpCLf5ifYnalmhH/SVfnqQDGkrO4/0CpDtnfFTK+7eG/WVVl32
nkeDIKUwDf420g8Z6nWyTdepNyXtJWfJYfv4hLb6w/9+qg1hO4zt+a6btvmJhpHfGairFo2f
j7XGz78HURwNRgPeNMSckHSbUq/PGMX5LY/UG0LOZCzDsvQztOP3LWrHedCnY24YjQbUbrdp
67XKByrapiwPimU3ZJhzsrLpuJ8o1A//ghap2ZIKW/KwjjvUTySFWS5vmMnaUkjnE3eWhnp9
SuwFdHDBEmzffKOG0fhEcaKfiezvUDdJcrqM8l7x1PPPfTWMvD+Xe4cqVQOe2VQ/UWSVXlAr
n9tRlNfnNTrCKTTqiLtUaUCZGgz75fonFk9Hw3xu2c+cpGmYLLmXJudBTMeH72ca/LFH7Yzn
XcdkcSAoiCiJ+9dzmprSbopPdMoeXXiJHj29AmHYomP9nO/5XFPTarIHHh226VLlXs9P2AXL
JVw+bXnDkbHdmtkx7k4vqRo/s5zTxG7DvuEHF/lgGPIoz+4gz7VyDaGH5/wySc+D9MmoZZRP
zM44uxQRmOWqfHCW91pkO9b4oRf1gzCfqhFGQ1pstsqTQeTZFs0Fb7HaImo49mMacqzoyS9n
dP+DQ3ptS7HBozDTJmRDNO5vVNNYbpTrNCQb1Y2SFnmFKGU8yfQd76kZz/R6H2Pamr2zmKQT
NsfrFdOUkKfPDsp1QhyZM9WOI6Uh72+hPVkNM2+h4DkymhbH03Rc0tzreIOEJysNziIOwVQv
15wcfXeqn+VcRGzMFvvz8dHxZDPkBOBvT/UKYVUXv7w7rWkH1Lf3376ea+rKhl3xzXAUF0sF
FxxU1CU7lU4Bk/b+dax4yqcpYaF5QzRdV65qTskwo0dctrYEGST4x9jW7wXJ8Xv929T/GqYl
i21JVrFtm9Z2pTdXONoNb+tNTnvTOud7ZJ1C3ujVmfYoLZd4nCo98gQyYGX49I3EJAwrw9E0
TctsVJoPy5UZSyUa0tZ1YbnEyn5st2lbFalLdR6MhtN8KznHOQ3nNqfPM2/aWBhOU+eKG30V
u12d2Jf21Unz1qKAxdPUNFa6XOcsVcPenJGWzTQ8xsWZwahM8blO57HP78aLo7jYaF1F5eXw
49AOLCk8TxgVPe3jFn38jo84DaPrPZuUs85wlPU6aZCP0rhT7HlsXNneE+PKr+r4t6HPVePp
bElqubhI6APB/P7JEqaKhtOePn+jhC88UhWX+WKHOFWWmcNLisI0TdUzwbfsxsVaWEkfH/Hc
TRaEVxpWdhxHfovETrGokM+xLvVy1lQvGubzBV0K/RtL1PVi873E62Xl/xVtB3ocDcM2WjcG
8+DFm92XJ9PFunZ5omEsE9drh3iiPmP4D3Y/cEpvOhxOjkEHe+Mtzsm8ta+3BOdWpTw6eM5b
wnMDllui56TdItexuw3ew23bs0XGrPV43EdD6zmZbi3RQ88L4maXDiZvXozHgCaDwSWuGC+n
Oi/lmeh0RraG44nKo6clFkvr1ShPp5B6qz4+rHP9dkXpiXajVtVSHpmGckNvDOMZeo/R9KU9
G7TyUGitPLRkSnQT0TCULJvYbPLszUTNdHCnILMemq7Qi+WXKC6t0W1FM+A6PS+kezAdmg7T
+FB33JWlTTcbDeFVFe/rK5nTomxVOy18uhgo9um/lDmqo8+7dMrtcM5l79TOuSS/lLKFgYVs
rPS6507GZ+d+p0iu2rNZtrlKthjquX4LoY4+1+6zqND9Nr62fou5Z1muTHxmHnTGUV0GNEs3
JUurh7D6C2RLf5qVgKL0dBi3H6QsKrXN0n4gm7urZbt32WyvttlebvOt1fPo/Zs3NEyK6yE+
p0yDkP/pKzR9iqxfpvRX11Gj0ZBuMfWsoOMlsV7+2inqGBvkuzpMxD1q6CQ5jGtoWPwdTMOc
/H6IGmpwDZVfTQ2dDORCDZV319A1h76on+MTF39WP4ucX9TPyVlNWT9LFxAr6uesYur6yQ7q
GLZvzdVPU9foaf3kmvPrrp9lAJYw4aSQ6jKnF9kHs+p2owKOzxymw7O8zM2ETF1r2SMsw/dn
Y8pvfNuzFwqpabreZDarozNrOxOa6JsIjdX4Zf1syMCbnfmstPjO+jnNVH9BrtpQrjKRqz7M
8sgD5CphzZ/rC+l8g7lK5+MVuUofmo7ufXOVaDr3z1XCdjaRq4TrLeSqwnTkqq8nV1nIVR9m
eWTzuUqGHAzTXCWD0PoGc5XOxytylT40Hd175ioZWta9c5UMTWsDuUqGtrOQqwrTkau+nlzV
QK76MMsjD5CrvMCay1WeZ3x7uarIx8tzVXFoOrr3zVW+MO6fq/xpIvqiXOWb1s1cVZqOXPX1
5CobuerDLI88QK5S3bn7VVI53+D9qiIfr8hV+tB0dO+bq5R///tVUnmbuF8lu8bC/arSdOSq
rydXNZGrPszyyAPkKqc5d79KOo1v8H5VkY9X5Cp9aDq6981Vjrr//SrpuJu4XyUdb+F+VWk6
ctXXk6ucz89V/8OvXyZRid//7jvr2YKG+SXVH8kb5dTjeaNP8/sr3X6/++6ofcTOwHNbTv+T
lEXTIOgM+6OzKK73WqZrU6fDuzt6gDvlhwTwXDZU8YB6qxraryZLU2M1CForiIvBMyaD94dH
f//5Df/71z9/89Nv+ffP//jjT7cN5lrB8mXubhjOSncXTc9VPk9UJ1WXHf0pKZ3x6AifR8d5
CEf/QhrLXR28oqk845leKD2JXL1ow2CSACQgAQlIQAISkIAEJCABCUhAAhKQgAQkIAEJSEAC
EpCABCQgAQlIQAISkIAEJCABCUhAAhKQgOSBSb74gwP1attGYNyy8tOXbvfGys/pyljZXf4h
WV/+gYHwQ5CABCQgAQlIQAISkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQgAQlIQAISkIAE
JCABCUhAgrWfWPsJPwQJSEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQgAQkIAEJSEACEpCA
BCQgAQlIQAISkIAEJFj7ibWfiCiQgAQkIAEJSEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQ
gAQkIAEJSEACEpCABCQgAQlIQIK1n/BDkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCT/ByTV
O6lh8Qpusb/rKttl+8Mo9jsXA8XWmy5b73zBHVTe7xh2k/fnG7izCipQgQpUoAIVqEAFKlCB
6uumwtUhSEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQgOSXJsFfJ8KDQAISkIAEJCABCUhA
AhKQgAQkIAEJSEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQgAQkIAHJr/ibKWpzr4/kjXLq
MRt9mt9fEfp+991R+4i7YX6Ver0nV479ZDB4EqpRP697LWm7dDFQ/X7idYp9DCyaFhML19ja
ruh7pVL/UnG3sRoELdpLvF5WaXQc+S0ydshLBoMW/eHR339+w//+9c/f/PRb/v3zP/74Ex0l
OeVKT5PPgnbddGu5ZT6mR1Z1oPfZPDpNlRe0KsfKeZOq6fs8b2xZ3Mn6yeVQ5b2O7j6JGcj2
mUcZX7qatljrajVWr6Y1jIble2zHMGWyiQt1slwVC2odTw+rQEyABCQgAQlIQAISkIAEJCAB
CUhAAhKQgORrJBFN+5a/I/dc5d/4O/LxX5EL/56f9op5AQlIQAISkIAEJCABCUhAAhKQgAQk
IAEJSEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQgAQkIFn6V+T4BiH4IUhAAhKQgAQkIAEJ
SEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQgwTcI4RuE1voGIQvf
IIToBglIQAISkIAEJCABCUhAAhKQgAQkIPkmv0Eo7OIbhOBhIAEJSEACEpCABCQgAQlIQAIS
kIAEJCABCUiWryAMi1dwi/1dV9ku2x9Gsd+5GCi23nTveQd11edw8n7HsJu8P9/A53OCClSg
AhWoQAUqUIEKVKD6uqlwdQgSkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQg+aVJ8B238CCQ
gAQkIAEJSEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQgAQlIQPIr
/o7b/wdrP/G5GaACFahABSpQgQpUoAIVPj/t13HFBR8FFahABSpQgQpUoAIVqECFKzB8vxHi
B1SgAhWoQAUqUIEKVKACFa4OcXWI+AEVqEAFKlCBClSgAhWoQIWrQ1wdIn5ABSpQgQpUoAIV
qEAFKlB9jVT/Czhnu0nrgQIA

--MdJ3p2aQbVp3YFXz--

--=_smp.if.uj.edu.pl-27823-1306771816-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk3jwWYACgkQ7ZLFFOttZ4K8EgCgn5MuXCI0gIq/akyemJMyRdOa
XFUAoL2hJUsBoI6bw/aVbQNinJE1iOEV
=olNu
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-27823-1306771816-0001-2--
