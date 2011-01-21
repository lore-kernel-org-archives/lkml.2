Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1AUNkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:40:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:48094 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1AUNkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:40:20 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110121122412.GA5071@zhy>
References: <1295443822.28776.23.camel@laptop>
	 <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
	 <1295499568.8027.30.camel@marge.simson.net>
	 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
	 <1295503938.8027.59.camel@marge.simson.net>
	 <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
	 <1295512625.8027.88.camel@marge.simson.net>
	 <AANLkTi=WhLy=4MNdm-HaOUOmbKXsNSJojnzqRTYp6qop@mail.gmail.com>
	 <1295518047.8027.104.camel@marge.simson.net>
	 <1295608136.28776.266.camel@laptop>  <20110121122412.GA5071@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Jan 2011 14:40:58 +0100
Message-ID: <1295617258.28776.274.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 20:24 +0800, Yong Zhang wrote:
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -2624,6 +2624,8 @@ void sched_fork(struct task_struct *p, i
> >  
> >       if (!rt_prio(p->prio))
> >               p->sched_class = &fair_sched_class;
> > +     else
> > +             p->se.vruntime = 0;
> 
> This can be moved to __sched_fork() 

But we cannot do it unconditionally, we want to inherit the parent's
->vruntime when we're a fair task clone.
