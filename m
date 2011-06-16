Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab1FPUEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:04:43 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:32991
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932349Ab1FPUCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 70/77] Staging: hv: netvsc: Cleanup error return values in rndis_filter_set_packet_filter()
Date: Thu, 16 Jun 2011 13:17:43 -0700
Message-Id: <1308255470-3826-70-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux error codes and cleanup some error paths.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index f26886d..f5f3052 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -511,7 +511,7 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 			RNDIS_MESSAGE_SIZE(struct rndis_set_request) +
 			sizeof(u32));
 	if (!request) {
-		ret = -1;
+		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
@@ -531,7 +531,6 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
 
 	if (t == 0) {
-		ret = -1;
 		dev_err(&dev->net_dev->dev->device,
 			"timeout before we got a set response...\n");
 		/*
@@ -540,8 +539,6 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 		 */
 		goto Exit;
 	} else {
-		if (ret > 0)
-			ret = 0;
 		set_complete = &request->response_msg.msg.set_complete;
 		status = set_complete->status;
 	}
-- 
1.7.4.1

