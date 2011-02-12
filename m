Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1BLMNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 07:13:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50776 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1BLMNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 07:13:36 -0500
Date: Sat, 12 Feb 2011 12:13:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, glikely@secretlab.ca
Subject: Re: [PATCH V2 1/4] ARM: Xilinx: Adding Xilinx board support
Message-ID: <20110212121320.GH15616@n2100.arm.linux.org.uk>
References: <1297270845-18802-1-git-send-email-john.linn@xilinx.com> <0e8b21c6-60ff-4f82-a8e6-5c2a0fe80372@VA3EHSMHS005.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e8b21c6-60ff-4f82-a8e6-5c2a0fe80372@VA3EHSMHS005.ehs.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:00:42AM -0700, John Linn wrote:
> +/* arch/arm/mach-xilinx/board_ep107.c
> + *
> + * This file contains code specific to the Xilinx EP107 board.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on /arch/arm/mach-realview/core.c
> + *
> + *  Copyright (C) 1999 - 2003 ARM Limited
> + *  Copyright (C) 2000 Deep Blue Solutions Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

You probably don't want to include this paragraph - their address keeps
changing, so will require files to be constantly updated.

> + */
> +
> +#include <linux/platform_device.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <mach/xilinx_soc.h>
> +#include <mach/irqs.h>
> +#include <linux/clkdev.h>

Please group linux/ includes together, then asm/ includes, lastly mach/
includes.

> @@ -0,0 +1,113 @@
> +/* arch/arm/mach-xilinx/common.c
...
> +/**
> + * system_init - System specific initialization, intended to be called from
> + *			board specific initialization.
> + *
> + **/
> +void __init system_init(void)

Is there a better name for this - maybe prefixing it with xilinx_ ?

> +{
> +#ifdef CONFIG_CACHE_L2X0
> +	/*
> +	 * 64KB way size, 8-way associativity, parity disabled
> +	 */
> +	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
> +#endif
> +}
> +
> +/**
> + * irq_init - Interrupt controller initialization for the GIC.
> + *
> + **/
> +void __init irq_init(void)

Ditto.

> +/**
> + * map_io - Create memory mappings needed for early I/O.
> + *
> + **/
> +void __init map_io(void)

Ditto.
