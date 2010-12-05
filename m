Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab0LEU7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:59:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0LEU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:59:08 -0500
Date: Sun, 5 Dec 2010 21:58:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Colin Walters <walters@verbum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101205205844.GA7902@elte.hu>
References: <1289783580.495.58.camel@maggy.simson.net>
 <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
 <201012052118.43843.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012052118.43843.kernel@kolivas.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> Greets.
> 
> I applaud your efforts to continue addressing interactivity and responsiveness 
> but, I know I'm going to regret this, I feel strongly enough to speak up about 
> this change.
> 
> On Sun, 5 Dec 2010 10:43:44 Colin Walters wrote:
> > On Sat, Dec 4, 2010 at 5:39 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > What's your point again? It's a heuristic.
> > 
> > So if it's a heuristic the OS can get wrong,
> 
> This is precisely what I see as the flaw in this approach. [...]

I think you are misunderstanding Mike's auto-group scheduling feature.

The scheduling itself is not 'heuristics'.

It is the _composition of a group_ that has a heuristic default. (We use the 'tty' 
to act as the grouping)

But that can be changed: the cgroup interfaces can be (and are) used by Gnome to 
create different groups. They can be used by users as well, using cgroup tooling.

What the kernel does is that it provides sane defaults.

> [...]
>
> Move away from the fragile heuristic tweaks and find a longer term robust 
> solution.

This is not some kernel heuristic that cannot be modified - which was the main 
problem of the O(1) scheduler. This is a common-sense default that can be overriden 
by user-space if it wants to.

So i definitely think you are confusing the two cases.

Thanks,

	Ingo
