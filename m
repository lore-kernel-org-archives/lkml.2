Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1BQOzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:55:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48238 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756233Ab1BQOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:55:49 -0500
Date: Thu, 17 Feb 2011 09:55:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 2/2] PM: Make system-wide PM and runtime PM handle
 subsystems consistently
In-Reply-To: <201102170045.48975.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1102170951330.2153-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Rafael J. Wysocki wrote:

> > > Apart from this I think the order of checks introduced by the $subject patch
> > > should be:
> > > (1) If dev->class != NULL and dev->class->pm != NULL, use dev->class,
> > >     or otherwise
> > > (2) if dev->type != NULL and dev->type->pm != NULL, use dev->type,
> > >     or otherwise
> > > (3) use dev->bus (if present).
> > > as that would allow classes and device types to override bus type PM
> > > callbacks if they wish to.
> > 
> > I haven't heard of any device types being present on more than one kind
> > of bus, so it makes sense for device types to override bus types.
> 
> OK
> 
> > But I'm not so sure about the priority we should give to classes.  On the
> > other hand, if no classes define a dev_pm_ops then of course it doesn't
> > matter.
> 
> The change will also affect classes that provide "legacy" suspend-resume
> (if there are any, which I'm totally unsure of).
> 
> Anyway, I think we need to choose one ordering. :-)
> 
> What about type / bus / class , then?

I really don't know.  Somebody who has more experience with device 
class implementations should answer.

Greg, any ideas?

To recap: The issue is how to handle multiple PM callbacks.  Since the
bus type, device type, and device class may all have their own
callbacks, Rafael has decided the best approach is to prioritize them
and invoke only the highest-priority callback.  But what priority order
should we use?

Alan Stern

