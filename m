Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0FBEfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:35:18 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:58324 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab0FBEfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:35:16 -0400
Date: Wed, 2 Jun 2010 07:34:47 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] fbdev: fix frame buffer devices menu
Message-ID: <20100602043447.GA12190@jasper.tkos.co.il>
References: <1274896477-6832-1-git-send-email-cascardo@holoscopio.com>
 <20100527040329.GA14841@jasper.tkos.co.il>
 <20100601142806.03c50a49.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601142806.03c50a49.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Jun 01, 2010 at 02:28:06PM -0700, Andrew Morton wrote:
> On Thu, 27 May 2010 07:03:29 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > On Wed, May 26, 2010 at 02:54:37PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > Commit f601441916d1e19291d0b4f044b4a7551e2924d0 has inserted the symbol
> > > HAVE_FB_IMX, which does not depend on FB after the menuconfig FB. This
> > > breaks the menu, presenting most of the drivers outside of it, when
> > > using menuconfig.
> > > 
> > > Moving the symbol to the start of the file, just like HAVE_FB_ATMEL,
> > > fixes the problem without breaking it for iMX25 configurations (tested
> > > with ARCH=arm, no build).
> > > 
> > > Cc: Baruch Siach <baruch@tkos.co.il>
> > > Cc: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> > > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > 
> > Acked-by: Baruch Siach <baruch@tkos.co.il>
> > 
> 
> OK, I've been sitting on the below patch
> (fbdev-fix-kconfig-breakage-in-drivers-video.patch) for months, waiting
> for Krzysztof to respond to some comment which Baruch made, but
> Krzysztof seems to have gone quiet.
> 
> Could you guys please compare Thadeu's patch with the below and work
> out which is preferable and whether the new patch has the same coverage
> as the old one, etc?

Krzysztof's patch breaks the fb support for the MX25 platform, so I prefer 
Thadeu's approach. I have no objection to the

s/(FB = y) && (SPARC && FB_SBUS)/FB_SBUS/

thing, though.

baruch

> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> There are two new options inside the CONFIG_FB section which do not depend
> on the CONFIG_FB.  This break Kconfig menu layout.
> 
> Fix it and reduce few conditions for sparc frame buffers as the FB_SBUS ==
> ((FB = y) && SPARC).
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/video/Kconfig |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff -puN drivers/video/Kconfig~fbdev-fix-kconfig-breakage-in-drivers-video drivers/video/Kconfig
> --- a/drivers/video/Kconfig~fbdev-fix-kconfig-breakage-in-drivers-video
> +++ a/drivers/video/Kconfig
> @@ -400,12 +400,9 @@ config FB_SA1100
>  	  If you plan to use the LCD display with your SA-1100 system, say
>  	  Y here.
>  
> -config HAVE_FB_IMX
> -	bool
> -
>  config FB_IMX
>  	tristate "Motorola i.MX LCD support"
> -	depends on FB && (HAVE_FB_IMX || ARCH_MX1 || ARCH_MX2)
> +	depends on FB && (ARCH_MX1 || ARCH_MX2)
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> @@ -802,7 +799,7 @@ config FB_SBUS
>  
>  config FB_BW2
>  	bool "BWtwo support"
> -	depends on (FB = y) && (SPARC && FB_SBUS)
> +	depends on FB_SBUS
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> @@ -811,7 +808,7 @@ config FB_BW2
>  
>  config FB_CG3
>  	bool "CGthree support"
> -	depends on (FB = y) && (SPARC && FB_SBUS)
> +	depends on FB_SBUS
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> @@ -820,7 +817,7 @@ config FB_CG3
>  
>  config FB_CG6
>  	bool "CGsix (GX,TurboGX) support"
> -	depends on (FB = y) && (SPARC && FB_SBUS)
> +	depends on FB_SBUS
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
>  	help
> _
> 

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
