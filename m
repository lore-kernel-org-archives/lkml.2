Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab1JHEEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 00:04:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50750 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1JHEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 00:04:05 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.15.19
Date: Fri, 7 Oct 2011 21:03:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Greg KH <greg@kroah.com>
Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
Message-ID: <20111008040351.GA7694@leaf>
References: <1317963790-29426-1-git-send-email-manjugk@ti.com>
 <1317963790-29426-3-git-send-email-manjugk@ti.com>
 <20111007064928.GE27508@kroah.com>
 <20111007205715.GC5275@leaf>
 <20111007212326.GA29003@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007212326.GA29003@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 02:23:26PM -0700, Greg KH wrote:
> On Fri, Oct 07, 2011 at 01:57:15PM -0700, Josh Triplett wrote:
> > On Thu, Oct 06, 2011 at 11:49:28PM -0700, Greg KH wrote:
> > > On Fri, Oct 07, 2011 at 10:33:07AM +0500, G, Manjunath Kondaiah wrote:
> > > > +config PROBE_DEFER
> > > > +	bool "Deferred Driver Probe"
> > > > +	default y
> > > > +	help
> > > > +	  This option provides deferring driver probe if it has dependency on
> > > > +	  other driver. Without this feature, initcall ordering should be done
> > > > +	  manually to resolve driver dependencies. This feature completely side
> > > > +	  steps the issues by allowing driver registration to occur in any
> > > > +	  order, and any driver can request to be retried after a few more other
> > > > +	  drivers get probed.
> > > 
> > > Why is this even an option?  Why would you ever want it disabled?  Why
> > > does it need to be selected?
> > > 
> > > If you are going to default something to 'y' then just make it so it
> > > can't be turned off any other way by just not making it an option at
> > > all.
> > 
> > Given that the drivers which use this mechanism will not necessarily get
> > built into the kernel, I'd suggest that it should remain optional and
> > default to n.  Those drivers can then add a dependency on PROBE_DEFER.
> > Let's try to avoid adding more infrastructure to the kernel that takes
> > up space even when unused; certainly embedded will appreciate not having
> > this feature unless a driver needs it.
> 
> How much extra space is this "feature" really?

Just checked: 776 bytes, 640 of text and 136 of data.  We have kconfig
options for comparable amounts.

> I don't see it being
> anything larger than the amount of memory increase that just happened as
> I typed this email as part of the ongoing memory density changes.

I don't know about the changes you mean, but in any case I'd like to
prevent mandatory size increases wherever possible.  I'd love to see the
size of "allnoconfig" getting *smaller* over time, not larger.

- Josh Triplett
