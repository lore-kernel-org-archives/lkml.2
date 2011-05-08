Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1EHNdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 09:33:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36046 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1EHNds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 09:33:48 -0400
Date: Sun, 8 May 2011 06:33:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/3] signed overflow, virtualization
 optimizations, deadlock avoidance
Message-ID: <20110508133343.GA18287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset adds a few more commits to the list:

1.	Rework check_cpu_stall to avoid signed overflow.
2.	Provide an RCU API for better detection of running in a
	guest OS (thanks to Gleb Natapov).
3.	Permit rcu_read_unlock() to be called while holding one
	of the runqueue locks in response to a lockdep splat,
	quite possibly from Valdis Kletnieks.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

 b/include/linux/rcutiny.h |    8 +++++
 b/include/linux/rcutree.h |   10 +++++++
 b/kernel/rcutree.c        |   13 +++++----
 b/kernel/rcutree.h        |    5 ---
 b/kernel/rcutree_plugin.h |   64 ++++++++++++++--------------------------------
 kernel/rcutree.c          |   45 ++++++++++----------------------
 6 files changed, 61 insertions(+), 84 deletions(-)
