Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2BVKHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:07:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63366 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2BVKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:07:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 3/5] Extcon: support multiple states at a device.
Date: Wed, 22 Feb 2012 10:07:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-15?q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com> <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com> <1328856038-21912-4-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1328856038-21912-4-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202221007.07600.arnd@arndb.de>
X-Provags-ID: V02:K0:7uUcPWAK1JG8Twwm8eSGjJJacJVXz3K06lCDN3pt+Rz
 uCiVYhlSJ0kKMhmdisMh1N1jGg+YrvmDhtuTg95Q3KoHnYWxyt
 p25qxOIqLz3zTgF/Oj/Z7KOE+8whnBUUgB4oUKu7cTRJ0dznSh
 Y+H6Q2y92ZqLicGv4JF9ii4Q3pRjk4R7oZSvsPV8KWB1qgiSJU
 xSO6WB4qLxxfaSyyl3P/nB9ig06k+tifVnqwlsb2CsfDppRfRh
 gJEsw/R1Dl8+VSkk91oUnAvy4gOvR2PhfzfDJ2rEl+TU0Nf7Ff
 F6cmzqTWL8FMDtcTw4els2lRSnQS9tquGscVMVIlkVP29LMO+s
 /Y6tm2CUkEz2ZJ/Fv3yw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 February 2012, MyungJoo Ham wrote:
>  Date:          December 2011
>  Contact:       MyungJoo Ham <myungjoo.ham@samsung.com>
>  Description:
> -               The /sys/class/extcon/.../state shows the cable attach/detach
> -               information of the corresponding extcon object. If the extcon
> -               objecct has an optional callback "show_state" defined, the
> -               callback will provide the name with this sysfs node.
> +               The /sys/class/extcon/.../state shows and stores the cable
> +               attach/detach information of the corresponding extcon object.
> +               If the extcon objecct has an optional callback "show_state"
> +               defined, the showing function is overriden with the optional
> +               callback.
> +
> +               If the default callback for showing function is used, the
> +               format is like this:
> +               # cat state
> +               USB_OTG=1
> +               HDMI=0
> +               TA=1
> +               EAR_JACK=0
> +               #
> +               In this example, the extcon device have USB_OTG and TA
> +               cables attached and HDMI and EAR_JACK cables detached.
> +
> +               There are two methods to update state of extcon.
> +               Method 1.
> +                 echo CABLE_NAME [0|1] > state
> +               Method 2.
> +                 echo 0xHEX > state
> +
> +               Method 1 updates the state (0 or 1) of the
> +               corresponding cable (either the name or index of the cable).
> +               Method 2 updates the whole state of the extcon dev.

I think having two ways to do the same thing is rather confusing, it would
be nice to provide only one way and make sure that it works for everyone.

Maybe the entire thing can be turned around into one attribute group
per cable and unified with the mutually-exclusive part, like

extcon/.../usb-otg/state 			# 0 or 1 for disable or enable
		  /mutually-exclusive		# list of exclusive ports
	  /hdmi/...
	  /ta/...

	Arnd
