Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0JOUXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:23:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34065 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0JOUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:23:40 -0400
Date: Fri, 15 Oct 2010 21:23:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de,
        valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
        amit.kucheria@canonical.com, xiao-lizhang@freescale.com
Subject: Re: [PATCH 1/2] ARM: imx: Add wake functionality to GPIO
Message-ID: <20101015202330.GA25365@n2100.arm.linux.org.uk>
References: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 03:18:27PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Add function definition for irq_chip.set_wake to enable GPIO to
> wake-up the system.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/plat-mxc/gpio.c              |   35 +++++++++++++++++++++++++++++++++
>  arch/arm/plat-mxc/include/mach/gpio.h |    3 ++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
> index 57ec4a8..7647ba3 100644
> --- a/arch/arm/plat-mxc/gpio.c
> +++ b/arch/arm/plat-mxc/gpio.c
> @@ -20,9 +20,11 @@
>   */
>  
>  #include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/gpio.h>
> +#include <mach/gpio.h>

Not necessary.  linux/gpio.h -> asm/gpio.h -> mach/gpio.h
