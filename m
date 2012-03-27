Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2C0Cmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 22:42:35 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:18817
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610Ab2C0Cme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 22:42:34 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz9371I542Mzz1202hzz8275bh8275dhz2dh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 26 Mar 2012 22:42:20 -0400
Subject: RE: [PATCH 2/2] regulator: ad5398: Use devm_kzalloc
Thread-Topic: [PATCH 2/2] regulator: ad5398: Use devm_kzalloc
Thread-Index: Ac0LvqwMwjSN0RrASgqG8AFZjkTArAABIovA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16F258A5B28@NWD2CMBX1.ad.analog.com>
References: <1332814105.21855.1.camel@phoenix>
 <1332814182.21855.2.camel@phoenix>
In-Reply-To: <1332814182.21855.2.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2R2geja019445

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com]
Sent: Tuesday, March 27, 2012 10:10 AM
To: linux-kernel@vger.kernel.org
Cc: Zhang, Sonic; Liam Girdwood; Mark Brown
Subject: [PATCH 2/2] regulator: ad5398: Use devm_kzalloc

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index ed58798..7d51793 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -220,7 +220,7 @@ static int __devinit ad5398_probe(struct i2c_client *client,
        if (!init_data)
                return -EINVAL;

-       chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+       chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
        if (!chip)
                return -ENOMEM;

@@ -246,7 +246,6 @@ static int __devinit ad5398_probe(struct i2c_client *client,
        return 0;

 err:
-       kfree(chip);
        return ret;
 }

@@ -255,8 +254,6 @@ static int __devexit ad5398_remove(struct i2c_client *client)
        struct ad5398_chip_info *chip = i2c_get_clientdata(client);

        regulator_unregister(chip->rdev);
-       kfree(chip);
-
        return 0;
 }

--
1.7.5.4




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
