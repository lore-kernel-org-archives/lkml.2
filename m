Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab0K1JGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 04:06:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1889 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0K1JFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 04:05:52 -0500
From: Joe Perches <joe@perches.com>
To: Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        linux-driver@qlogic.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] qlcnic: remove unnecessary [kv][mcz]alloc casts
Date: Sun, 28 Nov 2010 01:05:44 -0800
Message-Id: <09e14a8c16d54605ab6d3be562abc6820ba2a7aa.1290934782.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290934782.git.joe@perches.com>
References: <cover.1290934782.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/qlcnic/qlcnic_init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/qlcnic/qlcnic_init.c b/drivers/net/qlcnic/qlcnic_init.c
index 3f97018..c5ea2f4 100644
--- a/drivers/net/qlcnic/qlcnic_init.c
+++ b/drivers/net/qlcnic/qlcnic_init.c
@@ -274,8 +274,7 @@ int qlcnic_alloc_sw_resources(struct qlcnic_adapter *adapter)
 				rds_ring->dma_size + NET_IP_ALIGN;
 			break;
 		}
-		rds_ring->rx_buf_arr = (struct qlcnic_rx_buffer *)
-			vzalloc(RCV_BUFF_RINGSIZE(rds_ring));
+		rds_ring->rx_buf_arr = vzalloc(RCV_BUFF_RINGSIZE(rds_ring));
 		if (rds_ring->rx_buf_arr == NULL) {
 			dev_err(&netdev->dev, "Failed to allocate "
 				"rx buffer ring %d\n", ring);
-- 
1.7.3.2.245.g03276.dirty

