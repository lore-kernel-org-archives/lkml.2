Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab2F0U26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:28:58 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20476 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2F0U24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:28:56 -0400
Date: Wed, 27 Jun 2012 22:28:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Chris Forbes <chrisf@ijw.co.nz>, David Rowe <david@rowetel.com>,
        Steve Underwood <steveu@coppice.org>
Subject: [PATCH] Staging: echo: One variable per line
Message-ID: <alpine.LNX.2.00.1206272226070.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our convention is one (statement and) variable per line. Enforce
this in drivers/staging/echo/echo.[ch] .

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/echo/echo.c |  9 ++++++---
 drivers/staging/echo/echo.h | 28 ++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index afbf544..ca87ce9 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -118,7 +118,8 @@
 #ifdef __bfin__
 static inline void lms_adapt_bg(struct oslec_state *ec, int clean, int shift)
 {
-	int i, j;
+	int i;
+	int j;
 	int offset1;
 	int offset2;
 	int factor;
@@ -335,7 +336,8 @@ int16_t oslec_update(struct oslec_state *ec, int16_t tx, int16_t rx)
 {
 	int32_t echo_value;
 	int clean_bg;
-	int tmp, tmp1;
+	int tmp;
+	int tmp1;
 
 	/*
 	 * Input scaling was found be required to prevent problems when tx
@@ -624,7 +626,8 @@ EXPORT_SYMBOL_GPL(oslec_update);
 
 int16_t oslec_hpf_tx(struct oslec_state *ec, int16_t tx)
 {
-	int tmp, tmp1;
+	int tmp;
+	int tmp1;
 
 	if (ec->adaption_mode & ECHO_CAN_USE_TX_HPF) {
 		tmp = tx << 15;
diff --git a/drivers/staging/echo/echo.h b/drivers/staging/echo/echo.h
index 754e66d..32ca9de 100644
--- a/drivers/staging/echo/echo.h
+++ b/drivers/staging/echo/echo.h
@@ -36,7 +36,6 @@ What does it do?
 This module aims to provide G.168-2002 compliant echo cancellation, to remove
 electrical echoes (e.g. from 2-4 wire hybrids) from voice calls.
 
-
 How does it work?
 
 The heart of the echo cancellor is FIR filter. This is adapted to match the
@@ -128,7 +127,8 @@ a minor burden.
     echo canceller.
 */
 struct oslec_state {
-	int16_t tx, rx;
+	int16_t tx;
+	int16_t rx;
 	int16_t clean;
 	int16_t clean_nlp;
 
@@ -145,11 +145,18 @@ struct oslec_state {
 	int16_t shift;
 
 	/* Average levels and averaging filter states */
-	int Ltxacc, Lrxacc, Lcleanacc, Lclean_bgacc;
-	int Ltx, Lrx;
+	int Ltxacc;
+	int Lrxacc;
+	int Lcleanacc;
+	int Lclean_bgacc;
+	int Ltx;
+	int Lrx;
 	int Lclean;
 	int Lclean_bg;
-	int Lbgn, Lbgn_acc, Lbgn_upper, Lbgn_upper_acc;
+	int Lbgn;
+	int Lbgn_acc;
+	int Lbgn_upper;
+	int Lbgn_upper_acc;
 
 	/* foreground and background filter states */
 	struct fir16_state_t fir_state;
@@ -157,11 +164,16 @@ struct oslec_state {
 	int16_t *fir_taps16[2];
 
 	/* DC blocking filter states */
-	int tx_1, tx_2, rx_1, rx_2;
+	int tx_1;
+	int tx_2;
+	int rx_1;
+	int rx_2;
 
 	/* optional High Pass Filter states */
-	int32_t xvtx[5], yvtx[5];
-	int32_t xvrx[5], yvrx[5];
+	int32_t xvtx[5];
+	int32_t yvtx[5];
+	int32_t xvrx[5];
+	int32_t yvrx[5];
 
 	/* Parameters for the optional Hoth noise generator */
 	int cng_level;
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

