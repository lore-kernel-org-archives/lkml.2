Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1HVWBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:01:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1HVWBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:01:05 -0400
Date: Mon, 22 Aug 2011 14:51:51 -0700
From: Greg KH <gregkh@suse.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for
 uevent
Message-ID: <20110822215151.GA18397@suse.de>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
 <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
 <4E4937A4.5070204@linutronix.de>
 <CACxGe6sAOYf3r4i1no=+-RgTLuiRbxYkcy+9VFXaCZOXUOi_uw@mail.gmail.com>
 <20110822214154.GB20451@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110822214154.GB20451@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:41:54PM -0700, Sarah Sharp wrote:
> On Mon, Aug 15, 2011 at 09:17:41AM -0600, Grant Likely wrote:
> > On Mon, Aug 15, 2011 at 9:13 AM, Sebastian Andrzej Siewior
> > <bigeasy@linutronix.de> wrote:
> > > Grant Likely wrote:
> > >>>
> > >>> --- a/drivers/base/platform.c
> > >>> +++ b/drivers/base/platform.c
> > >>> @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct
> > >>> kobj_uevent_env *env)
> > >>>               return rc;
> > >>>
> > >>>       add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
> > >>> -               (pdev->id_entry) ? pdev->id_entry->name : pdev->name);
> > >>> +                       pdev->name);
> > >>
> > >> Yes, this looks like the right thing to do to me.  Also, I think the
> > >> original code is suspect because it causes the uevent data to be
> > >> different after binding a driver to a device.
> > >
> > > Why different? The code matches (pdev->name == id->name) or
> > > (pdev->name ==  driver->name) so in both cases it should be equal to
> > > pdev->name.
> > >
> > > Are you or Greg taking this?
> > 
> > This one is all Greg.
> 
> Greg, do you want to take this patch through your driver core tree, or
> would you prefer to have it come through the xHCI tree?

I'll take it in my driver-core tree separate, as the others don't depend
on this one, right?

greg k-h
