Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1AaXX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:23:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37862 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1AaXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:23:28 -0500
Date: Mon, 31 Jan 2011 16:23:23 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Kevin Hilman <khilman@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Message-ID: <20110131232323.GA2978@angua.secretlab.ca>
References: <201101300107.19389.rjw@sisk.pl>
 <87tygo3br4.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tygo3br4.fsf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 03:16:15PM -0800, Kevin Hilman wrote:
> Hi Rafael,
> 
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
> 
> Very nice.  I like the approach and the fact that it allows grouping of
> only devices we care about customizing, instead of every device on the
> platform_bus (I know Grant will like that part too.  :)

:-D

> I experimented with something similar before I took the easy way out
> with platform_bus_set_pm_ops() :/
> 
> This approach might also solve the problem(s) we've been discussing
> around the conflicts between runtime PM callbacks and system PM
> callbacks (that RTC vs. i2c issue.)  With this approach, I shouldn't
> have to to add the callbacks like I did for the i2c driver, but rather
> handle them in common code.  I'll experiment with this...
> 
> The primary question for me is whether this should rather be at the
> 'struct device' level instead of at the platform_device level.  While
> we're currently only using this customization on platform_devices, I
> don't think we should limit it to that.  Part of these discussions at
> LPC was also about whether or not to move to using custom SoC-specific
> devices and busses.  If/when we go that route, we'd want these power
> domains part of struct device, not platform_device.

Definitely should be at the struct device level IMNSHO.

