Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1CCVN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:13:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46793 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab1CCVN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=G2VYt1BEBeb/PJPOne9yEDfs/Ww6Rig61lDW6YRnPHJkZG1R3lv/D+9tqTGhHxhXk6
         vMoX72c6lyQnDp92BKgxgoTxOe7KjbRZgCNcV8EsDxGGo2GBznuSp/rs54iP7Tzl5bf5
         xATAP5LBG6G/e4HniraYAhSl2o/M7GdsPExIE=
Message-ID: <4D70048D.7070403@gmail.com>
Date: Fri, 04 Mar 2011 00:13:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] x86: remove unneeded prototypes
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-6-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1299182701-8591-6-git-send-email-henne@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 11:05 PM, Henrik Kretzschmar wrote:
> lapic_clockevent is moved, that we can get rid of some
> unneeded prototypes.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
>  arch/x86/kernel/apic/apic.c |   38 +++++++++++++++++---------------------
>  1 files changed, 17 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index a0e9c1f..64efb2d 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -187,29 +187,8 @@ static struct resource lapic_resource = {
>  
>  static unsigned int calibration_result;
>  
> -static int lapic_next_event(unsigned long delta,
> -			    struct clock_event_device *evt);
> -static void lapic_timer_setup(enum clock_event_mode mode,
> -			      struct clock_event_device *evt);
> -static void lapic_timer_broadcast(const struct cpumask *mask);
>  static void apic_pm_activate(void);
>  
> -/*
> - * The local apic timer can be used for any function which is CPU local.
> - */
> -static struct clock_event_device lapic_clockevent = {
> -	.name		= "lapic",
> -	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
> -			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
> -	.shift		= 32,
> -	.set_mode	= lapic_timer_setup,
> -	.set_next_event	= lapic_next_event,
> -	.broadcast	= lapic_timer_broadcast,
> -	.rating		= 100,
> -	.irq		= -1,
> -};
> -static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
> -
>  static unsigned long apic_phys;
>  
>  /*
> @@ -501,6 +480,23 @@ static void lapic_timer_broadcast(const struct cpumask *mask)
>  #endif
>  }
>  
> +
> +/*
> + * The local apic timer can be used for any function which is CPU local.
> + */
> +static struct clock_event_device lapic_clockevent = {
> +	.name		= "lapic",
> +	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
> +			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
> +	.shift		= 32,
> +	.set_mode	= lapic_timer_setup,
> +	.set_next_event	= lapic_next_event,
> +	.broadcast	= lapic_timer_broadcast,
> +	.rating		= 100,
> +	.irq		= -1,
> +};
> +static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
> +
>  /*
>   * Setup the local APIC timer for this CPU. Copy the initialized values
>   * of the boot CPU and register the clock event in the framework.

Looks good to me  -- now this snippets are near the place we refer them.

-- 
    Cyrill
