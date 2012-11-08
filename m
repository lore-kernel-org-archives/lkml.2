Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2KHKdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:33:16 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42538 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2KHKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:33:13 -0500
MIME-Version: 1.0
In-Reply-To: <00f401cdb733$97e429a0$c7ac7ce0$%choi@samsung.com>
References: <00f401cdb733$97e429a0$c7ac7ce0$%choi@samsung.com>
Date: Thu, 8 Nov 2012 16:03:12 +0530
Message-ID: <CAK44p20gtJ=ywOvZVu8eZKFBVCNgJSndhffhOJOuRuuGNHXiTA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] therma: exynos: Supports thermal tripping
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2012 12:17, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> TMU urgently sends active-high signal (thermal trip) to PMU,
> and thermal tripping by hardware logic i.e PMU is performed.
> Thermal tripping means that PMU cut off the whole power of SoC
> by controlling external voltage regulator.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/thermal/exynos_thermal.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index 6ce6667..5672e95 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -53,6 +53,7 @@
>  #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
>  #define EXYNOS_TMU_GAIN_SHIFT          8
>  #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
> +#define EXYNOS_TMU_TRIP_EN             BIT(12)
>  #define EXYNOS_TMU_CORE_ON             1
>  #define EXYNOS_TMU_CORE_OFF            0
>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
> @@ -656,6 +657,9 @@ static void exynos_tmu_control(struct platform_device
> *pdev, bool on)
>         if (data->soc == SOC_ARCH_EXYNOS) {
>                 con |= pdata->noise_cancel_mode <<
> EXYNOS_TMU_TRIP_MODE_SHIFT;
>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
> +
> +               if (pdata->trigger_level3_en)
> +                       con |= EXYNOS_TMU_TRIP_EN;
Hi Jonghwan Choi,

IMO, Also you need to write 4th trigger level, Currently only 3
trigger levels are stored in register THD_TEMP_RISE.

Thanks,
Amit Daniel
>         }
>
>         if (on) {
> --
> 1.7.4.1
>
