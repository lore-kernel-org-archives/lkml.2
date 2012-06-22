Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284Ab2FVPPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:15:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:40690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab2FVPPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:15:16 -0400
Message-ID: <1340378107.18025.79.camel@twins>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: mingo@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Date: Fri, 22 Jun 2012 17:15:07 +0200
In-Reply-To: <4FE48A09.7050305@canonical.com>
References: <1340364965.18025.71.camel@twins>
	 <4FE48A09.7050305@canonical.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 17:06 +0200, Stefan Bader wrote:
> > @@ -7595,6 +7597,11 @@ void sched_move_task(struct task_struct *tsk)
> >       if (unlikely(running))
> >               tsk->sched_class->put_prev_task(rq, tsk);
> >  
> > +     tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
> s/p/tsk/
> > +                       struct task_group, css);
> > +     tg = autogroup_task_group(p, tg);
> s/p/tsk/
> > +     tsk->sched_task_group = tg;
> > + 

Hmm, I'm very sure I at least compiled a kernel after this.. must've
been the wrong machine.. /me dons a brown paper bag.
