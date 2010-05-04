Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab0EDDgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:36:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50231 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab0EDDgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:36:20 -0400
Date: Mon, 3 May 2010 20:36:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT PULL] RCU fixes for 2.6.34
Message-ID: <20100504033616.GA6155@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here are RCU fixes for 2.6.34, mainly RCU-lockdep fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git urgent-to-mingo

This set excludes the three needing Acked-by, and also excludes the
commits targeted for 2.6.35.

							Thanx, Paul

------------------>
David Howells (2)
    KEYS: Fix an RCU warning in the reading of user keys
    KEYS: Fix an RCU warning

Lai Jiangshan (1)
    rcu: v2: optionally leave lockdep enabled after RCU lockdep splat

Li Zefan (4)
    cgroup: Check task_lock in task_subsys_state()
    sched: Fix an RCU warning in print_task()
    cgroup: Fix an RCU warning in alloc_css_id()
    cgroup: Fix an RCU warning in cgroup_path()

 include/linux/cgroup.h       |    1 +
 include/linux/rcupdate.h     |   15 +++++++++++----
 kernel/cgroup.c              |   16 +++++++++++-----
 kernel/lockdep.c             |    2 ++
 kernel/sched_debug.c         |    2 ++
 lib/Kconfig.debug            |   12 ++++++++++++
 security/keys/request_key.c  |   13 ++++++++-----
 security/keys/user_defined.c |    3 ++-
 8 files changed, 49 insertions(+), 15 deletions(-)
