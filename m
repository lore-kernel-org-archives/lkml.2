Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1ATGMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:12:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47906 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752239Ab1ATGMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:12:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZGd1288EZ6d0kJldFZRZiNMm+Zs66aLRlS6DO9U
	NUmmZXGeo5kBuO
Subject: Re: Bug in scheduler when using rt_mutex
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295430276.30950.1414.camel@laptop> <1295433498.30950.1482.camel@laptop>
	 <1295436632.30950.1542.camel@laptop> <1295441881.11678.41.camel@kolo>
	 <1295442799.11678.43.camel@kolo> <1295443822.28776.23.camel@laptop>
	 <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
	 <1295499568.8027.30.camel@marge.simson.net>
	 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 07:12:18 +0100
Message-ID: <1295503938.8027.59.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 13:30 +0800, Yong Zhang wrote:
> On Thu, Jan 20, 2011 at 12:59 PM, Mike Galbraith <efault@gmx.de> wrote:
> > or the task is enqueued
> > at it's last offset as usual for runnable tasks.
> 
> But shouldn't we task the tasks as WAKEUP, through the task has been
> waked on other sched_class?

We don't need to play any games with it afaiks, just normalize it, and
the rest is taken care of automatically.
 
> IOW, I wonder if we should play with place_entity() at some point.

If the task returns as a sleeper, place entity() will be called when it
is awakened, so it's sleep credit will be clipped as usual.  So vruntime
can be much less than min_vruntime at class exit time, and it doesn't
matter, clipping on wakeup after re-entry takes care of it.. if that's
what you were thinking about.

	-Mike

