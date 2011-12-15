Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab1LOJB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:01:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:36747 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab1LOJB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:01:27 -0500
Message-ID: <4EE9B75C.9060204@infradead.org>
Date: Thu, 15 Dec 2011 07:01:16 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Luca Risolia <luca.risolia@studio.unibo.it>,
        Eric Piel <eric.piel@tremplin-utc.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/15] module_param: check type correctness for module_param_array
References: <87aa6utu6s.fsf@rustcorp.com.au>
In-Reply-To: <87aa6utu6s.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-12-2011 01:00, Rusty Russell wrote:
> module_param_array(), unlike its non-array cousins, didn't check the type
> of the variable.  Fixing this found two bugs.
> 
> Cc: Luca Risolia <luca.risolia@studio.unibo.it>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Eric Piel <eric.piel@tremplin-utc.net>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/media/video/et61x251/et61x251_core.c |    4 ++--
>  drivers/media/video/sn9c102/sn9c102_core.c   |    4 ++--

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

>  drivers/mfd/janz-cmodio.c                    |    2 +-
>  drivers/misc/lis3lv02d/lis3lv02d.c           |    2 ++
>  include/linux/moduleparam.h                  |    1 +
>  5 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
> --- a/drivers/media/video/et61x251/et61x251_core.c
> +++ b/drivers/media/video/et61x251/et61x251_core.c
> @@ -76,8 +76,8 @@ MODULE_PARM_DESC(video_nr,
>  		 "\none and for every other camera."
>  		 "\n");
>  
> -static short force_munmap[] = {[0 ... ET61X251_MAX_DEVICES-1] =
> -			       ET61X251_FORCE_MUNMAP};
> +static bool force_munmap[] = {[0 ... ET61X251_MAX_DEVICES-1] =
> +			      ET61X251_FORCE_MUNMAP};
>  module_param_array(force_munmap, bool, NULL, 0444);
>  MODULE_PARM_DESC(force_munmap,
>  		 "\n<0|1[,...]> Force the application to unmap previously"
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
> --- a/drivers/media/video/sn9c102/sn9c102_core.c
> +++ b/drivers/media/video/sn9c102/sn9c102_core.c
> @@ -75,8 +75,8 @@ MODULE_PARM_DESC(video_nr,
>  		 "\none and for every other camera."
>  		 "\n");
>  
> -static short force_munmap[] = {[0 ... SN9C102_MAX_DEVICES-1] =
> -			       SN9C102_FORCE_MUNMAP};
> +static bool force_munmap[] = {[0 ... SN9C102_MAX_DEVICES-1] =
> +			      SN9C102_FORCE_MUNMAP};
>  module_param_array(force_munmap, bool, NULL, 0444);
>  MODULE_PARM_DESC(force_munmap,
>  		 " <0|1[,...]>"
> diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
> --- a/drivers/mfd/janz-cmodio.c
> +++ b/drivers/mfd/janz-cmodio.c
> @@ -33,7 +33,7 @@
>  
>  /* Module Parameters */
>  static unsigned int num_modules = CMODIO_MAX_MODULES;
> -static unsigned char *modules[CMODIO_MAX_MODULES] = {
> +static char *modules[CMODIO_MAX_MODULES] = {
>  	"empty", "empty", "empty", "empty",
>  };
>  
> diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
> --- a/drivers/misc/lis3lv02d/lis3lv02d.c
> +++ b/drivers/misc/lis3lv02d/lis3lv02d.c
> @@ -111,6 +111,8 @@ static struct kernel_param_ops param_ops
>  	.get = param_get_int,
>  };
>  
> +#define param_check_axis(name, p) param_check_int(name, p)
> +
>  module_param_array_named(axes, lis3_dev.ac.as_array, axis, NULL, 0644);
>  MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
>  
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -395,6 +395,7 @@ extern int param_get_invbool(char *buffe
>   * module_param_named() for why this might be necessary.
>   */
>  #define module_param_array_named(name, array, type, nump, perm)		\
> +	param_check_##type(name, &(array)[0]);				\
>  	static const struct kparam_array __param_arr_##name		\
>  	= { .max = ARRAY_SIZE(array), .num = nump,                      \
>  	    .ops = &param_ops_##type,					\

