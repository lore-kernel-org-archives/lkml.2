Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1ASFlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:41:03 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53222 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751071Ab1ASFlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:41:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/x0C9PhpTxCCwSL41401xXCiKo7TCdexllcEOTJK
	K7D0Z2r14SQ7qI
Subject: Re: Bug in scheduler when using rt_mutex
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTineieNdiKduDHQ-J+Xv6Pq9O0pTZraBJEw=p5e7@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295408637.8017.56.camel@marge.simson.net>
	 <AANLkTineieNdiKduDHQ-J+Xv6Pq9O0pTZraBJEw=p5e7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 06:40:57 +0100
Message-ID: <1295415657.8017.113.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:35 +0800, Yong Zhang wrote:

> cfs_rq->curr != se is always true.

If that were always true, we'd illegally enqueue a running task.

        if (running)
                p->sched_class->set_curr_task(rq);
                ==> set_curr_task_fair(rq);
                ==>      struct sched_entity *se = &rq->curr->se;
                ==>      set_next_entity(cfs_rq_of(se), se);
                ==>          cfs_rq->curr = se;
                (prevents running entity from being enqueued below)
        if (on_rq) {
                enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);

                check_class_changed(rq, p, prev_class, oldprio, running);
        }

	-Mike

