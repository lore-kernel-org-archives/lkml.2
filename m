Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2I0FYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:24:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51135 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2I0FYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <1348620211-1409-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1348620211-1409-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Thu, 27 Sep 2012 10:54:40 +0530
Message-ID: <CAK44p219E_AHQZ_4MRB=+hMpcT78cAdzvVdLg7Y3jEfW3Gyhfw@mail.gmail.com>
Subject: Re: [PATCH] Thermal: Fix bug on cpu_cooling, cooling device's id
 conflict problem.
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2012 06:13, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> This patch fixes small bug on cpu_cooling. CPU cooling device has own
> id generated with idr mathod. However in the previous version, it swapped
> to all same id at last stage of probing as 0. This makes id's collision and
> also occures error when it releases that id.
>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/thermal/cpu_cooling.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 99a5d75..9050c1b 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -351,7 +351,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>         struct cpufreq_cooling_device *cpufreq_dev = NULL;
>         unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
>         char dev_name[THERMAL_NAME_LENGTH];
> -       int ret = 0, id = 0, i;
> +       int ret = 0, i;
>         struct cpufreq_policy policy;
>
>         list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
> @@ -396,7 +396,6 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>                 kfree(cpufreq_dev);
>                 return ERR_PTR(-EINVAL);
>         }
> -       cpufreq_dev->id = id;

This change looks fine. May be some last minute typo caused this bug.

Thanks,
Amit Daniel
>         cpufreq_dev->cool_dev = cool_dev;
>         cpufreq_dev->cpufreq_state = 0;
>         mutex_lock(&cooling_cpufreq_lock);
> --
> 1.7.4.1
>
