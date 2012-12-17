Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2LQVrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:47:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56544 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2LQVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:47:04 -0500
Message-ID: <50CF92D5.6090805@wwwdotorg.org>
Date: Mon, 17 Dec 2012 14:47:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: Re: [PATCH 3/4] ARM: tegra: Add OF_DEV_AUXDATA for uart driver in
 board dt
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com> <1355746101-15291-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355746101-15291-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 05:08 AM, Laxman Dewangan wrote:
> Add OF_DEV_AUXDATA for high speed uart controller driver for
> Tegra20/Tegra30 board dt files.
> Set the parent clock of uart controller to PLLP.

> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c

> @@ -94,6 +94,11 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {

> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006000, "tegra-uart.0", NULL),
> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006040, "tegra-uart.1", NULL),
> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006200, "tegra-uart.2", NULL),
> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006300, "tegra-uart.3", NULL),
> +	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006400, "tegra-uart.4", NULL),

Instead, can we simply get the clocks from device tree? Prashant, how
much effort will that be once your clock patches are checked in, or is
it already part of those patches?

> @@ -106,7 +111,10 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
>  static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
>  	/* name		parent		rate		enabled */
>  	{ "uarta",	"pll_p",	216000000,	true },
> +	{ "uartb",	"pll_p",	216000000,	false },
> +	{ "uartc",	"pll_p",	216000000,	false },
>  	{ "uartd",	"pll_p",	216000000,	true },
> +	{ "uarte",	"pll_p",	216000000,	false },

Prashant's clock patches remove this table. Please work with him to work
out how to deal with that.
