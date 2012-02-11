Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab2BKPCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 10:02:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41884 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab2BKPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 10:02:24 -0500
Subject: Re: [RFC][PATCH] sched: Optimize cgroup pick_next_task_fair
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Turner <pjt@google.com>, Venkatesh Pallipadi <venki@google.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1328943389.7340.29.camel@marge.simpson.net>
References: <1328936700.2476.17.camel@laptop>
	 <1328943389.7340.29.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Feb 2012 16:02:17 +0100
Message-ID: <1328972537.11320.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 07:56 +0100, Mike Galbraith wrote:
> On Sat, 2012-02-11 at 06:05 +0100, Peter Zijlstra wrote: 
> > Since commit 2f36825b1 ("sched: Next buddy hint on sleep and preempt
> > path") it is likely we pick a new task from the same cgroup, doing a put
> > and then set on all intermediate entities is a waste of time, so try to
> > avoid this.
> 
> Good idea, we need to lose some weight. 

I actually set out to do something else, but then ended up here.. weird
how that works ;-)

My initial idea was to try and get rid of the pick_next_entity()
downward walk by keeping that data up-to-date when we dequeue/enqueue.

That all got a tad convoluted, I'll have to try it again. Anyway, that
ended up needing to rework the put/set stuff, and that part wasn't as
bad.

