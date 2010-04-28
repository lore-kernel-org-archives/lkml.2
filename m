Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0D1R0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:26:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1784 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0D1R0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:26:16 -0400
Subject: Re: [PATCH] Staging: cx25821 : fix coding style issues in
 cx25821-alsa.c
From: Joe Perches <joe@perches.com>
To: sai <tsg321@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1272475020-4994-1-git-send-email-tsg321@gmail.com>
References: <1272475020-4994-1-git-send-email-tsg321@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 10:26:14 -0700
Message-ID: <1272475574.18228.26.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 22:47 +0530, sai wrote:
> This is a patch to cx25821-alsa.c file that fixes of most of the warning & errors found by checkpatch.pl tool
> Signed-off-by: sai gopal <tsg321@gmail.com>
> ---
>  drivers/staging/cx25821/cx25821-alsa.c |   75 +++++++++++++++++---------------
>  1 files changed, 40 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
> index 061add3..0890384 100644
> --- a/drivers/staging/cx25821/cx25821-alsa.c
> +++ b/drivers/staging/cx25821/cx25821-alsa.c
[]
> @@ -42,10 +42,10 @@
>  
>  #define AUDIO_SRAM_CHANNEL	SRAM_CH08
>  
> -#define dprintk(level,fmt, arg...)	if (debug >= level) \
> +#define dprintk(level, fmt, arg...)	if (debug >= level) \
>  	printk(KERN_INFO "%s/1: " fmt, chip->dev->name , ## arg)
>  
> -#define dprintk_core(level,fmt, arg...)	if (debug >= level) \
> +#define dprintk_core(level, fmt, arg...)	if (debug >= level) \
>  	printk(KERN_DEBUG "%s/1: " fmt, chip->dev->name , ## arg)

These macros should really be do {macro} while (0)
so that they can be simply used in an if/else

#define dprintk(level, fmt, arg...)					\
do {									\
	if (debug >= level)						\
		printk(KERN_INFO "%s/1: " fmt, chip->dev->name, ##arg);	\
} while (0)


