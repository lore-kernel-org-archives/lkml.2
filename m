Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1BUESN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:18:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37280 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1BUESM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:18:12 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-16-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-16-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:18:10 -0800
Message-ID: <AANLkTin8AmjM2CWoNh54NmyV6=298bGzDUPO+j4LTrBj@mail.gmail.com>
Subject: Re: [PATCH v2 14/21] ARM: tegra: clock: Refcount periph clock enables
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
> Some peripheral clocks share enable bits.  Refcount the enables so
> that calling clk_disable on one clock will not turn off another
> clock.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/mach-tegra/tegra2_clocks.c |   35 +++++++++++++++++++++++++++++------
>  1 files changed, 29 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
> index 196c249..2734889 100644
> --- a/arch/arm/mach-tegra/tegra2_clocks.c
> +++ b/arch/arm/mach-tegra/tegra2_clocks.c
> @@ -154,6 +154,12 @@ static void __iomem *reg_pmc_base = IO_ADDRESS(TEGRA_PMC_BASE);
>  */
>  static DEFINE_SPINLOCK(clock_register_lock);
>
> +/*
> + * Some peripheral clocks share an enable bit, so refcount the enable bits
> + * in registers CLK_ENABLE_L, CLK_ENABLE_H, and CLK_ENABLE_U
> + */
> +static int tegra_periph_clk_enable_refcount[3 * 32];

Given that this is always locked when incrementing/decrementing,
should it just be switched to an array of atomics instead?


-Olof
