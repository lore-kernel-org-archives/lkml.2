Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0KGRA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 12:00:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51767 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab0KGRAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:00:25 -0500
Date: Sun, 7 Nov 2010 17:00:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v2] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20101107170005.GC1759@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289147348-31969-1-git-send-email-alchark@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of other points - sorry, should've been in the last mail.

On Sun, Nov 07, 2010 at 07:28:52PM +0300, Alexey Charkov wrote:
> diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
> new file mode 100644
> index 0000000..e0c6268
> --- /dev/null
> +++ b/arch/arm/mach-vt8500/Kconfig
> @@ -0,0 +1,65 @@
> +if ARCH_VT8500
> +
> +config VTWM_VERSION_VT8500
> +	bool
> +	default n

n is the default anyway, so specifying this is redundant.

> +void __init bv07_init(void)
> +{
> +#ifdef CONFIG_FB_VT8500
> +	void __iomem *gpio_mux_reg = ioremap(wmt_current_regs->gpio
> +					     + 0x200, 4);

ioremap() is generally regarded as a function which can fail, and therefore
needs its return value checked.  There seems to be multiple instances of
this through this patch.
