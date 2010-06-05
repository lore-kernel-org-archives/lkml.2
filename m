Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab0FEKMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:12:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:64909 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab0FEKHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:07:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,366,1272870000"; 
   d="scan'208";a="804988038"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC PATCH v7 06/19] Add a function to indicate if device use external buffer.
Date: Sat,  5 Jun 2010 18:14:45 +0800
Message-Id: <1275732899-5423-6-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1275732899-5423-5-git-send-email-xiaohui.xin@intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-2-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-3-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-4-git-send-email-xiaohui.xin@intel.com>
 <1275732899-5423-5-git-send-email-xiaohui.xin@intel.com>
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
index 31d9c4a..0cb78f4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1602,6 +1602,11 @@ extern void netdev_mp_port_detach(struct net_device *dev);
 extern int netdev_mp_port_prep(struct net_device *dev,
 			struct mpassthru_port *port);
 
+static inline bool dev_is_mpassthru(struct net_device *dev)
+{
+	return (dev && dev->mp_port);
+}
+
 static inline void napi_free_frags(struct napi_struct *napi)
 {
 	kfree_skb(napi->skb);
-- 
1.5.4.4

