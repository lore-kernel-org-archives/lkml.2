Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0ELVg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:36:58 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45099 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab0ELVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH RFC tip/core/rcu 18/23] net/netfilter: __rcu annotations
Date: Wed, 12 May 2010 14:33:37 -0700
Message-Id: <1273700022-16523-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/net/netfilter/nf_conntrack.h |    2 +-
 net/ipv4/netfilter/nf_nat_core.c     |    2 +-
 net/netfilter/core.c                 |    2 +-
 net/netfilter/nf_conntrack_ecache.c  |    4 ++--
 net/netfilter/nf_conntrack_extend.c  |    2 +-
 net/netfilter/nf_conntrack_proto.c   |    4 ++--
 net/netfilter/nf_log.c               |    2 +-
 net/netfilter/nf_queue.c             |    2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bde095f..92229d1 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -75,7 +75,7 @@ struct nf_conntrack_helper;
 /* nf_conn feature for connections that have a helper */
 struct nf_conn_help {
 	/* Helper. if any */
-	struct nf_conntrack_helper *helper;
+	struct nf_conntrack_helper __rcu *helper;
 
 	union nf_conntrack_help help;
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 4f8bddb..1263f2a 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -38,7 +38,7 @@ static DEFINE_SPINLOCK(nf_nat_lock);
 static struct nf_conntrack_l3proto *l3proto __read_mostly;
 
 #define MAX_IP_NAT_PROTO 256
-static const struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO]
+static const struct nf_nat_protocol __rcu *nf_nat_protos[MAX_IP_NAT_PROTO]
 						__read_mostly;
 
 static inline const struct nf_nat_protocol *
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 78b505d..fdaec7d 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -27,7 +27,7 @@
 
 static DEFINE_MUTEX(afinfo_mutex);
 
-const struct nf_afinfo *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
+const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;
 EXPORT_SYMBOL(nf_afinfo);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo)
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index f516961..97619fc 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -26,10 +26,10 @@
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
-struct nf_ct_event_notifier *nf_conntrack_event_cb __read_mostly;
+struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_event_cb);
 
-struct nf_exp_event_notifier *nf_expect_event_cb __read_mostly;
+struct nf_exp_event_notifier __rcu *nf_expect_event_cb __read_mostly;
 EXPORT_SYMBOL_GPL(nf_expect_event_cb);
 
 /* deliver cached events and clear cache entry - must be called with locally
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index fdc8fb4..9a0f75f 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -16,7 +16,7 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-static struct nf_ct_ext_type *nf_ct_ext_types[NF_CT_EXT_NUM];
+static struct nf_ct_ext_type __rcu *nf_ct_ext_types[NF_CT_EXT_NUM];
 static DEFINE_MUTEX(nf_ct_ext_type_mutex);
 
 void __nf_ct_ext_destroy(struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index a44fa75..45b8091 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -30,8 +30,8 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-static struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX] __read_mostly;
-struct nf_conntrack_l3proto *nf_ct_l3protos[AF_MAX] __read_mostly;
+static struct nf_conntrack_l4proto __rcu **nf_ct_protos[PF_MAX] __read_mostly;
+struct nf_conntrack_l3proto __rcu *nf_ct_l3protos[AF_MAX] __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_l3protos);
 
 static DEFINE_MUTEX(nf_ct_proto_mutex);
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 015725a..64ba4d6 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -16,7 +16,7 @@
 #define NF_LOG_PREFIXLEN		128
 #define NFLOGGER_NAME_LEN		64
 
-static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
+static const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
 static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
 static DEFINE_MUTEX(nf_log_mutex);
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index c49ef21..e137c6b 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -17,7 +17,7 @@
  * long term mutex.  The handler must provide an an outfn() to accept packets
  * for queueing and must reinject all packets it receives, no matter what.
  */
-static const struct nf_queue_handler *queue_handler[NFPROTO_NUMPROTO] __read_mostly;
+static const struct nf_queue_handler __rcu *queue_handler[NFPROTO_NUMPROTO] __read_mostly;
 
 static DEFINE_MUTEX(queue_handler_mutex);
 
-- 
1.7.0.6

