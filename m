Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0I2IVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:21:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63457 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0I2IU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:20:59 -0400
Date: Wed, 29 Sep 2010 17:20:55 +0900
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] SPI: add PrimeCell generic DMA to PL022 v12
Message-ID: <20100929082055.GC4703@angua.secretlab.ca>
References: <1285684441-21700-1-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 04:33:55PM +0200, Linus Walleij wrote:
> This extends the PL022 SSP/SPI driver with generic DMA engine
> support using the PrimeCell DMA engine interface. Also fix up the
> test code for the U300 platform.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> Changes:
> - Switch CONFIG_DMADEVICES for CONFIG_DMA_ENGINE to counter
>   a compilation error spotted by Grant.
> ---
>  arch/arm/mach-u300/dummyspichip.c |    1 +
>  drivers/spi/amba-pl022.c          |  516 ++++++++++++++++++++++++++++++-------
>  include/linux/amba/pl022.h        |    6 +
>  3 files changed, 435 insertions(+), 88 deletions(-)
> 
> diff --git a/arch/arm/mach-u300/dummyspichip.c b/arch/arm/mach-u300/dummyspichip.c
> index 03f7936..b86e944 100644
> --- a/arch/arm/mach-u300/dummyspichip.c
> +++ b/arch/arm/mach-u300/dummyspichip.c
> @@ -267,6 +267,7 @@ static struct spi_driver pl022_dummy_driver = {
>  	.driver = {
>  		.name	= "spi-dummy",
>  		.owner	= THIS_MODULE,
> +		.bus = &spi_bus_type,

This shouldn't be necessary.  spi_register_driver already sets the bus
type field.

Otherwise, this patch looks good.  If you're okay with me dropping
this hunk, then I'll pick up this patch into my next-spi branch.

g.
