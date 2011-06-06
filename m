Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1FFSHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:07:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63244 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1FFSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dIqDNY9GniMmjMz9MJAZm2knGsw1A+cjGvVc6vT7CRPoNPyJUE06Uvbcornp6CkyHa
         XvdgMWWu9CX0e6Uly6wfFV+VOzUB5Mm6u93ukPXyoVA6UU13JJDMVe74JeJHb03J/K1l
         GWoJvNahsBGy980LNIUX/v+hSHIULP1aAku3M=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@lxorguk.ukuu.org.uk,
        Mark Einon <Mark.Einon@gmail.com>, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH v2 3/7] staging: et131x: et131x_adapter.h checkpatch fixes
Date: Mon,  6 Jun 2011 19:07:00 +0100
Message-Id: <1307383624-8740-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
 <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon <Mark.Einon@gmail.com>

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |    2 +-
 drivers/staging/et131x/et131x_adapter.h |    8 ++++----
 drivers/staging/et131x/et131x_netdev.c  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index c634e35..1425af2 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -452,7 +452,7 @@ void ConfigFlowControl(struct et131x_adapter *etdev)
  */
 void UpdateMacStatHostCounters(struct et131x_adapter *etdev)
 {
-	struct _ce_stats_t *stats = &etdev->Stats;
+	struct ce_stats_t *stats = &etdev->Stats;
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
 
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index c9a119e..87905e7 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -67,7 +67,7 @@
  * Do not change these values: if changed, then change also in respective
  * TXdma and Rxdma engines
  */
-#define NUM_DESC_PER_RING_TX         512	/* TX Do not change these values */
+#define NUM_DESC_PER_RING_TX         512    /* TX Do not change these values */
 #define NUM_TCB                      64
 
 /*
@@ -98,7 +98,7 @@ struct rfd {
 #define FLOW_NONE	3
 
 /* Struct to define some device statistics */
-typedef struct _ce_stats_t {
+struct ce_stats_t {
 	/* Link Input/Output stats */
 	uint64_t ipackets;	/* # of in packets */
 	uint64_t opackets;	/* # of out packets */
@@ -143,7 +143,7 @@ typedef struct _ce_stats_t {
 
 	u32 SynchrounousIterations;
 	u32 InterruptStatus;
-} CE_STATS_t, *PCE_STATS_t;
+};
 
 
 /* The private adapter structure */
@@ -239,7 +239,7 @@ struct et131x_adapter {
 	u8 ReplicaPhyLoopbkPF;	/* Replica Enable Pass/Fail */
 
 	/* Stats */
-	CE_STATS_t Stats;
+	struct ce_stats_t Stats;
 
 	struct net_device_stats net_stats;
 	struct net_device_stats net_stats_prev;
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index b25bae2..5f6522c 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -161,7 +161,7 @@ struct net_device_stats *et131x_stats(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct net_device_stats *stats = &adapter->net_stats;
-	CE_STATS_t *devstat = &adapter->Stats;
+	struct ce_stats_t *devstat = &adapter->Stats;
 
 	stats->rx_packets = devstat->ipackets;
 	stats->tx_packets = devstat->opackets;
-- 
1.7.4.4

