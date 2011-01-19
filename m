Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1ASGh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:37:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46245 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751955Ab1ASGh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:37:26 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Id/UkHg0Ih/hF+nJqTwkIXp3SzWaFphnMVz6bjh
	Z/LPEezYvi9n/l
Subject: Re: Bug in scheduler when using rt_mutex
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTinfGL3=8LKTx3gCg_V9DfXi44E2PxPd-vQVfALU@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295408637.8017.56.camel@marge.simson.net>
	 <AANLkTineieNdiKduDHQ-J+Xv6Pq9O0pTZraBJEw=p5e7@mail.gmail.com>
	 <1295415657.8017.113.camel@marge.simson.net>
	 <AANLkTinfGL3=8LKTx3gCg_V9DfXi44E2PxPd-vQVfALU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 07:37:21 +0100
Message-ID: <1295419041.8017.120.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 14:09 +0800, Yong Zhang wrote:
> On Wed, Jan 19, 2011 at 1:40 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Wed, 2011-01-19 at 12:35 +0800, Yong Zhang wrote:
> >
> >> cfs_rq->curr != se is always true.
> >
> > If that were always true, we'd illegally enqueue a running task.
> 
> I'm sorry that I'm not express myself correctly.

Human communication methods are all buggy as hell :)

> The conclusion of (cfs_rq->curr != se is always true) is not
> self-contained. IOW, it's based on one condition which is
> (task_of(se) != rq->curr). So what I want to say is:
> task_of(se) != rq->curr    ==>   cfs_rq_of(se)->curr != se
> So,
>          !running                   ==>   cfs_rq_of(se)->curr != se
> 
> Is this more clear?

Yeah.

	-Mike

