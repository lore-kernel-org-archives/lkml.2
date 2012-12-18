Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2LRWRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:17:15 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34041 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab2LRWRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:17:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,311,1355126400"; 
   d="scan'208";a="15096557"
Message-ID: <50D0EB69.10901@codeaurora.org>
Date: Tue, 18 Dec 2012 14:17:13 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, nico@linaro.org,
        will.deacon@arm.com, marc.zyngier@arm.com, john.stultz@linaro.org
Subject: Re: [RFC PATCH 4/5] clockevents: Add generic timer broadcast function
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com> <1355832418-31692-5-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1355832418-31692-5-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nit

On 12/18/12 04:06, Mark Rutland wrote:
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index c2dd022..ec22a80 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -86,6 +87,12 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
>  	return (dev && tick_broadcast_device.evtdev == dev);
>  }
>  
> +static void err_broadcast(const struct cpumask *mask)
> +{
> +	pr_crit_once("Attempted to broadcast tick, but no broadcast mechanism "
> +		     "present. Some CPUs may be unresponsive.");

This is missing a newline. You may also want to put the string on a
single line so we can easily grep for it in the sources.

> @@ -105,6 +112,14 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
>  	 */
>  	if (!tick_device_is_functional(dev)) {
>  		dev->event_handler = tick_handle_periodic;
> +		if (!dev->broadcast)
> +			dev->broadcast = tick_broadcast;
> +		if (!dev->broadcast) {
> +			pr_warn_once("%s depends on broadcast, but no "
> +				     "broadcast function available\n",

Same one line comment here. I thought checkpatch didn't complain anymore.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

