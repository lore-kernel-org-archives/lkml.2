Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1LBTTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:19:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59172 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1LBTTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:19:23 -0500
Date: Fri, 2 Dec 2011 19:19:17 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111202191917.GB3037@localhost.localdomain>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
 <20111110152606.GB3207@oksana.dev.rtsoft.ru>
 <20111110153816.239af1d7@lxorguk.ukuu.org.uk>
 <20111110162859.GA7088@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 08:28:59PM +0400, Anton Vorontsov wrote:
> Drivers should not use NO_IRQ; moreover, some architectures don't
> have it nowadays. '0' is the 'no irq' case.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Acked-by: Alan Cox <alan@linux.intel.com>
> ---
> 
> On Thu, Nov 10, 2011 at 03:38:16PM +0000, Alan Cox wrote:
> > On Thu, 10 Nov 2011 19:26:06 +0400
> > Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > 
> > > Drivers should not use NO_IRQ; moreover, some architectures don't
> > > have it nowadays. '0' is the 'no irq' case.
> > > 
> > > Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> > 
> > Acked-by: Alan Cox <alan@linux.intel.com>
> 
> In case if we don't want a "band-aid fix" for 3.2, here is the patch
> that just does the proper fix (w/ a risk to break minor architectures).

This is now broken on ARM where, for good or bad, NO_IRQ currently is
used and is -1.

How do we resolve it?  If we are ready to eliminate NO_IRQ from
drivers/of/irq.c (or indeed, all code that uses it) and just use 0 for
that case, we should surely just do it... but I'm not confident I can
judge on that.

Half-removing NO_IRQ is going to be problematic, though...
I really don't care whether the "no irq" value is 0 or -1, but it is
abundantly clear that choosing different values to mean the same thing
on opposite sides of an interface does not work.

Cheers
---Dave

> 
>  drivers/ata/pata_of_platform.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
> index a72ab0d..2a472c5 100644
> --- a/drivers/ata/pata_of_platform.c
> +++ b/drivers/ata/pata_of_platform.c
> @@ -52,7 +52,7 @@ static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
>  	}
>  
>  	ret = of_irq_to_resource(dn, 0, &irq_res);
> -	if (ret == NO_IRQ)
> +	if (!ret)
>  		irq_res.start = irq_res.end = 0;
>  	else
>  		irq_res.flags = 0;
> -- 
> 1.7.5.3
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
