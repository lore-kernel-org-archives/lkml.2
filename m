Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2FNRMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:12:17 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40500 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab2FNRMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <4FD8BAD2.50703@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
	<4FD8BAD2.50703@linaro.org>
Date: Thu, 14 Jun 2012 19:12:14 +0200
Message-ID: <CACRpkdZFi34nChnMEo6yik67zk9owZLk-6zcdP7mmOXyLz8uqQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] i2c: Add Device Tree support to the Nomadik I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 6:07 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we apply the bindings required for successful Device Tree
> probing of the i2c-nomadik driver. We also apply a fall-back
> configuration in case either one is not provided, or a required
> element is missing from the one supplied.
>
> Cc: linux-i2c@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This looks more like I'd expect it, good job! :-D

> +static int __devinit
> +nmk_i2c_of_probe(struct device_node *np, struct nmk_i2c_controller *pdata)
> +{
> +       of_property_read_u32(np, "clock-frequency", (u32*)&pdata->clk_freq);
> +       if (!pdata->clk_freq) {
> +               pr_warn("%s: Clock frequency not found\n", np->full_name);
> +               return -EINVAL;
> +       }
> +
> +       of_property_read_u32(np, "stericsson,slsu", (u32*)&pdata->slsu);
> +       if (!pdata->slsu) {
> +               pr_warn("%s: Data line delay not found\n", np->full_name);
> +               return -EINVAL;
> +       }
> +
> +       of_property_read_u32(np, "stericsson,tft", (u32*)&pdata->tft);
> +       if (!pdata->tft) {
> +               pr_warn("%s: Tx FIFO threshold not found\n", np->full_name);
> +               return -EINVAL;
> +       }
> +
> +       of_property_read_u32(np, "stericsson,rft", (u32*)&pdata->rft);
> +       if (!pdata->rft) {
> +               pr_warn("%s: Rx FIFO threshold not found\n", np->full_name);
> +               return -EINVAL;
> +       }
> +
> +       of_property_read_u32(np, "stericsson,timeout", (u32*)&pdata->timeout);
> +       if (!pdata->timeout) {
> +               pr_warn("%s: Timeout not found\n", np->full_name);
> +               return -EINVAL;
> +       }
> +
> +       if (of_get_property(np, "stericsson,i2c_freq_mode_fast", NULL))
> +               pdata->sm = I2C_FREQ_MODE_FAST;
> +       else
> +               pdata->sm = I2C_FREQ_MODE_STANDARD;
> +
> +       return 0;
> +}

Will this compile fine if CONFIG_OF is not selected?

>        /* fetch the controller configuration from machine */
>        dev->cfg.clk_freq = pdata->clk_freq;
> -       dev->cfg.slsu   = pdata->slsu;
> -       dev->cfg.tft    = pdata->tft;
> -       dev->cfg.rft    = pdata->rft;
> -       dev->cfg.sm     = pdata->sm;
> -
> -       i2c_set_adapdata(adap, dev);
> +       dev->cfg.slsu     = pdata->slsu;
> +       dev->cfg.tft      = pdata->tft;
> +       dev->cfg.rft      = pdata->rft;
> +       dev->cfg.sm       = pdata->sm;  i2c_set_adapdata(adap, dev);

This looks like an unrelated whitespace fix, but OK...

Yours,
Linus Walleij
