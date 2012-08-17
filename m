Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2HQPV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:21:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab2HQPVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:21:18 -0400
Date: Fri, 17 Aug 2012 17:17:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120817151747.GA8248@redhat.com>
References: <20120724203613.GA9637@redhat.com> <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817151447.GA7918@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Oleg Nesterov wrote:
>
> On 08/16, Peter Zijlstra wrote:
> >
> >      write_lock_irq(&tasklist_lock)
> >      task_lock(parent)		parent->alloc_lock
>
> And this is already wrong. See the comment above task_lock().
>
> > And since it_lock is IRQ-safe and alloc_lock isn't, you've got the IRQ
> > inversion deadlock reported.
>
> Yes. Or, IOW, write_lock(tasklist) is IRQ-safe and thus it can't nest
> with alloc_lock.
>
> > David, Al, anybody want to have a go at fixing this?
>
> I still think that task_work_add() should synhronize with exit_task_work()
> itself and fail if necessary. But I wasn't able to convince Al ;)

And this is my old patch: http://marc.info/?l=linux-kernel&m=134082268721700
It should be re-diffed of course.

Oleg.

