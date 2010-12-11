Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab0LKU4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:56:34 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:63011 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0LKU4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WsGi/743ND07S8XgA5Tf/ZBq/VDUuksvmtJxFnY1wodS8YSvU0q3Uznz/P4nAbcdDh
         c+IkH0hxdioubuCJggYJ3P46z/KYyH4JzuHjSYUIc3JnMnT3Zd2J6RsmzKi38JIybmht
         OKRm83F7fnQjFsnStwIzgutqJ6h/c4n+t9fKA=
Date: Sat, 11 Dec 2010 21:57:11 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sa1100: Fix platform device registration
Message-ID: <20101211205710.GB810@boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <1292090000-21779-1-git-send-email-jochen@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1292090000-21779-1-git-send-email-jochen@scram.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Applies and makes sense, so

Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

On Sat, Dec 11, 2010 at 06:53:20PM +0100, Jochen Friedrich wrote:
> Since commit 7a5b4e16c880f8350d255dc188f81622905618c1, simpad devices don't
> boot anymore, since platform devices are registered too early. Fix by moving
> the registration from map_io to arch_initcall as done on other sa1100 boards.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  arch/arm/mach-sa1100/simpad.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
> index 27692d0..cfb7607 100644
> --- a/arch/arm/mach-sa1100/simpad.c
> +++ b/arch/arm/mach-sa1100/simpad.c
> @@ -166,9 +166,6 @@ static void __init simpad_map_io(void)
>  	PCFR = 0;
>  	PSDR = 0;
>  
> -	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
> -			      ARRAY_SIZE(simpad_flash_resources));
> -	sa11x0_register_mcp(&simpad_mcp_data);
>  }
>  
>  static void simpad_power_off(void)
> @@ -216,6 +213,10 @@ static int __init simpad_init(void)
>  
>  	pm_power_off = simpad_power_off;
>  
> +	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
> +			      ARRAY_SIZE(simpad_flash_resources));
> +	sa11x0_register_mcp(&simpad_mcp_data);
> +
>  	ret = platform_add_devices(devices, ARRAY_SIZE(devices));
>  	if(ret)
>  		printk(KERN_WARNING "simpad: Unable to register mq200 framebuffer device");
> -- 
> 1.7.2.3
