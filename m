Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2C0DBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:01:41 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:39046
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541Ab2C0DBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:01:40 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz9371I542Mzz1202hzz8275bh8275dhz2dh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 26 Mar 2012 23:01:21 -0400
Subject: RE: [PATCH 1/2] regulator: ad5398: show changing current in uA
Thread-Topic: [PATCH 1/2] regulator: ad5398: show changing current in uA
Thread-Index: Ac0LvoLLOSpXS15uRmiD8N3pX3TUDAAB1wQw
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16F258A5B43@NWD2CMBX1.ad.analog.com>
References: <1332814105.21855.1.camel@phoenix>
In-Reply-To: <1332814105.21855.1.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2R32WnU019486

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com]
Sent: Tuesday, March 27, 2012 10:08 AM
To: linux-kernel@vger.kernel.org
Cc: Zhang, Sonic; Liam Girdwood; Mark Brown
Subject: [PATCH 1/2] regulator: ad5398: show changing current in uA

Integer division may truncate the result.
Current code shows changing current is 0mA when selector is 1 ... 8.

For example:
selector = 1
ad5398_calc_current returns 117, debug message shows 117/1000 = 0mA
selector = 2
ad5398_calc_current returns 234, debug message shows 234/1000 = 0mA
selector = 3
ad5398_calc_current returns 351, debug message shows 351/1000 = 0mA
............
selector = 8
ad5398_calc_current returns 937, debug message shows 937/1000 = 0mA

Show the changing current in uA makes it easier for debugging.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 26d23ad..ed58798 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -99,8 +99,8 @@ static int ad5398_set_current_limit(struct regulator_dev *rdev, int min_uA, int
        if (ad5398_calc_current(chip, selector) > max_uA)
                return -EINVAL;

-       dev_dbg(&client->dev, "changing current %dmA\n",
-               ad5398_calc_current(chip, selector) / 1000);
+       dev_dbg(&client->dev, "changing current %duA\n",
+               ad5398_calc_current(chip, selector));

        /* read chip enable bit */
        ret = ad5398_read_reg(client, &data);
--
1.7.5.4




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
