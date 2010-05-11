Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0EKXdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:33:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58631 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0EKXdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:33:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH RFC tip/core/rcu 06/11] staging: remove all rcu head initializations
Date: Tue, 11 May 2010 16:33:01 -0700
Message-Id: <1273620786-20392-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100511233241.GA20250@linux.vnet.ibm.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/batman-adv/hard-interface.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index befd488..96ea0e5 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -301,7 +301,6 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if->if_num = if_num;
 	batman_if->dev = dev;
 	batman_if->if_active = IF_INACTIVE;
-	INIT_RCU_HEAD(&batman_if->rcu);
 
 	printk(KERN_INFO "batman-adv:Adding interface: %s\n", dev);
 	avail_ifs++;
-- 
1.7.0.6

