Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab2DZUje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:39:34 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:34772 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758675Ab2DZUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:39:32 -0400
From: Kevin Hilman <khilman@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/3] twl4030: enable wakeup on twl4030 IRQ.
Organization: Texas Instruments, Inc.
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.66013.stgit@notabene.brown>
Date: Thu, 26 Apr 2012 13:39:32 -0700
In-Reply-To: <20120425030524.7832.66013.stgit@notabene.brown> (NeilBrown's
	message of "Wed, 25 Apr 2012 13:05:24 +1000")
Message-ID: <874ns69qij.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> Most of the interrupts that come through this line should trigger
> wakeups:
>   power button
>   RTC alarm
>   power available
>   usb plug/unplug
>
> so mark the interrupt as a wakeup interrupt.
> This is particularly important for when the interrupt arrives during
> the late suspend phase.  Without this setting it will be ignored.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Kevin Hilman <khilman@ti.com>


> ---
>
>  drivers/mfd/twl4030-irq.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> index 5d656e8..ad733d7 100644
> --- a/drivers/mfd/twl4030-irq.c
> +++ b/drivers/mfd/twl4030-irq.c
> @@ -757,6 +757,7 @@ int twl4030_init_irq(struct device *dev, int irq_num)
>  		dev_err(dev, "could not claim irq%d: %d\n", irq_num, status);
>  		goto fail_rqirq;
>  	}
> +	enable_irq_wake(irq_num);
>  
>  	return irq_base;
>  fail_rqirq:
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
