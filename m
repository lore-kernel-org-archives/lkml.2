Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1I1NQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:16:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1I1NQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:16:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH v4 3/3] arm/tegra: device tree support for ventana board
Date: Wed, 28 Sep 2011 15:16:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <1317171902-14736-1-git-send-email-pdeschrijver@nvidia.com> <1317171902-14736-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1317171902-14736-4-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281516.42513.arnd@arndb.de>
X-Provags-ID: V02:K0:IPT8l/Wk7OC8sz84nx1i8JsNtCHiK/rBsIFbwWNuR+J
 NHMy2iqEDNQ6XrJ8fOghPYcUL0DxmvqwXxTDTPcI382IUBPvuh
 7p0oHwLhiUI0ppoYD/FDwZTvYu0AHg2vMd2zIrefRQgAu5uzTp
 f6k02fBFa0wabHCwmJ44rNY83rghRPKOMv7nxTfhbUH49GTLip
 64IUN8C/283tqULXnqYZiuAswzYHJxhDR+XOeLlJB3WgpcdGcQ
 64wQI5tiIIrDhI4PkoOs/ITVvAhYb6IqrCi8QDSWiA2tmDrKO4
 Novua5EpVYkiGk1yVztUommYDPZ9Y7XievJHLPlXt1RxWOUIbA
 WCZwj+TtfKjU7bXYtUyU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, Peter De Schrijver wrote:
> --- a/arch/arm/mach-tegra/board-dt.c
> +++ b/arch/arm/mach-tegra/board-dt.c
> @@ -47,7 +47,7 @@
>  
>  void harmony_pinmux_init(void);
>  void seaboard_pinmux_init(void);
> -
> +void ventana_pinmux_init(void);
>  
>  struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
>         OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
> @@ -95,6 +95,8 @@ static void __init tegra_dt_init(void)
>                 harmony_pinmux_init();
>         else if (of_machine_is_compatible("nvidia,seaboard"))
>                 seaboard_pinmux_init();
> +       else if (of_machine_is_compatible("nvidia,ventana"))
> +               ventana_pinmux_init();

Are you (Peter, Colin, Olof) confident that this is not getting out
of hand before it's getting better?

If we are keeping the per-board pinmux configuration in the kernel
for longer, I think it would be better to do this table-driven than
having a list of top-level of_machine_is_compatible() statements
and do something like:

static struct {
	const char *machine;
	struct tegra_pingroup_config *config[];
} pinmux_configs[] __initdata = {
	{ "nvidia,ventana", &ventana_pinmux },
	{ "nvidia,seaboard, &seaboard_pinmux },
};

	Arnd
