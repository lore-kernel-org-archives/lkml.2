Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1LHWZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:25:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7975 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1LHWZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:25:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 08 Dec 2011 14:24:47 -0800
From: Stephen Warren <swarren@nvidia.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Thu, 8 Dec 2011 14:24:46 -0800
Subject: RE: [PATCH] Documentation/pinctrl: various minor fixes
Thread-Topic: [PATCH] Documentation/pinctrl: various minor fixes
Thread-Index: Acy198zOSehgc/CaShiOkapBan07bwAAEnpA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77B9F@HQMAIL01.nvidia.com>
References: <1323382892-28298-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1323382892-28298-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB8MPEDC032590

Uwe Kleine-KÃ¶nig wrote at Thursday, December 08, 2011 3:22 PM:
> - add some consts
> - don't use the group index alone to determine the value to write to
>   foo's mux register. For spi and i2c the group index is always 0.
>   Additionally using the function index makes much more sense as it
>   generates a different value for each function/group pair.
> - fix a few syntax errors

> @@ -600,7 +600,7 @@ static int foo_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
>  int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
>  		unsigned group)
>  {
> -	u8 regbit = (1 << group);
> +	u8 regbit = (1 << selector + group);
> 
>  	writeb((readb(MUX)|regbit), MUX)
>  	return 0;
> @@ -609,7 +609,7 @@ int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
>  int foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
>  		unsigned group)
>  {
> -	u8 regbit = (1 << group);
> +	u8 regbit = (1 << selector);
> 
>  	writeb((readb(MUX) & ~(regbit)), MUX)
>  	return 0;

Shouldn't those two regbit calculations match?

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
