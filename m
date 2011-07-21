Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab1GUGiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:38:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36156 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1GUGiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:38:14 -0400
From: jhbird.choi@samsung.com
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        "Choi, Jong-Hwan" <jhbird.choi@samsung.com>
Subject: [PATCH] net: Kobj and queues_kset should be used when CONFIG_XPS is enabled
Date: Thu, 21 Jul 2011 15:33:03 +0900
Message-Id: <1311229983-6081-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Choi, Jong-Hwan <jhbird.choi@samsung.com>

Kobj and queues_kset are used with CONFIG_XPS=y.

Signed-off-by: Choi, Jong-Hwan <jhbird.choi@samsung.com>
---
 include/linux/netdevice.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9e19477..8eb2f11 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -556,7 +556,7 @@ struct netdev_queue {
 	struct Qdisc		*qdisc;
 	unsigned long		state;
 	struct Qdisc		*qdisc_sleeping;
-#ifdef CONFIG_RPS
+#if defined(CONFIG_RPS) || defined(CONFIG_XPS)
 	struct kobject		kobj;
 #endif
 #if defined(CONFIG_XPS) && defined(CONFIG_NUMA)
@@ -1214,7 +1214,7 @@ struct net_device {
 
 	unsigned char		broadcast[MAX_ADDR_LEN];	/* hw bcast add	*/
 
-#ifdef CONFIG_RPS
+#if defined(CONFIG_RPS) || defined(CONFIG_XPS)
 	struct kset		*queues_kset;
 
 	struct netdev_rx_queue	*_rx;
-- 
1.7.1

