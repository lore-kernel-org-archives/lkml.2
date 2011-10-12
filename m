Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab1JLEOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:14:04 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:4824 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab1JLENW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:13:22 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        jeffchu@broadcom.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 5/7 v4] i2c-eg20t: add stop sequence in case wait-event timeout occurs
Date: Wed, 12 Oct 2011 13:13:04 +0900
Message-Id: <1318392786-23610-5-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318392786-23610-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add stop sequence in case wait-event timeout in write processing.
(read processing already had it)

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 0693246..116708d 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -459,6 +459,7 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
+		pch_i2c_stop(adap);
 		return -ETIME;
 	}
 
@@ -479,6 +480,7 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
 				   I2CMIF_BIT);
 		} else { /* wait-event timeout */
+			pch_i2c_stop(adap);
 			return -ETIME;
 		}
 	}
@@ -635,6 +637,7 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		pch_clrbit(adap->pch_base_address, PCH_I2CSR, I2CMIF_BIT);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
+		pch_i2c_stop(adap);
 		return -ETIME;
 	}
 
-- 
1.7.4.4

