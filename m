Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1GORxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:53:22 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37138
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753968Ab1GOR35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 007/117] Staging: hv: storvsc: Use the newly introduced vmbus ID in storvsc driver
Date: Fri, 15 Jul 2011 10:45:55 -0700
Message-Id: <1310752065-27895-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced vmbus ID in storvsc driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e4cdbc5..e30f11c 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -646,6 +646,21 @@ static struct scsi_host_template scsi_driver = {
 	.dma_boundary =		PAGE_SIZE-1,
 };
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{
+		/* SCSI guid */
+		.guid = {
+			0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
+			0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
+		}
+	},
+	{
+		.guid = {
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+		}
+	},
+};
 
 /*
  * storvsc_probe - Add a new device for this driver
@@ -720,6 +735,7 @@ static int storvsc_probe(struct hv_device *device)
 /* The one and only one */
 
 static struct hv_driver storvsc_drv = {
+	.id_table = id_table,
 	.probe = storvsc_probe,
 	.remove = storvsc_remove,
 };
-- 
1.7.4.1

