Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1BAKwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:52:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab1BAKwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:52:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Date: Tue, 1 Feb 2011 11:52:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>
References: <201101300107.19389.rjw@sisk.pl> <878vy01udd.fsf@ti.com>
In-Reply-To: <878vy01udd.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011152.21200.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 01, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Hi,
> >
> > This is something we discussed during the last Linux Plumbers Conference.
> >
> > The problem appears to be that the same device may be used in different
> > systems in different configurations such that actions necessary for the
> > device's power management can vary from one system to another.  In those
> > cases the drivers' power management callbacks are generally not sufficient,
> > because they can't take the configuration of the whole system into account.
> >
> > I think this issue may be addressed by adding objects that will represent
> > power domains and will provide power management callbacks to be executed
> > in addition to the device driver's PM callbacks, which is done by the patch
> > below.
> >
> > Please have a look at it and tell me what you think.
> >
> 
> FYI... I just tested this patch on OMAP by converting our existing use
> of platform_bus_set_ops() to use this approach by adding a powerdomain
> to each omap_device.   
> 
> Note we're currently only overriding the runtime_[suspend|resume]
> methods, so those are the only paths I've tested.

Thanks a lot for the testing!

I'm going to prepare a new version of the patch that will add power domain
objects at the core level (ie. struct device).

Rafael
