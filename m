Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3ACQch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:32:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3ACQcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:32:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 9/9] ARM: tegra: Add initial support for Tegra 114 SoC.
Date: Thu, 3 Jan 2013 16:28:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com> <1355996654-6579-10-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1355996654-6579-10-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301031628.19743.arnd@arndb.de>
X-Provags-ID: V02:K0:UOsNE6nAE9d7UnwUzxdAqsP45u6upqhn4yaaSZN/VQc
 /ah9+ypbdM8JIjjea83A0e9L8zGHuslzFNxFeopdpqx1p+KzQd
 RDHVOtTYMWhp12qpccyeXHHJC2pcPA7YK/9i6u36hqLLFyaM/c
 3CTpAOrkUA3USqXWydskTtPD2YZAUFqiwmF2c77BHdv5r8CCT8
 IGKz2Pd9kDX4k+03B4xWQQzsuxJMGXfr2TpiWKJD59Tt55wz9Y
 WyIInxvcYn58mV1RkPx1A+5aVKWiKTJPTSBEpajrfUa+P68Bzt
 3NXHs+E5wgQBG+jN4Hlgfi6wRXuqD2hLxzcVlWotHYTR1hgEYA
 wFCRcWKEMnR8ds7llwZs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2012, Hiroshi Doyu wrote:
> +
> +DT_MACHINE_START(TEGRA114_DT, "NVIDIA Tegra114 (Flattened Device Tree)")
> +       .smp            = smp_ops(tegra_smp_ops),
> +       .map_io         = tegra_map_common_io,
> +       .init_early     = tegra30_init_early,
> +       .init_irq       = tegra_dt_init_irq,
> +       .handle_irq     = gic_handle_irq,
> +       .init_time      = clocksource_of_init,
> +       .init_machine   = tegra114_dt_init,
> +       .init_late      = tegra_init_late,
> +       .restart        = tegra_assert_system_reset,
> +       .dt_compat      = tegra114_dt_board_compat,
> +MACHINE_END

This one is so similar to Tegra30 that I wonder if it's actually worth keeping
them separate still. The only difference I see is the clock initialization.
Maybe that can be factored out to keep this the same as Tegra30.

Or are you planning to add more SoC specific here that would make this harder?

	Arnd
