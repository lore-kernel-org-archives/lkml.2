Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1GFMep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:34:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44039 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1GFMeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:34:44 -0400
Date: Wed, 6 Jul 2011 13:34:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v8] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20110706123417.GA25400@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20101107165745.GB1759@n2100.arm.linux.org.uk> <AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com> <20101107171726.GF1759@n2100.arm.linux.org.uk> <20101108171930.GA1471@alchark-u3s.lan> <20101111212322.GA15533@alchark-u3s.lan> <20101111234957.GA28735@n2100.arm.linux.org.uk> <20101219174017.GA31832@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101219174017.GA31832@alchark-u3s>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 08:40:17PM +0300, Alexey Charkov wrote:
> +static struct map_desc vt8500_io_desc[] __initdata = {
> +	/* SoC MMIO registers, to be filled in later */
> +	[0] = {
> +		.type		= MT_DEVICE
> +	},
> +	/* PCI I/O space, numbers tied to those in <mach/io.h> */
> +	[1] = {
> +		.virtual	= 0xf0000000,
> +		.pfn		= __phys_to_pfn(0xc0000000),
> +		.length		= SZ_64K,
> +		.type		= MT_DEVICE
> +	},
> +};
...
> diff --git a/arch/arm/mach-vt8500/include/mach/io.h b/arch/arm/mach-vt8500/include/mach/io.h
> new file mode 100644
> index 0000000..8dd55c8
> --- /dev/null
> +++ b/arch/arm/mach-vt8500/include/mach/io.h
> +#ifndef __ASM_ARM_ARCH_IO_H
> +#define __ASM_ARM_ARCH_IO_H
> +
> +#define IO_SPACE_LIMIT 0xffff
> +
> +#define __io(a)		((void __iomem *)((a) + 0xf0000000))
> +#define __mem_pci(a)	(a)

Can you explain why you seem to have PCI IO space, yet don't have CONFIG_PCI
selected?  Do you have any drivers which use this space without CONFIG_PCI=y?

Thanks.
