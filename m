Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1EQS1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:27:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44441 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756144Ab1EQS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:27:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+RSSERdQSRNdoOOln2+xPvqyt5wVkQ4anO0JeMwi
	C84O5nu1Z545e9
Subject: Re: [PATCH] sched: fix how RT task is pulled
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <BANLkTimOfL9iWFEhV6tQcTBM+V5N3b+-YA@mail.gmail.com>
References: <BANLkTinw9LLiGD788+6AvbE+54jyVRUwBg@mail.gmail.com>
	 <BANLkTikPhwajRBZ-dx46NnobOu10AmXoSg@mail.gmail.com>
	 <BANLkTimOfL9iWFEhV6tQcTBM+V5N3b+-YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 20:27:09 +0200
Message-ID: <1305656829.6238.41.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 22:47 +0800, Hillf Danton wrote:
> On Tue, May 17, 2011 at 10:35 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Sun, May 15, 2011 at 10:50 AM, Hillf Danton <dhillf@gmail.com> wrote:
> >> When pulling RT task for a given runqueue, if it is already overloaded
> >> with RT tasks, the pull operation could be avoided at the moment.
> >>
> >> btw, it looks like a typo?
> >
> > No.
> >
> > Below is how rt_overloaded() is realized:
> > static inline int rt_overloaded(struct rq *rq)
> > {
> >        return atomic_read(&rq->rd->rto_count);
> > }
> >
> > You can notice it's about the overload of the very root_domain.
> >
> Well, why is it going no head if not overloaded?

To avoid examining masks (maybe huge) routinely.  Challenge is to
improve oddball case (overload) without injuring the common case.

	-Mike

