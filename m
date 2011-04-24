Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab1DYACj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 20:02:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:49246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab1DYACg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 20:02:36 -0400
Date: Sun, 24 Apr 2011 16:36:44 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/9] PM: Rework shmobile and OMAP runtime PM using power
 domains (v2)
Message-ID: <20110424233644.GA20577@suse.de>
References: <201104130205.26988.rjw@sisk.pl>
 <201104170135.19388.rjw@sisk.pl>
 <201104242330.13607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104242330.13607.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 11:30:13PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Taking the feedback from the last version of the patchset into account
> I reworked patches [7/9] and [8/9] so that multiple clocks can be used for
> runtime PM.  I also fixed a couple of build issues (the patches have been
> built for x86, ARM/shmobile and ARM/OMAP1).
> 
> On Sunday, April 17, 2011, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The following series of patches is my attempt to consolidate the shmobile and
> > OMAP runtime PM code using power domains so that it is not necessary to
> > replace the platform bus type's runtime PM callbacks any more.
> > 
> > Some of the patches have already been posted, some are new and some are
> > from Kevin. :-)
> 
> The high-level description of what the patches do hasn't changed, so:
> 
> [1/9] - Make power domain callbacks take precedence over subsystem ones
>         (this one has been discussed already).
> 
> [2/9] - Export the platform bus type's default PM callbacks so that they
>         can be used in power domain objects.
> 
> [3/9] - Use a default power domain for runtime PM on shmobile (both ARM
>         and SH flavors) instead of replacing the platform bus type's
>         runtime PM callbacks (using __weak).
> 
> [4/9] - Use generic runtime PM callbacks directly in the platform bus type.
> 
> [5/9] - Move OMAP2 runtime PM implementation to using a power domain object
>         (patch from Kevin rebased on top of [1-4/9]).
> 
> [6/9] - Add subsystem data field to struct dev_pm_info.
> 
> [7/9] - Introduce generic clock manipulation routines for runtime PM and
>         convert ARM shmobile to using them.
> 
> [8/9] - Move OMAP1 runtime PM to the new core infrastructure.
> 
> [9/9] - Remove platform_bus_set_pm_ops() (patch from Kevin).
> 
> If there are no objections (or reports of breakage), I'd like to push these
> patches through the suspend-2.6 tree in the 2.6.40 merge window.

No objections from me at all, looks great, thanks for doing this.

greg k-h
