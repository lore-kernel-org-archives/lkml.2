Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2HJG5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:57:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65217 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2HJG52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <1344437248-20560-6-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
	<1344437248-20560-6-git-send-email-arnd@arndb.de>
Date: Fri, 10 Aug 2012 12:27:27 +0530
Message-ID: <CAJuYYwRJqpPbrn-8FfQEhsdw1Vafr4MoH0hmfTObxdY8WRiHpQ@mail.gmail.com>
Subject: Re: [PATCH 05/11] ARM: exynos: exynos_pm_add_dev_to_genpd may be unused
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2012 20:17, Arnd Bergmann <arnd@arndb.de> wrote:
> exynos_pm_add_dev_to_genpd is used if one or more out of a large
> number of Kconfig symbols are enabled. However the new
> exynos_defconfig selects none of those, so the function becomes
> unused. Marking it so lets the compiler automatically discard
> it.
>
> Without this patch, building exynos_defconfig results in:
>
> arch/arm/mach-exynos/pm_domains.c:118:123: warning: 'exynos_pm_add_dev_to_genpd' defined but not used [-Wunused-function]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  arch/arm/mach-exynos/pm_domains.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
> index 373c3c0..c0bc83a 100644
> --- a/arch/arm/mach-exynos/pm_domains.c
> +++ b/arch/arm/mach-exynos/pm_domains.c
> @@ -115,7 +115,7 @@ static __init int exynos_pm_dt_parse_domains(void)
>  }
>  #endif /* CONFIG_OF */
>
> -static __init void exynos_pm_add_dev_to_genpd(struct platform_device *pdev,
> +static __init __maybe_unused void exynos_pm_add_dev_to_genpd(struct platform_device *pdev,
>                                                 struct exynos_pm_domain *pd)
>  {
>         if (pdev->dev.bus) {
> --
> 1.7.10
>

Acked-by: Thomas Abraham <thomas.abraham@linaro.org>
