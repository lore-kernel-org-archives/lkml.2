Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1C1XVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:21:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1C1XVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OnAylI8RUG9gVo0VY/OOSUD6/MN9CBijIz8mwJJCvceTU9t4etTOJc+lM5CmKGdVU2
         8r1Rt4ptBjkW15XwsOOcBJFRxaQ38UBVIAOJW+af02oXqA/lowN1yNc8NGHIVTQXblql
         FOWsGSnjbeN5AYZ1RUQjidxA8k9+vKu0w095o=
Subject: Re: [PATCH v2] memstick: make enable_dma less generic in r592
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110329101025.434e6d95.sfr@canb.auug.org.au>
References: <20110328144458.efedbefc.sfr@canb.auug.org.au>
	 <20110329092416.a4b1d98f.sfr@canb.auug.org.au>
	 <20110329094856.3f61a0ce.sfr@canb.auug.org.au>
	 <20110329101025.434e6d95.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 01:21:26 +0200
Message-ID: <1301354486.17303.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 10:10 +1100, Stephen Rothwell wrote:
> Fixes this build error:
> 
> drivers/memstick/host/r592.c:26: error: 'enable_dma' redeclared as different kind of symbol
> arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/memstick/host/r592.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> v2: get the arguments to module_param_named() in the right order (blush :-))
> 
> This has been applied to linux-next today.
> 
> diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
> index 767406c..700d420 100644
> --- a/drivers/memstick/host/r592.c
> +++ b/drivers/memstick/host/r592.c
> @@ -23,7 +23,7 @@
>  #include <linux/swab.h>
>  #include "r592.h"
>  
> -static int enable_dma = 1;
> +static int r592_enable_dma = 1;
>  static int debug;
>  
>  static const char *tpc_names[] = {
> @@ -267,7 +267,7 @@ static void r592_stop_dma(struct r592_device *dev, int error)
>  /* Test if hardware supports DMA */
>  static void r592_check_dma(struct r592_device *dev)
>  {
> -	dev->dma_capable = enable_dma &&
> +	dev->dma_capable = r592_enable_dma &&
>  		(r592_read_reg(dev, R592_FIFO_DMA_SETTINGS) &
>  			R592_FIFO_DMA_SETTINGS_CAP);
>  }
> @@ -898,7 +898,7 @@ static void __exit r592_module_exit(void)
>  module_init(r592_module_init);
>  module_exit(r592_module_exit);
>  
> -module_param(enable_dma, bool, S_IRUGO);
> +module_param_named(enable_dma, r592_enable_dma, bool, S_IRUGO);
>  MODULE_PARM_DESC(enable_dma, "Enable usage of the DMA (default)");
>  module_param(debug, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Debug level (0-3)");
> -- 
> 1.7.4.1
> 


Sorry for this name clash. I didn't expect it.
Thanks for spotting this.

-- 
Best regards,
        Maxim Levitsky

Visit my blog: http://maximlevitsky.wordpress.com
Warning: Above blog contains rants.

