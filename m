Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691Ab1EANcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:32:51 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38385 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab1EANWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 44/86] net,rcu: convert call_rcu(dn_dev_free_ifa_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:24 -0700
Message-Id: <1304256126-26015-44-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback dn_dev_free_ifa_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(dn_dev_free_ifa_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/decnet/dn_dev.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 0dcaa90..4c27615 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -332,14 +332,9 @@ static struct dn_ifaddr *dn_dev_alloc_ifa(void)
 	return ifa;
 }
 
-static void dn_dev_free_ifa_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct dn_ifaddr, rcu));
-}
-
 static void dn_dev_free_ifa(struct dn_ifaddr *ifa)
 {
-	call_rcu(&ifa->rcu, dn_dev_free_ifa_rcu);
+	kfree_rcu(ifa, rcu);
 }
 
 static void dn_dev_del_ifa(struct dn_dev *dn_db, struct dn_ifaddr __rcu **ifap, int destroy)
-- 
1.7.3.2

