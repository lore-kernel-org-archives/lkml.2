Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2BXQzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:55:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61209 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab2BXQzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:55:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dongas86@gmail.com designates 10.68.233.36 as permitted sender) smtp.mail=dongas86@gmail.com; dkim=pass header.i=dongas86@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-17-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-17-git-send-email-swarren@nvidia.com>
Date: Sat, 25 Feb 2012 00:55:37 +0800
Message-ID: <CAA+hA=QBySeYNoXK1D7DEONc3E_e6bs-6L72hBMxXUdxcWOyjA@mail.gmail.com>
Subject: Re: [PATCH 16/20] pinctrl: Refactor struct pinctrl handling in core.c
 vs pinmux.c
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 2:45 PM, Stephen Warren <swarren@nvidia.com> wrote:
> This change separates two aspects of struct pinctrl:
>
> a) The data representation of the parsed mapping table, into:
>
>   1) The top-level struct pinctrl object, a single entity returned
>      by pinctrl_get().
>
>   2) The parsed version of each mapping table entry, struct
>      pinctrl_setting, of which there is one per mapping table entry.
>
> b) The code that handles this; the code for (1) above is in core.c, and
>   the code to parse/execute each entry in (2) above is in pinmux.c, while
>   the iteration over multiple settings is lifted to core.c.
>
> This will allow the following future changes:
>
> 1) pinctrl_get() API rework, so that struct pinctrl represents all states
>   for the device, and the device can select between them without calling
>   put()/get() again.
>
> 2) To support that, a struct pinctrl_state object will be inserted into
>   the data model between the struct pinctrl and struct pinctrl_setting.
>
> 3) The mapping table will be extended to allow specification of pin config
>   settings too. To support this, struct pinctrl_setting will be enhanced
>   to store either mux settings or config settings, and functions will be
>   added to pinconf.c to parse/execute pin configuration settings.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Looks good to me.
Please also with my tag.
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

BTW, one minor thing, see below:
...
> -/**
> - * pinmux_search_function() - check pin control driver for a certain function
> - * @pctldev: device to check for function and position
> - * @map: function map containing the function and position to look for
> - * @func_selector: returns the applicable function selector if found
> - * @group_selector: returns the applicable group selector if found
> - *
> - * This will search the pinmux driver for an applicable
> - * function with a specific pin group, returns 0 if these can be mapped
> - * negative otherwise
> - */
> -static int pinmux_search_function(struct pinctrl_dev *pctldev,
> -                                 struct pinctrl_map const *map,
> -                                 unsigned *func_selector,
> -                                 unsigned *group_selector)
> +int pinmux_func_name_to_selector(struct pinctrl_dev *pctldev,
> +                                const char *function)
Static?

Regards
Dong Aisheng
