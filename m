Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1DNWph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:45:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52090 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab1DNWpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:45:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC][PATCH] PM: Make power domain callbacks take precedence over subsystem ones
Date: Fri, 15 Apr 2011 00:45:54 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104130205.26988.rjw@sisk.pl> <BANLkTimQ6kX41-53Dw2RqEVyYzbT2qbz9Q@mail.gmail.com>
In-Reply-To: <BANLkTimQ6kX41-53Dw2RqEVyYzbT2qbz9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104150045.54904.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 14, 2011, Magnus Damm wrote:
> Hi Rafael,
> 
> On Wed, Apr 13, 2011 at 9:05 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Change the PM core's behavior related to power domains in such a way
> > that, if a power domain is defined for a given device, its callbacks
> > will be executed instead of and not in addition to the device
> > subsystem's PM callbacks.
> 
> Thanks for your work on this! I'm very happy to see a more fine
> grained interface for SoC specific code compared to the weak symbols
> and other coarse grained alternatives for the platform bus.
> 
> My only thought on this is if we really want to limit ourselves to
> only control power domains using these callbacks. I can imagine that
> some SoCs want to do other non-power domain specific operations with
> these callbacks, and if so, perhaps using the term power domain as
> name of the pointer in struct device would be somewhat odd. OTOH, I
> really dislike naming discussions in general and I can't really think
> of any good names. So it all looks more like a set of system specific
> PM override hooks.
> 
> Or is there something that is really power domain specific with these hooks?

Not in principle, but I think there is.  Namely, if there are two groups
of devices belonging to the same bus type (e.g. platform) that each require
different PM handling, it is legitimate to call them "power domains" (where
"domain" means "a set of devices related to each other because of the way
they need to be handled"), even if they don't share power resources.

Of course, if they do share power resources, the term is just right. :-)

Thanks,
Rafael
