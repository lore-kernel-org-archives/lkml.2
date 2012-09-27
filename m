Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2I0NUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:20:01 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55524 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab2I0NUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:20:00 -0400
MIME-Version: 1.0
In-Reply-To: <1348682889-9509-2-git-send-email-m-karicheri2@ti.com>
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com>
	<1348682889-9509-2-git-send-email-m-karicheri2@ti.com>
Date: Thu, 27 Sep 2012 15:19:58 +0200
Message-ID: <CACRpkdZ=8m+X2KnUPFFhT2LsvTe-jPR_m6oVt_CEFfY-LvFHmg@mail.gmail.com>
Subject: Re: [PATCH 01/13] clk: davinci - add Main PLL clock driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: mturquette@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        shawn.guo@linaro.org, rob.herring@calxeda.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, nsekhar@ti.com, khilman@ti.com,
        linux@arm.linux.org.uk, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-keystone@list.ti.com,
        linux-c6x-dev@linux-c6x.org, cyril@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 8:07 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:

> +struct clk_davinci_pll_data {
> +       /* physical addresses set by platform code */
> +       u32 phy_pllm;
> +       /* if PLL has a prediv register this should be non zero */
> +       u32 phy_prediv;
> +       /* if PLL has a postdiv register this should be non zero */
> +       u32 phy_postdiv;
> +       /* mapped addresses. should be initialized by  */
> +       void __iomem *pllm;
> +       void __iomem *prediv;
> +       void __iomem *postdiv;
> +       u32 pllm_mask;
> +       u32 prediv_mask;
> +       u32 postdiv_mask;
> +       u32 num;
> +       /* framework flags */
> +       u32 flags;
> +       /* pll flags */
> +       u32 pll_flags;
> +       /* use this value for prediv */
> +       u32 fixed_prediv;
> +       /* multiply PLLM by this factor. By default most SOC set this to zero
> +        * that translates to a multiplier of 1 and incrementer of 1.
> +        * To override default, set this factor
> +        */
> +       u32 pllm_multiplier;
> +};
> +

No, that's not what I meant.

I meant like this:

/**
 * struct clk_davinci_pll_data - struct holding the PLL data
 * phy_pllm: physical addresses set by platform code
 * phy_prediv: ...
(...)
 */
struct clk_davinci_pll_data {
      u32 phy_pllm;
      u32 phy_prediv;
(...)
};

Yours,
Linus Walleij
