Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab2EPF3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:29:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56458 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752252Ab2EPF3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:29:19 -0400
Message-ID: <1337146157.26509.9.camel@joe2Laptop>
Subject: Re: [PATCH v2 1/7] backlight: use pr_warn instead of printk
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Date: Tue, 15 May 2012 22:29:17 -0700
In-Reply-To: <001f01cd3321$ff4260d0$fdc72270$%han@samsung.com>
References: <001f01cd3321$ff4260d0$fdc72270$%han@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 14:08 +0900, Jingoo Han wrote:
> This patch uses pr_warn instead of printk to allow dynamic debugging.

A slight mistake in the commit message.
pr_debug not pr_warn.

> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index bf5b1ec..f7ce212 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -5,6 +5,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) "backlight: " fmt

I'd prefer:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
> index 1c298d5..e61db49 100644
> --- a/drivers/video/backlight/lcd.c
> +++ b/drivers/video/backlight/lcd.c
> @@ -5,6 +5,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) "lcd: " fmt

KBUILD_MODNAME here too


