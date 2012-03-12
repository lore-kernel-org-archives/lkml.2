Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2CLVEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:04:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48042 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2CLVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:04:46 -0400
Message-ID: <4F5E64EB.6050200@wwwdotorg.org>
Date: Mon, 12 Mar 2012 15:04:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: fix error path in pinconf_map_to_setting()
References: <1331584870-10077-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1331584870-10077-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 02:41 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The code was using the union member
> setting->data.configs.group_or_pin to store a potential
> error code, but since that member is unsigned the
> < 0 comparison was not true, letting errors pass thru,

"thru" is a pet peeve of mine; it'd be great to spell this correctly as
"through".

> ending up as mapped to pin "-22". Fix this up and print
> the error.

Oops. Sorry about that.

> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
...
> -		setting->data.configs.group_or_pin =
> -			pin_get_from_name(pctldev,
> -					  map->data.configs.group_or_pin);
> -		if (setting->data.configs.group_or_pin < 0)
> -			return setting->data.configs.group_or_pin;
> +		ret = pin_get_from_name(pctldev,
> +					map->data.configs.group_or_pin);
> +		if (ret < 0) {

"ret" here is named "pin" other places pin_get_from_name() is called,
and that naming seems to make a bit more sense here too.

Otherwise,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
