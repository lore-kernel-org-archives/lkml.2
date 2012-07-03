Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab2GCHyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:54:51 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22705
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768Ab2GCHyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:54:49 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzz8275bhz2dh2a8h668h839h93fhd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>
Date: Tue, 3 Jul 2012 03:54:55 -0400
Subject: RE: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Topic: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
Thread-Index: Ac1Y73DQsW5bS61KSluvRmkAVPP4FwAAYCTA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D17140805D85@NWD2CMBX1.ad.analog.com>
References: <1341301353.12050.1.camel@phoenix>
In-Reply-To: <1341301353.12050.1.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q637stOc014396



>-----Original Message-----
>From: Axel Lin [mailto:axel.lin@gmail.com]
>Sent: Tuesday, July 03, 2012 3:43 PM
>To: Mark Brown
>Cc: linux-kernel@vger.kernel.org; Zhang, Sonic; Lars-Peter Clausen; Liam
>Girdwood
>Subject: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
>checking
>
>It is ok to request current limit with min_uA < chip->min_uA and
>max_uA > chip->max_uA.
>
>We need to set min_uA = chip->min_uA if (min_uA < chip->min_uA),
>this ensures the equation to calcuate selator does not return negative number.
>

You should not do it in driver. Set a correct min_uA value in your application.

Regards,

Sonic

>Signed-off-by: Axel Lin <axel.lin@gmail.com>
>~
>---
> drivers/regulator/ad5398.c |    7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
>index 46d05f3..84fdcda 100644
>--- a/drivers/regulator/ad5398.c
>+++ b/drivers/regulator/ad5398.c
>@@ -89,9 +89,10 @@ static int ad5398_set_current_limit(struct regulator_dev
>*rdev, int min_uA, int
>       unsigned short data;
>       int ret;
>
>-      if (min_uA > chip->max_uA || min_uA < chip->min_uA)
>-              return -EINVAL;
>-      if (max_uA > chip->max_uA || max_uA < chip->min_uA)
>+      if (min_uA < chip->min_uA)
>+              min_uA = chip->min_uA;
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
