Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab0HNOjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 10:39:13 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:36349 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756662Ab0HNOjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 10:39:12 -0400
From: Sundar R IYER <sundar.iyer@stericsson.com>
To: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Date: Sat, 14 Aug 2010 16:39:02 +0200
Subject: RE: [PATCH] regulator: ab8500 - fix the logic to remove already
 registered regulators in error path
Thread-Topic: [PATCH] regulator: ab8500 - fix the logic to remove already
 registered regulators in error path
Thread-Index: Acs7trs05ECGMDW2QhuTNDUhYcT/6AABDp0QAADXHqA=
Message-ID: <33A307AF30D7BF4F811B1568FE7A9B18188E2CA3@EXDCVYMBSTM006.EQ1STM.local>
References: <1281793444.2974.5.camel@phoenix> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7EEdLYq024453

Oops, I didnâ€™t see the below patch.

[PATCH] regulator: ab3100 - fix the logic to remove already registered regulators in error path

Sorry for the inconvenience!

Cheers!
Sundar

>-----Original Message-----
>From: Sundar R IYER
>Sent: Saturday, August 14, 2010 8:05 PM
>To: 'Axel Lin'; linux-kernel
>Cc: Liam Girdwood; Mark Brown; Linus WALLEIJ
>Subject: RE: [PATCH] regulator: ab8500 - fix the logic to remove already registered
>regulators in error path
>
>Thanx!
>
>BTW, could you also include the AB3100 as well into this patch? I derived it from
>the AB3100 implementation.
>
>Linus, any comments?
>
>Regards,
>Sundar
>
>>-----Original Message-----
>>From: Axel Lin [mailto:axel.lin@gmail.com]
>>Sent: Saturday, August 14, 2010 7:14 PM
>>To: linux-kernel
>>Cc: Liam Girdwood; Mark Brown; Sundar R IYER
>>Subject: [PATCH] regulator: ab8500 - fix the logic to remove already registered
>>regulators in error path
>>
>>In current implementation, ab8500_regulator_info[0].regulator is not
>>unregistered if the error happen at i > 0.
>>
>>This patch fixes the resource leak and also improves the readability.
>>
>>Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>---
>>I think this change is better ( in readability ) than simply change "while (i > 0)" to
>>"while (i >= 0)".
>>
>> drivers/regulator/ab8500.c |    4 +---
>> 1 files changed, 1 insertions(+), 3 deletions(-)
>>
>>diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
>>index dc3f1a4..775688e 100644
>>--- a/drivers/regulator/ab8500.c
>>+++ b/drivers/regulator/ab8500.c
>>@@ -368,11 +368,9 @@ static __devinit int ab8500_regulator_probe(struct
>>platform_device *pdev)
>> 			dev_err(&pdev->dev, "failed to register regulator %s\n",
>> 					info->desc.name);
>> 			/* when we fail, un-register all earlier regulators */
>>-			i--;
>>-			while (i > 0) {
>>+			while (--i >= 0) {
>> 				info = &ab8500_regulator_info[i];
>> 				regulator_unregister(info->regulator);
>>-				i--;
>> 			}
>> 			return err;
>> 		}
>>--
>>1.7.0.4
>>
>>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
