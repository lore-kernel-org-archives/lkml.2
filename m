Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2IXVAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:00:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46938 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2IXVAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:00:50 -0400
Date: Mon, 24 Sep 2012 17:00:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [SCSI PATCH] sd: max-retries becomes configurable
Message-ID: <20120924210049.GA18527@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 drivers/scsi/sd.c |    4 ++++
 drivers/scsi/sd.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..d15074b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -92,6 +92,10 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
+static int sd_max_retries = 5;
+module_param_named(max_retries, sd_max_retries, int, 0644);
+MODULE_PARM_DESC(max_retries, "Maximum number of retries, before failing command (default 5)");
+
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
 #else
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f703f48..f8488fa 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -18,7 +18,7 @@
 /*
  * Number of allowed retries
  */
-#define SD_MAX_RETRIES		5
+#define SD_MAX_RETRIES		sd_max_retries
 #define SD_PASSTHROUGH_RETRIES	1
 #define SD_MAX_MEDIUM_TIMEOUTS	2
 
