Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab2F2EWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:22:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40376 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2F2EWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:22:18 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/3] staging: sep: sep_crypto.c: Remove useless function crypto_sep_dump_message
Date: Fri, 29 Jun 2012 01:19:22 -0300
Message-Id: <1340943564-19082-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340943564-19082-1-git-send-email-marcos.souza.org@gmail.com>
References: <1340943564-19082-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function crypto_sep_dump_message don't have any use in this driver. So remove it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/sep/sep_crypto.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index 1cc790e..e87b4fc 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -85,28 +85,6 @@ static void sep_dequeuer(void *data);
 
 /* TESTING */
 /**
- * crypto_sep_dump_message - dump the message that is pending
- * @sep: SEP device
- * This will only print dump if DEBUG is set; it does
- * follow kernel debug print enabling
- */
-static void crypto_sep_dump_message(struct sep_device *sep, void *msg)
-{
-#if 0
-	u32 *p;
-	u32 *i;
-	int count;
-
-	p = sep->shared_addr;
-	i = (u32 *)msg;
-	for (count = 0; count < 10 * 4; count += 4)
-		dev_dbg(&sep->pdev->dev,
-			"[PID%d] Word %d of the message is %x (local)%x\n",
-				current->pid, count/4, *p++, *i++);
-#endif
-}
-
-/**
  *	sep_do_callback
  *	@work: pointer to work_struct
  *	This is what is called by the queue; it is generic so that it
@@ -1646,7 +1624,6 @@ static u32 crypto_post_op(struct sep_device *sep)
 
 	dev_dbg(&ta_ctx->sep_used->pdev->dev, "crypto post_op\n");
 	dev_dbg(&ta_ctx->sep_used->pdev->dev, "crypto post_op message dump\n");
-	crypto_sep_dump_message(ta_ctx->sep_used, ta_ctx->msg);
 
 	/* first bring msg from shared area to local area */
 	memcpy(ta_ctx->msg, sep->shared_addr,
-- 
1.7.10.2

