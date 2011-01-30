Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1A3Wjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 17:39:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50650 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab1A3Wjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 17:39:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Date: Sun, 30 Jan 2011 23:39:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.1101301100090.6500-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101301100090.6500-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101302339.02993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 30, 2011, Alan Stern wrote:
> On Sun, 30 Jan 2011, Rafael J. Wysocki wrote:
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
> 
> One thing about this implementation is slightly questionable.  The new
> power_domain callbacks were added to the __weak platform PM routines,
> which means they will have to be included in every overriding routine
> provided by a platform imiplementation.
> 
> Would it be better to separate these things?  Have the power_domain 
> callbacks occur in a static outer function which then calls a public 
> __weak inner function that can be overridden?

That certainly is a good idea, but I wasn't sure how to do that.  It looks
like I could keep the __weak functions as they are and modify
platform_dev_pm_ops instead to point to a new set of function that in turn
would call the __weak ones.  For example, the .suspend pointer in
platform_dev_pm_ops might point to a new function, say
platform_pm_full_suspend() that would call the power domain functions and
the "original" platform_pm_suspend().  Is that what you mean?

Rafael
