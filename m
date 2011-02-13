Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1BMWUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:20:12 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52695 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1BMWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:20:06 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Subject: [PATCH 4/6] sisfb: add RAM type detection for XGI Z9
Date: Mon, 14 Feb 2011 00:11:26 +0200
Message-Id: <1297635088-13224-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect the XGI Z9 RAM type as "documented" by the XGI's xgifb driver.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index f0c48e8..de03567 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4955,7 +4955,13 @@ sisfb_post_xgi_ramtype(struct sis_video_info *ivideo)
 		v1 = bios[0x1d2];
 	}
 	if (!(ramtype & 0x80)) {
-		if (ivideo->chip == XGI_20) {
+		if (sisfb_xgi_is21(ivideo)) {
+			SiS_SetRegAND(SISCR, 0xb4, 0xfd); /* GPIO control */
+			SiS_SetRegOR(SISCR, 0x4a, 0x80);  /* GPIOH EN */
+			reg = SiS_GetReg(SISCR, 0x48);
+			SiS_SetRegOR(SISCR, 0xb4, 0x02);
+			ramtype = reg & 0x01;		  /* GPIOH */
+		} else if (ivideo->chip == XGI_20) {
 			SiS_SetReg(SISCR, 0x97, v1);
 			reg = SiS_GetReg(SISCR, 0x97);
 			if (reg & 0x10) {
-- 
1.5.6.5

