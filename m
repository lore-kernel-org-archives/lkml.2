Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0ELVes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:34:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45318 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173Ab0ELVeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:34:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH RFC tip/core/rcu 12/23] net: __rcu annotations for drivers
Date: Wed, 12 May 2010 14:33:31 -0700
Message-Id: <1273700022-16523-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/net/bnx2.h         |    2 +-
 drivers/net/bnx2x.h        |    2 +-
 drivers/net/cnic.h         |    2 +-
 drivers/net/macvtap.c      |    2 +-
 include/linux/if_macvlan.h |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bnx2.h b/drivers/net/bnx2.h
index cd4b0e4..7bdb1cb 100644
--- a/drivers/net/bnx2.h
+++ b/drivers/net/bnx2.h
@@ -6746,7 +6746,7 @@ struct bnx2 {
 	u32		tx_wake_thresh;
 
 #ifdef BCM_CNIC
-	struct cnic_ops		*cnic_ops;
+	struct cnic_ops	__rcu	*cnic_ops;
 	void			*cnic_data;
 #endif
 
diff --git a/drivers/net/bnx2x.h b/drivers/net/bnx2x.h
index 3c48a7a..9dfb57b 100644
--- a/drivers/net/bnx2x.h
+++ b/drivers/net/bnx2x.h
@@ -1007,7 +1007,7 @@ struct bnx2x {
 	dma_addr_t		timers_mapping;
 	void			*qm;
 	dma_addr_t		qm_mapping;
-	struct cnic_ops		*cnic_ops;
+	struct cnic_ops __rcu	*cnic_ops;
 	void			*cnic_data;
 	u32			cnic_tag;
 	struct cnic_eth_dev	cnic_eth_dev;
diff --git a/drivers/net/cnic.h b/drivers/net/cnic.h
index a0d853d..9852375 100644
--- a/drivers/net/cnic.h
+++ b/drivers/net/cnic.h
@@ -177,7 +177,7 @@ struct cnic_local {
 #define ULP_F_INIT	0
 #define ULP_F_START	1
 #define ULP_F_CALL_PENDING	2
-	struct cnic_ulp_ops *ulp_ops[MAX_CNIC_ULP_TYPE];
+	struct cnic_ulp_ops __rcu *ulp_ops[MAX_CNIC_ULP_TYPE];
 
 	/* protected by ulp_lock */
 	u32 cnic_local_flags;
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index abba3cc..adf0145 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -37,7 +37,7 @@
 struct macvtap_queue {
 	struct sock sk;
 	struct socket sock;
-	struct macvlan_dev *vlan;
+	struct macvlan_dev __rcu *vlan;
 	struct file *file;
 	unsigned int flags;
 };
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index b78a712..c15ed77 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -47,7 +47,7 @@ struct macvlan_dev {
 	enum macvlan_mode	mode;
 	int (*receive)(struct sk_buff *skb);
 	int (*forward)(struct net_device *dev, struct sk_buff *skb);
-	struct macvtap_queue	*tap;
+	struct macvtap_queue __rcu *tap;
 };
 
 static inline void macvlan_count_rx(const struct macvlan_dev *vlan,
-- 
1.7.0.6

