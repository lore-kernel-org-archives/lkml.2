Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1EaIo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:44:29 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41770 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1EaIo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:44:28 -0400
Date: Tue, 31 May 2011 09:44:24 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, arnd@arndb.de,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 1/4] gpio: gpio-mxc: add gpio driver for Freescale MXC
 architecture
Message-ID: <20110531084424.GA2266@pulham.picochip.com>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
 <1306767139-24763-2-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306767139-24763-2-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Mon, May 30, 2011 at 10:52:16PM +0800, Shawn Guo wrote:
> Add gpio-mxc driver by copying arch/arm/plat-mxc/gpio.c into
> drivers/gpio with the following changes.
> 
>  * Use readl/writel to replace mach-specific accessors
>    __raw_readl/__raw_writel
> 
>  * Migrate to platform driver by adding .probe function
> 
>  * Add a list to save all mx2 ports references, so that
>    mx2_gpio_irq_handler can walk through all interrupt status
>    registers
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---

Could you use the stuff in drivers/gpio/basic_mmio_gpio.c for 
implementing the gpio_chip?  I had a go a little while ago [1] but since 
then we've made it possible to embed the bgpio_chip in your own 
structure which may be cleaner.

Jamie

1. http://permalink.gmane.org/gmane.linux.ports.arm.kernel/113139
