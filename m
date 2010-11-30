Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0K3SQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:16:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50644 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab0K3SQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:16:07 -0500
Date: Tue, 30 Nov 2010 18:14:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jamie Iles <jamie.iles@picochip.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] ARM: cns3xxx: Add support for SMP
Message-ID: <20101130181442.GA9137@n2100.arm.linux.org.uk>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru> <20101130171700.GB24034@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130171700.GB24034@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 08:17:00PM +0300, Anton Vorontsov wrote:
> Nothing fancy needs to be done, just use generic SCU routines.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>

This I assume is an age old patch.

> diff --git a/arch/arm/mach-cns3xxx/include/mach/smp.h b/arch/arm/mach-cns3xxx/include/mach/smp.h
> new file mode 100644
> index 0000000..44aa7ea
> --- /dev/null
> +++ b/arch/arm/mach-cns3xxx/include/mach/smp.h
> @@ -0,0 +1,28 @@
> +/*
> + * Copyright 2002 ARM Ltd.
> + * Copyright 2008 Cavium Networks
> + *
> + * This file is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, Version 2, as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MACH_SMP_H
> +#define __MACH_SMP_H
> +
> +#include <asm/hardware/gic.h>
> +
> +#define hard_smp_processor_id()				\
> +	({						\
> +		unsigned int cpunum;			\
> +		__asm__("mrc p15, 0, %0, c0, c0, 5"	\
> +			: "=r" (cpunum));		\
> +		cpunum &= 0x0F;				\
> +	})

#include <asm/smp_mpidr.h>

replaces this, but it's not actually necessary - it's only used by some
bug checking code in the CPU hotplug code.  I'm shortly going to be
deleting all hard_smp_processor_id() implementations.
