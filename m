Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab0IKJgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 05:36:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:50447 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab0IKJgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 05:36:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,351,1280732400"; 
   d="scan'208";a="605970611"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC PATCH v10 05/16] Add a function to indicate if device use external buffer.
Date: Sat, 11 Sep 2010 17:52:58 +0800
Message-Id: <1284198789-5358-6-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1284198789-5358-5-git-send-email-xiaohui.xin@intel.com>
References: <1284198789-5358-1-git-send-email-xiaohui.xin@intel.com>
 <1284198789-5358-2-git-send-email-xiaohui.xin@intel.com>
 <1284198789-5358-3-git-send-email-xiaohui.xin@intel.com>
 <1284198789-5358-4-git-send-email-xiaohui.xin@intel.com>
 <1284198789-5358-5-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/netdevice.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5f192de..23d6ec0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1602,6 +1602,11 @@ extern gro_result_t	napi_gro_frags(struct napi_struct *napi);
 extern int netdev_mp_port_prep(struct net_device *dev,
 				struct mpassthru_port *port);
 
+static inline bool dev_is_mpassthru(struct net_device *dev)
+{
+	return dev && dev->mp_port;
+}
+
 static inline void napi_free_frags(struct napi_struct *napi)
 {
 	kfree_skb(napi->skb);
-- 
1.5.4.4

