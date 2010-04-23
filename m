Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0DWSvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:51:21 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:54379 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752231Ab0DWSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:51:18 -0400
Date: Fri, 23 Apr 2010 22:25:52 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Richard =?utf-8?Q?R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Vrabel <david.vrabel@csr.com>, Pierre Ossman <pierre@ossman.eu>,
       Ben Dooks <ben@simtec.co.uk>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sdhci-pltfm: Do not print errors in case of an
 extended iomem size
Message-ID: <20100423182552.GA4076@oksana.dev.rtsoft.ru>
References: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
 <20100316183430.GC25670@oksana.dev.rtsoft.ru>
 <4BA0708C.8070402@pelagicore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BA0708C.8070402@pelagicore.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 07:02:52AM +0100, Richard Röjfors wrote:
> On 3/16/10 7:34 PM, Anton Vorontsov wrote:
> > Some hosts have an extended SDHCI iomem size, so the driver should
> > only print errors if the iomem size is less than 0x100.
> 
> With this change you allow a bigger resource than we really need.
> I think you should also change request_mem_region and ioremap to only
> request and map the actual needed size. (0x100)

Sorry for the delayed response.

Why do you think that mapping more than "needed" is a bad thing?
Looking into the PCI driver, it just maps the whole PCI BAR (which
makes sense, since later SDHCI spec might easily introduce an
extended address space, so hardcoding 0x100 isn't very good).

There is another case when mapping the whole SDHCI mem space
might be convenient: if the platform code will want to use
the ioremapped region inside the platform hooks.

Thanks!

> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> >  drivers/mmc/host/sdhci-pltfm.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
> > index 217b911..b6ee0d7 100644
> > --- a/drivers/mmc/host/sdhci-pltfm.c
> > +++ b/drivers/mmc/host/sdhci-pltfm.c
> > @@ -61,7 +61,7 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
> >  		goto err;
> >  	}
> >  
> > -	if (resource_size(iomem) != 0x100)
> > +	if (resource_size(iomem) < 0x100)
> >  		dev_err(&pdev->dev, "Invalid iomem size. You may "
> >  			"experience problems.\n");
> >  
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
