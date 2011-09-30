Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1I3RJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:09:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab1I3RJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:09:25 -0400
Date: Fri, 30 Sep 2011 10:09:14 -0700
From: Greg KH <gregkh@suse.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for
 uevent
Message-ID: <20110930170914.GA15341@suse.de>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
 <20110930132914.GA877@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930132914.GA877@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 04:29:16PM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Aug 15, 2011 at 04:51:22PM +0200, Sebastian Andrzej Siewior wrote:
> > If id_entry is available then it is used. However if we remove first the
> > driver followed by the device, then the id_entry is pointing to driver's
> > memory which is long gone.
> > Since id->name and plat->name are equal there is no point in
> > distinguishing them.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  drivers/base/platform.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 0cad9c7..cd71575 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
> >  		return rc;
> >  
> >  	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
> > -		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
> > +			pdev->name);
> >  	return 0;
> >  }
> >  
> 
> Just a gentle reminder on this patch. Greg, has this one been queued to
> your drivers-core tree ? Should it go on -rc or now it's already too
> late and going on merge window ?

It's been in my drivers-core tree for a while, and I didn't think it was
needed for 3.1, as it didn't solve an existing bug, did it?

It's queued for 3.2, does it need to get into 3.1-stable?  If so, I can
do that.

thanks,

greg k-h
