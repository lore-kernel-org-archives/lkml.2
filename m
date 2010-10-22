Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab0JVVnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0JVVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:43:33 -0400
Date: Fri, 22 Oct 2010 17:42:12 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
	trace_sched_wakeup.c
Message-ID: <20101022214211.GJ6498@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu> <20101020164324.GC7348@redhat.com> <20101020183329.GA12666@elte.hu> <20101021110925.GA27219@elte.hu> <20101022175845.GF6498@redhat.com> <20101022182433.GA24637@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022182433.GA24637@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 08:24:33PM +0200, Ingo Molnar wrote:
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > On Thu, Oct 21, 2010 at 01:09:25PM +0200, Ingo Molnar wrote:
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Jason Baron <jbaron@redhat.com> wrote:
> > > > 
> > > > > [...] Do we always fail after "Testing all events:" is printed? [...]
> > > > 
> > > > Yes, in all cases i checked. Sometimes it's an oops.
> > > 
> > > Such as this one:
> > > 
> > > [    6.724449] Testing event kmalloc_node: OK
> > > [    6.744459] Testing event kmem_cache_alloc_node: 
> > > [    6.749111] BUG: unable to handle kernel paging request at ffffffff
> > > [    6.752000] IP: [<f6425f7c>] 0xf6425f7c
> > > [    6.752000] *pde = 01384067 *pte = 00000000 
> > > [    6.752000] Oops: 0002 [#1] PREEMPT SMP 
> > > [    6.752000] last sysfs file: 
> > > [    6.752000] Modules linked in:
> > > [    6.752000] 
> > > [    6.752000] Pid: 2, comm: kthreadd Not tainted 2.6.36-rc8-tip+ #50831 /
> > > [    6.752000] EIP: 0060:[<f6425f7c>] EFLAGS: 00010282 CPU: 0
> > > [    6.752000] EIP is at 0xf6425f7c
> > > [    6.752000] EAX: ffffffff EBX: c1021c4f ECX: 00000001 EDX: 00000000
> > > [    6.752000] ESI: f6425f7c EDI: fffffff4 EBP: f640c000 ESP: f6425ee4
> > > [    6.752000]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > > [    6.752000] Process kthreadd (pid: 2, ti=f6424000 task=f640c000 task.ti=f6424000)
> > > [    6.752000] Stack:
> > > [    6.752000]  c1021c4f f640c02c 00800711 00000000 00000000 00000000 f6425f7c f6809880
> > > [    6.752000] <0> f6425f7c 00000000 00000000 f6425f7c c1022a54 00000000 00000000 00000000
> > > [    6.752000] <0> 00000000 00800711 00000000 00000000 00000000 c101d94a f6809880 c131f3a0
> > > [    6.752000] Call Trace:
> > > [    6.752000]  [<c1021c4f>] ? copy_process+0xa1/0xd6d
> > > [    6.752000]  [<c1022a54>] ? do_fork+0x139/0x2ca
> > > [    6.752000]  [<c101d94a>] ? dequeue_task+0xb9/0xc8
> > > [    6.752000]  [<c1245597>] ? schedule+0x821/0x84b
> > > [    6.752000]  [<c1038079>] ? kthread+0x0/0x68
> > > [    6.752000]  [<c1007930>] ? kernel_thread+0x77/0x7f
> > > [    6.752000]  [<c1038079>] ? kthread+0x0/0x68
> > > [    6.752000]  [<c1002cbc>] ? kernel_thread_helper+0x0/0x10
> > > [    6.752000]  [<c1038172>] ? kthreadd+0x91/0xc7
> > > [    6.752000]  [<c10380e1>] ? kthreadd+0x0/0xc7
> > > [    6.752000]  [<c1002cc2>] ? kernel_thread_helper+0x6/0x10
> > > [    6.752000] Code: 98 80 f6 00 c0 40 f6 a9 37 61 f9 11 07 80 00 79 80 03 c1 c0 5f 42 f6 7c 5f 42 f6 30 79 00 c1 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 79 80 03 c1 70 3f 42 f6 00 
> > > [    6.752000] EIP: [<f6425f7c>] 0xf6425f7c SS:ESP 0068:f6425ee4
> > > [    6.752000] CR2: 00000000ffffffff
> > > [    6.752000] ---[ end trace 6000cf675d3eddec ]---
> > > 
> > > (captured two days ago)
> > > 
> > > Full bootlog is attached below.
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > > 
> > 
> > Hi,
> > 
> > this looks potentially like a separate issue from the 'hang' one - I'm wondering 
> > if this was re-produced with the same .config as the 'hang' case? I haven't been 
> > able to hit this one yet....
> 
> Not the same config, and it's very spurious - i.e. a slightly different -tip version 
> with the same config will boot fine. (this suggests some race)
> 
> Something very much not good with the fundamental mechanics of jump labels i'm 
> afraid. It might be corrupting some memory here, or have some window of 
> vulnerability in which an IRQ hits (or so) we will crash.
> 
> Thanks,
> 
> 	Ingo

we probably should have more sanity checks in the jump label code. The
patch below verifies the the src and target addresses are within the
text sections, and checks that we are not jumping to target out of
range. 

comments? it be nice to get these into the tree asap, so that these
might indicate what the issue is. Only lightly tested at this point.

thanks,

-Jason

Add sanity checks to the jump label code. Check that the src and dest
addresses are in the text sections, and that we aren't jump farther than
we can reach.


Signed-off-by: Jason Baron <jbaron@redhat.com>

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 961b6b3..14b2180 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -28,11 +28,17 @@ void arch_jump_label_transform(struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	union jump_code_union code;
+	long diff;
 
 	if (type == JUMP_LABEL_ENABLE) {
 		code.jump = 0xe9;
-		code.offset = entry->target -
-				(entry->code + JUMP_LABEL_NOP_SIZE);
+		diff = (long)entry->target -
+				((long)(entry->code + JUMP_LABEL_NOP_SIZE));
+		if (abs(diff) > 0x7fffffff) {
+			printk(KERN_ERR "jump label out of bounds!\n");
+			BUG();
+		}
+		code.offset = (s32)diff;
 	} else
 		memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
 	get_online_cpus();
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 7be868b..a33b01d 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -78,6 +78,28 @@ static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
 	return NULL;
 }
 
+static void verify_jump_addresses(struct jump_entry *table, int nr_entries)
+{
+	int count;
+	struct jump_entry *iter;
+
+	count = nr_entries;
+	iter = table;
+	while (count--) {
+		if (!kernel_text_address(iter->code)) {
+			printk(KERN_ERR "jump label: invalid src addr: %lx\n",
+					(unsigned long)iter->code);
+			BUG();
+		}
+		if (!kernel_text_address(iter->target)) {
+			printk(KERN_ERR "jump label: invalid dest addr: %lx\n",
+					(unsigned long)iter->target);
+			BUG();
+		}
+		iter++;
+	}
+}
+
 static struct jump_label_entry *
 add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
 {
@@ -85,6 +107,9 @@ add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
 	struct jump_label_entry *e;
 	u32 hash;
 
+	/* first verify that the addresses are ok */
+	verify_jump_addresses(table, nr_entries);
+
 	e = get_jump_label_entry(key);
 	if (e)
 		return ERR_PTR(-EEXIST);
@@ -289,6 +314,8 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
 {
 	struct jump_label_module_entry *e;
 
+	verify_jump_addresses(iter_begin, count);
+
 	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
 	if (!e)
 		return ERR_PTR(-ENOMEM);
