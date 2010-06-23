Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0FWWpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:45:13 -0400
Received: from kroah.org ([198.145.64.141]:36474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0FWWpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:45:11 -0400
Date: Wed, 23 Jun 2010 15:41:50 -0700
From: Greg KH <greg@kroah.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Hebbar Shivananda <x0hebbar@ti.com>,
       Ramos Falcon Ernesto <ernesto@ti.com>, Anna Suman <s-anna@ti.com>,
       Kanigeri Hari <h-kanigeri2@ti.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Gupta Ramesh <grgupta@ti.com>,
       Guzman Lugo Fernando <fernando.lugo@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       Gomez Castellanos Ivan <ivan.gomez@ti.com>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Armando Uribe De Leon <x0095078@ti.com>,
       Deepak Chitriki <deepak.chitriki@ti.com>, Menon Nishanth <nm@ti.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Pitney Gilbert <gpitney@ti.com>, Bhavin Shah <bshah@ti.com>,
       Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [PATCH 11/11] staging: ti dspbridge: enable driver building
Message-ID: <20100623224150.GA6680@kroah.com>
References: <1277298125-17991-1-git-send-email-ohad@wizery.com>
 <1277298840-18516-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277298840-18516-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 04:14:00PM +0300, Ohad Ben-Cohen wrote:
> From: Omar Ramirez Luna <omar.ramirez@ti.com>
> 
> Add Kconfig + Makefile for TI's DSP Bridge driver
> and expose it to the staging menu.
> 
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
> Signed-off-by: Kanigeri, Hari <h-kanigeri2@ti.com>
> Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
> Signed-off-by: Guzman Lugo, Fernando <fernando.lugo@ti.com>
> Signed-off-by: Hebbar, Shivananda <x0hebbar@ti.com>
> Signed-off-by: Ramos Falcon, Ernesto <ernesto@ti.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> Signed-off-by: Anna, Suman <s-anna@ti.com>
> Signed-off-by: Gupta, Ramesh <grgupta@ti.com>
> Signed-off-by: Gomez Castellanos, Ivan <ivan.gomez@ti.com>
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Signed-off-by: Armando Uribe De Leon <x0095078@ti.com>
> Signed-off-by: Deepak Chitriki <deepak.chitriki@ti.com>
> Signed-off-by: Menon, Nishanth <nm@ti.com>
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/staging/Kconfig              |    2 +
>  drivers/staging/Makefile             |    1 +
>  drivers/staging/tidspbridge/Kconfig  |   88 ++++++++++++++++++++++++++++++++++
>  drivers/staging/tidspbridge/Makefile |   34 +++++++++++++
>  4 files changed, 125 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/tidspbridge/Kconfig
>  create mode 100644 drivers/staging/tidspbridge/Makefile
> 
> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index 3de4bca..c9e8215 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -153,5 +153,9 @@ source "drivers/staging/easycap/Kconfig"
>  
>  source "drivers/staging/solo6x10/Kconfig"
>  
> +source "drivers/staging/tidspbridge/Kconfig"
> +
> +source "drivers/staging/tidspbridge/Kconfig"
> +
>  endif # !STAGING_EXCLUDE_BUILD
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index b28d820..952b64e 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -57,3 +57,4 @@ obj-$(CONFIG_TOUCHSCREEN_MRSTOUCH)	+= mrst-touchscreen/
>  obj-$(CONFIG_MSM_STAGING)	+= msm/
>  obj-$(CONFIG_EASYCAP)		+= easycap/
>  obj-$(CONFIG_SOLO6X10)		+= solo6x10/
> +obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge/
> diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
> new file mode 100644
> index 0000000..37fa2b1
> --- /dev/null
> +++ b/drivers/staging/tidspbridge/Kconfig
> @@ -0,0 +1,88 @@
> +#
> +# DSP Bridge Driver Support
> +#
> +
> +menuconfig TIDSPBRIDGE
> +	tristate "DSP Bridge driver"
> +	default n

The default is always 'n' so you don't need this.

Also, this enables the driver to be built on x86, which fails horribly,
and I don't think is what you really want to have happen :)

So I need some more Kconfig changes here, care to redo just this one
patch?  I've applied all the others and they will show up in linux-next
tomorrow.

thanks,

greg k-h
