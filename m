Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2JLHyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:54:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48303 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab2JLHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:54:05 -0400
Date: Fri, 12 Oct 2012 09:53:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        kirill@shutemov.name
Subject: Re: [GIT PULL rcu/urgent] Fixes for RCU regressions
Message-ID: <20121012075359.GA19783@gmail.com>
References: <20121011172237.GA32051@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011172237.GA32051@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This series fixes some RCU regressions in 3.7.
> 
> Kirill A. Shutemov found a case where synchronize_rcu() is invoked
> from a CPU-hotplug notifier, which, with RCU's shiny new kthread-based
> grace-period implementation, results in deadlock.  The first commit
> in this series fixes this deadlock by introducing RCU-specific
> synchronization, so that RCU grace periods exclude only RCU's CPU-hotplug
> notifiers, not the entire CPU-hotplug operation.  Kirill successfully
> tested this commit (as have I), and it has furthermore been exposed to
> -next testing.
> 
> The other commit in this series adds a warning to the new RCU_USER_QS
> and RCU_USER_QS_FORCE Kconfig options, noting that these features,
> though reasonably stable, are probably not ready for millions of users.
> This commit affects only the Kconfig help text.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
> 
> 							Thanx, Paul
> 
> ------------------>
> Frederic Weisbecker (1):
>       rcu: Advise most users not to enable RCU user mode
> 
> Paul E. McKenney (1):
>       rcu: Grace-period initialization excludes only RCU notifier
> 
>  init/Kconfig     |   12 ++++++++++++
>  kernel/rcutree.c |   21 ++++++++++-----------
>  kernel/rcutree.h |    6 ++++++
>  3 files changed, 28 insertions(+), 11 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
