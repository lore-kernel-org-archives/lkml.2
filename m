Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2CZGeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:34:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52687 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2CZGeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:34:03 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/3 v2] i2c-eg20t: Call init() when wait-event timeout occurs
Date: Mon, 26 Mar 2012 15:34:10 +0900
Message-Id: <1332743650-9412-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332741325-7746-2-git-send-email-tomoya.rohm@gmail.com>
References: <1332741325-7746-2-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 had checkpatch warnings.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
v2
 - Updated for checkpatch
---
 drivers/i2c/busses/i2c-eg20t.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index d73975b..0e3a89f 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -445,7 +445,10 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 			pch_i2c_init(adap);
 			return -EAGAIN;
 		} else { /* wait-event timeout */
+			pch_err(adap, "%s(L.%d):wait-event timeout\n",
+				__func__, __LINE__);
 			pch_i2c_stop(adap);
+			pch_i2c_init(adap);
 			return -ETIME;
 		}
 	} else {
@@ -469,7 +472,10 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 		pch_i2c_init(adap);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
+		pch_err(adap, "%s(L.%d):wait-event timeout\n",
+			__func__, __LINE__);
 		pch_i2c_stop(adap);
+		pch_i2c_init(adap);
 		return -ETIME;
 	}
 
@@ -490,7 +496,10 @@ static s32 pch_i2c_writebytes(struct i2c_adapter *i2c_adap,
 			pch_clrbit(adap->pch_base_address, PCH_I2CSR,
 				   I2CMIF_BIT);
 		} else { /* wait-event timeout */
+			pch_err(adap, "%s(L.%d):wait-event timeout\n",
+				__func__, __LINE__);
 			pch_i2c_stop(adap);
+			pch_i2c_init(adap);
 			return -ETIME;
 		}
 	}
@@ -598,7 +607,10 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 			pch_i2c_init(adap);
 			return -EAGAIN;
 		} else { /* wait-event timeout */
+			pch_err(adap, "%s(L.%d):wait-event timeout\n",
+				__func__, __LINE__);
 			pch_i2c_stop(adap);
+			pch_i2c_init(adap);
 			return -ETIME;
 		}
 		pch_i2c_restart(adap);
@@ -621,7 +633,10 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 			pch_i2c_init(adap);
 			return -EAGAIN;
 		} else { /* wait-event timeout */
+			pch_err(adap, "%s(L.%d):wait-event timeout\n",
+				__func__, __LINE__);
 			pch_i2c_stop(adap);
+			pch_i2c_init(adap);
 			return -ETIME;
 		}
 	} else {
@@ -648,7 +663,10 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 		pch_i2c_init(adap);
 		return -EAGAIN;
 	} else { /* wait-event timeout */
+		pch_err(adap, "%s(L.%d):wait-event timeout\n",
+			__func__, __LINE__);
 		pch_i2c_stop(adap);
+		pch_i2c_init(adap);
 		return -ETIME;
 	}
 
@@ -677,7 +695,10 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 					return -EIO;
 				}
 			} else { /* wait-event timeout */
+				pch_err(adap, "%s(L.%d):wait-event timeout\n",
+					__func__, __LINE__);
 				pch_i2c_stop(adap);
+				pch_i2c_init(adap);
 				return -ETIME;
 			}
 
@@ -698,7 +719,10 @@ static s32 pch_i2c_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
 				return -EIO;
 			}
 		} else { /* wait-event timeout */
+			pch_err(adap, "%s(L.%d):wait-event timeout\n",
+				__func__, __LINE__);
 			pch_i2c_stop(adap);
+			pch_i2c_init(adap);
 			return -ETIME;
 		}
 
-- 
1.7.7.6

