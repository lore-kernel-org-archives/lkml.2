Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2BXGJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:09:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2BXGJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:09:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
Date: Fri, 24 Feb 2012 07:09:11 +0100
Message-ID: <CACRpkdZWu_nYkWLxXBUv-VAQTMByDM37qACRf3im7R4GQgZc5A@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define, and
 use it
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 1:04 AM, Stephen Warren <swarren@nvidia.com> wrote:

> This provides a single centralized name for the default state.
>
> Update PIN_MAP_* macros to use this state name, instead of requiring the
> user to pass a state name in.
>
> Update documentation and mapping tables to use this.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

I like the direction this is taking for sure. This is however not
working because
it break U300, no hogs nor device requests work after this patch so I cannot
apply it.

I folded in this:

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 57ef1e6..ac12e08 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1612,9 +1612,9 @@ static struct pinctrl_map __initdata u300_pinmux_map[] = {
        PIN_MAP_SYS_HOG("pinmux-u300", "emif0"),
        PIN_MAP_SYS_HOG("pinmux-u300", "emif1"),
        /* per-device maps for MMC/SD, SPI and UART */
-       PIN_MAP("MMCSD", "pinctrl-u300", "mmc0", "mmci"),
-       PIN_MAP("SPI", "pinctrl-u300", "spi0", "pl022"),
-       PIN_MAP("UART0", "pinctrl-u300", "uart0", "uart0"),
+       PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "mmc0", "mmci"),
+       PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "spi0", "pl022"),
+       PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "uart0", "uart0"),
 };

 struct u300_mux_hog {
@@ -1646,7 +1646,7 @@ static int __init u300_pinctrl_fetch(void)
                struct pinctrl *p;
                int ret;

-               p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
+               p = pinctrl_get(u300_mux_hogs[i].dev, PINCTRL_STATE_DEFAULT);
                if (IS_ERR(p)) {
                        pr_err("u300: could not get pinmux hog %s\n",
                               u300_mux_hogs[i].name);


Still no luck :-(

What am I missing?

Yours,
Linus Walleij
