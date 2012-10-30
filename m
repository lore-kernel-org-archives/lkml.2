Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab2J3QrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:47:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52254 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588Ab2J3QrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:47:17 -0400
Date: Tue, 30 Oct 2012 09:46:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/4] CPU stall-warning changes for 3.8
Message-ID: <20121030164622.GA25108@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-2876-0000-0000-000001818111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series adds updates to RCU's CPU stall warning capability,
with patches as follows:

1.	For architectures without NMI-based stack-dump capability,
	have the current CPU remotely access the stalled CPU's stack
	to dump it.
2.	Include the number of the last grace period started and completed
	in RCU CPU stall warning messages.
3.	Dump the number of RCU callbacks on the system in order to help
	diagnose situations where spurious grace periods were started.
4.	Prototype patch to provide RCU CPU stall warning messages for
	Tiny RCU.

							Thanx, Paul

 b/include/linux/sched.h   |    2 
 b/kernel/rcu.h            |    7 +++
 b/kernel/rcupdate.c       |   52 +++++++++++++++++++++++++
 b/kernel/rcutiny.c        |    6 +-
 b/kernel/rcutiny_plugin.h |   56 +++++++++++++++++++++++++++
 b/kernel/rcutree.c        |   94 +++++++++++++++++++++-------------------------
 b/kernel/rcutree.h        |    5 --
 b/kernel/sched/core.c     |    6 ++
 b/lib/Kconfig.debug       |    2 
 9 files changed, 171 insertions(+), 59 deletions(-)

