Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab2CMFHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:07:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63847 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509Ab2CMFHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAMHCuPUOnftKYaGjEpA9rZFc1yjH3U-EkEEUWqcFapSKROTopQ@mail.gmail.com>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
	<1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
	<CAMHCuPUOnftKYaGjEpA9rZFc1yjH3U-EkEEUWqcFapSKROTopQ@mail.gmail.com>
Date: Tue, 13 Mar 2012 10:37:42 +0530
Message-ID: <CAK44p23nZ0kgdieasMkChV8B51Rjt=KrmypN+ksV+nym_e0Cqw@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/4] thermal: Add generic cpufreq cooling implementation
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Sundar <sunder.svit@gmail.com>
Cc: len.brown@intel.com, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        rob.lee@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 March 2012 09:41, Sundar <sunder.svit@gmail.com> wrote:
> Hi Amit,
>
> I am new here; so please bear with my questions/doubts :)
>
> On Wed, Feb 22, 2012 at 3:44 PM, Amit Daniel Kachhap
> <amit.kachhap@linaro.org> wrote:
>> This patch adds support for generic cpu thermal cooling low level
>> implementations using frequency scaling up/down based on the request
>> from user. Different cpu related cooling devices can be registered by the
>> user and the binding of these cooling devices to the corresponding
>
> "Different cpu related cooling devices": Do you mean cooling devices
> for different CPUs (num_cpus) or are you referring to different
> customers aka consumer drivers who could use this framework and impose
> the cooling.
Correct but the consumer driver only has to use the other
thermal-sys.c functions. Only register cpu cooling devices is
implemented in this work.
>
>> trip points can be easily done as the registration API's return the
>> cooling device pointer. The user of these api's are responsible for
>> passing clipping frequency in percentages.
>
> Why do you want to pass the clipping frequency in percentages? Wouldnt
> it be simpler for any platform sensor driver to just pass the
> frequency it wants to throttle the CPU?
Yes i also agree.
>
>> +
>> +    This interface function registers the cpufreq cooling device with the name
>> +    "thermal-cpufreq-%x". This api can support multiple instance of cpufreq cooling
>> +    devices.
>
> When you refer to cooling devices, is it the number of instances
> per-CPU that is supported? Sorry I am unable to follow.
CPU cooling apis can be used as below
1)per cpus if different frequency clipping is needed. so multiple
instance of this api can be called.
2)for all the cpus as provided with mask when same frequency clipping
is needed. In this case single instance is fine.
>
>> +       .polling_interval: polling interval for this cooling state.
>> +    tab_size: the total number of cooling state.
>
> By cooling_state, I assume you are referring to the thermal state for
> the platform? or only for the CPU?
Yes thermal state of the platform.
>
>> +    mask_val: all the allowed cpu's where frequency clipping can happen.
>
> Why should this be a new variable? The policy->affected_cpus should be
> the same as this IMO?
yes this should be same. I will check this.
>
>> +       help
>> +         This implements the generic cpu cooling mechanism through frequency
>> +         reduction, cpu hotplug and any other ways of reducing temperature. An
>
> Apart from reducing the CPU frequency, (probably) CPU hotplug, what
> other means of reducing CPU temperature? Or are you referring to any
> platform temperature controls?
No only CPU related. Other control ways I thought was cpuidle with low
power states and cpu_power factor modifications used in the schedular.
>
> It isnt very clear from the documentation (at least to me) if this is
> only for CPU cooling or generic platform cooling.
>
> Cheers!
> --
> ---------
> The views expressed in this email are personal and do not necessarily
> echo my employers'.
