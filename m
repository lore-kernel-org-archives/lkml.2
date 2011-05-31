Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1EaKin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:38:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:58087 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1EaKim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:38:42 -0400
Date: Tue, 31 May 2011 12:38:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mattias Wallin <mattias.wallin@stericsson.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
In-Reply-To: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>
Message-ID: <alpine.LFD.2.02.1105311236250.3078@ionos>
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Mattias Wallin wrote:
> +static cycle_t clksrc_db8500_prcmu_read(struct clocksource *cs)
> +{
> +	u32 count, count2;
> +
> +	do {
> +		count = readl(PRCMU_TIMER_4_DOWNCOUNT);
> +		count2 = readl(PRCMU_TIMER_4_DOWNCOUNT);
> +	} while (count2 != count);

What's the point of this exercise ?

> +	clocksource_calc_mult_shift(&clocksource_db8500_prcmu,
> +		RATE_32K, SCHED_CLOCK_MIN_WRAP);
> +	clocksource_register(&clocksource_db8500_prcmu);

Please use clocksource_register_hz()

> diff --git a/include/linux/clksrc-db8500-prcmu.h b/include/linux/clksrc-db8500-prcmu.h
> new file mode 100644
> index 0000000..42b8587
> --- /dev/null
> +++ b/include/linux/clksrc-db8500-prcmu.h

Huch, why needs this to be a separate head in include/linux ?

> @@ -0,0 +1,17 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2011
> + *
> + * License Terms: GNU General Public License v2
> + * Author: Mattias Wallin <mattias.wallin@stericsson.com>
> + *
> + */
> +#ifndef __CLKSRC_DB8500_PRCMU_H
> +#define __CLKSRC_DB8500_PRCMU_H
> +
> +#ifdef CONFIG_CLKSRC_DB8500_PRCMU
> +void __init clksrc_db8500_prcmu_init(void);
> +#else
> +void __init clksrc_db8500_prcmu_init(void) {}
> +#endif
> +
> +#endif
> -- 
> 1.7.4.3
> 
> 
