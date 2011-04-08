Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab1DHW6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:58:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:33912 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab1DHW6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:58:46 -0400
Date: Fri, 8 Apr 2011 15:59:28 -0700
From: Greg KH <gregkh@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Andres Salomon <dilinger@queued.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC] [PATCH] mfd: Fetch cell pointer from
 platform_device->mfd_cell
Message-ID: <20110408225928.GA28190@suse.de>
References: <20110408004007.GC3923@sortiz-mobl>
 <20110407193855.1e9182bb@debxo>
 <20110408225451.GC30969@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408225451.GC30969@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 09, 2011 at 12:54:52AM +0200, Samuel Ortiz wrote:
> Hi Andres,
> 
> On Thu, Apr 07, 2011 at 07:38:55PM -0700, Andres Salomon wrote:
> > > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > > index f051cff..6c3a2bd 100644
> > > --- a/drivers/base/platform.c
> > > +++ b/drivers/base/platform.c
> > > @@ -149,6 +149,7 @@ static void platform_device_release(struct device
> > > *dev) 
> > >  	of_device_node_put(&pa->pdev.dev);
> > >  	kfree(pa->pdev.dev.platform_data);
> > > +	kfree(pa->pdev.mfd_cell);
> > 
> > Hm, given that most platform devices won't be mfd devices (and thus
> > mfd_cell will be NULL), is it better to rely on kfree's
> > unlikely(ZERO_OR_NULL_PTR(...)), or have this be "if
> > (pa->pdev.mfd_cell) kfree(pa->pdev.mfd_cell);"?
> I'd say the former (obviously), unless Greg wants it to be otherwise.

Yes, as the patch was originally written is fine with me.

thanks,

greg k-h
