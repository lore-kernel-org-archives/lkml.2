Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1GAJ4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:56:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45951 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1GAJz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:55:59 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] drivers: staging: echo: Fix coding style issues.
Date: Fri,  1 Jul 2011 21:55:38 +1200
Message-Id: <1309514138-31192-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues as flagged by checkpatch.pl

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
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

