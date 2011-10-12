Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab1JLENW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:13:22 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:4780 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab1JLENV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:13:21 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        jeffchu@broadcom.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/7 v4] i2c-eg20t: Modify returned value s32 to long
Date: Wed, 12 Oct 2011 13:13:01 +0900
Message-Id: <1318392786-23610-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type of wait_event_timeout is long not s32.
This patch replaces s32 with long.
Additionally, delete negative processing(ret < 0).

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index d1cd304..5ecbee0 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -314,13 +314,9 @@ static void pch_i2c_start(struct i2c_algo_pch_data *adap)
  */
 static s32 pch_i2c_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
 {
-	s32 ret;
+	long ret;
 	ret = wait_event_timeout(pch_event,
 			(adap->pch_event_flag != 0), msecs_to_jiffies(50));
-	if (ret < 0) {
-		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
-		return ret;
-	}
 
 	if (ret == 0) {
 		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
-- 
1.7.4.4

