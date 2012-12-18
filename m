Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2LRWRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:17:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55307 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LRWRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:17:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,311,1355126400"; 
   d="scan'208";a="14982495"
Message-ID: <50D0EB67.2060802@codeaurora.org>
Date: Tue, 18 Dec 2012 14:17:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, nico@linaro.org,
        marc.zyngier@arm.com, will.deacon@arm.com, john.stultz@linaro.org,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/5] clockevents: Add generic timer broadcast receiver
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com> <1355832418-31692-3-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1355832418-31692-3-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/12 04:06, Mark Rutland wrote:
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index f113755..c2dd022 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -125,6 +125,21 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
>  	return ret;
>  }
>  
> +int tick_receive_broadcast(void)
> +{
> +	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
> +	struct clock_event_device *evt = td->evtdev;
> +
> +	if (!evt)
> +		return -ENODEV;
> +
> +	if (!evt->event_handler)
> +		return -EINVAL;
> +

Does this actually happen? It's not obvious to me how it does.

> +	evt->event_handler(evt);
> +	return 0;
> +}
> +
>  /*
>   * Broadcast the event to the cpus, which are set in the mask (mangled).
>   */


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

