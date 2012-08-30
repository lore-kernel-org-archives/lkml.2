Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2H3Vnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:43:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54722 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2H3Vnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:40 -0400
Date: Thu, 30 Aug 2012 12:02:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/3] CPU-hotplug changes
Message-ID: <20120830190245.GA32625@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-9360-0000-0000-00000A06A23A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains fixes and improvements related to CPU hotplug:

1.	Remove _rcu_barrier() dependency on __stop_machine().
2.	Disallow callback registry on offline CPUs.
3.	Fix load avg vs cpu-hotplug (with Peter Zijlstra).

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcutree.c       |   83 ++++++-----------------------------------------
 b/kernel/rcutree.h       |    3 -
 b/kernel/rcutree_trace.c |    4 +-
 b/kernel/sched/core.c    |   41 +++++++++++------------
 kernel/rcutree.c         |   10 +++++
 5 files changed, 43 insertions(+), 98 deletions(-)

