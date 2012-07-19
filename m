Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab2GSQns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:43:48 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:56452 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab2GSQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:43:39 -0400
Message-ID: <50083932.8090209@ti.com>
Date: Thu, 19 Jul 2012 22:13:30 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        broonie@sirena.org.uk
Subject: Re: spi/omap2: mark omap2_mcspi_master_setup as __devinit
References: <201207191452.56549.arnd@arndb.de>
In-Reply-To: <201207191452.56549.arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Mark
Since Grant is moving to a new house.

On Thursday 19 July 2012 08:22 PM, Arnd Bergmann wrote:
> This warning recently appeared with omap2plus_defconfig:
>
> WARNING: drivers/spi/built-in.o(.devinit.text+0x3c4): Section mismatch in reference from the function omap2_mcspi_probe() to the function .init.text:omap2_mcspi_master_setup()
> The function __devinit omap2_mcspi_probe() references
> a function __init omap2_mcspi_master_setup().
> If omap2_mcspi_master_setup is only used by omap2_mcspi_probe then
> annotate omap2_mcspi_master_setup with a matching annotation.
>
> The fix is obviously to mark the omap2_mcspi_master_setup function as
> __devinit, rather than __init.
Acked-by: Shubhrajyoti D <shubhrajyoti@ti.com <mailto:shubhrajyoti@ti.com>>

Thanks for the patch.
Apologies for breaking in one  my patch series.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 0c73dd4..dc02f2f 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -1032,7 +1032,7 @@ static int omap2_mcspi_transfer_one_message(struct spi_master *master,
>  	return 0;
>  }
>  
> -static int __init omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
> +static int __devinit omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
>  {
>  	struct spi_master	*master = mcspi->master;
>  	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;

