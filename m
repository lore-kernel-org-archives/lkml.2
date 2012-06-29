Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab2F2EW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:22:29 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65084 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2F2EW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:22:26 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/3] staging: sep: sep_crypto.c: Remove useless functions sep_dump and sep_dump_sg
Date: Fri, 29 Jun 2012 01:19:23 -0300
Message-Id: <1340943564-19082-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340943564-19082-1-git-send-email-marcos.souza.org@gmail.com>
References: <1340943564-19082-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions only has commented code, so remove it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/sep/sep_crypto.c |   77 --------------------------------------
 1 file changed, 77 deletions(-)

diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index e87b4fc..4453bae 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -465,55 +465,6 @@ static int partial_overlap(void *src_ptr, void *dst_ptr, u32 nbytes)
 	return 0;
 }
 
-/* Debug - prints only if DEBUG is defined; follows kernel debug model */
-static void sep_dump(struct sep_device *sep, char *stg, void *start, int len)
-{
-#if 0
-	int ct1;
-	u8 *ptt;
-
-	dev_dbg(&sep->pdev->dev,
-		"Dump of %s starting at %08lx for %08x bytes\n",
-		stg, (unsigned long)start, len);
-	for (ct1 = 0; ct1 < len; ct1 += 1) {
-		ptt = (u8 *)(start + ct1);
-		dev_dbg(&sep->pdev->dev, "%02x ", *ptt);
-		if (ct1 % 16 == 15)
-			dev_dbg(&sep->pdev->dev, "\n");
-	}
-	dev_dbg(&sep->pdev->dev, "\n");
-#endif
-}
-
-/* Debug - prints only if DEBUG is defined; follows kernel debug model */
-static void sep_dump_sg(struct sep_device *sep, char *stg,
-			struct scatterlist *sg)
-{
-#if 0
-	int ct1, ct2;
-	u8 *ptt;
-
-	dev_dbg(&sep->pdev->dev, "Dump of scatterlist %s\n", stg);
-
-	ct1 = 0;
-	while (sg) {
-		dev_dbg(&sep->pdev->dev, "page %x\n size %x", ct1,
-			sg->length);
-		dev_dbg(&sep->pdev->dev, "phys addr is %lx",
-			(unsigned long)sg_phys(sg));
-		ptt = sg_virt(sg);
-		for (ct2 = 0; ct2 < sg->length; ct2 += 1) {
-			dev_dbg(&sep->pdev->dev, "byte %x is %02x\n",
-				ct2, (unsigned char)*(ptt + ct2));
-		}
-
-		ct1 += 1;
-		sg = sg_next(sg);
-	}
-	dev_dbg(&sep->pdev->dev, "\n");
-#endif
-}
-
 /* Debug - prints only if DEBUG is defined */
 static void sep_dump_ivs(struct ablkcipher_request *req, char *reason)
 
@@ -1216,9 +1167,6 @@ static int sep_crypto_block_data(struct ablkcipher_request *req)
 	/* Key already done; this is for data */
 	dev_dbg(&ta_ctx->sep_used->pdev->dev, "sending data\n");
 
-	sep_dump_sg(ta_ctx->sep_used,
-		"block sg in", ta_ctx->src_sg);
-
 	/* check for valid data and proper spacing */
 	src_ptr = sg_virt(ta_ctx->src_sg);
 	dst_ptr = sg_virt(ta_ctx->dst_sg);
@@ -1340,14 +1288,10 @@ static int sep_crypto_block_data(struct ablkcipher_request *req)
 		sep_write_context(ta_ctx, &msg_offset,
 			&sctx->des_private_ctx,
 			sizeof(struct sep_des_private_context));
-		sep_dump(ta_ctx->sep_used, "ctx to block des",
-			&sctx->des_private_ctx, 40);
 	} else {
 		sep_write_context(ta_ctx, &msg_offset,
 			&sctx->aes_private_ctx,
 			sizeof(struct sep_aes_private_context));
-		sep_dump(ta_ctx->sep_used, "ctx to block aes",
-			&sctx->aes_private_ctx, 20);
 	}
 
 	/* conclude message */
@@ -1404,8 +1348,6 @@ static int sep_crypto_send_key(struct ablkcipher_request *req)
 		}
 
 		memcpy(ta_ctx->iv, ta_ctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
-		sep_dump(ta_ctx->sep_used, "iv",
-			ta_ctx->iv, SEP_DES_IV_SIZE_BYTES);
 	}
 
 	if ((ta_ctx->current_request == AES_CBC) &&
@@ -1416,8 +1358,6 @@ static int sep_crypto_send_key(struct ablkcipher_request *req)
 		}
 
 		memcpy(ta_ctx->iv, ta_ctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
-		sep_dump(ta_ctx->sep_used, "iv",
-			ta_ctx->iv, SEP_AES_IV_SIZE_BYTES);
 	}
 
 	/* put together message to SEP */
@@ -1430,8 +1370,6 @@ static int sep_crypto_send_key(struct ablkcipher_request *req)
 			sep_write_msg(ta_ctx, ta_ctx->iv,
 				SEP_DES_IV_SIZE_BYTES, sizeof(u32) * 4,
 				&msg_offset, 1);
-			sep_dump(ta_ctx->sep_used, "initial IV",
-				ta_ctx->walk.iv, SEP_DES_IV_SIZE_BYTES);
 		} else {
 			/* Skip if ECB */
 			msg_offset += 4 * sizeof(u32);
@@ -1443,8 +1381,6 @@ static int sep_crypto_send_key(struct ablkcipher_request *req)
 			sep_write_msg(ta_ctx, ta_ctx->iv,
 				SEP_AES_IV_SIZE_BYTES, max_length,
 				&msg_offset, 1);
-			sep_dump(ta_ctx->sep_used, "initial IV",
-				ta_ctx->walk.iv, SEP_AES_IV_SIZE_BYTES);
 		} else {
 				/* Skip if ECB */
 				msg_offset += max_length;
@@ -1647,16 +1583,10 @@ static u32 crypto_post_op(struct sep_device *sep)
 			sep_read_context(ta_ctx, &msg_offset,
 			&sctx->des_private_ctx,
 			sizeof(struct sep_des_private_context));
-
-			sep_dump(ta_ctx->sep_used, "ctx init des",
-				&sctx->des_private_ctx, 40);
 		} else {
 			sep_read_context(ta_ctx, &msg_offset,
 			&sctx->aes_private_ctx,
 			sizeof(struct sep_aes_private_context));
-
-			sep_dump(ta_ctx->sep_used, "ctx init aes",
-				&sctx->aes_private_ctx, 20);
 		}
 
 		sep_dump_ivs(req, "after sending key to sep\n");
@@ -1735,9 +1665,6 @@ static u32 crypto_post_op(struct sep_device *sep)
 				sizeof(struct sep_aes_private_context));
 		}
 
-		sep_dump_sg(ta_ctx->sep_used,
-			"block sg out", ta_ctx->dst_sg);
-
 		/* Copy to correct sg if this block had oddball pages */
 		if (ta_ctx->dst_sg_hold)
 			sep_copy_sg(ta_ctx->sep_used,
@@ -2251,8 +2178,6 @@ static void sep_hash_update(void *data)
 		src_ptr = NULL;
 	}
 
-	sep_dump_sg(ta_ctx->sep_used, "hash block sg in", ta_ctx->src_sg);
-
 	ta_ctx->dcb_input_data.app_in_address = src_ptr;
 	ta_ctx->dcb_input_data.data_in_size =
 		req->nbytes - (head_len + tail_len);
@@ -2484,8 +2409,6 @@ static void sep_hash_digest(void *data)
 		src_ptr = NULL;
 	}
 
-	sep_dump_sg(ta_ctx->sep_used, "hash block sg in", ta_ctx->src_sg);
-
 	ta_ctx->dcb_input_data.app_in_address = src_ptr;
 	ta_ctx->dcb_input_data.data_in_size = req->nbytes - tail_len;
 	ta_ctx->dcb_input_data.app_out_address = NULL;
-- 
1.7.10.2

