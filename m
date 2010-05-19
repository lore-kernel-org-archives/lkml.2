Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0ESJ4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:56:55 -0400
Received: from mga05.intel.com ([192.55.52.89]:62591 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753382Ab0ESJ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:56:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,262,1272870000"; 
   d="scan'208";a="568566593"
Date: Wed, 19 May 2010 11:57:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20100519095718.GA2903@sortiz.org>
References: <20100519140310.e439960d.sfr@canb.auug.org.au>
 <20100519042333.GA8818@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519042333.GA8818@bnru02.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Wed, May 19, 2010 at 09:53:35AM +0530, Rabin VINCENT wrote:
> On Wed, May 19, 2010 at 06:03:10 +0200, Stephen Rothwell wrote:
> > After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > drivers/mfd/ab8500-core.c: In function 'ab8500_irq_remove':
> > drivers/mfd/ab8500-core.c:302: error: implicit declaration of function 'set_irq_flags'
> > 
> > Caused by commit 16548223daf6b3b95b75cb961d772831a754e126 ("mfd: new
> > AB8500 driver").
> 
> Oops, one of the calls to set_irq_flags() is missing a CONFIG_ARM.  The
> patch below should fix it.  Thanks.
Patch merged with the main ab8500 one, thanks for the quick fix.
Stephen, this is pushed and the mfd tree should be fine now.

Cheers,
Samuel.


> From 39368228513c8b429daa274362e7bfe80598b366 Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> Date: Wed, 19 May 2010 09:41:56 +0530
> Subject: [PATCH] mfd: ab8500: fix build on !ARM
> 
> Add a missing CONFIG_ARM around one of the calls to set_irq_flags(), to
> prevent these errors on other archs:
> 
> drivers/mfd/ab8500-core.c: In function 'ab8500_irq_remove':
> drivers/mfd/ab8500-core.c:302: error: implicit declaration of function 'set_irq_flags'
> 
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>  drivers/mfd/ab8500-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index e93833f..f3d26fa 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -299,7 +299,9 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
>  	int irq;
>  
>  	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
> +#ifdef CONFIG_ARM
>  		set_irq_flags(irq, 0);
> +#endif
>  		set_irq_chip_and_handler(irq, NULL, NULL);
>  		set_irq_chip_data(irq, NULL);
>  	}
> -- 
> 1.7.0
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
