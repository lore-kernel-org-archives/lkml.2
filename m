Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab1I2NU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:20:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51361 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab1I2NU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110929164028.912fba5b3fd2c4d12663de04@canb.auug.org.au>
References: <20110929164028.912fba5b3fd2c4d12663de04@canb.auug.org.au>
Date: Thu, 29 Sep 2011 09:20:55 -0400
Message-ID: <CAP=VYLqY5S1rdCcfgNf26EwKFwZZPZNjBn0FJdsqy0DJi5y_Vg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (moduleh
 tree related)
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 2:40 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/staging/cxt1e1/linux.c:113:32: error: expected ')' before 'int'
> drivers/staging/cxt1e1/linux.c:117:30: error: expected ')' before 'int'
> drivers/staging/cxt1e1/linux.c:121:30: error: expected ')' before 'int'
> drivers/staging/cxt1e1/linux.c:125:31: error: expected ')' before 'int'
> drivers/staging/cxt1e1/linux.c:129:31: error: expected ')' before 'int'
>
> Caused by the module split.  The fix in the moduleh tree (commit
> 6eee8b750254 ("staging: Add module.h to more drivers implicitly using
> i")) is incorrect in that module.h has been included too late.

Thanks, I've fixed the mislocation in the original.

Paul.

>
> I have applied the following patch for today.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 29 Sep 2011 16:36:21 +1000
> Subject: [PATCH] staging: move the module.h include in cxt1e1/linux.c
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/cxt1e1/linux.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
> index e7029af..6e574fe 100644
> --- a/drivers/staging/cxt1e1/linux.c
> +++ b/drivers/staging/cxt1e1/linux.c
> @@ -15,6 +15,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>  #include <linux/types.h>
> +#include <linux/module.h>
>  #include <linux/netdevice.h>
>  #include <linux/hdlc.h>
>  #include <linux/if_arp.h>
> @@ -163,7 +164,6 @@ mkret (int bsd)
>
>  /***************************************************************************/
>  #include <linux/workqueue.h>
> -#include <linux/module.h>
>
>  /***
>  * One workqueue (wq) per port (since musycc allows simultaneous group
> --
> 1.7.6.3
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
