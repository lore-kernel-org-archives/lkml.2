Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0ERTLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:11:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49038 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab0ERTL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:11:29 -0400
Date: Tue, 18 May 2010 12:11:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, mathieu.desnoyers@efficios.com
Subject: [PATCH] selinux: remove all rcu head initializations
Message-ID: <20100518191125.GA7014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Would you guys like to carry this patch, or should I push it up
-tip?  If I don't hear otherwise from you, I will push it up -tip.
The INIT_RCU_HEAD() primitive is going away in favor of debugobjects.

							Thanx, Paul

------------------------------------------------------------------------

selinux: remove all rcu head initializations

Remove all rcu head inits. We don't care about the RCU head state before passing
it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
keep track of objects on stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Reviewed-by: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 989fef8..bf4e3bc 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -288,7 +288,6 @@ static struct avc_node *avc_alloc_node(void)
 	if (!node)
 		goto out;
 
-	INIT_RCU_HEAD(&node->rhead);
 	INIT_HLIST_NODE(&node->list);
 	avc_cache_stats_incr(allocations);
 
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index dc92792..65ebfe9 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -183,8 +183,6 @@ static void sel_netnode_insert(struct sel_netnode *node)
 		BUG();
 	}
 
-	INIT_RCU_HEAD(&node->rcu);
-
 	/* we need to impose a limit on the growth of the hash table so check
 	 * this bucket to make sure it is within the specified bounds */
 	list_add_rcu(&node->list, &sel_netnode_hash[idx].list);
