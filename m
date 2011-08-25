Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1HYV2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:28:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41772 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753964Ab1HYV23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:28:29 -0400
X-Sasl-enc: phhqVDWMh/Lz2X+eWOAyemYkyTSjFHbv8CZ90sYKTP44 1314307706
Date: Thu, 25 Aug 2011 14:28:20 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 22/59] Staging: hv: vmbus: Get rid of the unused name
 field in struct hv_driver
Message-ID: <20110825212820.GA6770@kroah.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-22-git-send-email-kys@microsoft.com>
 <20110825212428.GA1617@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825212428.GA1617@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 02:24:28PM -0700, Greg KH wrote:
> On Thu, Aug 25, 2011 at 09:48:48AM -0700, K. Y. Srinivasan wrote:
> > Get rid of the unused "name" field in struct hv_driver.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/hyperv.h |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
> > index b8199f4..60ead66 100644
> > --- a/drivers/staging/hv/hyperv.h
> > +++ b/drivers/staging/hv/hyperv.h
> > @@ -802,8 +802,6 @@ struct hv_device_info {
> >  
> >  /* Base driver object */
> >  struct hv_driver {
> > -	const char *name;
> 
> Wait, why is this unused?  What are you going to use as your name for
> the driver in sysfs then?  The module name?
> 
> As much as I love seeing things deleted, I really think you need this
> field.
> 
> Ah, yeah, I see why you think it's unneeded, crud like this in the
> drivers:
> 
> 	drv->driver.name = driver_name;
> 
> No vmbus driver should ever have to touch the base struct driver on it's
> own at all.  Your vmbus core should properly handle telling the driver
> core what the name of the driver is.
> 
> As an example, see the __pci_register_driver() function, the first thing
> that code does is set the name based on the name of the larger
> pci_driver structure passed to it.
> 
> Man, if you want something done right, you have to do it yourself, let
> me go make these changes so you don't have to do any new work at this
> point in time, hopefully your other patches will apply...

What, vmbus_child_driver_register() takes a struct driver *?

No wonder things are so messed up here, and why you got confused.  Let
me pound on this for a bit to see if I can get it cleaned up to be more
"sane"...

greg k-h
