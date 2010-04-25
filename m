Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0DYNoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:44:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39624 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0DYNoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=iTRJySp93T9qhyoeepd/X37I6EJ4hYTU3CcBv6X+0T3XqR0i22p44SyhuIGqlScSwp
         lm/GWvHo9Q6etNmon0h+qi1wLE7SC6S9pNA7sGk0w5r3drxZakAz7g28JA0/V/Nx8JL8
         /xYrkBg089ASpvZno84MF0S/sDzB1/ujNHtQw=
Date: Sun, 25 Apr 2010 22:41:11 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] staging: cyrstalhd: clean up crystalhd_user_close()
 return code
Message-Id: <20100425224111.28600e78.yuasa@linux-mips.org>
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
 drivers/staging/crystalhd/crystalhd_cmds.c |    6 ++----
 drivers/staging/crystalhd/crystalhd_cmds.h |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index bfa11df..d341876 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -913,7 +913,7 @@ BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
  * Closer aplication handle and release app specific
  * resources.
  */
-BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user *uc)
+void crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user *uc)
 {
 	uint32_t mode = uc->mode;
 
@@ -928,14 +928,12 @@ BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user
 		crystalhd_hw_free_dma_rings(&ctx->hw_ctx);
 		crystalhd_destroy_dio_pool(ctx->adp);
 	} else if (bc_cproc_get_user_count(ctx)) {
-		return BC_STS_SUCCESS;
+		return;
 	}
 
 	crystalhd_hw_close(&ctx->hw_ctx);
 
 	ctx->state = BC_LINK_INVALID;
-
-	return BC_STS_SUCCESS;
 }
 
 /**
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.h b/drivers/staging/crystalhd/crystalhd_cmds.h
index ea1b0d4..026a07e 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.h
+++ b/drivers/staging/crystalhd/crystalhd_cmds.h
@@ -80,7 +80,7 @@ BC_STATUS crystalhd_resume(struct crystalhd_cmd *ctx);
 crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cmd,
 				      struct crystalhd_user *uc);
 BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx, struct crystalhd_user **user_ctx);
-BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user *uc);
+void crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user *uc);
 int crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx, struct crystalhd_adp *adp);
 void crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx);
 bool crystalhd_cmd_interrupt(struct crystalhd_cmd *ctx);
-- 
1.7.1

