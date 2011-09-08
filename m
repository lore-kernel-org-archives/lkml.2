Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1IHMin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:38:43 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:52320 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab1IHMim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:38:42 -0400
X-IronPort-AV: E=Sophos;i="4.68,350,1312156800"; 
   d="scan'208";a="7675413"
Date: Thu, 8 Sep 2011 13:46:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v3 1/2] xen: add an "highmem" parameter to
 alloc_xenballooned_pages
In-Reply-To: <4E67A377.3090004@goop.org>
Message-ID: <alpine.DEB.2.00.1109081346160.12963@kaball-desktop>
References: <alpine.DEB.2.00.1109071723470.12963@kaball-desktop> <1315413571-10938-1-git-send-email-stefano.stabellini@eu.citrix.com> <4E67A377.3090004@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, Jeremy Fitzhardinge wrote:
> > diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> > index f914b26..07a56c2 100644
> > --- a/drivers/xen/gntdev.c
> > +++ b/drivers/xen/gntdev.c
> > @@ -123,7 +123,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
> >  	    NULL == add->pages)
> >  		goto err;
> >  
> > -	if (alloc_xenballooned_pages(count, add->pages))
> > +	if (alloc_xenballooned_pages(count, add->pages, 0 /* lowmem */))
> 
> If the parameter is "bool" you should pass true/false.  But it might be
> better to just make it take a GFP_ constant directly.

I would rather have a bool to be consistent with the other balloon
interfaces.
