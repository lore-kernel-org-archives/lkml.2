Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0JVX7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:59:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab0JVXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e35RxXETmGXS4XfnNBTHSITT9HOKNJcCjBz9WCEm0OgFM9yH8IrZKMbSdqpJwY/LAD
         YbaRIo/nitMMab5OyF6/LOmf/p8zgV1oBYopXwutn/Anyz7zUKfaVeB1cEPEtrPsWDtl
         uxaRMhzP/e0u2Q9vAq81StorJzsO3l5wF9Szw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 08/29] memstick: mspro: add comments to few functions
Date: Sat, 23 Oct 2010 01:53:36 +0200
Message-Id: <1287791637-10329-9-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a comment before function is not only a good way
to give some information to the reader, but
it serves as a good anchor point for diff so that
it doesn't produce a diff between different
functions (sigh...)

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 13cb83b..a7f263d 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -515,6 +515,10 @@ has_int_reg:
 
 /*** Data transfer ***/
 
+/*
+ * Start execution of next block request,
+ * or continue execution of the current one
+ */
 static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
@@ -575,6 +579,11 @@ try_again:
 	goto try_again;
 }
 
+/*
+ * Completes execution of current block request.
+ *  After execution of this function, the msb->block_req might or might not
+ *  be NULL. If it is, it means we don't have any more requests to process
+ */
 static int mspro_block_complete_req(struct memstick_dev *card, int error)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
@@ -630,6 +639,10 @@ out:
 	return error;
 }
 
+/*
+ * This pauses driver.
+ * Makes sure that driver won't send any commands to the device
+ */
 static void mspro_block_stop(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
@@ -651,6 +664,7 @@ static void mspro_block_stop(struct memstick_dev *card)
 	}
 }
 
+/* This undoes effects of mspro_block_stop */
 static void mspro_block_start(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-- 
1.7.1

