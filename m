Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0DYNpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:45:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39624 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab0DYNoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=qLsmZmhXDptOQrd2y+z7pT71s7QlBAXvleGgGNyhR9ggZW8FyvCag+wB0YEGEMZ+7D
         Foc8n3ANcSz6bh/Cm1Hs+3yeJesLUhzUodb4LGjcaX6VCgnAr6RXYa6rThN02wDHtihg
         UfKfo3l4VLqDNMlWP1g61xcPShAknVzu3P52Q=
Date: Sun, 25 Apr 2010 22:40:41 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] staging: crystalhd: clean up
 crystalhd_delete_cmd_context() return code
Message-Id: <20100425224041.293a0aac.yuasa@linux-mips.org>
In-Reply-To: <20100425221851.223dc284.yuasa@linux-mips.org>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/staging/crystalhd/crystalhd_cmds.c |    4 +---
 drivers/staging/crystalhd/crystalhd_cmds.h |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c  |    5 +----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index 516e825..bfa11df 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -984,13 +984,11 @@ int __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
  *
  * Called at the time of driver un-load.
  */
-BC_STATUS __devexit crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
+void __devexit crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
 {
 	BCMLOG(BCMLOG_DBG, "Deleting Command context..\n");
 
 	ctx->adp = NULL;
-
-	return BC_STS_SUCCESS;
 }
 
 /**
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.h b/drivers/staging/crystalhd/crystalhd_cmds.h
index 90b4467..ea1b0d4 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.h
+++ b/drivers/staging/crystalhd/crystalhd_cmds.h
@@ -82,7 +82,7 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cm
 BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx, struct crystalhd_user **user_ctx);
 BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user *uc);
 int crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx, struct crystalhd_adp *adp);
-BC_STATUS crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx);
+void crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx);
 bool crystalhd_cmd_interrupt(struct crystalhd_cmd *ctx);
 
 #endif
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 490d2e0..19769df 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -512,7 +512,6 @@ static void __devexit chd_pci_release_mem(struct crystalhd_adp *pinfo)
 static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 {
 	struct crystalhd_adp *pinfo;
-	BC_STATUS sts = BC_STS_SUCCESS;
 
 	BCMLOG_ENTER;
 
@@ -522,9 +521,7 @@ static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 		return;
 	}
 
-	sts = crystalhd_delete_cmd_context(&pinfo->cmds);
-	if (sts != BC_STS_SUCCESS)
-		BCMLOG_ERR("cmd delete :%d \n", sts);
+	crystalhd_delete_cmd_context(&pinfo->cmds);
 
 	chd_dec_release_chdev(pinfo);
 
-- 
1.7.1

