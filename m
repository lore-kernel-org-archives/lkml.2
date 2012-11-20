Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2KTBkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:40:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37560 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2KTBk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <007401cdc6ba$0742d6d0$15c88470$%choi@samsung.com>
References: <007401cdc6ba$0742d6d0$15c88470$%choi@samsung.com>
Date: Tue, 20 Nov 2012 10:40:28 +0900
X-Google-Sender-Auth: b1dwz4JabI4NsSbhdqhpscbjuFs
Message-ID: <CAH9JG2VKYSAQ=Og4-fgToV_aNwEV_aH-=UQZDbAOnA-ShfKdYw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] therma: exynos: Supports thermal tripping
From: Kyungmin Park <kmpark@infradead.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>,
        "jonghwa3.lee" <jonghwa3.lee@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/12, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> TMU urgently sends active-high signal (thermal trip) to PMU,
> and thermal tripping by hardware logic i.e PMU is performed.
> Thermal tripping means that PMU cut off the whole power of SoC
> by controlling external voltage regulator.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Ackedy-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/exynos_thermal.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index 129e827..569478d 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -58,6 +58,7 @@
>  #define EXYNOS_TMU_CORE_ON             BIT(0)
>  #define EXYNOS_TMU_CORE_ON_SHIFT       0
>  #define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
> EXYNOS_TMU_CORE_ON_SHIFT)
> +#define EXYNOS_TMU_TRIP_EN             BIT(12)
>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
>
>  /* Exynos4210 specific registers */
> @@ -631,6 +632,12 @@ static int exynos_tmu_initialize(struct
> platform_device
> *pdev)
>                         goto out;
>                 }
>                 rising_threshold |= (threshold_code << 16);
> +               threshold_code = temp_to_code(data,
> pdata->trigger_levels[3]);
> +               if (threshold_code < 0) {
> +                       ret = threshold_code;
> +                       goto out;
> +               }
> +               rising_threshold |= (threshold_code << 24);
>
>                 writel(rising_threshold,
>                                 data->base + EXYNOS_THD_TEMP_RISE);
> @@ -665,6 +672,8 @@ static void exynos_tmu_control(struct platform_device
> *pdev, bool on)
>                 con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
>                 con |= pdata->noise_cancel_mode <<
> EXYNOS_TMU_TRIP_MODE_SHIFT;
>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
> +               if (pdata->trigger_levels[3])
> +                       con |= EXYNOS_TMU_TRIP_EN;
>         }
>
>         if (on) {
> @@ -770,6 +779,7 @@ static struct exynos_tmu_platform_data const
> exynos_default_tmu_data = {
>         .trigger_levels[0] = 85,
>         .trigger_levels[1] = 103,
>         .trigger_levels[2] = 110,
> +       .trigger_levels[3] = 120,
>         .trigger_level0_en = 1,
>         .trigger_level1_en = 1,
>         .trigger_level2_en = 1,
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
