Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab2EWSzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:55:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42660 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2EWSzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:55:31 -0400
From: "Porter, Matt" <mporter@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>,
        "Dill, Russ" <russ.dill@ti.com>
Subject: Re: [PATCH] [ARM] Unconditional call to smp_cross_call on UP crashes
Thread-Topic: [PATCH] [ARM] Unconditional call to smp_cross_call on UP
 crashes
Thread-Index: AQHNOQfoJJoHOXtfR0mG8MkuMJr42JbYDPcA
Date: Wed, 23 May 2012 18:55:23 +0000
Message-ID: <8792C188-08C9-4575-97F6-CAC09A25A9AB@ti.com>
References: <1337879399-9998-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1337879399-9998-1-git-send-email-panto@antoniou-consulting.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B393C17632187C44ACCC9BF8B19CACD3@owa.mail.ti.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 24, 2012, at 1:09 PM, Pantelis Antoniou wrote:

> omap2plus_defconfig builds with SMP & SMP_ON_UP set.
> On beagle (which is UP) is_smp() returns false and we don't call
> smp_init_cpus which in turn does not initialize smp_cross_call which
> remains NULL.
> 
> When issuing a reboot we OOPS with a NULL dereference on stop smp_call.
> 
> Fixed by checking is_smp in smp_send_stop()

Please also add Cc: stable@vger.kernel.org in the sign offs
so it's picked up in stable.

Tested-by: Matt Porter <mporter@ti.com>

> ---
> arch/arm/kernel/smp.c |    4 ++++
> 1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 8f46446..2a61335 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -588,6 +588,10 @@ void smp_send_stop(void)
> 	unsigned long timeout;
> 	struct cpumask mask;
> 
> +	/* make sure we don't bother if not SMP */
> +	if (!is_smp())
> +		return;
> +
> 	cpumask_copy(&mask, cpu_online_mask);
> 	cpumask_clear_cpu(smp_processor_id(), &mask);
> 	smp_cross_call(&mask, IPI_CPU_STOP);
> -- 
> 1.7.1
> 

