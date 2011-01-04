Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1ADIcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:32:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab1ADIcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:32:03 -0500
Message-ID: <4D22DB19.3000300@cn.fujitsu.com>
Date: Tue, 04 Jan 2011 16:32:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] rcu: call __rcu_read_unlock() in exit_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:31:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-04 16:31:44,
	Serialize complete at 2011-01-04 16:31:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rcu_read_unlock() is a wrapper of many things:
	the core __rcu_read_unlock(), debugs...etc.

It is better that we only calls the core __rcu_read_unlock() here.

signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a363871..94035a0 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -802,7 +802,7 @@ void exit_rcu(void)
 	if (t->rcu_read_lock_nesting == 0)
 		return;
 	t->rcu_read_lock_nesting = 1;
-	rcu_read_unlock();
+	__rcu_read_unlock();
 }
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
