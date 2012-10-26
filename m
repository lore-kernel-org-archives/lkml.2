Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2JZAe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:34:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:53119 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab2JZAG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gao feng <gaofeng@cn.fujitsu.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/42] infiniband: pass rdma_cm module to netlink_dump_start
Date: Thu, 25 Oct 2012 17:05:38 -0700
Message-Id: <20121026000127.811281502@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 809d5fc9bf6589276a12bd4fd611e4c7ff9940c3 ]

set netlink_dump_control.module to avoid panic.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c     |    3 ++-
 drivers/infiniband/core/netlink.c |    1 +
 include/rdma/rdma_netlink.h       |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3451,7 +3451,8 @@ out:
 }
 
 static const struct ibnl_client_cbs cma_cb_table[] = {
-	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats },
+	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats,
+				       .module = THIS_MODULE },
 };
 
 static int __init cma_init(void)
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -151,6 +151,7 @@ static int ibnl_rcv_msg(struct sk_buff *
 			{
 				struct netlink_dump_control c = {
 					.dump = client->cb_table[op].dump,
+					.module = client->cb_table[op].module,
 				};
 				return netlink_dump_start(nls, skb, nlh, &c);
 			}
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -39,6 +39,7 @@ struct rdma_cm_id_stats {
 
 struct ibnl_client_cbs {
 	int (*dump)(struct sk_buff *skb, struct netlink_callback *nlcb);
+	struct module *module;
 };
 
 int ibnl_init(void);


