Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1HMA2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:28:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64600 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab1HMA1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:52 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/10]net Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:14 -0700
Message-Id: <1313195235-4522-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock  <justinmattock@gmail.com>

---
 net/atm/clip.c            |    4 ++--
 net/atm/common.c          |    4 ++--
 net/atm/svc.c             |    4 ++--
 net/dsa/mv88e6060.c       |    2 +-
 net/dsa/mv88e6123_61_65.c |    4 ++--
 net/dsa/mv88e6131.c       |    2 +-
 net/sched/sch_atm.c       |    6 +++---
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/atm/clip.c b/net/atm/clip.c
index 8523940..82d1877 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -76,7 +76,7 @@ static void link_vcc(struct clip_vcc *clip_vcc, struct atmarp_entry *entry)
 {
 	pr_debug("%p to entry %p (neigh %p)\n", clip_vcc, entry, entry->neigh);
 	clip_vcc->entry = entry;
-	clip_vcc->xoff = 0;	/* @@@ may overrun buffer by one packet */
+	clip_vcc->xoff = 0;	/* may overrun buffer by one packet */
 	clip_vcc->next = entry->vccs;
 	entry->vccs = clip_vcc;
 	entry->neigh->used = jiffies;
@@ -343,7 +343,7 @@ static struct neigh_table clip_tbl = {
 	.gc_thresh3 	= 1024,
 };
 
-/* @@@ copy bh locking from arp.c -- need to bh-enable atm code before */
+/* copy bh locking from arp.c -- need to bh-enable atm code before */
 
 /*
  * We play with the resolve flag: 0 and 1 have the usual meaning, but -1 means
diff --git a/net/atm/common.c b/net/atm/common.c
index 14ff9fe..5164849 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -551,7 +551,7 @@ int vcc_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *m,
 		goto out;
 	}
 	if (m->msg_iovlen != 1) {
-		error = -ENOSYS; /* fix this later @@@ */
+		error = -ENOSYS; /* fix this later */
 		goto out;
 	}
 	buff = m->msg_iov->iov_base;
@@ -675,7 +675,7 @@ static int atm_change_qos(struct atm_vcc *vcc, struct atm_qos *qos)
 
 static int check_tp(const struct atm_trafprm *tp)
 {
-	/* @@@ Should be merged with adjust_tp */
+	/* Should be merged with adjust_tp */
 	if (!tp->traffic_class || tp->traffic_class == ATM_ANYCLASS)
 		return 0;
 	if (tp->traffic_class != ATM_UBR && !tp->min_pcr && !tp->pcr &&
diff --git a/net/atm/svc.c b/net/atm/svc.c
index 754ee47..852edd3 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -117,8 +117,8 @@ static int svc_bind(struct socket *sock, struct sockaddr *sockaddr,
 		goto out;
 	}
 	clear_bit(ATM_VF_BOUND, &vcc->flags);
-	    /* failing rebind will kill old binding */
-	/* @@@ check memory (de)allocation on rebind */
+	/* failing rebind will kill old binding */
+	/* check memory (de)allocation on rebind */
 	if (!test_bit(ATM_VF_HASQOS, &vcc->flags)) {
 		error = -EBADFD;
 		goto out;
diff --git a/net/dsa/mv88e6060.c b/net/dsa/mv88e6060.c
index 8f4ff5a..a9c522b 100644
--- a/net/dsa/mv88e6060.c
+++ b/net/dsa/mv88e6060.c
@@ -163,7 +163,7 @@ static int mv88e6060_setup(struct dsa_switch *ds)
 	if (ret < 0)
 		return ret;
 
-	/* @@@ initialise atu */
+	/* initialise atu */
 
 	ret = mv88e6060_setup_global(ds);
 	if (ret < 0)
diff --git a/net/dsa/mv88e6123_61_65.c b/net/dsa/mv88e6123_61_65.c
index 52faaa2..1c2fa39 100644
--- a/net/dsa/mv88e6123_61_65.c
+++ b/net/dsa/mv88e6123_61_65.c
@@ -175,7 +175,7 @@ static int mv88e6123_61_65_setup_global(struct dsa_switch *ds)
 	for (i = 0; i < 16; i++)
 		REG_WRITE(REG_GLOBAL2, 0x0f, 0x8000 | (i << 8));
 
-	/* @@@ initialise AVB (22/23) watchdog (27) sdet (29) registers */
+	/* initialise AVB (22/23) watchdog (27) sdet (29) registers */
 
 	return 0;
 }
@@ -329,7 +329,7 @@ static int mv88e6123_61_65_setup(struct dsa_switch *ds)
 	if (ret < 0)
 		return ret;
 
-	/* @@@ initialise vtu and atu */
+	/* initialise vtu and atu */
 
 	ret = mv88e6123_61_65_setup_global(ds);
 	if (ret < 0)
diff --git a/net/dsa/mv88e6131.c b/net/dsa/mv88e6131.c
index 9bd1061..caef6ea 100644
--- a/net/dsa/mv88e6131.c
+++ b/net/dsa/mv88e6131.c
@@ -325,7 +325,7 @@ static int mv88e6131_setup(struct dsa_switch *ds)
 	if (ret < 0)
 		return ret;
 
-	/* @@@ initialise vtu and atu */
+	/* initialise vtu and atu */
 
 	ret = mv88e6131_setup_global(ds);
 	if (ret < 0)
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index e25e490..547dd4c 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -16,7 +16,7 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 
-extern struct socket *sockfd_lookup(int fd, int *err);	/* @@@ fix this */
+extern struct socket *sockfd_lookup(int fd, int *err);	/* fix this */
 
 /*
  * The ATM queuing discipline provides a framework for invoking classifiers
@@ -248,7 +248,7 @@ static int atm_tc_change(struct Qdisc *sch, u32 classid, u32 parent,
 		error = -EPROTOTYPE;
 		goto err_out;
 	}
-	/* @@@ should check if the socket is really operational or we'll crash
+	/* should check if the socket is really operational or we'll crash
 	   on vcc->send */
 	if (classid) {
 		if (TC_H_MAJ(classid ^ sch->handle)) {
@@ -393,7 +393,7 @@ done:
 	} else {
 		if (flow->vcc)
 			ATM_SKB(skb)->atm_options = flow->vcc->atm_options;
-		/*@@@ looks good ... but it's not supposed to work :-) */
+		/* looks good ... but it's not supposed to work :-) */
 #ifdef CONFIG_NET_CLS_ACT
 		switch (result) {
 		case TC_ACT_QUEUED:
-- 
1.7.6

