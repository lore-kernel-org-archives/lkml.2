Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1EIWEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:04:45 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48647
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754764Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 042/206] Staging: hv: Get rid of the forwrd declaration of destroy_bounce_buffer
Date: Mon,  9 May 2011 14:55:24 -0700
Message-Id: <1304978288-22999-42-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 4196d6a..bf5b138 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -148,6 +148,21 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	return 0;
 }
 
+static void destroy_bounce_buffer(struct scatterlist *sgl,
+				  unsigned int sg_count)
+{
+	int i;
+	struct page *page_buf;
+
+	for (i = 0; i < sg_count; i++) {
+		page_buf = sg_page((&sgl[i]));
+		if (page_buf != NULL)
+			__free_page(page_buf);
+	}
+
+	kfree(sgl);
+}
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
@@ -157,8 +172,6 @@ static int storvsc_remove(struct hv_device *dev);
 static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 						unsigned int sg_count,
 						unsigned int len);
-static void destroy_bounce_buffer(struct scatterlist *sgl,
-				  unsigned int sg_count);
 static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count);
 static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 					    struct scatterlist *bounce_sgl,
@@ -542,21 +555,6 @@ cleanup:
 	return NULL;
 }
 
-static void destroy_bounce_buffer(struct scatterlist *sgl,
-				  unsigned int sg_count)
-{
-	int i;
-	struct page *page_buf;
-
-	for (i = 0; i < sg_count; i++) {
-		page_buf = sg_page((&sgl[i]));
-		if (page_buf != NULL)
-			__free_page(page_buf);
-	}
-
-	kfree(sgl);
-}
-
 /* Assume the bounce_sgl has enough room ie using the create_bounce_buffer() */
 static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 					  struct scatterlist *bounce_sgl,
-- 
1.7.4.1

