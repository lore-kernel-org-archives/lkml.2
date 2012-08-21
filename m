Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2HUShu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758354Ab2HUShr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:37:47 -0400
Date: Tue, 21 Aug 2012 20:34:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120821183408.GA11721@redhat.com>
References: <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins> <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins> <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins> <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821182751.GA11243@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Oleg Nesterov wrote:
>
> static inline bool cmp_xchg(struct callback_head **ptr, void *old, void *new)
> {
> 	return cmpxchg(ptr, old, new) == old;
> }
>
> int
> task_work_add(struct task_struct *task, struct callback_head *twork, bool notify)
> {
> 	do {
> 		twork->next = ACCESS_ONCE(task->task_works);
> 		if (unlikely(twork->next == TWORK_EXITED))
> 			return -ESRCH;
> 	} while (cmp_xchg(&task->task_works, twork->next, twork));
          ^^^^^^^^^^^^^^^

while (!cmp_xchg(...))

Oleg.

