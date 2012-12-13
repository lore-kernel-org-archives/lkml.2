Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2LMOek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:34:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:61078 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab2LMOeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:34:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,273,1355126400"; 
   d="scan'208";a="180444972"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>, Dave Jones <davej@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Thermal: Add a thermal notifier for user space
Thread-Topic: Thermal: Add a thermal notifier for user space
Thread-Index: AQHN2JaLAx/F7LJ440qgx4qjhhTcrpgVgrmAgAFJq7A=
Date: Thu, 13 Dec 2012 14:34:29 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5924876C@BGSMSX101.gar.corp.intel.com>
References: <20121212180547.F12BE6606F0@gitolite.kernel.org>
	 <20121212182838.GA7497@redhat.com> <1355358199.2276.2.camel@rzhang1-mobl4>
In-Reply-To: <1355358199.2276.2.camel@rzhang1-mobl4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBDEYniV026485

> -----Original Message-----
> From: Zhang, Rui
> Sent: Thursday, December 13, 2012 5:53 AM
> To: Dave Jones
> Cc: Linux Kernel Mailing List; R, Durgadoss
> Subject: Re: Thermal: Add a thermal notifier for user space
> 
> On Wed, 2012-12-12 at 13:28 -0500, Dave Jones wrote:
> > On Wed, Dec 12, 2012 at 06:05:47PM +0000, Linux Kernel wrote:
> >  > Gitweb:
> http://git.kernel.org/linus/;a=commit;h=1cc807a234cb988d69ba18f6a3a1c68
> d71e54bed
> >  > Commit:     1cc807a234cb988d69ba18f6a3a1c68d71e54bed
> >  > Parent:     e151a202a084f9f4310d1aa4398325c56ca95fda
> >  > Author:     Durgadoss R <durgadoss.r@intel.com>
> >  > AuthorDate: Tue Sep 18 11:05:03 2012 +0530
> >  > Committer:  Zhang Rui <rui.zhang@intel.com>
> >  > CommitDate: Mon Nov 5 14:00:08 2012 +0800
> >  >
> >  >     Thermal: Add a thermal notifier for user space
> >  >
> >  >     This patch registers a governor which will let the
> >  >     user land manage the platform thermals. Whenever a
> >  >     trip happens, this governor just notifies the user
> >  >     space using kobj_uevent().
> >  >
> >  >     Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> >  >     Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> >
> >
> >  > +config USER_SPACE
> >  > +	bool "User_space thermal governor"
> >  > +	depends on THERMAL
> >  > +	help
> >  > +	  Enable this to let the user space manage the platform thermals.
> >
> > This is terribly generic sounding.  Might I suggest THERMAL_USER_SPACE
> instead ?
> >
> Hi, Dave,

Agree with you Dave. Could have chosen a better name :-)

Thanks Rui for the Quick fix.

> 
> You're right. How about the patch attached?
> 
> thanks,
> rui
> 
> From 595a531b3fbfd21d3d84a16fb8df93fdc0fe47e5 Mon Sep 17 00:00:00
> 2001
> From: Zhang Rui <rui.zhang@intel.com>
> Date: Thu, 13 Dec 2012 08:05:12 +0800
> Subject: [PATCH] Thermal: Rename thermal governor Kconfig options
> 
> Rename thermal governor Kconfig options,
> CONFIG_STEP_WISE, CONFIG_FAIR_SHARE, CONFIG_USER_SPACE
> to
> CONFIG_THERMAL_GOVERNOR_STEP_WISE,
> CONFIG_THERMAL_GOVERNOR_FAIR_SHARE,
> CONFIG_THERMAL_GOVERNOR_USER_SPACE,
> to avoid confusions brought by the previous generic naming.
> 

Acked-by: Durgadoss R <durgadoss.r@intel.com>

Thanks,
Durga

> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/thermal/Kconfig  |   12 ++++++------
>  drivers/thermal/Makefile |    6 +++---
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index 8636fae..13fed80 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -29,14 +29,14 @@ choice
> 
>  config THERMAL_DEFAULT_GOV_STEP_WISE
>  	bool "step_wise"
> -	select STEP_WISE
> +	select THERMAL_GOVERNOR_STEP_WISE
>  	help
>  	  Use the step_wise governor as default. This throttles the
>  	  devices one step at a time.
> 
>  config THERMAL_DEFAULT_GOV_FAIR_SHARE
>  	bool "fair_share"
> -	select FAIR_SHARE
> +	select THERMAL_GOVERNOR_FAIR_SHARE
>  	help
>  	  Use the fair_share governor as default. This throttles the
>  	  devices based on their 'contribution' to a zone. The
> @@ -44,24 +44,24 @@ config THERMAL_DEFAULT_GOV_FAIR_SHARE
> 
>  config THERMAL_DEFAULT_GOV_USER_SPACE
>  	bool "user_space"
> -	select USER_SPACE
> +	select THERMAL_GOVERNOR_USER_SPACE
>  	help
>  	  Select this if you want to let the user space manage the
>  	  lpatform thermals.
> 
>  endchoice
> 
> -config FAIR_SHARE
> +config THERMAL_GOVERNOR_FAIR_SHARE
>  	bool "Fair-share thermal governor"
>  	help
>  	  Enable this to manage platform thermals using fair-share governor.
> 
> -config STEP_WISE
> +config THERMAL_GOVERNOR_STEP_WISE
>  	bool "Step_wise thermal governor"
>  	help
>  	  Enable this to manage platform thermals using a simple linear
> 
> -config USER_SPACE
> +config THERMAL_GOVERNOR_USER_SPACE
>  	bool "User_space thermal governor"
>  	help
>  	  Enable this to let the user space manage the platform thermals.
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index d8da683..4f5103d 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -5,9 +5,9 @@
>  obj-$(CONFIG_THERMAL)		+= thermal_sys.o
> 
>  # governors
> -obj-$(CONFIG_FAIR_SHARE)	+= fair_share.o
> -obj-$(CONFIG_STEP_WISE)		+= step_wise.o
> -obj-$(CONFIG_USER_SPACE)	+= user_space.o
> +obj-$(CONFIG_THERMAL_GOVERNOR_FAIR_SHARE)	+= fair_share.o
> +obj-$(CONFIG_THERMAL_GOVERNOR_STEP_WISE)	+= step_wise.o
> +obj-$(CONFIG_THERMAL_GOVERNOR_USER_SPACE)	+= user_space.o
> 
>  # cpufreq cooling
>  obj-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
> --
> 1.7.9.5
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
