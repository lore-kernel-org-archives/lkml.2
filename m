Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab1LFD3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:29:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60558 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab1LFD3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:29:51 -0500
Date: Tue, 6 Dec 2011 11:29:33 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: [PATCH 3/3] rcu: use rt_mutex_lock_irqdisabled() in rcu_boost()
Message-ID: <20111206032933.GC17091@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
 <20111205164505.GB2326@linux.vnet.ibm.com>
 <20111206012635.GA32498@zhy>
 <20111206021227.GO2326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111206021227.GO2326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we will get false positive warning from might_sleep()

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2020e8a..489b1cd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1237,7 +1237,7 @@ static int rcu_boost(struct rcu_node *rnp)
 				   "rcu_boost_mutex");
 	t->rcu_boost_mutex = &mtx;
 	raw_spin_unlock(&rnp->lock); /* rrupts remain disabled. */
-	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
+	rt_mutex_lock_irqdisabled(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 	local_irq_restore(flags);
 
-- 
1.7.5.4

