Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030280Ab2CIUaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:30:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:52977 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781Ab2CIUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:30:05 -0500
Date: Fri, 9 Mar 2012 15:30:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regmap: Fix missing prototype of devres_alloc() and
 friends
Message-ID: <20120309203000.GA10835@windriver.com>
References: <1331324248-1599-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1331324248-1599-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH] regmap: Fix missing prototype of devres_alloc() and friends] On 09/03/2012 (Fri 13:17) Stephen Warren wrote:

> regmap.s uses devres_alloc() and others that are prototyped in device.h.
> Include that to solve the following:

Thanks, I've already taken care of this earlier today.

http://marc.info/?l=linux-next&m=133130596327850&w=2

Paul.

> 
> drivers/base/regmap/regmap.c: In function 'devm_regmap_init':
> drivers/base/regmap/regmap.c:331:2: error: implicit declaration of function 'devres_alloc' [-Werror=implicit-function-declaration]
> drivers/base/regmap/regmap.c:338:3: error: implicit declaration of function 'devres_add' [-Werror=implicit-function-declaration]
> drivers/base/regmap/regmap.c:340:3: error: implicit declaration of function 'devres_free' [-Werror=implicit-function-declaration]
> drivers/base/regmap/regmap.c: In function '_regmap_raw_write':
> drivers/base/regmap/regmap.c:421:5: error: implicit declaration of function 'dev_err' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  drivers/base/regmap/regmap.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index e1a4097..7a3f535 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -10,6 +10,7 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/device.h>
>  #include <linux/slab.h>
>  #include <linux/export.h>
>  #include <linux/mutex.h>
> -- 
> 1.7.0.4
> 
