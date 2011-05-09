Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab1EIWEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:04:55 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47414
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754158Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 039/206] Staging: hv: Get rid of the forward declaration for storvsc_device_alloc()
Date: Mon,  9 May 2011 14:55:21 -0700
Message-Id: <1304978288-22999-39-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 52d8974..2bd9c09 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -112,10 +112,19 @@ static int stor_vsc_initialize(struct hv_driver *driver)
 	return 0;
 }
 
+static int storvsc_device_alloc(struct scsi_device *sdevice)
+{
+	/*
+	 * This enables luns to be located sparsely. Otherwise, we may not
+	 * discovered them.
+	 */
+	sdevice->sdev_bflags |= BLIST_SPARSELUN | BLIST_LARGELUN;
+	return 0;
+}
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
-static int storvsc_device_alloc(struct scsi_device *);
 static int storvsc_device_configure(struct scsi_device *);
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd);
 static int storvsc_remove(struct hv_device *dev);
@@ -821,19 +830,6 @@ static int storvsc_merge_bvec(struct request_queue *q,
 	return bvec->bv_len;
 }
 
-/*
- * storvsc_device_configure - Configure the specified scsi device
- */
-static int storvsc_device_alloc(struct scsi_device *sdevice)
-{
-	/*
-	 * This enables luns to be located sparsely. Otherwise, we may not
-	 * discovered them.
-	 */
-	sdevice->sdev_bflags |= BLIST_SPARSELUN | BLIST_LARGELUN;
-	return 0;
-}
-
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
 	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
-- 
1.7.4.1

