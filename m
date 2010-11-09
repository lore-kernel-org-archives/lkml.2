Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0KIBgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:36:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55429 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0KIBgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:36:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JmBYwqLlRxyaWn5bjzegmrTxuDtWLXPvyfudn8hlDB2ZgqKaY+VCPlzzOPTZCW/XIl
         0q62cbaP+9UTQHZJiCVydCInHB33iQWnIwSoZOTiXg12XA1uWKw6Ii1PAkpm6CSiARSn
         lGwhOVc6vOlm8DD01P1vx5co/V8BWcYpfI4K0=
Subject: [PATCH] hwmon: (ad7414) Return proper error code for ad7414_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Sean MacLennan <smaclennan@pikatech.com>, lm-sensors@lm-sensors.org
Content-Type: text/plain
Date: Tue, 09 Nov 2010 09:40:34 +0800
Message-Id: <1289266834.14461.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return proper error if i2c_check_functionality reports
the adapter does not support the capability we need.

Also remove unneeded initialization for err variable.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/ad7414.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
index 1e4c21f..86d822a 100644
--- a/drivers/hwmon/ad7414.c
+++ b/drivers/hwmon/ad7414.c
@@ -178,11 +178,13 @@ static int ad7414_probe(struct i2c_client *client,
 {
 	struct ad7414_data *data;
 	int conf;
-	int err = 0;
+	int err;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |
-				     I2C_FUNC_SMBUS_READ_WORD_DATA))
+				     I2C_FUNC_SMBUS_READ_WORD_DATA)) {
+		err = -EOPNOTSUPP;
 		goto exit;
+	}
 
 	data = kzalloc(sizeof(struct ad7414_data), GFP_KERNEL);
 	if (!data) {
-- 
1.7.2



