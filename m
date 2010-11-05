Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0KEDJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:09:22 -0400
Received: from mail.perches.com ([173.55.12.10]:4207 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0KEDJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:11 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 47/49] net/rds: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:11 -0700
Message-Id: <8a5a2c1182dcc6c558c1c351e63c5bcccac537f1.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/rds/ib_cm.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index ee369d2..cc6b073 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -374,23 +374,21 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		goto out;
 	}
 
-	ic->i_sends = vmalloc_node(ic->i_send_ring.w_nr * sizeof(struct rds_ib_send_work),
+	ic->i_sends = vzalloc_node(ic->i_send_ring.w_nr * sizeof(struct rds_ib_send_work),
 				   ibdev_to_node(dev));
 	if (!ic->i_sends) {
 		ret = -ENOMEM;
 		rdsdebug("send allocation failed\n");
 		goto out;
 	}
-	memset(ic->i_sends, 0, ic->i_send_ring.w_nr * sizeof(struct rds_ib_send_work));
 
-	ic->i_recvs = vmalloc_node(ic->i_recv_ring.w_nr * sizeof(struct rds_ib_recv_work),
+	ic->i_recvs = vzalloc_node(ic->i_recv_ring.w_nr * sizeof(struct rds_ib_recv_work),
 				   ibdev_to_node(dev));
 	if (!ic->i_recvs) {
 		ret = -ENOMEM;
 		rdsdebug("recv allocation failed\n");
 		goto out;
 	}
-	memset(ic->i_recvs, 0, ic->i_recv_ring.w_nr * sizeof(struct rds_ib_recv_work));
 
 	rds_ib_recv_init_ack(ic);
 
-- 
1.7.3.1.g432b3.dirty

