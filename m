Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2J1TYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:24:48 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37688 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2J1TYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <1351181518-11882-3-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
	<1351181518-11882-3-git-send-email-m-karicheri2@ti.com>
Date: Sun, 28 Oct 2012 20:24:46 +0100
Message-ID: <CACRpkdaNfv13xxHyA0p9M7oqRqb7j0J9gvyYvYhgCs7-z4ifhQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: mturquette@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        shawn.guo@linaro.org, rob.herring@calxeda.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, nsekhar@ti.com, khilman@ti.com,
        linux@arm.linux.org.uk, sshtylyov@mvista.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-keystone@list.ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 6:11 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:

> This is the driver for the Power Sleep Controller (PSC) hardware
> found on DM SoCs as well Keystone SoCs (c6x). This driver borrowed
> code from arch/arm/mach-davinci/psc.c and implemented the driver
> as per common clock provider API. The PSC module is responsible for
> enabling/disabling the Power Domain and Clock domain for different IPs
> present in the SoC. The driver is configured through the clock data
> passed to the driver through struct clk_psc_data.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Here is some pedantic stuff if you're really bored:

> diff --git a/drivers/clk/davinci/clk-psc.c b/drivers/clk/davinci/clk-psc.c
(...)
> +               ptcmd = 1 << domain;

ptcmd = BIT(domain);

> +               pdctl = readl(psc_base + PDCTL + 4 * domain);
> +               pdctl |= 0x100;

pdctl |= BIT(8); /* and here a comment explaing what on earth that means */

> +       } else {
> +               ptcmd = 1 << domain;

ptcmd = BIT(domain);

Yours,
Linus Walleij
