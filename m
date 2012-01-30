Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2A3QhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:37:24 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35533
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753185Ab2A3QhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:37:23 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] net/hyperv: Remove the unnecessary memset in rndis_filter_send()
Date: Mon, 30 Jan 2012 08:33:36 -0800
Message-Id: <1327941218-12547-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1327941218-12547-1-git-send-email-haiyangz@microsoft.com>
References: <1327941218-12547-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory has been allocated by kzalloc, so it's unnecessary to memset
again.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 129e696..c0aa8b0 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -759,8 +759,6 @@ int rndis_filter_send(struct hv_device *dev,
 	/* Add the rndis header */
 	filter_pkt = (struct rndis_filter_packet *)pkt->extension;
 
-	memset(filter_pkt, 0, sizeof(struct rndis_filter_packet));
-
 	rndis_msg = &filter_pkt->msg;
 	rndis_msg_size = RNDIS_MESSAGE_SIZE(struct rndis_packet);
 
-- 
1.7.7

