Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab2JKRXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:23:19 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38638 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759004Ab2JKRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:23:18 -0400
Date: Thu, 11 Oct 2012 10:22:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, kirill@shutemov.name
Subject: [GIT PULL rcu/urgent] Fixes for RCU regressions
Message-ID: <20121011172237.GA32051@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101117-5518-0000-0000-0000085BB408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series fixes some RCU regressions in 3.7.

Kirill A. Shutemov found a case where synchronize_rcu() is invoked
from a CPU-hotplug notifier, which, with RCU's shiny new kthread-based
grace-period implementation, results in deadlock.  The first commit
in this series fixes this deadlock by introducing RCU-specific
synchronization, so that RCU grace periods exclude only RCU's CPU-hotplug
notifiers, not the entire CPU-hotplug operation.  Kirill successfully
tested this commit (as have I), and it has furthermore been exposed to
-next testing.

The other commit in this series adds a warning to the new RCU_USER_QS
and RCU_USER_QS_FORCE Kconfig options, noting that these features,
though reasonably stable, are probably not ready for millions of users.
This commit affects only the Kconfig help text.

These changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

							Thanx, Paul

------------------>
Frederic Weisbecker (1):
      rcu: Advise most users not to enable RCU user mode

Paul E. McKenney (1):
      rcu: Grace-period initialization excludes only RCU notifier

 init/Kconfig     |   12 ++++++++++++
 kernel/rcutree.c |   21 ++++++++++-----------
 kernel/rcutree.h |    6 ++++++
 3 files changed, 28 insertions(+), 11 deletions(-)

