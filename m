Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445Ab1DPWYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 18:24:19 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:55553 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759197Ab1DPWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 18:24:14 -0400
Subject: Re: [RFC][PATCH] PM: Make power domain callbacks take precedence
 over subsystem ones
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <201104160118.24113.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1104151033020.2051-100000@iolanthe.rowland.org>
	 <201104160118.24113.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments, Inc.
Date: Sat, 16 Apr 2011 10:15:33 -0700
Message-ID: <1302974133.2719.31.camel@vence>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 01:18 +0200, Rafael J. Wysocki wrote:
> On Friday, April 15, 2011, Alan Stern wrote:
> > On Fri, 15 Apr 2011, Rafael J. Wysocki wrote:
> > 
> > > On Thursday, April 14, 2011, Magnus Damm wrote:
> > 
> > > > My only thought on this is if we really want to limit ourselves to
> > > > only control power domains using these callbacks. I can imagine that
> > > > some SoCs want to do other non-power domain specific operations with
> > > > these callbacks, and if so, perhaps using the term power domain as
> > > > name of the pointer in struct device would be somewhat odd. OTOH, I
> > > > really dislike naming discussions in general and I can't really think
> > > > of any good names. So it all looks more like a set of system specific
> > > > PM override hooks.
> > > > 
> > > > Or is there something that is really power domain specific with these hooks?
> > > 
> > > Not in principle, but I think there is.  Namely, if there are two groups
> > > of devices belonging to the same bus type (e.g. platform) that each require
> > > different PM handling, it is legitimate to call them "power domains" (where
> > > "domain" means "a set of devices related to each other because of the way
> > > they need to be handled"), even if they don't share power resources.
> > > 
> > > Of course, if they do share power resources, the term is just right. :-)
> > 
> > They could be called "PM domains" instead of "power domains".  That's 
> > legitimate because they do get used by the PM core, even if they don't 
> > literally involve groups of devices sharing the same power supply.
> 
> Well, "power domain" can be regarded as a short form of "power management
> domain", which makes the point kind of moot. ;-)

Except that on most embedded SoCs, the term power domain has specific
meaning in hardware, so using something other than that is preferred
IMO.

What this really is is just per-device dev_pm_ops, which platform code
can use to group devices however it likes.

So rather than call it a power domain, or a PM domain, we could also
just add a struct dev_pm_ops to struct device. 

Kevin


