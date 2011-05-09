Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1EIWEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:04:53 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54135
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754253Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 040/206] Staging: hv: Move the function storvsc_merge_bvec() to earlier in the file
Date: Mon,  9 May 2011 14:55:22 -0700
Message-Id: <1304978288-22999-40-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2bd9c09..44dbaae 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -122,6 +122,13 @@ static int storvsc_device_alloc(struct scsi_device *sdevice)
 	return 0;
 }
 
+static int storvsc_merge_bvec(struct request_queue *q,
+			      struct bvec_merge_data *bmd, struct bio_vec *bvec)
+{
+	/* checking done by caller. */
+	return bvec->bv_len;
+}
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
@@ -823,13 +830,6 @@ retry_request:
 
 static DEF_SCSI_QCMD(storvsc_queuecommand)
 
-static int storvsc_merge_bvec(struct request_queue *q,
-			      struct bvec_merge_data *bmd, struct bio_vec *bvec)
-{
-	/* checking done by caller. */
-	return bvec->bv_len;
-}
-
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
 	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
-- 
1.7.4.1

