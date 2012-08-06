Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2HFUJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:09:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36863 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752836Ab2HFUJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:09:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18HFLV1yW8HvA2Wb7TUWcuqUzJybZlsgkwrrB+5pr
	PexhZuNXMHXbO8
Message-ID: <1344283776.6768.10.camel@marge.simpson.net>
Subject: Re: [patch] sched,cgroup_sched: fix up task_groups list
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 06 Aug 2012 22:09:36 +0200
In-Reply-To: <1344279897.27828.97.camel@twins>
References: <1344267125.6853.33.camel@marge.simpson.net>
	 <1344279897.27828.97.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 21:04 +0200, Peter Zijlstra wrote: 
> On Mon, 2012-08-06 at 17:32 +0200, Mike Galbraith wrote:
> > Thinko happened during sched migration to kernel/sched, fix it up.
> 
> what's the effect.. that is what broke and why are we backporting this
> to -stable?

The effect is that for_each_rt_rq() doesn't work, because it's not the
same task_groups list that groups were added to, it's an empty list, so
__enable/disable_runtime() and print_rt_stats() don't work, and you
can't see rt task groups.

-Mike

