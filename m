Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab1FFWiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:38:54 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37305
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758199Ab1FFWfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 41/49] Staging: hv: vmbus: Increase the timeout for some critical calls
Date: Mon,  6 Jun 2011 15:50:05 -0700
Message-Id: <1307400613-13234-41-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the timeout for some critical calls. In testing we discovered that the
current timeout of 1 second was insufficient under some conditions.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 5a2a947..69b5641 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -480,7 +480,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 		}
 	}
-	t = wait_for_completion_timeout(&msginfo->waitevent, HZ);
+	t = wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
 	BUG_ON(t == 0);
 
 
@@ -530,7 +530,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 			       sizeof(struct vmbus_channel_gpadl_teardown));
 
 	BUG_ON(ret != 0);
-	t = wait_for_completion_timeout(&info->waitevent, HZ);
+	t = wait_for_completion_timeout(&info->waitevent, 5*HZ);
 	BUG_ON(t == 0);
 
 	/* Received a torndown response */
-- 
1.7.4.1

