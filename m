Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1JFGvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:51:45 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:27162 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353Ab1JFGvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:51:43 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 6/7 v3] i2c-eg20t: Fix flag setting issue
Date: Thu,  6 Oct 2011 15:56:31 +0900
Message-Id: <1317884192-10694-7-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1317884192-10694-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1317884192-10694-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
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
index 5cdf9cb..20c0f34 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -319,11 +319,13 @@ static s32 pch_i2c_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
 
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
1.7.4.4

