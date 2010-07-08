Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0GHJIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:08:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43995 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0GHJIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:08:42 -0400
Date: Thu, 8 Jul 2010 11:08:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <petkovbb@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] acerhdf: make needlessly global symbols static
Message-ID: <20100708090836.GA14580@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Axel Lin <axel.lin@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <petkovbb@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	platform-driver-x86@vger.kernel.org
References: <1278553580.7162.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1278553580.7162.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Thu, Jul 08, 2010 at 09:46:20AM +0800

> The following symbols are needlessly defined global:
> 
> thz_dev
> cl_dev
> acerhdf_dev
> acerhdf_dev_ops
> acerhdf_cooling_ops
> 
> This patch makes the symbols static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Borislav Petkov <bp@alien8.de>

> ---
>  drivers/platform/x86/acerhdf.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 7b2384d..5caaaf0 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -92,9 +92,9 @@ static unsigned int fanstate = ACERHDF_FAN_AUTO;
>  static char force_bios[16];
>  static char force_product[16];
>  static unsigned int prev_interval;
> -struct thermal_zone_device *thz_dev;
> -struct thermal_cooling_device *cl_dev;
> -struct platform_device *acerhdf_dev;
> +static struct thermal_zone_device *thz_dev;
> +static struct thermal_cooling_device *cl_dev;
> +static struct platform_device *acerhdf_dev;
>  
>  module_param(kernelmode, uint, 0);
>  MODULE_PARM_DESC(kernelmode, "Kernel mode fan control on / off");
> @@ -374,7 +374,7 @@ static int acerhdf_get_crit_temp(struct thermal_zone_device *thermal,
>  }
>  
>  /* bind callback functions to thermalzone */
> -struct thermal_zone_device_ops acerhdf_dev_ops = {
> +static struct thermal_zone_device_ops acerhdf_dev_ops = {
>  	.bind = acerhdf_bind,
>  	.unbind = acerhdf_unbind,
>  	.get_temp = acerhdf_get_ec_temp,
> @@ -449,7 +449,7 @@ err_out:
>  }
>  
>  /* bind fan callbacks to fan device */
> -struct thermal_cooling_device_ops acerhdf_cooling_ops = {
> +static struct thermal_cooling_device_ops acerhdf_cooling_ops = {
>  	.get_max_state = acerhdf_get_max_state,
>  	.get_cur_state = acerhdf_get_cur_state,
>  	.set_cur_state = acerhdf_set_cur_state,
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Regards/Gruss,
Boris.
