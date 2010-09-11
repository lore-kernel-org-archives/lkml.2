Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab0IKJcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:32:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:60876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0IKJcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:32:32 -0400
Subject: Re: [PATCH] sched: Increment cache_nice_tries only on periodic lb
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1284167957-3675-1-git-send-email-venki@google.com>
References: <1284167957-3675-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 11 Sep 2010 11:32:21 +0200
Message-ID: <1284197541.2251.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 18:19 -0700, Venkatesh Pallipadi wrote:
> scheduler uses cache_nice_tries as an indicator to do cache_hot and active
> load balance, when normal load balance fails. Currently, this value is changed
> on any failed load balance attempt. That ends up being not so nice to workloads
> that enter/exit idle often, as they do more frequent new_idle balance and
> that pretty soon results in cache hot tasks being pulled in.
> 
> Making the cache_nice_tries ignore failed new_idle balance seems to make
> better sense. With that only the failed load balance in periodic load balance
> gets accounted and the rate of accumulation of cache_nice_tries will not
> depend on idle entry/exit (short running sleep-wakeup kind of tasks). This
> reduces movement of cache_hot tasks.

Seems to make sense..

I've also wondered if it would make sense to restore 0437e109e (sched:
zap the migration init / cache-hot balancing code), esp because what the
comment says isn't actually true anymore, we don't use the tree for
load-balancing.

But even if we were, the left size of the tree isn't the cold side, nor
would I guess the right side be.. tricky stuff that.

I know Gregory Haskins has played with restoring it, and I think he
found some benefit from it, although he didn't pursue it, it might be
worth seeing if it does for your workloads.

I've queued the patch, thanks!
