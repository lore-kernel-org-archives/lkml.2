Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1AUPDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:03:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36095 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1AUPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qZTYIGucaXu8MOUG/+uoeQOle/9hPGDfExdT7CRdAnxia7+Kk0V4Q685trC7ud8fBY
         UE6IdpqIhdyo+Rb/p/UtttxaiQXgRb1PE0A9GcReXCIeRy2jfbgY3SNVH9Q1GkkmSBBj
         4kVKcDw3Q3EvdiMni31ayDJHL4Re3JA3JvTP4=
Date: Fri, 21 Jan 2011 23:03:23 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bug in scheduler when using rt_mutex
Message-ID: <20110121150323.GC6051@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1295499568.8027.30.camel@marge.simson.net>
 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
 <1295503938.8027.59.camel@marge.simson.net>
 <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
 <1295512625.8027.88.camel@marge.simson.net>
 <AANLkTi=WhLy=4MNdm-HaOUOmbKXsNSJojnzqRTYp6qop@mail.gmail.com>
 <1295518047.8027.104.camel@marge.simson.net>
 <1295608136.28776.266.camel@laptop>
 <20110121122412.GA5071@zhy>
 <1295617258.28776.274.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1295617258.28776.274.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 02:40:58PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-01-21 at 20:24 +0800, Yong Zhang wrote:
> > > Index: linux-2.6/kernel/sched.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/sched.c
> > > +++ linux-2.6/kernel/sched.c
> > > @@ -2624,6 +2624,8 @@ void sched_fork(struct task_struct *p, i
> > >  
> > >       if (!rt_prio(p->prio))
> > >               p->sched_class = &fair_sched_class;
> > > +     else
> > > +             p->se.vruntime = 0;
> > 
> > This can be moved to __sched_fork() 
> 
> But we cannot do it unconditionally, we want to inherit the parent's
> ->vruntime when we're a fair task clone.

Doesn't task_fork_fair()(which is called after __sched_fork())
take the inherit job?

Am I missing something?

Thanks,
Yong
