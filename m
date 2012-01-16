Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885Ab2APFHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:07:32 -0500
Received: from mail2.nsc.com ([12.238.8.132]:41336 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750715Ab2APFHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:07:31 -0500
X-WSS-ID: 0LXVKWF-0A-0JX-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Axel Lin" <axel.lin@gmail.com>
cc: "Jeong, Daniel" <Daniel.Jeong@nsc.com>,
        "Anton Vorontsov" <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 15 Jan 2012 21:07:18 -0800
Subject: RE: [PATCH] power_supply: Add MODULE_DEVICE_TABLE for lp8727
 charger
Thread-Topic: [PATCH] power_supply: Add MODULE_DEVICE_TABLE for lp8727
 charger
Thread-Index: AczRKAkDBJN3O3QITpy0EOVqsdoAmAC5H/tw
Message-ID: <B567DBAB974C0544994013492B949F8E3812BEEB67@EXMAIL03.scwf.nsc.com>
References: <1326372302.5729.1.camel@phoenix>
In-Reply-To: <1326372302.5729.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630D6F001LS9702675-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0G583Lq009080

> Add MODULE_DEVICE_TABLE to setup modalias for lp8727.

Autoloading this module is not required.
The LP8727 includes a charger function with the micro/mini USB interface.
Charging a battery and detecting which cable is inserted, this kind of job must be started at the beginning of system boot.
So the lp8727 driver should be loaded before an user-space accesses this driver.

Thanks & BR
Milo -

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Thursday, January 12, 2012 9:45 PM
To: linux-kernel@vger.kernel.org
Cc: Kim, Milo; Jeong, Daniel; Anton Vorontsov
Subject: [PATCH] power_supply: Add MODULE_DEVICE_TABLE for lp8727 charger

Add MODULE_DEVICE_TABLE to setup modalias for lp8727.
The i2c_device_id table is supposed to be zero-terminated.
Thus add a missing terminate entry for lp8727_ids.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/lp8727_charger.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index b15b575..8e901c9 100644
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -464,7 +464,9 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
 
 static const struct i2c_device_id lp8727_ids[] = {
 	{"lp8727", 0},
+	{ },
 };
+MODULE_DEVICE_TABLE(i2c, lp8727_ids);
 
 static struct i2c_driver lp8727_driver = {
 	.driver = {
-- 
1.7.5.4



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
