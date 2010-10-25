Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0JYMSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:18:38 -0400
Received: from fep16.mx.upcmail.net ([62.179.121.36]:49269 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab0JYMSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:18:37 -0400
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20101025121059.GA3063@elte.hu>
References: <20101021110925.GA27219@elte.hu>
	 <20101022175845.GF6498@redhat.com> <20101022182433.GA24637@elte.hu>
	 <20101022183900.GG6498@redhat.com> <20101023200216.GA19324@elte.hu>
	 <1287881618.16971.657.camel@gandalf.stny.rr.com>
	 <20101024112540.GA21267@elte.hu> <20101025085927.GA11025@elte.hu>
	 <20101025093045.GA21997@elte.hu> <20101025114501.GA2000@elte.hu>
	 <20101025121059.GA3063@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 14:18:23 +0200
Message-ID: <1288009103.15336.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=zlRBWuFCZaNL9+WHNm1pWLowY5Lx061w2zJBJiDkNAU= c=1 sm=0 a=LuwKl7ggZIAA:10 a=IkcTkHD0fZMA:10 a=vXqc77g62WSbAXhc15MA:9 a=r5aSRX3RhIBf45Z-Q4NNyTsa-dAA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 14:10 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > and here's a new crash with a new config:
> > 
> > [   11.810471] Testing event timer_expire_exit: OK
> > [   11.850475] Testing event timer_cancel: OK
> > [   11.890508] Testing event hrtimer_init: OK
> > [   11.930469] Testing event hrtimer_start: OK
> > [   11.970475] Testing event hrtimer_expire_entry: 
> > [   11.980002] BUG: unable to handle kernel NULL pointer dereference at (null)
> > [   11.980010] IP: [<(null)>] (null)
> > [   11.980010] *pde = 00000000 
> > [   11.980010] Oops: 0000 [#1] SMP 
> > [   11.980010] last sysfs file: 
> > [   11.980010] Modules linked in:
> > [   11.980010] 
> > [   11.980010] Pid: 0, comm: swapper Not tainted 2.6.36-tip-05833-g9db2fad-dirty #52316 A8N-E/System Product Name
> > [   11.980010] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 0
> > [   11.980010] EIP is at 0x0
> > [   11.980010] EAX: f6806a94 EBX: f6806a94 ECX: 00010000 EDX: 00000096
> > [   11.980010] ESI: f65bdf50 EDI: f6806a00 EBP: f6806a30 ESP: c13dff04
> > [   11.980010]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > [   11.980010] Process swapper (pid: 0, ti=c13de000 task=c13e2f20 task.ti=c13de000)
> > [   11.980010] Stack:
> > [   11.980010]  c103d297 00000000 c10460c1 c13dff4c ca105369 00000002 ffffffff 7fffffff
> > [   11.980010]  c103d52b ca105369 00000002 ca105369 0000002c f6806a00 00000000 f6806a04
> > [   11.980010]  ca105369 00000002 ca105369 00000002 00000000 f6805dac 00000000 c1420788
> > [   11.980010] Call Trace:
> > [   11.980010]  [<c103d297>] ? __run_hrtimer+0x91/0x105
> > [   11.980010]  [<c10460c1>] ? tick_sched_timer+0x0/0x1a1
> > [   11.980010]  [<c103d52b>] ? hrtimer_interrupt+0x108/0x20a
> > [   11.980010]  [<c1012294>] ? smp_apic_timer_interrupt+0x66/0x75
> > [   11.980010]  [<c12c202a>] ? apic_timer_interrupt+0x36/0x3c
> > [   11.980010]  [<c10163f0>] ? native_safe_halt+0x2/0x3
> > [   11.980010]  [<c10072c6>] ? default_idle+0x66/0x91
> > [   11.980010]  [<c10020f6>] ? cpu_idle+0x98/0xda
> > [   11.980010]  [<c142280a>] ? start_kernel+0x2f7/0x2fc
> > [   11.980010] Code:  Bad EIP value.
> > [   11.980010] EIP: [<00000000>] 0x0 SS:ESP 0068:c13dff04
> > [   11.980010] CR2: 0000000000000000
> > [   11.980010] ---[ end trace 74b10a949febd52e ]---

> Here's the disassembly of the crash site:
> 
> c103d282:       89 da                   mov    %ebx,%edx
> c103d284:       8b 4c 24 04             mov    0x4(%esp),%ecx
> c103d288:       ff 16                   call   *(%esi)
> c103d28a:       83 c6 08                add    $0x8,%esi
> c103d28d:       83 3e 00                cmpl   $0x0,(%esi)
> c103d290:       eb eb                   jmp    c103d27d <__run_hrtimer+0x77>
> c103d292:       89 d8                   mov    %ebx,%eax
> c103d294:       ff 14 24                call   *(%esp)
> c103d297:       89 04 24                mov    %eax,(%esp)
> c103d29a:       e9 00 00 00 00          jmp    c103d29f <__run_hrtimer+0x99>
> c103d29f:       eb 19                   jmp    c103d2ba <__run_hrtimer+0xb4>
> c103d2a1:       8b 35 50 f1 40 c1       mov    0xc140f150,%esi
> c103d2a7:       85 f6                   test   %esi,%esi
> c103d2a9:       74 0f                   je     c103d2ba <__run_hrtimer+0xb4>
> c103d2ab:       8b 46 04                mov    0x4(%esi),%eax
> c103d2ae:       89 da                   mov    %ebx,%edx
> c103d2b0:       ff 16                   call   *(%esi)
> c103d2b2:       83 c6 08                add    $0x8,%esi
> c103d2b5:       83 3e 00                cmpl   $0x0,(%esi)
> c103d2b8:       eb ef                   jmp    c103d2a9 <__run_hrtimer+0xa3>
> c103d2ba:       89 f8                   mov    %edi,%eax
> c103d2bc:       e8 ea 43 28 00          call   c12c16ab <_raw_spin_lock>
> c103d2c1:       83 3c 24 00             cmpl   $0x0,(%esp)
> 
> (gdb) list *0xc103d297
> 0xc103d297 is in __run_hrtimer (kernel/hrtimer.c:1227).
> 1222		 * they get migrated to another cpu, therefore its safe to unlock
> 1223		 * the timer base.
> 1224		 */
> 1225		raw_spin_unlock(&cpu_base->lock);
> 1226		trace_hrtimer_expire_entry(timer, now);
> 1227		restart = fn(timer);
> 1228		trace_hrtimer_expire_exit(timer);
> 1229		raw_spin_lock(&cpu_base->lock);
> 1230	
> 1231		/*

> 
> i.e. the 'fn(timer)' call crashed.

Right, and its doing an indirect function call from the first stack
entry.. which would seem to suggest someone scribbled our stack..


