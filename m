Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1GOSFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:05:16 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:59893
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751910Ab1GOSDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:03:14 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 008/117] Staging: hv: netvsc: Use the newly introduced vmbus ID in netvsc driver
Date: Fri, 15 Jul 2011 10:45:56 -0700
Message-Id: <1310752065-27895-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced vmbus ID in netvsc driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 61989f0..1f4b7b4 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -413,8 +413,25 @@ static int netvsc_remove(struct hv_device *dev)
 	return 0;
 }
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{
+		/* Network guid */
+		.guid = {
+			0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
+			0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
+		}
+	},
+	{
+		.guid = {
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+		}
+	},
+};
+
 /* The one and only one */
 static struct  hv_driver netvsc_drv = {
+	.id_table = id_table,
 	.probe = netvsc_probe,
 	.remove = netvsc_remove,
 };
-- 
1.7.4.1

