Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab2CUJwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:52:14 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54937 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab2CUJwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitzmic@googlemail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 11/11] scsi/atari: Make more functions static
Date: Wed, 21 Mar 2012 10:51:55 +0100
Message-Id: <1332323515-7314-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@googlemail.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/atari_scsi.c |   13 +++++++------
 drivers/scsi/atari_scsi.h |    5 -----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 3102ce5..df740cb 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -572,7 +572,7 @@ static void falcon_get_lock(void)
 }
 
 
-int __init atari_scsi_detect(struct scsi_host_template *host)
+static int __init atari_scsi_detect(struct scsi_host_template *host)
 {
 	static int called = 0;
 	struct Scsi_Host *instance;
@@ -724,7 +724,7 @@ int __init atari_scsi_detect(struct scsi_host_template *host)
 	return 1;
 }
 
-int atari_scsi_release(struct Scsi_Host *sh)
+static int atari_scsi_release(struct Scsi_Host *sh)
 {
 	if (IS_A_TT())
 		free_irq(IRQ_TT_MFP_SCSI, sh);
@@ -788,7 +788,7 @@ static int __init atari_scsi_setup(char *str)
 __setup("atascsi=", atari_scsi_setup);
 #endif /* !MODULE */
 
-int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
+static int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
 {
 	int rv;
 	struct NCR5380_hostdata *hostdata =
@@ -861,7 +861,7 @@ static void __init atari_scsi_reset_boot(void)
 #endif
 
 
-const char *atari_scsi_info(struct Scsi_Host *host)
+static const char *atari_scsi_info(struct Scsi_Host *host)
 {
 	/* atari_scsi_detect() is verbose enough... */
 	static const char string[] = "Atari native SCSI";
@@ -871,8 +871,9 @@ const char *atari_scsi_info(struct Scsi_Host *host)
 
 #if defined(REAL_DMA)
 
-unsigned long atari_scsi_dma_setup(struct Scsi_Host *instance, void *data,
-				   unsigned long count, int dir)
+static unsigned long atari_scsi_dma_setup(struct Scsi_Host *instance,
+					  void *data, unsigned long count,
+					  int dir)
 {
 	unsigned long addr = virt_to_phys(data);
 
diff --git a/drivers/scsi/atari_scsi.h b/drivers/scsi/atari_scsi.h
index efadb8d..bd52df7 100644
--- a/drivers/scsi/atari_scsi.h
+++ b/drivers/scsi/atari_scsi.h
@@ -18,11 +18,6 @@
 /* (I_HAVE_OVERRUNS stuff removed) */
 
 #ifndef ASM
-int atari_scsi_detect (struct scsi_host_template *);
-const char *atari_scsi_info (struct Scsi_Host *);
-int atari_scsi_reset (Scsi_Cmnd *, unsigned int);
-int atari_scsi_release (struct Scsi_Host *);
-
 /* The values for CMD_PER_LUN and CAN_QUEUE are somehow arbitrary. Higher
  * values should work, too; try it! (but cmd_per_lun costs memory!) */
 
-- 
1.7.0.4

