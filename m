Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1HYQa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:30:59 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48480
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753559Ab1HYQ26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 53/59] Staging: hv: netvsc: Cleanup error return values in rndis_filter_set_packet_filter()
Date: Thu, 25 Aug 2011 09:49:19 -0700
Message-Id: <1314290965-2698-53-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux error codes and cleanup some error paths.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
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

