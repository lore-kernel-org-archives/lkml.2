Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab1DNCYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:24:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:52936 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab1DNCYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:24:42 -0400
Date: Wed, 13 Apr 2011 19:16:35 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] usb: gadget: storage_common: use kstrto*()
Message-ID: <20110414021635.GA13169@suse.de>
References: <c7bc1074f7cd049786ac2d50fe71b5e3ca0beba2.1302732994.git.mina86@mina86.com>
 <8739llk6m0.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739llk6m0.fsf@erwin.mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 02:40:39AM +0200, Michal Nazarewicz wrote:
> This commit replaces the usage of strict_strtoul() (which
> became deprecated after commit 33ee3b2e) with kstrtouint().
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/gadget/storage_common.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> > @@ -711,10 +711,11 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
> >  	ssize_t		rc = count;
> >  	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
> >  	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
> > -	unsigned long	ro;
> > +	unsigned	ro;
> >  
> > -	if (strict_strtoul(buf, 2, &ro))
> > -		return -EINVAL;
> > +	rc = kstrtouint(buf, 2, &ro);
> > +	if (rc)
> > +		return rc;
> >  
> 
> Sorry, I've just noticed this zeroes the rc so that the function returns
> invalid read length.  Attached patch has the following delta included:

Ugh, I applied the first one already :(

Care to send a follow-on patch that fixes this properly?

thanks,

greg k-h
