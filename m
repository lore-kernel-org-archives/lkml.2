Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab1JEET6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:19:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37471 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab1JEETN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:19:13 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.lapis-semi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 5/7 v2] i2c-eg20t: Fix flag setting issue
Date: Wed,  5 Oct 2011 13:17:42 +0900
Message-Id: <1317788264-13118-5-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317788264-13118-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1317788264-13118-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, in case occurring abnormal event,
internal flag variable(=pch_event_flag) is not reset.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index ecabf5e..66de0a9 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -317,11 +317,13 @@ static s32 pch_i2c_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
 
 	if (ret == 0) {
 		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
+		adap->pch_event_flag = 0;
 		return -ETIMEDOUT;
 	}
 
 	if (adap->pch_event_flag & I2C_ERROR_MASK) {
 		pch_err(adap, "error bits set: %x\n", adap->pch_event_flag);
+		adap->pch_event_flag = 0;
 		return -EIO;
 	}
 
-- 
1.7.6.4

