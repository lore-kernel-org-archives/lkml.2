Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0GHHUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:20:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0GHHUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:20:00 -0400
Date: Thu, 8 Jul 2010 09:19:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Venkatesh Pallipadi <venki@google.com>, Pierre Tardy <tardyp@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf migration
Message-ID: <20100708071942.GA26454@elte.hu>
References: <20100707151318.GA5984@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707151318.GA5984@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4602]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> To begin with, the name is a bit pompous. It's not a strong cpu task 
> migration observer as it's only based on the number of tasks living in a cpu 
> runqueue. This is the only basis for the cpu load: it doesn't handle the 
> nice level, scheduler classes, of each tasks (except idle ones that don't 
> count on the load).
> 
> At least not yet.
> 
> But still I think it's a cool toy, I've been playing with it for the last 
> weeks and it can give you a nice overview of what happens wrt migration 
> decisions for each migration opportunities: wake up, fork and exec, sleep 
> (sleep doesn't involve migration decision, but it's still an rq detach), and 
> load balancing. In fact it's more about "runqueue events".

Cool, looks really nice!

> == How to use ==
> 
> 
> I suggest you to use latest tip:/perf/core
> 
> Run the following command (followed by a command if you want):
> 
> $ sudo ./perf record -m 16384 -a -e sched:sched_wakeup -e sched:sched_wakeup_new -e sched:sched_switch -e sched:sched_migrate_task

Does 'perf sched record' include these events?

> Now ensure you have no lost events:
> 
> 
> $ sudo ./perf trace -d
> Misordered timestamps: 0
> Lost events: 0 <----

We need some warning for this in the GUI i guess?

> If so you need to increase the buffer size (-m nr_pages option in perf record).
> 
> Then put the script in the tools/perf directory and run it:
> 
> $ ./perf trace -s migration.py
> 
> You'll need wxpython.

Looks like this could be turned into 'perf sched view' or 'perf sched 
migration'?

How tasks schedule/migrate is basically how scheduler developers look at 
sched-trace data, so it would be nice if your GUI became the gui for perf 
sched.

	Ingo
