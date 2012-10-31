Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab2JaRvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:51:15 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:41548 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758866Ab2JaRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:51:13 -0400
Date: Wed, 31 Oct 2012 17:51:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: johnstul@us.ibm.com, tglx@linutronix.de,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] clocksource: use this_cpu_ptr per-cpu helper
In-Reply-To: <50910A23.9060600@gmail.com>
Message-ID: <0000013ab7f2c88e-30f3ae51-814d-4dbc-be11-feb465d88761-000000@email.amazonses.com>
References: <50910A23.9060600@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> diff --git a/drivers/clocksource/arm_generic.c b/drivers/clocksource/arm_generic.c
> index c4d9f95..cb445ab 100644
> --- a/drivers/clocksource/arm_generic.c
> +++ b/drivers/clocksource/arm_generic.c
> @@ -224,7 +224,7 @@ int __init arm_generic_timer_init(void)
>  	lpj_fine = arch_timer_rate / HZ;
>
>  	/* Immediately configure the timer on the boot CPU */
> -	arch_timer_setup(per_cpu_ptr(&arch_timer_evt, smp_processor_id()));
> +	arch_timer_setup(this_cpu_ptr(&arch_timer_evt));
>
>  	register_cpu_notifier(&arch_timer_cpu_nb);

Reviewed-by: Christoph Lameter <cl@linux.com>

