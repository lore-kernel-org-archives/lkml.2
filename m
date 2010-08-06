Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab0HFJJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:09:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:28117 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab0HFJJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,327,1278313200"; 
   d="scan'208";a="593547796"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC PATCH v9 03/16] Add a ndo_mp_port_prep func to net_device_ops.
Date: Fri,  6 Aug 2010 17:23:31 +0800
Message-Id: <1281086624-5765-4-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1281086624-5765-3-git-send-email-xiaohui.xin@intel.com>
References: <1281086624-5765-1-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-2-git-send-email-xiaohui.xin@intel.com>
 <1281086624-5765-3-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

If the driver want to allocate external buffers,
then it can export it's capability, as the skb
buffer header length, the page length can be DMA, etc.
The external buffers owner may utilize this.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/netdevice.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ba582e1..aba0308 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -710,6 +710,10 @@ struct net_device_ops {
 	int			(*ndo_fcoe_get_wwn)(struct net_device *dev,
 						    u64 *wwn, int type);
 #endif
+#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
+	int			(*ndo_mp_port_prep)(struct net_device *dev,
+						struct mpassthru_port *port);
+#endif
 };
 
 /*
-- 
1.5.4.4

