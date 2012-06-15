Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2FOON2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:13:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:41572 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab2FOONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:13:25 -0400
Message-Id: <20120615140217.933711648@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jun 2012 14:13:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: [RFC patch V2 0/7] Per cpu thread hotplug infrastructure
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements the infrastructure for parking and
unparking kernel threads to avoid the full teardown and fork on cpu
hotplug operations along with management infrastructure for hotplug
and users.

Changes since V1:

 - Addressed the review comments
 - Fixed a missing state update in parkme (reported by Paul)
 - Simplified rcu_yield()
 - Added Pauls RCU conversion

Full diffstat below. Due to the RCU cleanup we now remove more code
than we add. :)

Thanks,

	tglx
---
 drivers/infiniband/hw/ehca/ehca_irq.c |  240 ++++++++-------------
 drivers/infiniband/hw/ehca/ehca_irq.h |    5 
 include/linux/kthread.h               |   11 
 include/linux/smpboot.h               |   40 +++
 kernel/cpu.c                          |   10 
 kernel/kthread.c                      |  184 ++++++++++++++--
 kernel/rcutree.c                      |   12 -
 kernel/rcutree.h                      |   15 -
 kernel/rcutree_plugin.h               |  375 +++++-----------------------------
 kernel/rcutree_trace.c                |    3 
 kernel/smpboot.c                      |  206 ++++++++++++++++++
 kernel/smpboot.h                      |    4 
 kernel/softirq.c                      |   84 +------
 kernel/watchdog.c                     |  232 ++++++---------------
 14 files changed, 678 insertions(+), 743 deletions(-)

