Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2KSFk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:40:58 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41685 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2KSF31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:27 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 13/58] RCU: Make rcu_is_cpu_rrupt_from_idle helper functions static
Date: Sun, 18 Nov 2012 21:27:52 -0800
Message-Id: <1353302917-13995-14-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both rcutiny and rcutree define a helper funtion
rcu_is_cpu_rrupt_from_idle, each used exactly once, later in the same
file.  Declare these helper functions static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutiny.c |    2 +-
 kernel/rcutree.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e4c6a59..0e506c3 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -193,7 +193,7 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
  * interrupts don't count, we must be running at the first interrupt
  * level.
  */
-int rcu_is_cpu_rrupt_from_idle(void)
+static int rcu_is_cpu_rrupt_from_idle(void)
 {
 	return rcu_dynticks_nesting <= 0;
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..70d9b6e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -783,7 +783,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
  * interrupt from idle, return true.  The caller must have at least
  * disabled preemption.
  */
-int rcu_is_cpu_rrupt_from_idle(void)
+static int rcu_is_cpu_rrupt_from_idle(void)
 {
 	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
 }
-- 
1.7.10.4

