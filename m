Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1LNIgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:36:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37196 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1LNIgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <1323851530-4171-1-git-send-email-linus.walleij@stericsson.com>
References: <1323851530-4171-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 14 Dec 2011 16:36:18 +0800
Message-ID: <CAN1soZybpVCPJsytuaQuZW_pNwzjBFn4gEdXOrJAPY7pXoiPhg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add a group-specific hog macro
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 4:32 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> To create elegant tables for pinmux hogs on the PXA MMP platform,
> we need this hog macro that can specify both function and group in
> one go.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  include/linux/pinctrl/machine.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> index ad430e0..d0aecb7 100644
> --- a/include/linux/pinctrl/machine.h
> +++ b/include/linux/pinctrl/machine.h
> @@ -73,6 +73,15 @@ struct pinmux_map {
>        { .name = a, .ctrl_dev_name = b, .function = c, \
>          .hog_on_boot = true }
>
> +/*
> + * Convenience macro to map a system function onto a certain pinctrl device
> + * using a specified group, to be hogged by the pinmux core until the system
> + * shuts down.
> + */
> +#define PINMUX_MAP_SYS_HOG_GROUP(a, b, c, d)           \
> +       { .name = a, .ctrl_dev_name = b, .function = c, .group = d, \
> +         .hog_on_boot = true }
> +
>  #ifdef CONFIG_PINMUX
>
>  extern int pinmux_register_mappings(struct pinmux_map const *map,
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
