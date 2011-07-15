Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1GORyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:54:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33184
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753143Ab1GOR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 006/117] Staging: hv: blkvsc: Use the newly introduced vmbus ID in the blockvsc driver
Date: Fri, 15 Jul 2011 10:45:54 -0700
Message-Id: <1310752065-27895-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced vmbus ID in the blockvsc driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 018b293..38117d96 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -802,10 +802,26 @@ static void blkvsc_request(struct request_queue *queue)
 	}
 }
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{
+		/* IDE guid */
+		.guid = {
+			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
+			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
+		}
+	},
+	{
+		.guid = {
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+		}
+	},
+};
 
 
 /* The one and only one */
 static  struct hv_driver blkvsc_drv = {
+	.id_table = id_table,
 	.probe =  blkvsc_probe,
 	.remove =  blkvsc_remove,
 	.shutdown = blkvsc_shutdown,
-- 
1.7.4.1

