Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1HYQfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:35:46 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42807
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753509Ab1HYQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 33/59] Staging: hv: vmbus: Cleanup the error return value in vmbus_recvpacket_raw()
Date: Thu, 25 Aug 2011 09:48:59 -0700
Message-Id: <1314290965-2698-33-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux errno values.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel.c  |    2 +-
 drivers/staging/hv/hv_mouse.c |    2 +-
 drivers/staging/hv/netvsc.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 9eb8def..ac92c1f 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -811,7 +811,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 		pr_err("Buffer too small - needed %d bytes but "
 			"got space for only %d bytes\n",
 			packetlen, bufferlen);
-		return -2;
+		return -ENOBUFS;
 	}
 
 	*requestid = desc.trans_id;
diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index dd8a114..2e04948 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -541,7 +541,7 @@ static void mousevsc_on_channel_callback(void *context)
 				}
 				break;
 			}
-		} else if (ret == -2) {
+		} else if (ret == -ENOBUFS) {
 			/* Handle large packet */
 			bufferlen = bytes_recvd;
 			buffer = kzalloc(bytes_recvd, GFP_KERNEL);
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index d547ff6..b89ac7e 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -884,7 +884,7 @@ static void netvsc_channel_cb(void *context)
 
 				break;
 			}
-		} else if (ret == -2) {
+		} else if (ret == -ENOBUFS) {
 			/* Handle large packet */
 			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
 			if (buffer == NULL) {
-- 
1.7.4.1

