Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0KDIoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:44:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:34881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0KDIoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:44:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,294,1286175600"; 
   d="scan'208";a="570251157"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v14 03/17] Add a ndo_mp_port_prep pointer to net_device_ops.
Date: Thu,  4 Nov 2010 17:04:59 +0800
Message-Id: <cd0686f2b8fc16a1d87ced228b2a90b93f008b94.1288860477.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
References: <1288861513-5707-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1288860477.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1288860477.git.xiaohui.xin@intel.com>
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
 include/linux/netdevice.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f6b1870..575777f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -723,6 +723,12 @@ struct netdev_rx_queue {
  * int (*ndo_set_vf_port)(struct net_device *dev, int vf,
  *			  struct nlattr *port[]);
  * int (*ndo_get_vf_port)(struct net_device *dev, int vf, struct sk_buff *skb);
+ *
+ * int (*ndo_mp_port_prep)(struct net_device *dev, struct mp_port *port);
+ *	If the driver want to allocate external buffers,
+ *	then it can export it's capability, as the skb
+ *	buffer header length, the page length can be DMA, etc.
+ *	The external buffers owner may utilize this.
  */
 #define HAVE_NET_DEVICE_OPS
 struct net_device_ops {
@@ -795,6 +801,10 @@ struct net_device_ops {
 	int			(*ndo_fcoe_get_wwn)(struct net_device *dev,
 						    u64 *wwn, int type);
 #endif
+#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
+	int			(*ndo_mp_port_prep)(struct net_device *dev,
+						struct mp_port *port);
+#endif
 };
 
 /*
-- 
1.7.3

