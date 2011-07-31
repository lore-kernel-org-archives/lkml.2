Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1GaIPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 04:15:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:61445 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1GaIO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 04:14:58 -0400
Date: Sun, 31 Jul 2011 04:14:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731081446.GL31842@windriver.com>
References: <20110729152533.73329e8bafd4e839e85f0555@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729152533.73329e8bafd4e839e85f0555@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 15:25) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/media/rc/ir-raw.c: In function 'init_decoders':
> drivers/media/rc/ir-raw.c:354:2: error: implicit declaration of function 'request_module'
> 
> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 15:21:27 +1000
> Subject: [PATCH] ir-raw.c: include modules .h for request_module

Thanks, I've got this change in tree now.

P.

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/media/rc/ir-raw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
> index 56adca8..ba817d2 100644
> --- a/drivers/media/rc/ir-raw.c
> +++ b/drivers/media/rc/ir-raw.c
> @@ -14,7 +14,7 @@
>  
>  #include <linux/kthread.h>
>  #include <linux/mutex.h>
> -#include <linux/export.h>
> +#include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
>  #include "rc-core-priv.h"
> -- 
> 1.7.5.4
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
