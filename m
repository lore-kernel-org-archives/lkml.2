Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab1LEQ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:57:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45047 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab1LEQ5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <1322999384-7886-2-git-send-email-b29396@freescale.com>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-2-git-send-email-b29396@freescale.com>
Date: Mon, 5 Dec 2011 17:57:42 +0100
Message-ID: <CACRpkdaYz+-nZA6atxA+5kvWOO84YeSHQPNiojq_R4zkHUGz3Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@freescale.com, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 4, 2011 at 12:49 PM, Dong Aisheng <b29396@freescale.com> wrote:

> +enum imx_mx53_pads {
> +       MX53_GPIO_19 = 0,
> +       MX53_KEY_COL0 = 1,
(...)

First I thought it looked a bit strange since you needed enums for all pads
but then I realized that your macros use the same enumerator name to
name the pad and then it looks sort of clever.

But maybe put in a comment about that here:

> +/* Pad names for the pinmux subsystem */

Like this:

/*
 * Pad names for the pinmux subsystem.
 * These pad names are constructed from the pin enumerator names
 * in the IMX_PINCTRL_PIN() macro.
 */

> +static const struct pinctrl_pin_desc mx53_pads[] = {
> +       IMX_PINCTRL_PIN(MX53_GPIO_19),
> +       IMX_PINCTRL_PIN(MX53_KEY_COL0),
(...)

> +/* mx53 pin groups and mux mode */
> +static const unsigned mx53_fec_pins[] = {
> +       MX53_FEC_MDC,
> +       MX53_FEC_MDIO,
> +       MX53_FEC_REF_CLK,
> +       MX53_FEC_RX_ER,
> +       MX53_FEC_CRS_DV,
> +       MX53_FEC_RXD1,
> +       MX53_FEC_RXD0,
> +       MX53_FEC_TX_EN,
> +       MX53_FEC_TXD1,
> +       MX53_FEC_TXD0,
> +};

I understand this.

> +static const unsigned mx53_fec_mux[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

But what is this? Just zeroes? Why?
Especially with a const so they really cannot be anything
else. The same pin (0) can only be enumerated once.

> +static const unsigned mx53_sd1_pins[] = {
> +       MX53_SD1_CMD,
> +       MX53_SD1_CLK,
> +       MX53_SD1_DATA0,
> +       MX53_SD1_DATA1,
> +       MX53_SD1_DATA2,
> +       MX53_SD1_DATA3,
> +
> +};
> +static const unsigned mx53_sd1_mux[] = { 0, 0, 0, 0, 0, 0 };

And here again.

> +static const unsigned mx53_sd3_pins[] = {
> +       MX53_PATA_DATA8,
> +       MX53_PATA_DATA9,
> +       MX53_PATA_DATA10,
> +       MX53_PATA_DATA11,
> +       MX53_PATA_DATA0,
> +       MX53_PATA_DATA1,
> +       MX53_PATA_DATA2,
> +       MX53_PATA_DATA3,
> +       MX53_PATA_IORDY,
> +       MX53_PATA_RESET_B,
> +
> +};
> +static const unsigned mx53_sd3_mux[] = { 4, 4, 4, 4, 4, 4, 4, 4, 2, 2 };

This also looks strange. Can you explain what these muxes are?

> +static const unsigned mx53_uart1_pins[] = {
> +       MX53_CSI0_DAT10,
> +       MX53_CSI0_DAT11,
> +};
> +static const unsigned mx53_uart1_mux[] = { 2, 2 };

And here again?

> +static const struct imx_pin_group mx53_pin_groups[] = {
> +       IMX_PIN_GROUP("fecgrp", mx53_fec_pins, mx53_fec_mux),
> +       IMX_PIN_GROUP("sd1grp", mx53_sd1_pins, mx53_sd1_mux),
> +       IMX_PIN_GROUP("sd3grp", mx53_sd3_pins, mx53_sd3_mux),
> +       IMX_PIN_GROUP("uart1grp", mx53_uart1_pins, mx53_uart1_mux),
> +};

So I understand the first and second argument to IMX_PIN_GROUP()
but not the third.

> +/* mx53 funcs and groups */
> +static const char * const fecgrps[] = { "fecgrp" };
> +static const char * const sd1grps[] = { "sd1grp" };
> +static const char * const sd3grps[] = { "sd3grp" };
> +static const char * const uart1grps[] = { "uart1grp" };
> +
> +static const struct imx_pmx_func mx53_pmx_functions[] = {
> +       IMX_PMX_FUNC("fec", fecgrps),
> +       IMX_PMX_FUNC("sd1", sd1grps),
> +       IMX_PMX_FUNC("sd3", sd3grps),
> +       IMX_PMX_FUNC("uart1", uart1grps),
> +};

This looks good.

Yours,
Linus Walleij
