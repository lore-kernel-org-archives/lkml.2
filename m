Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2LMHad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:30:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53823 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2LMHac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:30:32 -0500
Message-ID: <50C98413.5050707@linaro.org>
Date: Thu, 13 Dec 2012 08:30:27 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Julius Werner <jwerner@chromium.org>,
        Francesco Lavra <francescolavra.fl@gmail.com>,
        linux-pm@vger.kernel.org, Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>, len.brown@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] cpuidle - remove the power_specified field in the driver
References: <1355325801-1317-1-git-send-email-daniel.lezcano@linaro.org> <CAODwPW81fXDNMTvG8juR6iAGFeDV9PXE-65Wp+dAE-mcKYU2nw@mail.gmail.com> <50C8E275.9050308@linaro.org> <2077776.UzqC1zVIVr@vostro.rjw.lan>
In-Reply-To: <2077776.UzqC1zVIVr@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 11:42 PM, Rafael J. Wysocki wrote:
> On Wednesday, December 12, 2012 09:00:53 PM Daniel Lezcano wrote:
>> On 12/12/2012 07:50 PM, Julius Werner wrote:
>>> Thanks again for making this happen, Daniel. I like this version,
>>> except for the small nitpick that I still think it would make sense to
>>> also turn the loop in menu.c around. How about something like this:
>>>
>>>        for (i = drv->state_count - 1; i >= CPUIDLE_DRIVER_STATE_START; i++) {
>>>                 struct cpuidle_state *s = &drv->states[i];
>>>                 if (!s->disable && s->exit_latency <= latency_req &&
>>>                     s->target_residency <= data->predicted_us &&
>>>                     s->exit_latency * multiplier <= data->predicted_us) {
>>>                         data->last_state_idx = i;
>>>                         data->exit_us = s->exit_latency;
>>>                         break;
>>>                 }
>>>         }
>>
>> Actually I was planning to do that in a separate patch.
> 
> Can you submit that second patch too, please, so that people don't have to
> wonder?

Sure.


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

