Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1EIWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:03:08 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47458
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754878Ab1EIVoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 052/206] Staging: hv: Get rid of the forward declaration for storvsc_host_reset_handler()
Date: Mon,  9 May 2011 14:55:34 -0700
Message-Id: <1304978288-22999-52-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   49 ++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3b2917e..462aaa5 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -511,10 +511,33 @@ cleanup:
 }
 
 
+/*
+ * storvsc_host_reset_handler - Reset the scsi HBA
+ */
+static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
+{
+	int ret;
+	struct hv_host_device *host_dev =
+		(struct hv_host_device *)scmnd->device->host->hostdata;
+	struct hv_device *dev = host_dev->dev;
+
+	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
+		    scmnd->device, dev);
+
+	/* Invokes the vsc to reset the host/bus */
+	ret = storvsc_host_reset(dev);
+	if (ret != 0)
+		return ret;
+
+	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host reseted",
+		    scmnd->device, dev);
+
+	return ret;
+}
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
-static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd);
 
 static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
@@ -920,30 +943,6 @@ retry_request:
 
 static DEF_SCSI_QCMD(storvsc_queuecommand)
 
-/*
- * storvsc_host_reset_handler - Reset the scsi HBA
- */
-static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
-{
-	int ret;
-	struct hv_host_device *host_dev =
-		(struct hv_host_device *)scmnd->device->host->hostdata;
-	struct hv_device *dev = host_dev->dev;
-
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
-		    scmnd->device, dev);
-
-	/* Invokes the vsc to reset the host/bus */
-	ret = storvsc_host_reset(dev);
-	if (ret != 0)
-		return ret;
-
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host reseted",
-		    scmnd->device, dev);
-
-	return ret;
-}
-
 static int __init storvsc_init(void)
 {
 	int ret;
-- 
1.7.4.1

