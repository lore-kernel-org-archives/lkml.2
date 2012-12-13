Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2LMOaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:30:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031Ab2LMOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gao feng <gaofeng@cn.fujitsu.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 174/241] infiniband: pass rdma_cm module to netlink_dump_start
Date: Thu, 13 Dec 2012 11:58:59 -0200
Message-Id: <1355407206-17100-175-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

commit 809d5fc9bf6589276a12bd4fd611e4c7ff9940c3 upstream.

set netlink_dump_control.module to avoid panic.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/infiniband/core/cma.c     |    3 ++-
 drivers/infiniband/core/netlink.c |    1 +
 include/rdma/rdma_netlink.h       |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 2e826f9..d57ff70 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3457,7 +3457,8 @@ out:
 }
 
 static const struct ibnl_client_cbs cma_cb_table[] = {
-	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats },
+	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats,
+				       .module = THIS_MODULE },
 };
 
 static int __init cma_init(void)
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index e497dfb..fb99702 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -152,6 +152,7 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			{
 				struct netlink_dump_control c = {
 					.dump = client->cb_table[op].dump,
+					.module = client->cb_table[op].module,
 				};
 				return netlink_dump_start(nls, skb, nlh, &c);
 			}
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 3c5363a..bd3d8b2 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -39,6 +39,7 @@ struct rdma_cm_id_stats {
 
 struct ibnl_client_cbs {
 	int (*dump)(struct sk_buff *skb, struct netlink_callback *nlcb);
+	struct module *module;
 };
 
 int ibnl_init(void);
-- 
1.7.9.5

