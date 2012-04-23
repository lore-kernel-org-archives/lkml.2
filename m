Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2DWQQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:16:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47501 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2DWQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:16:51 -0400
Date: Mon, 23 Apr 2012 09:15:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH RFC tip/core/rcu 0/4] Updates to RCU_FAST_NO_HZ
Message-ID: <20120423161539.GA6467@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-2398-0000-0000-0000060943C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series covers enhancements to RCU_FAST_NO_HZ intended for v3.4-rc2.
The individual commits are as follows:

1.	Add tracing to rcu_cleanup_after_idle().
2.	Switch from hrtimer to normal timers to reduce overhead.
3.	Upgrade RCU_FAST_NO_HZ state machine to better account for
	brief pauses out of idle, which can happen due to power-management
	actions, Steven Rostedt's new RCU-idle-capable tracing macros,
	or my RCU_NONIDLE() macro.
4.	Use add_timer_on() to avoid timer migration.

							Thanx, Paul


 b/include/trace/events/rcu.h |    1 
 b/kernel/rcutree.c           |    2 
 b/kernel/rcutree.h           |    1 
 b/kernel/rcutree_plugin.h    |    1 
 kernel/rcutree_plugin.h      |  112 ++++++++++++++++++++++++++++---------------
 5 files changed, 80 insertions(+), 37 deletions(-)

