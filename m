Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2ATRAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:00:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11095 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab2ATRAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:00:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Jan 2012 09:00:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Date: Fri, 20 Jan 2012 09:00:38 -0800
Subject: RE: [PATCH 3/4] pinctrl: Add checks for empty names in
 pinmux_search_function
Thread-Topic: [PATCH 3/4] pinctrl: Add checks for empty names in
 pinmux_search_function
Thread-Index: AczXjwRrw1cT2w5KQmuZfVuyfinJRAABbBUA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB384@HQMAIL01.nvidia.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
 <20120120161730.21955.40332.stgit@kaulin.local>
In-Reply-To: <20120120161730.21955.40332.stgit@kaulin.local>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0KH0wk7006825

Tony Lindgren wrote at Friday, January 20, 2012 9:18 AM:
> Otherwise we can get the following when dealing with
> buggy data in a pinmux driver:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index 06b8943..ffe633d 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -584,6 +584,13 @@ static int pinmux_search_function(struct pinctrl_dev *pctldev,
>  							   selector);
>  		int ret;
> 
> +		if (!fname) {
> +			pr_warning("no name for function%i\n",
> +				   selector);
> +			selector++;
> +			continue;
> +		}
> +
>  		if (!strcmp(map->function, fname)) {
>  			/* Found the function, check pin group */
>  			ret = pinmux_check_pin_group(pctldev, selector,

Shouldn't this be BUG_ON(!fname)?

There are lots of other places that pmxops->get_function_name() is
called. Wouldn't it be better to enhance e.g. pinmux_check_ops() to
validate that all functions have a name during pinctrl registration?

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
