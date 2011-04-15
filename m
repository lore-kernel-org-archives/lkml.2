Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1DOOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:34:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47858 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754271Ab1DOOes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:34:48 -0400
Date: Fri, 15 Apr 2011 10:34:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        <linux-sh@vger.kernel.org>, <lethal@linux-sh.org>
Subject: Re: [RFC][PATCH] PM: Make power domain callbacks take precedence
 over subsystem ones
In-Reply-To: <201104150045.54904.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1104151033020.2051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Rafael J. Wysocki wrote:

> On Thursday, April 14, 2011, Magnus Damm wrote:

> > My only thought on this is if we really want to limit ourselves to
> > only control power domains using these callbacks. I can imagine that
> > some SoCs want to do other non-power domain specific operations with
> > these callbacks, and if so, perhaps using the term power domain as
> > name of the pointer in struct device would be somewhat odd. OTOH, I
> > really dislike naming discussions in general and I can't really think
> > of any good names. So it all looks more like a set of system specific
> > PM override hooks.
> > 
> > Or is there something that is really power domain specific with these hooks?
> 
> Not in principle, but I think there is.  Namely, if there are two groups
> of devices belonging to the same bus type (e.g. platform) that each require
> different PM handling, it is legitimate to call them "power domains" (where
> "domain" means "a set of devices related to each other because of the way
> they need to be handled"), even if they don't share power resources.
> 
> Of course, if they do share power resources, the term is just right. :-)

They could be called "PM domains" instead of "power domains".  That's 
legitimate because they do get used by the PM core, even if they don't 
literally involve groups of devices sharing the same power supply.

Alan Stern

