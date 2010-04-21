Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0DUUB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:01:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38396 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0DUUBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:01:55 -0400
Date: Wed, 21 Apr 2010 13:01:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/core/urgent] fix several lockdep splats, allow multiple
 splats
Message-ID: <20100421200150.GA3818@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset contains four RCU lockdep splat fixes, courtesy of David
Howells, Peter Zijlstra, and Trond Myklebust, as well as an enhancement
by Lai Jiangshan that permits collecting more than one RCU lockdep splat
per boot.

							Thanx, Paul

------------------------------------------------------------------------

 b/fs/nfs/delegation.c      |   42 ++++++++++++++++++++++++++++--------------
 b/include/linux/rcupdate.h |   15 +++++++++++----
 b/kernel/cgroup_freezer.c  |    5 ++++-
 b/kernel/lockdep.c         |    2 --
 b/kernel/sched.c           |   10 ++++++++++
 fs/nfs/delegation.c        |   44 +++++++++++++++++++++++---------------------
 6 files changed, 76 insertions(+), 42 deletions(-)
