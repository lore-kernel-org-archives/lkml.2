Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0HSOJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:09:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0HSOI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EiQiJYhalEl4RKfhVSx3I+eCUTune4B3Dzm/AOIRwfImbMO8BWUG06B81r4qZuRVZh
         tjsS4+CJP467NFqClyyy5lA7VMUacBAyKEz+PXBbhRMM5sEHC/KjrpQfnCEJ+fylFJXw
         W97fOfQQTm8zRVhemHLYYb3J6H+0Cs5awVt5w=
Date: Wed, 18 Aug 2010 22:23:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] iforce: simplify Kconfig depends
Message-ID: <20100819052317.GC5832@core.coreip.homeip.net>
References: <201008181006.26891.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008181006.26891.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,
On Wed, Aug 18, 2010 at 10:06:26AM -0700, H Hartley Sweeten wrote:
> The depends on for JOYSTICK_IFORCE is already handled in drivers/input/Kconfig and
> drivers/input/joystick/Kconfig.
> 
> Remove the depends on JOYSTICK_IFORCE for the *_USB and *_232 connections
> by wrapping them in an if/endif block. The second depends on check is still needed
> to prevent the iforce driver from being built-in while the connection is a module.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 

I have something in the local queus that reworks iforce a bit, I'll hold
on to the patch and see if it is still makes sense when I done with my
changes.

Thanks.

> ---
> 
> Should the connection depends on be changed to a select similar to the other
> joystick drivers?
> 
> diff --git a/drivers/input/joystick/iforce/Kconfig b/drivers/input/joystick/iforce/Kconfig
> index 8fde22a..d5fa68d 100644
> --- a/drivers/input/joystick/iforce/Kconfig
> +++ b/drivers/input/joystick/iforce/Kconfig
> @@ -3,7 +3,6 @@
>  #
>  config JOYSTICK_IFORCE
>  	tristate "I-Force devices"
> -	depends on INPUT && INPUT_JOYSTICK
>  	help
>  	  Say Y here if you have an I-Force joystick or steering wheel
>  
> @@ -12,16 +11,18 @@ config JOYSTICK_IFORCE
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called iforce.
>  
> +if JOYSTICK_IFORCE
> +
>  config JOYSTICK_IFORCE_USB
>  	bool "I-Force USB joysticks and wheels"
> -	depends on JOYSTICK_IFORCE && (JOYSTICK_IFORCE=m || USB=y) && USB
> +	depends on (JOYSTICK_IFORCE=m || USB=y) && USB
>  	help
>  	  Say Y here if you have an I-Force joystick or steering wheel
>  	  connected to your USB port.
>  
>  config JOYSTICK_IFORCE_232
>  	bool "I-Force Serial joysticks and wheels"
> -	depends on JOYSTICK_IFORCE && (JOYSTICK_IFORCE=m || SERIO=y) && SERIO
> +	depends on (JOYSTICK_IFORCE=m || SERIO=y) && SERIO
>  	help
>  	  Say Y here if you have an I-Force joystick or steering wheel
>  	  connected to your serial (COM) port.
> @@ -30,3 +31,4 @@ config JOYSTICK_IFORCE_232
>  	  <file:Documentation/input/joystick.txt>
>  	  and <file:Documentation/input/ff.txt>.
>  
> +endif

-- 
Dmitry
