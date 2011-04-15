Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1DOXSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:18:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1DOXSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:18:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Make power domain callbacks take precedence over subsystem ones
Date: Sat, 16 Apr 2011 01:18:23 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org
References: <Pine.LNX.4.44L0.1104151033020.2051-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104151033020.2051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104160118.24113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 15, 2011, Alan Stern wrote:
> On Fri, 15 Apr 2011, Rafael J. Wysocki wrote:
> 
> > On Thursday, April 14, 2011, Magnus Damm wrote:
> 
> > > My only thought on this is if we really want to limit ourselves to
> > > only control power domains using these callbacks. I can imagine that
> > > some SoCs want to do other non-power domain specific operations with
> > > these callbacks, and if so, perhaps using the term power domain as
> > > name of the pointer in struct device would be somewhat odd. OTOH, I
> > > really dislike naming discussions in general and I can't really think
> > > of any good names. So it all looks more like a set of system specific
> > > PM override hooks.
> > > 
> > > Or is there something that is really power domain specific with these hooks?
> > 
> > Not in principle, but I think there is.  Namely, if there are two groups
> > of devices belonging to the same bus type (e.g. platform) that each require
> > different PM handling, it is legitimate to call them "power domains" (where
> > "domain" means "a set of devices related to each other because of the way
> > they need to be handled"), even if they don't share power resources.
> > 
> > Of course, if they do share power resources, the term is just right. :-)
> 
> They could be called "PM domains" instead of "power domains".  That's 
> legitimate because they do get used by the PM core, even if they don't 
> literally involve groups of devices sharing the same power supply.

Well, "power domain" can be regarded as a short form of "power management
domain", which makes the point kind of moot. ;-)

Rafael

