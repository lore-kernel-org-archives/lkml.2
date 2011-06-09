Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1FIShU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:37:20 -0400
Received: from mail.perches.com ([173.55.12.10]:2701 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1FIShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:37:17 -0400
Subject: Re: [PATCH] regulator: Add rdev_crit() macro
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1307631997-32061-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1307631997-32061-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 11:37:15 -0700
Message-ID: <1307644635.13329.36.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 16:06 +0100, Mark Brown wrote:
> No actual users but provide the macro so there's less surprise when it's
> not there.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 47bf85d..f5e4665 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -34,6 +34,8 @@
>  
>  #include "dummy.h"
>  
> +#define rdev_crit(rdev, fmt, ...)					\
> +	pr_crit("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
>  #define rdev_err(rdev, fmt, ...)					\
>  	pr_err("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
>  #define rdev_warn(rdev, fmt, ...)					\

If that's really necessary, shouldn't rdev_emerg, rdev_alert
and rdev_notice be added as well?



