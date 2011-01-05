Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1AEKa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:30:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52244 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751930Ab1AEKa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:30:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+xHQAMv9OxLWEgqn8OkCW4/xzTEQsdaJ0FUwaDza
	GLzVJU4EezbQft
Subject: Re: [PATCH] sched: fix struct autogroup memory leak
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1294222874.2016.231.camel@laptop>
References: <1294222285.8369.2.camel@marge.simson.net>
	 <1294222874.2016.231.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 11:30:45 +0100
Message-ID: <1294223445.8369.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 11:21 +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-05 at 11:11 +0100, Mike Galbraith wrote:
> 
> >  static inline void autogroup_free(struct task_group *tg)
> >  {
> > -	kfree(tg->autogroup);
> > +	if (tg->autogroup)
> > +		kfree(tg->autogroup);
> >  }
> 
> WARNING: kfree(NULL) is safe this check is probably not required
> #43: FILE: kernel/sched_autogroup.c:24:
> +       if (tg->autogroup)
> +               kfree(tg->autogroup);

Once upon a time, I knew that.

sched: fix struct autogroup memory leak

Add missing change to actually use autogroup_free().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8382,6 +8382,7 @@ static void free_sched_group(struct task
 {
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
+	autogroup_free(tg);
 	kfree(tg);
 }
 


