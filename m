Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab2HIRsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:48:18 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51661
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753785Ab2HIRsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:48:16 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [PATCH net-next,1/1] hyperv: Add comments for the extended buffer after RNDIS message
Date: Thu,  9 Aug 2012 11:04:18 -0700
Message-Id: <1344535458-3613-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/rndis_filter.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 1e88a10..06f8601 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -46,8 +46,14 @@ struct rndis_request {
 	/* Simplify allocation by having a netvsc packet inline */
 	struct hv_netvsc_packet	pkt;
 	struct hv_page_buffer buf;
-	/* FIXME: We assumed a fixed size request here. */
+
 	struct rndis_message request_msg;
+	/*
+	 * The buffer for the extended info after the RNDIS message. It's
+	 * referenced based on the data offset in the RNDIS message. Its size
+	 * is enough for current needs, and should be sufficient for the near
+	 * future.
+	 */
 	u8 ext[100];
 };
 
-- 
1.7.4.1

