Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0JUL0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:26:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab0JUL0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:26:37 -0400
Date: Thu, 21 Oct 2010 13:26:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101021112614.GB26984@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
 <20101019184111.GA17266@elte.hu>
 <20101020154045.GA18353@elte.hu>
 <1287659656.16971.573.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287659656.16971.573.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-10-20 at 17:40 +0200, Ingo Molnar wrote:
> > FYI, there's a new mystery hang (sometimes crash) that triggers in -tip - and which 
> > seems to be tracing related. See the crashlog below - config attached.
> > 
> > It's not bisectable - small changes in the kernel make the bug come/go. (might be a 
> > race of some sorts)
> > 
> 
> 
> > [   42.324027] Testing all events: 
> > [  245.668090] INFO: task swapper:1 blocked for more than 120 seconds.
> > [  245.672051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  245.676026] swapper       D f6420b40  6544     1      0 0x00000000
> > [  245.684051]  f6437dac 00000046 f694aac0 f6420b40 f6438000 f6437d74 f6438294 f6438290
> > [  245.692237]  c2192ac0 c204e6c0 c2192ac0 c2192ac0 f6438290 00000000 f6438000 ff2ffa7d
> > [  245.701068]  00000009 f6420b40 f6437e5c 7fffffff f6438000 f6437dfc f6437e5c 7fffffff
> > [  245.709071] Call Trace:
> > [  245.711551]  [<c1a7f561>] schedule_timeout+0x1c/0x1e7
> > [  245.712036]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> > [  245.716037]  [<c1027f2d>] ? sub_preempt_count+0x4/0x98
> > [  245.720061]  [<c1a818b6>] ? _raw_spin_unlock_irq+0x2d/0x43
> > [  245.724036]  [<c1027fb4>] ? sub_preempt_count+0x8b/0x98
> > [  245.728036]  [<c1a7e76b>] wait_for_common+0xc1/0x11a
> > [  245.732062]  [<c102de32>] ? default_wake_function+0x0/0x12
> > [  245.736041]  [<c1a7e863>] wait_for_completion+0x17/0x19
> > [  245.740069]  [<c10667a2>] __stop_cpus+0xdd/0x103
> > [  245.744072]  [<c1a7e6db>] ? wait_for_common+0x31/0x11a
> > [  245.748040]  [<c10665a4>] ? stop_machine_cpu_stop+0x0/0x9a
> > [  245.752040]  [<c106683d>] stop_cpus+0x2c/0x3f
> > [  245.756069]  [<c10668af>] __stop_machine+0x5f/0x67
> > [  245.760186]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> > [  245.764040]  [<c1006240>] ? stop_machine_text_poke+0x0/0x43
> > [  245.768071]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> > [  245.772040]  [<c10060fd>] text_poke_smp+0x3a/0x42
> > [  245.776039]  [<c19f0a73>] ? cfdgml_create+0x2b/0xde
> 
> 
> > [  245.780098]  [<c1005b9c>] arch_jump_label_transform+0x53/0x67
> > [  245.784042]  [<c104ef0d>] jump_label_update+0x49/0x98
> 
> Looks like this code had jump labels enabled. Do you have a dump where
> they are not enabled?

No. Good find - and the timeline agrees too, these crashes started triggering when i 
pulled jump labels from you.

Thanks,

	Ingo
