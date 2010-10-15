Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0JOI4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:56:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:60392 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab0JOIwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:52:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,335,1283756400"; 
   d="scan'208";a="616995393"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v13 05/16] Add a function to indicate if device use external buffer.
Date: Fri, 15 Oct 2010 17:12:06 +0800
Message-Id: <e23470ddc6e09f8a7002dea7837685c546ce791d.1287132437.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1287133937-5538-1-git-send-email-xiaohui.xin@intel.com>
References: <1287133937-5538-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1287132437.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1287132437.git.xiaohui.xin@intel.com>
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
index 8dcf6de..f91d9bb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1739,6 +1739,11 @@ extern gro_result_t	napi_gro_frags(struct napi_struct *napi);
 extern int netdev_mp_port_prep(struct net_device *dev,
 				struct mp_port *port);
 
+static inline bool dev_is_mpassthru(struct net_device *dev)
+{
+	return dev && dev->mp_port;
+}
+
 static inline void napi_free_frags(struct napi_struct *napi)
 {
 	kfree_skb(napi->skb);
-- 
1.7.3

