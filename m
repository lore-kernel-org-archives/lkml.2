Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1GLInW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:43:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56031 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1GLInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:43:21 -0400
Subject: [PATCH v2] Input: cy8ctmg110_ts - fix checking return value of
 i2c_master_send
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuli Konttila <samuli.konttila@aavamobile.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 16:43:13 +0800
Message-ID: <1310460193.2028.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_master_send returns negative errno, or else the number of bytes written.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/cy8ctmg110_ts.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/cy8ctmg110_ts.c b/drivers/input/touchscreen/cy8ctmg110_ts.c
index 4481cc5..d7afa20 100644
--- a/drivers/input/touchscreen/cy8ctmg110_ts.c
+++ b/drivers/input/touchscreen/cy8ctmg110_ts.c
@@ -84,9 +84,9 @@ static int cy8ctmg110_write_regs(struct cy8ctmg110 *tsc, unsigned char reg,
 	memcpy(i2c_data + 1, value, len);
 
 	ret = i2c_master_send(client, i2c_data, len + 1);
-	if (ret != 1) {
+	if (ret != (len + 1)) {
 		dev_err(&client->dev, "i2c write data cmd failed\n");
-		return ret ? ret : -EIO;
+		return ret < 0 ? ret : -EIO;
 	}
 
 	return 0;
-- 
1.7.4.1



