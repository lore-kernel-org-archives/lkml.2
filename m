Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2KWNxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:53:31 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44309 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2KWNx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <1353676358-4385-1-git-send-email-fabio.baltieri@linaro.org>
References: <1353676358-4385-1-git-send-email-fabio.baltieri@linaro.org>
Date: Fri, 23 Nov 2012 19:23:28 +0530
Message-ID: <CAKohpommGWb0WRnUDd_Do4yuadA5RcR4_ULFEqt+t9DNFnCg-Q@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: fix wrong delay sampling rate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 18:42, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Restore the correct delay value for ondemand's od_dbs_timer, as it was
> changed erroneously in 83f0e55.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index bdaab92..cca3e9f 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -234,7 +234,8 @@ static void od_dbs_timer(struct work_struct *work)
>                         dbs_info->sample_type = OD_SUB_SAMPLE;
>                         delay = dbs_info->freq_hi_jiffies;
>                 } else {
> -                       delay = delay_for_sampling_rate(dbs_info->rate_mult);
> +                       delay = delay_for_sampling_rate(od_tuners.sampling_rate
> +                                               * dbs_info->rate_mult);

So sorry for my poor code :(

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
