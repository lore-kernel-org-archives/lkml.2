Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161933Ab2CPWdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:33:31 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:60038 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964942Ab2CPWd3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:33:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com>
 <201203161218.05125.arnd.bergmann@linaro.org> <201203162057.58706.arnd@arndb.de>
 <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 16 Mar 2012 15:33:04 -0700
Message-ID: <CAJOA=zPmy7Dwzw8EOCW_+cvy2Dv=w0TPUq7Zg_s=Y0rs+v+u2w@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
To: Paul Walmsley <paul@pwsan.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 3:21 PM, Paul Walmsley <paul@pwsan.com> wrote:
> From: Paul Walmsley <paul@pwsan.com>
> Date: Fri, 16 Mar 2012 16:06:30 -0600
> Subject: [PATCH] clk: mark the common clk code as EXPERIMENTAL for now
>
> Mark the common clk code as depending on CONFIG_EXPERIMENTAL.  The API
> is not well-defined and both it and the underlying mechanics are likely
> to need significant changes to support non-trivial uses of the rate
> changing code, such as DVFS with external I/O devices.  So any platforms
> that switch their implementation over to this may need to revise much
> of their driver code and revalidate their implementations until the
> behavior of the code is better-defined.
>
> A good time for removing this EXPERIMENTAL designation would be after at
> least two platforms that do DVFS on groups of external I/O devices have
> ported their clock implementations over to the common clk code.
>
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Mike Turquette <mturquette@ti.com>

ACK.  This will set some reasonable expectations while things are in flux.

Arnd are you willing to take this in?

Thanks,
Mike

> ---
>  drivers/clk/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 2eaf17e..a0a83de 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -12,6 +12,7 @@ config HAVE_MACH_CLKDEV
>  menuconfig COMMON_CLK
>        bool "Common Clock Framework"
>        select HAVE_CLK_PREPARE
> +       depends on EXPERIMENTAL
>        ---help---
>          The common clock framework is a single definition of struct
>          clk, useful across many platforms, as well as an
> --
> 1.7.9.1
>
