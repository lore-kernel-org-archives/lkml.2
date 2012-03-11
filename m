Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2CKELI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 23:11:08 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64467 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2CKELF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 23:11:05 -0500
MIME-Version: 1.0
In-Reply-To: <1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
	<1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
Date: Sun, 11 Mar 2012 09:41:03 +0530
Message-ID: <CAMHCuPUOnftKYaGjEpA9rZFc1yjH3U-EkEEUWqcFapSKROTopQ@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/4] thermal: Add generic cpufreq cooling implementation
From: Sundar <sunder.svit@gmail.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: len.brown@intel.com, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        rob.lee@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

I am new here; so please bear with my questions/doubts :)

On Wed, Feb 22, 2012 at 3:44 PM, Amit Daniel Kachhap
<amit.kachhap@linaro.org> wrote:
> This patch adds support for generic cpu thermal cooling low level
> implementations using frequency scaling up/down based on the request
> from user. Different cpu related cooling devices can be registered by the
> user and the binding of these cooling devices to the corresponding

"Different cpu related cooling devices": Do you mean cooling devices
for different CPUs (num_cpus) or are you referring to different
customers aka consumer drivers who could use this framework and impose
the cooling.

> trip points can be easily done as the registration API's return the
> cooling device pointer. The user of these api's are responsible for
> passing clipping frequency in percentages.

Why do you want to pass the clipping frequency in percentages? Wouldnt
it be simpler for any platform sensor driver to just pass the
frequency it wants to throttle the CPU?

> +
> +    This interface function registers the cpufreq cooling device with the name
> +    "thermal-cpufreq-%x". This api can support multiple instance of cpufreq cooling
> +    devices.

When you refer to cooling devices, is it the number of instances
per-CPU that is supported? Sorry I am unable to follow.

> +       .polling_interval: polling interval for this cooling state.
> +    tab_size: the total number of cooling state.

By cooling_state, I assume you are referring to the thermal state for
the platform? or only for the CPU?

> +    mask_val: all the allowed cpu's where frequency clipping can happen.

Why should this be a new variable? The policy->affected_cpus should be
the same as this IMO?

> +       help
> +         This implements the generic cpu cooling mechanism through frequency
> +         reduction, cpu hotplug and any other ways of reducing temperature. An

Apart from reducing the CPU frequency, (probably) CPU hotplug, what
other means of reducing CPU temperature? Or are you referring to any
platform temperature controls?

It isnt very clear from the documentation (at least to me) if this is
only for CPU cooling or generic platform cooling.

Cheers!
-- 
---------
The views expressed in this email are personal and do not necessarily
echo my employers'.
