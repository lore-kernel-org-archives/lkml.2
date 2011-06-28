Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1F1JoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:44:06 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:34599 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1F1Jnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:43:49 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] i2c-eg20t: Do not print error message if no ACK is received
Date: Tue, 28 Jun 2011 11:43:39 +0200
Message-Id: <1309254219-18875-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing so would spam the kernel log for each i2cdetect run and
device probe.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 8abfa4a..97110f7 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -345,7 +345,7 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
 	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
 
 	if (reg_val != 0) {
-		pch_err(adap, "return%d\n", -EPROTO);
+		pch_dbg(adap, "return%d\n", -EPROTO);
 		return -EPROTO;
 	}
 
-- 
1.7.3.4

