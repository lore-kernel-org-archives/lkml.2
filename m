Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041Ab0JZQJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:09:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57760 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760029Ab0JZQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hs9YROej/sNYKEy17Z3JqT+aaEojWVobUb6jV3jHOOIyBtP5C9i3HQ60Crp6hnTrQn
         FgfKirdZla7rLIBlAHCI+PwkSf07fAk4ugQLeTgsYt88GsVJ3rJUENVHdSupQKwG94AH
         25HsrBGipdMEEDLAoSc+ErdUU6FyOsDiY54/A=
Date: Tue, 26 Oct 2010 09:09:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Message-ID: <20101026160936.GD13097@core.coreip.homeip.net>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilkka,

On Mon, Oct 25, 2010 at 04:31:02PM +0300, Ilkka Koskinen wrote:
> This driver provides access to drive a vibrator connected
> to SPI data line via Input layer's Force Feedback interface.
> 
> Client application provides samples (data streams) to be
> played as CUSTOM_DATA. The samples are stored in driver's
> internal buffers.

If device is able to do custom waveform can't it also do regular effects
(constant, periodic, etc. Or is custom is actually random and you are
doing something like rumble effect?

> 
> The driver is not able to mix the given samples. Instead, it
> remembers the currently played sample and next one to be played.
> 

Why is this driver not using the memoryless FF  library (and extends it
to handle FF_CUSTOM effects) but rather reimplements it in the driver
itself?

> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> ---
>  drivers/input/misc/Kconfig     |    5 +
>  drivers/input/misc/Makefile    |    2 +-
>  drivers/input/misc/vibra_spi.c |  429 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/spi/vibra.h      |   34 ++++
>  4 files changed, 469 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/input/misc/vibra_spi.c
>  create mode 100644 include/linux/spi/vibra.h
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index b49e233..3441832 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -438,4 +438,9 @@ config INPUT_ADXL34X_SPI
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called adxl34x-spi.
>  
> +config INPUT_SPI_VIBRA
> +	tristate "Support for SPI driven Vibra module"
> +	help
> +	  Support for Vibra module that is connected to OMAP SPI bus.
> +

"To compile this driver as a module". Also please keep Kconfig and
Makefile sorted alphabetically.

Thanks.

-- 
Dmitry
