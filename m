Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2FZW33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:29:29 -0400
Received: from mail4.aviatnet.com ([192.147.115.31]:50428 "EHLO
	mail4.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2FZW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:29:14 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2012 18:29:14 EDT
Subject: [PATCH] rtc: ds1307: Register offset moved to chip description
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: <rtc-linux@googlegroups.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jun 2012 10:24:02 +1200
Message-ID: <1340749442.3241.4046.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.1.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc: ds1307: Register offset moved to chip description

From: Austin Boyle <Austin.Boyle@aviatnet.com>

Register offset is added to chip description instead of being hard-coded
into probe function.

Based on v3.5-rc4

Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>

---

diff --git a/a/drivers/rtc/rtc-ds1307.c b/b/drivers/rtc/rtc-ds1307.c
index 836710c..abf837b 100644
--- a/a/drivers/rtc/rtc-ds1307.c
+++ b/b/drivers/rtc/rtc-ds1307.c
@@ -122,6 +122,7 @@ struct ds1307 {
 
 struct chip_desc {
 	unsigned		alarm:1;
+	u8			offset;
 	u16			nvram_offset;
 	u16			nvram_size;
 	u16			trickle_charger_reg;
@@ -149,6 +150,9 @@ static const struct chip_desc chips[last_ds_type] = {
 	[ds_1388] = {
 		.trickle_charger_reg = 0x0a,
 	},
+	[ds_1388] = {
+		.offset		= 1, /* seconds field starts at 1 */
+	},
 	[ds_3231] = {
 		.alarm		= 1,
 	},
@@ -646,6 +650,7 @@ static int __devinit ds1307_probe(struct i2c_client *client,
 
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
+	ds1307->offset	= chip->offset;
 
 	if (pdata && pdata->trickle_charger_setup && chip->trickle_charger_reg)
 		i2c_smbus_write_byte_data(client, chip->trickle_charger_reg,
@@ -768,9 +773,6 @@ static int __devinit ds1307_probe(struct i2c_client *client,
 						  hour);
 		}
 		break;
-	case ds_1388:
-		ds1307->offset = 1; /* Seconds starts at 1 */
-		break;
 	default:
 		break;
 	}

