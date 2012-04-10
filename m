Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2DJPgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:36:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44223 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2DJPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:36:30 -0400
Message-ID: <4F84537A.2020300@wwwdotorg.org>
Date: Tue, 10 Apr 2012 09:36:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] pinctrl: implement pinctrl deferred probing
References: <1334045048-15566-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1334045048-15566-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 02:04 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> If drivers try to obtain pinctrl handles for a pin controller that
> has not yet registered to the subsystem, we need to be able to
> back out and retry with deferred probing. So let's return
> -EPROBE_DEFER whenever this location fails.
> 
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

This looks fine, except:

> @@ -521,8 +521,11 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
>  		dev_err(p->dev, "unknown pinctrl device %s in map entry",
>  			map->ctrl_dev_name);

Perhaps this dev_err (and the one in the other hunk) should be
downgraded to warn/info/debug?

> +		/*
> +		 * OK let us guess that the driver is not there yet, and
> +		 * let's defer obtaining this pinctrl handle to later...
> +		 */
> +		return -EPROBE_DEFER;
>  	}
