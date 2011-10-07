Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934885Ab1JGU5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:57:32 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46558 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab1JGU53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:57:29 -0400
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.15.19
Date: Fri, 7 Oct 2011 13:57:15 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Greg KH <greg@kroah.com>
Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
Message-ID: <20111007205715.GC5275@leaf>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-3-git-send-email-manjugk@ti.com>
 <20111007064928.GE27508@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007064928.GE27508@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 11:49:28PM -0700, Greg KH wrote:
> On Fri, Oct 07, 2011 at 10:33:07AM +0500, G, Manjunath Kondaiah wrote:
> > +config PROBE_DEFER
> > +	bool "Deferred Driver Probe"
> > +	default y
> > +	help
> > +	  This option provides deferring driver probe if it has dependency on
> > +	  other driver. Without this feature, initcall ordering should be done
> > +	  manually to resolve driver dependencies. This feature completely side
> > +	  steps the issues by allowing driver registration to occur in any
> > +	  order, and any driver can request to be retried after a few more other
> > +	  drivers get probed.
> 
> Why is this even an option?  Why would you ever want it disabled?  Why
> does it need to be selected?
> 
> If you are going to default something to 'y' then just make it so it
> can't be turned off any other way by just not making it an option at
> all.

Given that the drivers which use this mechanism will not necessarily get
built into the kernel, I'd suggest that it should remain optional and
default to n.  Those drivers can then add a dependency on PROBE_DEFER.
Let's try to avoid adding more infrastructure to the kernel that takes
up space even when unused; certainly embedded will appreciate not having
this feature unless a driver needs it.

(That said, it still feels to me like an explicit dependency mechanism
would make more sense than this "try again later" mechanism, but
nonetheless "try again later" seems like an improvement over what we
have now.)

> It also cleans up this diff a lot, as you really don't want #ifdef in .c
> files.

Ideally the entire .c file could become conditional on PROBE_DEFER via
kbuild, with the usual compatibility inlines in a .h file for the
!PROBE_DEFER case.

- Josh Triplett
