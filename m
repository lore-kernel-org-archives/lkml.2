Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422Ab0G3TEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:04:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50931 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438Ab0G3TD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q6cRMY+2pb7Cs8HCHEPxswr7vxUO27hTDgg0HJD6P3gDdLuyNnCyKHJE+Oyq2laaKU
         WxNSvUSQwpdb7u7pgXhwcYTlFndnbWkkQ/q/d55vAD/aun+CszMSBVx16E5JJHCwsYq3
         Cg8m2OuDCup/JR5kO2o7/x0oPc/da2fpX3r88=
Date: Fri, 30 Jul 2010 21:05:58 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jornada720_bl/jornada720_lcd: make needlessly global
 symbols static
Message-ID: <20100730190557.GA980@boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <1280458823.7632.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1280458823.7632.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 11:00:23AM +0800, Axel Lin wrote:
> The following symbols are needlessly defined global:
> jornada_bl_init
> jornada_bl_exit
> jornada_lcd_init
> jornada_lcd_exit
> 
> This patch makes the symbols static.

Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Thx.

> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/backlight/jornada720_bl.c  |    4 ++--
>  drivers/video/backlight/jornada720_lcd.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
> index 60e1d28..a20a01a 100644
> --- a/drivers/video/backlight/jornada720_bl.c
> +++ b/drivers/video/backlight/jornada720_bl.c
> @@ -146,12 +146,12 @@ static struct platform_driver jornada_bl_driver = {
>  	},
>  };
>  
> -int __init jornada_bl_init(void)
> +static int __init jornada_bl_init(void)
>  {
>  	return platform_driver_register(&jornada_bl_driver);
>  }
>  
> -void __exit jornada_bl_exit(void)
> +static void __exit jornada_bl_exit(void)
>  {
>  	platform_driver_unregister(&jornada_bl_driver);
>  }
> diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
> index 8fe0181..9fd7af2 100644
> --- a/drivers/video/backlight/jornada720_lcd.c
> +++ b/drivers/video/backlight/jornada720_lcd.c
> @@ -135,12 +135,12 @@ static struct platform_driver jornada_lcd_driver = {
>  	},
>  };
>  
> -int __init jornada_lcd_init(void)
> +static int __init jornada_lcd_init(void)
>  {
>  	return platform_driver_register(&jornada_lcd_driver);
>  }
>  
> -void __exit jornada_lcd_exit(void)
> +static void __exit jornada_lcd_exit(void)
>  {
>  	platform_driver_unregister(&jornada_lcd_driver);
>  }
> -- 
> 1.5.4.3
> 
> 
