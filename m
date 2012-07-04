Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2GDEMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 00:12:12 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:8604
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab2GDEMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 00:12:09 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzz8275bhz2dh2a8h668h839h93fhd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>
Date: Wed, 4 Jul 2012 00:12:03 -0400
Subject: RE: [PATCH v3] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Topic: [PATCH v3] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Index: Ac1ZmNt3v3sVfORjTQSx0U4ZXqkYAgAAjhtg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D171408060D3@NWD2CMBX1.ad.analog.com>
References: <1341374107.27231.1.camel@phoenix>
In-Reply-To: <1341374107.27231.1.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q644CHs7020291

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

>-----Original Message-----
>From: Axel Lin [mailto:axel.lin@gmail.com]
>Sent: Wednesday, July 04, 2012 11:55 AM
>To: Mark Brown
>Cc: linux-kernel@vger.kernel.org; Zhang, Sonic; Lars-Peter Clausen; Liam
>Girdwood
>Subject: [PATCH v3] regulator: ad5398: Fix min/max current limit boundary
>checking
>
>It is ok to request current limit with min_uA < chip->min_uA and
>max_uA > chip->max_uA.
>
>We need to set min_uA = chip->min_uA if (min_uA < chip->min_uA),
>this ensures the equation to calcuate selator does not return negative number.
>
>Also set max_uA = chip->max_uA if (max_uA > chip->max_uA), as suggested by
>Sonic.
>
>Signed-off-by: Axel Lin <axel.lin@gmail.com>
>---
> drivers/regulator/ad5398.c |    9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
>index 46d05f3..f123f7e 100644
>--- a/drivers/regulator/ad5398.c
>+++ b/drivers/regulator/ad5398.c
>@@ -89,9 +89,12 @@ static int ad5398_set_current_limit(struct regulator_dev
>*rdev, int min_uA, int
>       unsigned short data;
>       int ret;
>
>-      if (min_uA > chip->max_uA || min_uA < chip->min_uA)
>-              return -EINVAL;
>-      if (max_uA > chip->max_uA || max_uA < chip->min_uA)
>+      if (min_uA < chip->min_uA)
>+              min_uA = chip->min_uA;
>+      if (max_uA > chip->max_uA)
>+              max_uA = chip->max_uA;
>+
>+      if (min_uA > chip->max_uA || max_uA < chip->min_uA)
>               return -EINVAL;
>
>       selector = DIV_ROUND_UP((min_uA - chip->min_uA) * chip->current_level,
>--
>1.7.9.5
>
>
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
