Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab2AIWPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:15:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55011 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326Ab2AIWPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:15:07 -0500
Date: Mon, 9 Jan 2012 14:14:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/3] Additional RCU commits for 3.3
Message-ID: <20120109221457.GA28184@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010922-2398-0000-0000-00000346B44F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Further -next and other testing uncovered one upcoming change and some
build warnings.  The three commits below address these.  I am putting
them forward for 3.3, but of course if the risk of change exceeds the
magnitude of the problems, I can keep them queued for 3.4.  These are
all quite small, have been exposed to -next testing, and I retested them
against current tip/master.

The specific changes are as follows:

1.	Change rcutorture's module parameters of type int to instead
	be bool.  This is in preparation for Rusty's patch that makes
	type-int module parameters illegal.  (Courtesy of Rusty Russell.)

2.	Add "const" to the new is_idle_task()'s argument, which
	addresses a build warning located by Stephen Rothwell.

3.	Add __cpuinit to rcu_torture_onoff() to address a section
	mismatch build warning.  (Courtesy of Heiko Carstens.)

These changes are based off of 3.2-rc7 and are available in the git
repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

							Thanx, Paul

------------------>

Heiko Carstens (1):
      rcu: Add missing __cpuinit annotation in rcutorture code

Paul E. McKenney (1):
      sched: Add "const" to is_idle_task() parameter

Rusty Russell (1):
      rcu: Make rcutorture bool parameters really bool (core code)

 include/linux/sched.h |    2 +-
 kernel/rcutorture.c   |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

