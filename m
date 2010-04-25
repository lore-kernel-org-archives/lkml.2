Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0DYJQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:16:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:24216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab0DYJQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:16:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,269,1270450800"; 
   d="scan'208";a="561295794"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC][PATCH v4 01/18] Add a new struct for device to manipulate external buffer.
Date: Sun, 25 Apr 2010 17:19:48 +0800
Message-Id: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/netdevice.h |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c79a88b..bf79756 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -530,6 +530,22 @@ struct netdev_queue {
 	unsigned long		tx_dropped;
 } ____cacheline_aligned_in_smp;
 
+/* Add a structure in structure net_device, the new field is
+ * named as mp_port. It's for mediate passthru (zero-copy).
+ * It contains the capability for the net device driver,
+ * a socket, and an external buffer creator, external means
+ * skb buffer belongs to the device may not be allocated from
+ * kernel space.
+ */
+struct mpassthru_port	{
+	int		hdr_len;
+	int		data_len;
+	int		npages;
+	unsigned	flags;
+	struct socket	*sock;
+	struct skb_external_page *(*ctor)(struct mpassthru_port *,
+				struct sk_buff *, int);
+};
 
 /*
  * This structure defines the management hooks for network devices.
@@ -952,7 +968,8 @@ struct net_device {
 	struct macvlan_port	*macvlan_port;
 	/* GARP */
 	struct garp_port	*garp_port;
-
+	/* mpassthru */
+	struct mpassthru_port	*mp_port;
 	/* class/net/name entry */
 	struct device		dev;
 	/* space for optional device, statistics, and wireless sysfs groups */
-- 
1.5.4.4

