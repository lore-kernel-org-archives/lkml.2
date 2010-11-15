Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab0KOPuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:50:12 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59724 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab0KOPuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:50:09 -0500
MIME-Version: 1.0
X-Originating-IP: [81.245.189.130]
In-Reply-To: <1289498595-25806-2-git-send-email-trenn@suse.de>
References: <1289498595-25806-1-git-send-email-trenn@suse.de>
	<1289498595-25806-2-git-send-email-trenn@suse.de>
Date: Mon, 15 Nov 2010 16:50:08 +0100
Message-ID: <AANLkTikT-a=b76dw2eP0bOOJCxk0rrCfhnerqkvVmCzt@mail.gmail.com>
Subject: Re: [PATCH 1/3] PERF: Do not export power_frequency, but power_start event
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jean Pihet <j-pihet@ti.com>

On Thu, Nov 11, 2010 at 7:03 PM, Thomas Renninger <trenn@suse.de> wrote:
> power_frequency moved to drivers/cpufreq/cpufreq.c which has
> to be compiled in, no need to export it.
>
> intel_idle can a be module though...
>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: Jean Pihet <jean.pihet@newoldbits.com>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: linux-kernel@vger.kernel.org
> ---
>  drivers/idle/intel_idle.c   |    2 --
>  kernel/trace/power-traces.c |    2 +-
>  2 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 41665d2..3c95325 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -220,9 +220,7 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state)
>        kt_before = ktime_get_real();
>
>        stop_critical_timings();
> -#ifndef MODULE
>        trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
> -#endif
>        if (!need_resched()) {
>
>                __monitor((void *)&current_thread_info()->flags, 0, 0);
> diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
> index a22582a..0e0497d 100644
> --- a/kernel/trace/power-traces.c
> +++ b/kernel/trace/power-traces.c
> @@ -13,5 +13,5 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/power.h>
>
> -EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
>
> --
> 1.6.3
>
>
