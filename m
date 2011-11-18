Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1KRGBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 01:01:41 -0500
Received: from mail2.nsc.com ([12.238.8.132]:37372 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756628Ab1KRGBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 01:01:39 -0500
X-Greylist: delayed 1056 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 01:01:39 EST
X-WSS-ID: 0LUUD81-0A-29J-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Thu, 17 Nov 2011 21:43:06 -0800
Subject: [PATCH] power: lp8727 - add supported i2c functionality check
 routine
Thread-Topic: [PATCH] power: lp8727 - add supported i2c functionality
 check routine
Thread-Index: AcyJGBXAdUB8oJDGSj+lwhRWFSM0rwAVaYXwBxGMGXA=
Message-ID: <B567DBAB974C0544994013492B949F8E38123AC1B6@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E380F619DE2@EXMAIL03.scwf.nsc.com>
 <20111012194927.GA9239@oksana.dev.rtsoft.ru>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 62DB2FE71LS8357175-02-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAI61iFK008625

Hi, Anton

I send the patch for lp8727 charger driver.

Signed-off-by: Woogyom Kim <milo.kim@ti.com>

>From c72a8a461d19ace81d9d092e8a23de741dd2144f Mon Sep 17 00:00:00 2001
From: Milo(Woogyom) Kim <milo.kim@ti.com>
Date: Fri, 18 Nov 2011 14:30:59 +0900
Subject: [PATCH] power : lp8727 - add supported i2c functionality check routine

lp8727 i2c r/w functions are based on SMBUS I2C BLOCK.
So the driver needs to check whether i2c bus supports this functionality or not.
---
 drivers/power/lp8727_charger.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
index 6d13f83..b15b575 100755
--- a/drivers/power/lp8727_charger.c
+++ b/drivers/power/lp8727_charger.c
@@ -425,6 +425,9 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	struct lp8727_chg *pchg;
 	int ret;
 
+	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
+		return -EIO;
+
 	pchg = kzalloc(sizeof(*pchg), GFP_KERNEL);
 	if (!pchg)
 		return -ENOMEM;
-- 
1.7.4.1

Thanks & BR
Milo (Woogyom)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
