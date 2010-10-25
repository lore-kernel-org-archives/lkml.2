Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0JYJbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:31:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab0JYJbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:31:09 -0400
Date: Mon, 25 Oct 2010 11:30:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101025093045.GA21997@elte.hu>
References: <20101020164324.GC7348@redhat.com>
 <20101020183329.GA12666@elte.hu>
 <20101021110925.GA27219@elte.hu>
 <20101022175845.GF6498@redhat.com>
 <20101022182433.GA24637@elte.hu>
 <20101022183900.GG6498@redhat.com>
 <20101023200216.GA19324@elte.hu>
 <1287881618.16971.657.camel@gandalf.stny.rr.com>
 <20101024112540.GA21267@elte.hu>
 <20101025085927.GA11025@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025085927.GA11025@elte.hu>
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

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Interesting, the jump was to NULL. I'm thinking it hit a trace point and jumped 
> > > to a NULL address. I guess there's some strange race here. Is a cache flush 
> > > missing somewhere. I'll look more into this on Monday.
> > 
> > NULL wasnt the only crash i've seen in the past though, here's an older one:
> 
> here's another crash:

here's a repeat bootup with the same config:

Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: 
BUG: unable to handle kernel paging request at ffffffff
IP: [<b6c35f7c>] 0xb6c35f7c
*pde = 01b29067 *pte = 00000000 
Oops: 0002 [#1] SMP 
last sysfs file: 

Pid: 2, comm: kthreadd Not tainted 2.6.36-tip+ #52248 /
EIP: 0060:[<b6c35f7c>] EFLAGS: 00010282 CPU: 1
EAX: ffffffff EBX: 7902361a ECX: 00000000 EDX: 00000000
ESI: b6c35f7c EDI: fffffff4 EBP: b6c09c00 ESP: b6c35ee4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kthreadd (pid: 2, ti=b6c34000 task=b6c09c00 task.ti=b6c34000)
Stack:
 7902361a 00000001 00800711 00000400 b7006688 00000000 b6c35f7c 00000000
 b6c35f7c 00000000 00000000 b6c35f7c 790242e2 00000000 00000000 00000000
 00000000 00800711 00000000 00000000 00000000 00000000 00000409 00000400
Call Trace:
 [<7902361a>] ? 0x7902361a
 [<790242e2>] ? 0x790242e2
 [<79036c86>] ? 0x79036c86
 [<79007c1a>] ? 0x79007c1a
 [<79036c86>] ? 0x79036c86
 [<79002b78>] ? 0x79002b78
 [<79036d7b>] ? 0x79036d7b
 [<79036cee>] ? 0x79036cee
 [<79002b7e>] ? 0x79002b7e
Code: 00 00 00 40 99 20 00 b5 f9 e6 c0 11 07 80 00 86 6c 03 79 c0 5f c3 b6 7c 5f c3 b6 1a 7c 00 79 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 86 6c 03 79 74 3f c3 b6 00 
EIP: [<b6c35f7c>]  SS:ESP 0068:b6c35ee4
CR2: 00000000ffffffff

similar crash pattern, but slightly different place of crash.

	Ingo
