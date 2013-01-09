Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab3AIEgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 23:36:23 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62882 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab3AIEgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 23:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <1357642258-32421-1-git-send-email-inderpal.singh@linaro.org>
References: <1357642258-32421-1-git-send-email-inderpal.singh@linaro.org>
Date: Tue, 8 Jan 2013 20:36:20 -0800
Message-ID: <CADGdYn6=fztS_Z9UeQiRyfE3FTAq+XfuPSrY=fT7LOgU498QXQ@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] cpufreq: exynos: Show list of available frequencies
From: amit kachhap <amit.kachhap@gmail.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, kgene.kim@samsung.com,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 2:50 AM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:
> Add freq_attr attribute to show list of available frequencies.
>
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
>  drivers/cpufreq/exynos-cpufreq.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index 7012ea8..bc1e833 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -244,13 +244,26 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
>         return cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table);
>  }
>
> +static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
> +{
> +       cpufreq_frequency_table_put_attr(policy->cpu);
> +       return 0;
> +}
> +
> +static struct freq_attr *exynos_cpufreq_attr[] = {
> +       &cpufreq_freq_attr_scaling_available_freqs,
> +       NULL,
> +};
> +

This change looks fine. I guess this was posted before also but could
not go mainline.
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>

Thanks,
Amit Daniel
>  static struct cpufreq_driver exynos_driver = {
>         .flags          = CPUFREQ_STICKY,
>         .verify         = exynos_verify_speed,
>         .target         = exynos_target,
>         .get            = exynos_getspeed,
>         .init           = exynos_cpufreq_cpu_init,
> +       .exit           = exynos_cpufreq_cpu_exit,
>         .name           = "exynos_cpufreq",
> +       .attr           = exynos_cpufreq_attr,
>  #ifdef CONFIG_PM
>         .suspend        = exynos_cpufreq_suspend,
>         .resume         = exynos_cpufreq_resume,
> --
> 1.7.9.5
>
