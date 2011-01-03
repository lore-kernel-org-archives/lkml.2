Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1ACQlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:41:31 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33071 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab1ACQla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:41:30 -0500
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to
 sched_class::select_task_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1294072517.2016.101.camel@laptop>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.887559254@chello.nl> <20101229143136.GC2728@zhy>
	 <1294053409.2016.59.camel@laptop> <20110103145902.GA7632@redhat.com>
	 <1294068061.2016.84.camel@laptop>  <20110103154918.GB7632@redhat.com>
	 <1294072517.2016.101.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 17:41:36 +0100
Message-ID: <1294072896.2016.103.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 17:35 +0100, Peter Zijlstra wrote:
> > In fact, I am completely confused. I do not understand why do we
> > check task_running() at all. If we see on_rq == 0 && on_cpu == 1,
> > then this task is going to clear its on_cpu soon, once it finishes
> > context_switch().
> 
> > Probably, this check was needed before, try_to_wake_up() could
> > activate the task_running() task without migrating. But, at first
> > glance, this is no longer possible after this series?
> 
> It can still do that, I think the problem is us dropping rq->lock in the
> middle of schedule(), when the freshly woken migration thread comes in
> between there and moves the task away, you can get into the situation
> that two cpus reference the same task_struct at the same time, which
> usually leads to 'interesting' situations. 

Frr, brainfart, you cannot schedule the migration thread without
completely finishing prev.

/me goes ponder more
