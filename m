Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1EPOLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:11:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53107 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755276Ab1EPOLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:11:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX195IUVkUpt5fYOduV42n98H5VRgLE0aJ1CFIKzIq/
	Ocf6LY/232ysYs
Subject: Re: [PATCH] sched: avoid overpull when pulling RT task
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTino730kar=fEDJGCy8bCSVUe52aOw@mail.gmail.com>
References: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
	 <1305441316.7460.40.camel@marge.simson.net>
	 <BANLkTino730kar=fEDJGCy8bCSVUe52aOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 16:11:17 +0200
Message-ID: <1305555077.12285.63.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 21:14 +0800, Hillf Danton wrote:

> In the following patch, pulling is played in two rounds. In the first round,
> the highest priority task is determined with no pull operation. Pulling is
> carried out in the second round, and if the highest priority task is pulled,
> pulling could be stopped when overload detected, to relieve overpull.
> 
> Please review again, thanks.

Traversing runqueues twice to avoid some potential task bouncing during
overload situation seems like a really bad trade.  Not to mention that
between pass one and pass two, the world turns under your feet.

You could do it in one pass by leaving the victim's runqueue locked
unless you find a better victim I suppose.  Dunno, guess it all depends
on how much benefit the is to pulling only highest, which I can't answer
(my gut says "none, only more pain to be had here").

	-Mike

