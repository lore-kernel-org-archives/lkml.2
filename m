Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab2FHE1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45619 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2FHE1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:07 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH rcu 6/8] rcu: The rcu_needs_cpu() function is not a quiescent state
Date: Thu,  7 Jun 2012 21:26:53 -0700
Message-Id: <1339129615-1795-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
 <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-6148-0000-0000-00000685AAAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The TINY_PREEMPT_RCU() function rcu_preempt_needs_cpu(), which is called
from rcu_needs_cpu(), assumes that it is in a quiescent state with respect
to the CPU.  This is no longer the case.  This commit therefore updates
rcu_preempt_needs_cpu() to make it aware that it is not running in a
quiescent state.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
---
 kernel/rcutiny_plugin.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index fc31a2d..849ede5 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -846,8 +846,6 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
  */
 int rcu_preempt_needs_cpu(void)
 {
-	if (!rcu_preempt_running_reader())
-		rcu_preempt_cpu_qs();
 	return rcu_preempt_ctrlblk.rcb.rcucblist != NULL;
 }
 
-- 
1.7.8

