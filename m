Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab1EFJog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:44:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:54508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab1EFJoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:44:34 -0400
Date: Fri, 6 May 2011 11:44:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the trivial tree with the ux500-core
 tree
In-Reply-To: <BANLkTimHgUorm4HKuX7veUNR6M1o9LiTNA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1105061144200.28291@pobox.suse.cz>
References: <20110429115948.e949234b.sfr@canb.auug.org.au> <BANLkTikJ5CVvS+P17T_Mhtqyb29vpDcmvw@mail.gmail.com> <alpine.LNX.2.00.1105051547000.28291@pobox.suse.cz> <BANLkTimHgUorm4HKuX7veUNR6M1o9LiTNA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011, Linus Walleij wrote:

> 2011/5/5 Jiri Kosina <jkosina@suse.cz>:
> > On Fri, 29 Apr 2011, Linus Walleij wrote:
> >>
> >> I rewrote the driver completely so likely it will rather be dropped, but
> >> please check! I'll be happy to carry any patches.
> >
> > Seems to me that all the calls to request_mem_region() and
> > release_mem_region() still need the resource_size() fixup even in the new
> > driver.
> 
> OK I went in and tweaked the patch like this:
> 
> 	if (request_mem_region(gpio->memres->start,
> 			       resource_size(gpio->memres),
> 			       "GPIO Controller")
> 	    == NULL) {
> 		dev_err(gpio->dev, "could not reserve GPIO memory region\n");
> 		err = -ENODEV;
> 		goto err_no_ioregion;
> 	}
> (...)
> err_no_ioremap:
> 	release_mem_region(gpio->memres->start, resource_size(gpio->memres));
> (...)
> 	release_mem_region(gpio->memres->start,
> 			   resource_size(gpio->memres));
> 
> It'll appear in the next tree tomorrow or so. OK?

Thanks. I have dropped Joe's patch from my queue now.

-- 
Jiri Kosina
SUSE Labs
