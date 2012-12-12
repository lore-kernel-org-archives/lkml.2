Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2LLUBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:01:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44252 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2LLUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:01:03 -0500
Message-ID: <50C8E275.9050308@linaro.org>
Date: Wed, 12 Dec 2012 21:00:53 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Francesco Lavra <francescolavra.fl@gmail.com>,
        linux-pm@vger.kernel.org, Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>, len.brown@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] cpuidle - remove the power_specified field in the driver
References: <1355325801-1317-1-git-send-email-daniel.lezcano@linaro.org> <CAODwPW81fXDNMTvG8juR6iAGFeDV9PXE-65Wp+dAE-mcKYU2nw@mail.gmail.com>
In-Reply-To: <CAODwPW81fXDNMTvG8juR6iAGFeDV9PXE-65Wp+dAE-mcKYU2nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 07:50 PM, Julius Werner wrote:
> Thanks again for making this happen, Daniel. I like this version,
> except for the small nitpick that I still think it would make sense to
> also turn the loop in menu.c around. How about something like this:
> 
>        for (i = drv->state_count - 1; i >= CPUIDLE_DRIVER_STATE_START; i++) {
>                 struct cpuidle_state *s = &drv->states[i];
>                 if (!s->disable && s->exit_latency <= latency_req &&
>                     s->target_residency <= data->predicted_us &&
>                     s->exit_latency * multiplier <= data->predicted_us) {
>                         data->last_state_idx = i;
>                         data->exit_us = s->exit_latency;
>                         break;
>                 }
>         }

Actually I was planning to do that in a separate patch.


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

