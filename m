Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1HVSES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:04:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50339 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1HVSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:04:16 -0400
Date: Mon, 22 Aug 2011 20:05:44 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Magnus Damm <damm@opensource.se>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds: add missing include of linux/module.h
Message-ID: <20110822180544.GB2702@Boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <1313936407.13671.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1313936407.13671.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

On Sun, Aug 21, 2011 at 10:20:07PM +0800, Axel Lin wrote:
> >From 157207e0166b05e33722c1c87bf3753ee22c94fa Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Sun, 21 Aug 2011 22:14:44 +0800
> Subject: [PATCH] leds: add missing include of linux/module.h
> 
> Add missing include of linux/module.h for drivers that
> use interfaces from linux/module.h.  This patch fixes build errors.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Jonathan McDowell <noodles@earth.li>
> Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> Cc: Magnus Damm <damm@opensource.se>
> ---
> below is the build errors for leds-ams-delta.c.
> I got similar buld errors for leds-hp6xx.c and leds-renesas-tpu.c.
> 
>   CC      drivers/leds/leds-ams-delta.o
> drivers/leds/leds-ams-delta.c:116: error: 'THIS_MODULE' undeclared here (not in a function)
> drivers/leds/leds-ams-delta.c:133: error: expected declaration specifiers or '...' before string constant
> drivers/leds/leds-ams-delta.c:133: warning: data definition has no type or storage class
> drivers/leds/leds-ams-delta.c:133: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/leds/leds-ams-delta.c:133: warning: function declaration isn't a prototype
> drivers/leds/leds-ams-delta.c:134: error: expected declaration specifiers or '...' before string constant
> drivers/leds/leds-ams-delta.c:134: warning: data definition has no type or storage class
> drivers/leds/leds-ams-delta.c:134: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
> drivers/leds/leds-ams-delta.c:134: warning: function declaration isn't a prototype
> drivers/leds/leds-ams-delta.c:135: error: expected declaration specifiers or '...' before string constant
> drivers/leds/leds-ams-delta.c:135: warning: data definition has no type or storage class
> drivers/leds/leds-ams-delta.c:135: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/leds/leds-ams-delta.c:135: warning: function declaration isn't a prototype
> drivers/leds/leds-ams-delta.c:136: error: expected declaration specifiers or '...' before string constant
> drivers/leds/leds-ams-delta.c:136: warning: data definition has no type or storage class
> drivers/leds/leds-ams-delta.c:136: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
> drivers/leds/leds-ams-delta.c:136: warning: function declaration isn't a prototype
> make[2]: *** [drivers/leds/leds-ams-delta.o] Error 1
> make[1]: *** [drivers/leds] Error 2
> make: *** [drivers] Error 2
> 
>  drivers/leds/leds-ams-delta.c   |    1 +
>  drivers/leds/leds-hp6xx.c       |    1 +
>  drivers/leds/leds-renesas-tpu.c |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/leds/leds-ams-delta.c b/drivers/leds/leds-ams-delta.c
> index b982603..8c00937 100644
> --- a/drivers/leds/leds-ams-delta.c
> +++ b/drivers/leds/leds-ams-delta.c
> @@ -8,6 +8,7 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> diff --git a/drivers/leds/leds-hp6xx.c b/drivers/leds/leds-hp6xx.c
> index e4ce1fd..bcfbd3a 100644
> --- a/drivers/leds/leds-hp6xx.c
> +++ b/drivers/leds/leds-hp6xx.c
> @@ -10,6 +10,7 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> diff --git a/drivers/leds/leds-renesas-tpu.c b/drivers/leds/leds-renesas-tpu.c
> index 5bfb40e1..d9a7d72 100644
> --- a/drivers/leds/leds-renesas-tpu.c
> +++ b/drivers/leds/leds-renesas-tpu.c
> @@ -17,6 +17,7 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> +#include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/spinlock.h>
> -- 
> 1.7.4.1
> 
> 
