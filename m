Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2JQOYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:24:03 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64753 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2JQOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <1350387889-15324-4-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-4-git-send-email-hongbo.zhang@linaro.com>
Date: Wed, 17 Oct 2012 19:54:00 +0530
Message-ID: <CAKohponhk=Hz1XTVOoNZWnaSQjguzY6djVPaQou9SX3f0bieyw@mail.gmail.com>
Subject: Re: [PATCH 3/5] Thermal: fix empty list checking method.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2012 17:14, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>
> Is is not reliable to check the list entry pointer after
> list_for_each_entry loop, list_empty should be used instead.
>
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> ---
>  drivers/thermal/cpu_cooling.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index b6b4c2a..d196230 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -247,12 +247,13 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
>         struct cpufreq_frequency_table *table;
>
>         mutex_lock(&cooling_cpufreq_lock);
> +       if (list_empty(&cooling_cpufreq_list))
> +               goto return_get_max_state;
> +
>         list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
>                 if (cpufreq_device && cpufreq_device->cool_dev == cdev)
>                         break;
>         }
> -       if (cpufreq_device == NULL)
> -               goto return_get_max_state;

I am surprised, why is it written like this in the first place :)

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
