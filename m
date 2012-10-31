Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2JaKDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:03:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37082 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2JaKDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:03:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fa66d0000004cf-86-5090f7781445
Message-id: <5090F774.8030302@samsung.com>
Date: Wed, 31 Oct 2012 19:03:32 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v2 2/2] therma: exynos: Supports thermal tripping
References: <00f401cdb733$97e429a0$c7ac7ce0$%choi@samsung.com>
In-reply-to: <00f401cdb733$97e429a0$c7ac7ce0$%choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jAd3K7xMCDNb9Z7K4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZCxdMZin4yl9xf9o8xgbGWTxdjBwcEgImEn8/eXYxcgKZYhIX
	7q1n62Lk4hASWMQoseTyA0aQBK+AoMSPyfdYQOqZBeQljlzKBgkzC6hLTJq3iBnEFhLoYpI4
	uV0folxL4v/hN2BxFgFViYc7e8DGsAnISbxt+sYIMkZUIELiVz8HSFhEQFui7+ksVpC1zAIb
	GCXW3PvEBpIQFnCVmLh6MSPEfDuJKf0rWEBsTgF7iUsnzzNOYBSYheS6WQjXzUJy3QJG5lWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYwaH3TGoH48oGi0OMAhyMSjy8hv/6A4RYE8uKK3MP
	MUpwMCuJ8M7+NiFAiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6YklqdmpqQWoRTJaJ
	g1OqgXFfgu3v+SZCv00v10uUpuwSZ3/If7b9p9qGr6HpMd3zX16Rc5T3T1W/lvxM0rX9ZJzW
	aUknhvBM3aNlVv7lTXONWdccfmgvsjI3dnaa3NlJ+hrRByau/vvyV/y889bcLhLVNW3iC9sD
	Y/0cjn4Q6JkeWOD3WeXLjeTcOU2Myyfu7JvU/df6sxJLcUaioRZzUXEiABuKT9A5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 10월 31일 15:47, Jonghwan Choi wrote:
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
How do you think move this codes outside of parenthesis ? Then you can set trip enable bit depends
on soc type.

if (soc == exynos4210)
interrupt_en |= trigger_level3_en // this also has to be removed from if(on) part.
else /* for other SOCs */
con |= trigger_level3_en

>         }
>
>         if (on) {
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

