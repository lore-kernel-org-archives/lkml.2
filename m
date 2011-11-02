Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1KBSOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:14:01 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62662 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1KBSOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com>
Date: Wed, 2 Nov 2011 11:13:59 -0700
X-Google-Sender-Auth: 91vjL4mK58c8b6FtxVpkaMJ4sFU
Message-ID: <CAMbhsRQ7JwzQDmFYf7frwfBvvtkUqdENkmrxtMLRvb-PFbixiw@mail.gmail.com>
Subject: Re: [PATCH] arm/tegra: add support for tegra30 interrupts
From: Colin Cross <ccross@android.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 8:38 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> Tegra30 has 1 extra legacy interrupt controller. Use the GIC ITLinesNumber
> field to determine how many interrupt controllers we have and initialize
> appropriately. Also make room for the extra tegra30 interrupts by moving
> the GPIO IRQ base. This shouldn't affect existing code as it determines the
> correct IRQ number for GPIOs using TEGRA_GPIO_TO_IRQ()
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  arch/arm/mach-tegra/include/mach/iomap.h |    3 +++
>  arch/arm/mach-tegra/include/mach/irqs.h  |   14 +++++++-------
>  arch/arm/mach-tegra/irq.c                |   15 ++++++++++-----
>  3 files changed, 20 insertions(+), 12 deletions(-)
>

<snip>

> diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
> index 8ad82af..aad335b 100644
> --- a/arch/arm/mach-tegra/irq.c
> +++ b/arch/arm/mach-tegra/irq.c
<snip>
> @@ -112,8 +114,12 @@ static int tegra_retrigger(struct irq_data *d)
>  void __init tegra_init_irq(void)
>  {
>        int i;
> +       void __iomem *distbase;
> +
> +       distbase = IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE);
> +       num_ictlrs = readl_relaxed(distbase + GIC_DIST_CTR) & 0x1f;

Check num_ictlrs against ARRAY_SIZE(ictlr_reg_base)

Other than that:
Acked-by: Colin Cross <ccross@android.com>
