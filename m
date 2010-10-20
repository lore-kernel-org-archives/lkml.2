Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0JTPwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:52:36 -0400
Received: from fep16.mx.upcmail.net ([62.179.121.36]:62505 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab0JTPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:52:35 -0400
X-SourceIP: 80.56.199.130
Subject: Re: ptrace BUG [was: mmotm 2010-10-13-17-13 uploaded]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4CBF0FB7.3000602@gmail.com>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	 <4CBF0FB7.3000602@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 17:52:27 +0200
Message-ID: <1287589947.3488.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=FfKqumoxTXZ+9nPf2j1EcRvkwAYRHfr8aJLFveX/caA= c=1 sm=0 a=bL8u2p6j2agA:10 a=IkcTkHD0fZMA:10 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=nhUURdti6VFmraMYl1sA:9 a=9pWqRr82vrcvjp5Y6wgA:7 a=YY8VnUFarDD5FQ7kGaildzT6bCIA:4 a=QEXdDO2ut3YA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 17:50 +0200, Jiri Slaby wrote:
> On 10/14/2010 02:13 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> 
> Hi, I tried to run a process in gdb and got this BUG:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> IP: [<ffffffff810c5c08>] fetch_bp_busy_slots.clone.1+0x28/0x1c0
> PGD 1bacfa067 PUD 13b7f1067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
> CPU 1
> Modules linked in: dvb_usb_af9015 dvb_usb
> 
> Pid: 18934, comm: gdb Not tainted 2.6.36-rc7-mm1_64+ #1286 To be filled
> by O.E.M./To Be Filled By O.E.M.
> RIP: 0010:[<ffffffff810c5c08>]  [<ffffffff810c5c08>]
> fetch_bp_busy_slots.clone.1+0x28/0x1c0
> RSP: 0018:ffff8801b71a3ca8  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff8801b71a3d18 RCX: 0000000000000000
> RDX: ffff8801b71a3fd8 RSI: ffff88013bafc800 RDI: ffff8801b71a3d18
> RBP: ffff8801b71a3cf8 R08: ffffffff81039620 R09: ffff88013bafc800
> R10: fffe060673f40000 R11: 0000000000000001 R12: ffff88013bafc800
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88013bafc800
> FS:  00007f0acb802700(0000) GS:ffff8800af280000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000080 CR3: 0000000188f40000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process gdb (pid: 18934, threadinfo ffff8801b71a2000, task ffff88019ddfee80)
> Stack:
>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> <0> 0000000000000000 ffff88013bafc800 ffff88013bafc800 0000000000000000
> <0> 0000000000000000 ffff88013bafc800 ffff8801b71a3d38 ffffffff810c5dfa
> Call Trace:
>  [<ffffffff810c5dfa>] __reserve_bp_slot+0x5a/0x90
>  [<ffffffff815c26d9>] ? mutex_lock+0x19/0x50
>  [<ffffffff810c5e60>] reserve_bp_slot+0x20/0x40
>  [<ffffffff810c5f41>] register_perf_hw_breakpoint+0x11/0x50
>  [<ffffffff810c8da2>] ? filemap_fault+0x122/0x4b0
>  [<ffffffff810c5fad>] hw_breakpoint_event_init+0x2d/0x50
>  [<ffffffff810c4346>] perf_init_event+0x36/0x80
>  [<ffffffff810c45d8>] perf_event_alloc+0x248/0x350
>  [<ffffffff81039620>] ? ptrace_triggered+0x0/0x40
>  [<ffffffff810c49bc>] perf_event_create_kernel_counter+0x2c/0x150
>  [<ffffffff810c5601>] register_user_hw_breakpoint+0x11/0x20
>  [<ffffffff8103975e>] ptrace_set_breakpoint_addr+0xde/0x100
>  [<ffffffff8103a485>] ptrace_set_debugreg+0x55/0x80
>  [<ffffffff8103a902>] arch_ptrace+0xe2/0x370
>  [<ffffffff81074c18>] sys_ptrace+0x68/0xc0
>  [<ffffffff815c3e1f>] ? page_fault+0x1f/0x30
>  [<ffffffff8102ee2b>] system_call_fastpath+0x16/0x1b
> Code: 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 f4 53 48 89 fb
> 48 83 ec 28 44 8b b6 dc 01 00 00 48 8b 86 80 01 00 00 45 85 f6 <4c> 8b
> a8 80 00 00 00 78 5f 48 c7 c0 d8 e2 00 00 4d 63 f6 4a 8b
> RIP  [<ffffffff810c5c08>] fetch_bp_busy_slots.clone.1+0x28/0x1c0
>  RSP <ffff8801b71a3ca8>
> CR2: 0000000000000080
> ---[ end trace 8199f8c45e224e74 ]---
> psi[18938] trap int3 ip:7ffff3bdaa01 sp:7fffffffccc8 error:0
> 
> Is there a pacth for this already? Or should I investigate further?

---
commit d580ff8699e8811a9af37e9de4dea375401bdeec
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Oct 14 17:43:23 2010 +0200

    perf, hw_breakpoint: Fix crash in hw_breakpoint creation
    
    hw_breakpoint creation needs to account stuff per-task to ensure there
    is always sufficient hardware resources to back these things due to
    ptrace.
    
    With the perf per pmu context changes the event initialization no
    longer has access to the event context, for the simple reason that we
    need to first find the pmu (result of initialization) before we can
    find the context.
    
    This makes hw_breakpoints unhappy, because it can no longer do per
    task accounting, cure this by frobbing a task pointer in the event::hw
    bits for now...
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    LKML-Reference: <20101014203625.391543667@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2ebfc9a..97965fa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -536,6 +536,12 @@ struct hw_perf_event {
 		struct { /* breakpoint */
 			struct arch_hw_breakpoint	info;
 			struct list_head		bp_list;
+			/*
+			 * Crufty hack to avoid the chicken and egg
+			 * problem hw_breakpoint has with context
+			 * creation and event initalization.
+			 */
+			struct task_struct		*bp_target;
 		};
 #endif
 	};
@@ -693,6 +699,7 @@ struct swevent_hlist {
 
 #define PERF_ATTACH_CONTEXT	0x01
 #define PERF_ATTACH_GROUP	0x02
+#define PERF_ATTACH_TASK	0x04
 
 /**
  * struct perf_event - performance event kernel representation:
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 3b714e8..2c9120f 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -113,12 +113,12 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
  */
 static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
 {
-	struct perf_event_context *ctx = bp->ctx;
+	struct task_struct *tsk = bp->hw.bp_target;
 	struct perf_event *iter;
 	int count = 0;
 
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
-		if (iter->ctx == ctx && find_slot_idx(iter) == type)
+		if (iter->hw.bp_target == tsk && find_slot_idx(iter) == type)
 			count += hw_breakpoint_weight(iter);
 	}
 
@@ -134,7 +134,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		    enum bp_type_idx type)
 {
 	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->ctx->task;
+	struct task_struct *tsk = bp->hw.bp_target;
 
 	if (cpu >= 0) {
 		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -213,7 +213,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	       int weight)
 {
 	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->ctx->task;
+	struct task_struct *tsk = bp->hw.bp_target;
 
 	/* Pinned counter cpu profiling */
 	if (!tsk) {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b21d06a..856e20b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5255,9 +5255,10 @@ unlock:
  */
 static struct perf_event *
 perf_event_alloc(struct perf_event_attr *attr, int cpu,
-		   struct perf_event *group_leader,
-		   struct perf_event *parent_event,
-		   perf_overflow_handler_t overflow_handler)
+		 struct task_struct *task,
+		 struct perf_event *group_leader,
+		 struct perf_event *parent_event,
+		 perf_overflow_handler_t overflow_handler)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
@@ -5299,6 +5300,17 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (task) {
+		event->attach_state = PERF_ATTACH_TASK;
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+		/*
+		 * hw_breakpoint is a bit difficult here..
+		 */
+		if (attr->type == PERF_TYPE_BREAKPOINT)
+			event->hw.bp_target = task;
+#endif
+	}
+
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
 	
@@ -5559,7 +5571,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_task;
@@ -5728,7 +5740,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -5996,6 +6008,7 @@ inherit_event(struct perf_event *parent_event,
 
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
+					   child,
 					   group_leader, parent_event,
 					   NULL);
 	if (IS_ERR(child_event))


