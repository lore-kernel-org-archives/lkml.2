Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab2CZO0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:26:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40594 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2CZO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:18 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: david.daney@cavium.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:staging:octeon Fix typos in staging:octeon
Date: Mon, 26 Mar 2012 07:26:09 -0700
Message-Id: <1332771969-14754-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some typos an comments I found while reading. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/octeon/ethernet-rx.c   |    2 +-
 drivers/staging/octeon/ethernet-tx.c   |   10 +++++-----
 drivers/staging/octeon/ethernet-util.h |    2 +-
 drivers/staging/octeon/ethernet.c      |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 400df8c..5699e6f 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -162,7 +162,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 		/*
 		 * We received a packet with either an alignment error
 		 * or a FCS error. This may be signalling that we are
-		 * running 10Mbps with GMXX_RXX_FRM_CTL[PRE_CHK}
+		 * running 10Mbps with GMXX_RXX_FRM_CTL[PRE_CHK]
 		 * off. If this is the case we need to parse the
 		 * packet to determine if we can remove a non spec
 		 * preamble and generate a correct packet.
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 56d74dc..34ee51f 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -61,7 +61,7 @@
  * You can define GET_SKBUFF_QOS() to override how the skbuff output
  * function determines which output queue is used. The default
  * implementation always uses the base queue for the port. If, for
- * example, you wanted to use the skb->priority fieid, define
+ * example, you wanted to use the skb->priority field, define
  * GET_SKBUFF_QOS as: #define GET_SKBUFF_QOS(skb) ((skb)->priority)
  */
 #ifndef GET_SKBUFF_QOS
@@ -164,8 +164,8 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif
 
 	/*
-	 * Prefetch the private data structure.  It is larger that one
-	 * cache line.
+	 * Prefetch the private data structure.  If it is larger than the
+	 * one cache line.
 	 */
 	prefetch(priv);
 
@@ -290,8 +290,8 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * See if we can put this skb in the FPA pool. Any strange
 	 * behavior from the Linux networking stack will most likely
 	 * be caused by a bug in the following code. If some field is
-	 * in use by the network stack and get carried over when a
-	 * buffer is reused, bad thing may happen.  If in doubt and
+	 * in use by the network stack and gets carried over when a
+	 * buffer is reused, bad things may happen.  If in doubt and
 	 * you dont need the absolute best performance, disable the
 	 * define REUSE_SKBUFFS_WITHOUT_FREE. The reuse of buffers has
 	 * shown a 25% increase in performance under some loads.
diff --git a/drivers/staging/octeon/ethernet-util.h b/drivers/staging/octeon/ethernet-util.h
index 144fb99..2da5ce1 100644
--- a/drivers/staging/octeon/ethernet-util.h
+++ b/drivers/staging/octeon/ethernet-util.h
@@ -38,7 +38,7 @@ static inline void *cvm_oct_get_buffer_ptr(union cvmx_buf_ptr packet_ptr)
 }
 
 /**
- * INTERFACE - convert IPD port to locgical interface
+ * INTERFACE - convert IPD port to logical interface
  * @ipd_port: Port to check
  *
  * Returns Logical interface
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 9112cd8..4d70acf 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -356,7 +356,7 @@ static void cvm_oct_common_set_multicast_list(struct net_device *dev)
 			/* Force accept multicast packets */
 			control.s.mcst = 2;
 		else
-			/* Force reject multicat packets */
+			/* Force reject multicast packets */
 			control.s.mcst = 1;
 
 		if (dev->flags & IFF_PROMISC)
-- 
1.7.5.4

