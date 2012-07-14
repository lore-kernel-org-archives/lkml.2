Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2GNBdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 21:33:14 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64960 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2GNBdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 21:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <1342177825-19006-6-git-send-email-amit.kachhap@linaro.org>
References: <1342177825-19006-1-git-send-email-amit.kachhap@linaro.org>
	<1342177825-19006-6-git-send-email-amit.kachhap@linaro.org>
Date: Sat, 14 Jul 2012 10:33:10 +0900
X-Google-Sender-Auth: skzc2p77t4dcnUOvqqC-0w8K6fI
Message-ID: <CAH9JG2XGWgX-FiBacnrGXS-oG_7rbN1aum3mpW5HUAukiwaB7A@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] ARM: exynos: add thermal sensor driver platform
 data support
From: Kyungmin Park <kmpark@infradead.org>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org,
        lenb@kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        lm-sensors@lm-sensors.org, Donggeun Kim <dg77.kim@samsung.com>,
        SangWook Ju <sw.ju@samsung.com>, Durgadoss <durgadoss.r@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 8:10 PM, Amit Daniel Kachhap
<amit.kachhap@linaro.org> wrote:
> Add necessary default platform data support needed for TMU driver.  This
> dt/non-dt values are tested for origen exynos4210 and smdk exynos5250
> platforms.
Looks good to me.
just nitpicks below.

Thank you,
Kyungmin Park
>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> Cc: Donggeun Kim <dg77.kim@samsung.com>
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: SangWook Ju <sw.ju@samsung.com>
> Cc: Durgadoss <durgadoss.r@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/thermal/exynos_thermal.c |  111 +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 110 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index 9ef8c37..07736ea 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -662,14 +662,121 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
>  static struct thermal_sensor_conf exynos_sensor_conf = {
>         .name                   = "exynos-therm",
>         .read_temperature       = (int (*)(void *))exynos_tmu_read,
> +};
> +
> +#if defined(CONFIG_CPU_EXYNOS4210)
BTW, doesn't it same as exynos4412? does it different from exynos4412?
If it's same, it's better to use CONFIG_SOC_EXYNOS4?
> +static struct exynos_tmu_platform_data const exynos4_default_tmu_data = {
> +       .threshold = 80,
> +       .trigger_levels[0] = 5,
> +       .trigger_levels[1] = 20,
> +       .trigger_levels[2] = 30,
> +       .trigger_level0_en = 1,
> +       .trigger_level1_en = 1,
> +       .trigger_level2_en = 1,
> +       .trigger_level3_en = 0,
> +       .gain = 15,
> +       .reference_voltage = 7,
> +       .cal_type = TYPE_ONE_POINT_TRIMMING,
> +       .freq_tab[0] = {
> +               .freq_clip_max = 800 * 1000,
> +               .temp_level = 85,
> +       },
> +       .freq_tab[1] = {
> +               .freq_clip_max = 200 * 1000,
> +               .temp_level = 100,
> +       },
> +       .freq_tab_count = 2,
> +       .type = SOC_ARCH_EXYNOS4,
> +};
> +#define EXYNOS4_TMU_DRV_DATA (&exynos4_default_tmu_data)
> +#else
> +#define EXYNOS4_TMU_DRV_DATA (NULL)
> +#endif
> +
> +#if defined(CONFIG_SOC_EXYNOS5250)
similar.
> +static struct exynos_tmu_platform_data const exynos5_default_tmu_data = {
> +       .trigger_levels[0] = 85,
> +       .trigger_levels[1] = 103,
> +       .trigger_levels[2] = 110,
> +       .trigger_level0_en = 1,
> +       .trigger_level1_en = 1,
> +       .trigger_level2_en = 1,
> +       .trigger_level3_en = 0,
> +       .gain = 8,
> +       .reference_voltage = 16,
> +       .noise_cancel_mode = 4,
> +       .cal_type = TYPE_ONE_POINT_TRIMMING,
> +       .efuse_value = 55,
> +       .freq_tab[0] = {
> +               .freq_clip_max = 800 * 1000,
> +               .temp_level = 85,
> +       },
> +       .freq_tab[1] = {
> +               .freq_clip_max = 200 * 1000,
> +               .temp_level = 103,
> +       },
> +       .freq_tab_count = 2,
> +       .type = SOC_ARCH_EXYNOS5,
> +};
> +#define EXYNOS5_TMU_DRV_DATA (&exynos5_default_tmu_data)
> +#else
> +#define EXYNOS5_TMU_DRV_DATA (NULL)
> +#endif
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_tmu_match[] = {
> +       {
> +               .compatible = "samsung,exynos4-tmu",
> +               .data = (void *)EXYNOS4_TMU_DRV_DATA,
> +       },
> +       {
> +               .compatible = "samsung,exynos5-tmu",
> +               .data = (void *)EXYNOS5_TMU_DRV_DATA,
> +       },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_tmu_match);
> +#else
> +#define  exynos_tmu_match NULL
> +#endif
> +
> +static struct platform_device_id exynos_tmu_driver_ids[] = {
> +       {
> +               .name           = "exynos4-tmu",
> +               .driver_data    = (kernel_ulong_t)EXYNOS4_TMU_DRV_DATA,
> +       },
> +       {
> +               .name           = "exynos5-tmu",
> +               .driver_data    = (kernel_ulong_t)EXYNOS5_TMU_DRV_DATA,
> +       },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
> +
> +static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
> +                       struct platform_device *pdev)
> +{
> +#ifdef CONFIG_OF
> +       if (pdev->dev.of_node) {
> +               const struct of_device_id *match;
> +               match = of_match_node(exynos_tmu_match, pdev->dev.of_node);
> +               if (!match)
> +                       return NULL;
> +               return (struct exynos_tmu_platform_data *) match->data;
> +       }
> +#endif
> +       return (struct exynos_tmu_platform_data *)
> +                       platform_get_device_id(pdev)->driver_data;
>  }
> -;
>  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>  {
>         struct exynos_tmu_data *data;
>         struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
>         int ret, i;
>
> +       if (!pdata)
> +               pdata = exynos_get_driver_data(pdev);
> +
>         if (!pdata) {
>                 dev_err(&pdev->dev, "No platform init data supplied.\n");
>                 return -ENODEV;
> @@ -838,9 +945,11 @@ static struct platform_driver exynos_tmu_driver = {
>                 .name   = "exynos-tmu",
>                 .owner  = THIS_MODULE,
>                 .pm     = EXYNOS_TMU_PM,
> +               .of_match_table = exynos_tmu_match,
>         },
>         .probe = exynos_tmu_probe,
>         .remove = __devexit_p(exynos_tmu_remove),
> +       .id_table = exynos_tmu_driver_ids,
>  };
>
>  module_platform_driver(exynos_tmu_driver);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
