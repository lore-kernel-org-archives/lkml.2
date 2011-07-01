Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1GANre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:47:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56937 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab1GANrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:47:33 -0400
From: =?UTF-8?q?M=C3=A5rten=20Kongstad?= <marten.kongstad@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?M=C3=A5rten=20Kongstad?= <marten.kongstad@gmail.com>
Subject: [PATCH] Staging: echo: fix checkpatch errors and warnings
Date: Fri,  1 Jul 2011 15:46:49 +0200
Message-Id: <1309528009-1943-1-git-send-email-marten.kongstad@gmail.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 2 errors, 7 warnings as reported by checkpatch.

Signed-off-by: Mårten Kongstad <marten.kongstad@gmail.com>
---
 drivers/staging/echo/echo.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index c0adae1..afbf544 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -276,7 +276,6 @@ error_oom:
 	kfree(ec);
 	return NULL;
 }
-
 EXPORT_SYMBOL_GPL(oslec_create);
 
 void oslec_free(struct oslec_state *ec)
@@ -290,14 +289,12 @@ void oslec_free(struct oslec_state *ec)
 	kfree(ec->snapshot);
 	kfree(ec);
 }
-
 EXPORT_SYMBOL_GPL(oslec_free);
 
 void oslec_adaption_mode(struct oslec_state *ec, int adaption_mode)
 {
 	ec->adaption_mode = adaption_mode;
 }
-
 EXPORT_SYMBOL_GPL(oslec_adaption_mode);
 
 void oslec_flush(struct oslec_state *ec)
@@ -324,14 +321,12 @@ void oslec_flush(struct oslec_state *ec)
 	ec->curr_pos = ec->taps - 1;
 	ec->Pstates = 0;
 }
-
 EXPORT_SYMBOL_GPL(oslec_flush);
 
 void oslec_snapshot(struct oslec_state *ec)
 {
 	memcpy(ec->snapshot, ec->fir_taps16[0], ec->taps * sizeof(int16_t));
 }
-
 EXPORT_SYMBOL_GPL(oslec_snapshot);
 
 /* Dual Path Echo Canceller */
@@ -406,7 +401,7 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 		/* efficient "out with the old and in with the new" algorithm so
 		   we don't have to recalculate over the whole block of
 		   samples. */
-		new = (int)tx *(int)tx;
+		new = (int)tx * (int)tx;
 		old = (int)ec->fir_state.history[ec->fir_state.curr_pos] *
 		    (int)ec->fir_state.history[ec->fir_state.curr_pos];
 		ec->Pstates +=
@@ -603,7 +598,6 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 
 	return (int16_t) ec->clean_nlp << 1;
 }
-
 EXPORT_SYMBOL_GPL(oslec_update);
 
 /* This function is separated from the echo canceller is it is usually called
@@ -628,7 +622,7 @@ EXPORT_SYMBOL_GPL(oslec_update);
    giving very clean DC removal.
 */
 
-int16_t oslec_hpf_tx(struct oslec_state * ec, int16_t tx)
+int16_t oslec_hpf_tx(struct oslec_state *ec, int16_t tx)
 {
 	int tmp, tmp1;
 
@@ -657,7 +651,6 @@ int16_t oslec_hpf_tx(struct oslec_state * ec, int16_t tx)
 
 	return tx;
 }
-
 EXPORT_SYMBOL_GPL(oslec_hpf_tx);
 
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

