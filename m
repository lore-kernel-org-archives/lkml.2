Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0EaHsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:48:22 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38723 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0EaHsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:48:19 -0400
Date: Mon, 31 May 2010 16:47:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 2/8] arch/tile: infrastructure and configuration-related files.
Message-ID: <20100531074759.GC10515@linux-sh.org>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005290333.o4T3XuRo029935@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005290333.o4T3XuRo029935@farm-0002.internal.tilera.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 11:09:12PM -0400, Chris Metcalf wrote:
> +config ZONE_DMA
> +	def_bool y
> +

Do you really want ZONE_DMA? Looking through the code it seems like you
are just using this in place of ZONE_NORMAL instead of for dealing with
any specific DMA limitations.

> +config CC_OPTIMIZE_FOR_SIZE
> +	def_bool y
> +
This is a duplicate of the init/Kconfig entry. If you always want this
enabled you can select it.

> +config CLOCKSOURCE_WATCHDOG
> +	def_bool y
> +
Are you also sure that you want this? It doesn't seem like you have any
of the clocksource stability issues that x86 does, so it's not obvious
why you are enabling this.

> +config ARCH_DISCONTIGMEM_ENABLE
> +	def_bool y
> +
> +config ARCH_DISCONTIGMEM_DEFAULT
> +	def_bool y
> +
Have you considered sparsemem instead?

> +# SMP is required for Tilera Linux.
> +config SMP
> +	def_bool y
> +
Forcing on SMP is fairly unusual, you do not support booting UP kernels
at all?

> +config SERIAL_CONSOLE
> +	def_bool y
> +

This seems unused and looks like it was just copied over from some other
architecture?

> +config HVC_TILE
> +	select HVC_DRIVER
> +	def_bool y
> +
> +config TILE
> +	def_bool y
> +	select GENERIC_FIND_FIRST_BIT
> +	select GENERIC_FIND_NEXT_BIT
> +	select RESOURCES_64BIT
> +	select USE_GENERIC_SMP_HELPERS
> +
RESOURCES_64BIT is more legacy stuff, you don't need this anymore by
virtue of the 64-bit phys_addr_t that you're already forcing on.

> +menu "Bus options"
> +
> +config NO_IOMEM
> +	bool
> +	def_bool !PCI
> +

Have you inverted the logic here? Judging from your I/O routines it's the
PIO stuff you want disabled, not MMIO. As such, it's NO_IOPORT that you
want. Some of the PCI drivers will still use inb/outb and friends for PCI
IO space so disabling it for the !PCI case is fine.
