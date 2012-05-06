Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab2EFFeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 01:34:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38094 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2EFFeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 01:34:03 -0400
From: joseph daniel <josephdanielwalter@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Piotr Chmura <chmooreck@poczta.onet.pl>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: joseph daniel <josephdanielwalter@gmail.com>
Subject: [PATCH] staging/media/as102: removed else statements
Date: Sun,  6 May 2012 11:33:51 +0600
Message-Id: <1336282431-8861-1-git-send-email-josephdanielwalter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The else statement is actually not required, as we can assign AS10X_CMD_ERROR
to the error variable directly.

Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index 262bb94..a73df10 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -31,7 +31,7 @@
  */
 int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap)
 {
-	int error;
+	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
@@ -54,8 +54,6 @@ int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap)
 					    (uint8_t *) prsp,
 					    sizeof(prsp->body.turn_on.rsp) +
 					    HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
 	}
 
 	if (error < 0)
@@ -77,7 +75,7 @@ out:
  */
 int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
 {
-	int error;
+	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
@@ -99,8 +97,6 @@ int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
 			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
 			(uint8_t *) prsp,
 			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
 	}
 
 	if (error < 0)
@@ -124,7 +120,7 @@ out:
 int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
 		       struct as10x_tune_args *ptune)
 {
-	int error;
+	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *preq, *prsp;
 
 	ENTER();
@@ -159,8 +155,6 @@ int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
 					    (uint8_t *) prsp,
 					    sizeof(prsp->body.set_tune.rsp)
 					    + HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
 	}
 
 	if (error < 0)
@@ -184,7 +178,7 @@ out:
 int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
 			      struct as10x_tune_status *pstatus)
 {
-	int error;
+	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t  *preq, *prsp;
 
 	ENTER();
@@ -208,8 +202,6 @@ int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
 			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
 			(uint8_t *) prsp,
 			sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
 	}
 
 	if (error < 0)
@@ -241,7 +233,7 @@ out:
  */
 int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
 {
-	int error;
+	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
@@ -266,8 +258,6 @@ int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
 					    (uint8_t *) prsp,
 					    sizeof(prsp->body.get_tps.rsp) +
 					    HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
 	}
 
 	if (error < 0)
@@ -305,7 +295,7 @@ out:
 int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
 			      struct as10x_demod_stats *pdemod_stats)
 {
-	int error;
+	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
@@ -330,8 +320,6 @@ int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
 				(uint8_t *) prsp,
 				sizeof(prsp->body.get_demod_stats.rsp)
 				+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
 	}
 
 	if (error < 0)
@@ -370,7 +358,7 @@ out:
 int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
 			       uint8_t *is_ready)
 {
-	int error;
+	int error = AS10X_CMD_ERROR;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
@@ -395,8 +383,6 @@ int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
 					(uint8_t *) prsp,
 					sizeof(prsp->body.get_impulse_rsp.rsp)
 					+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
 	}
 
 	if (error < 0)
-- 
1.7.9.5

