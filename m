Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1DSVmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:42:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab1DSVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:41:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Add generic clock manipulation rountines for runtime PM
Date: Tue, 19 Apr 2011 23:42:26 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104182159.54316.rjw@sisk.pl> <BANLkTimZpXAH7uGTDmYJSJJWgX=H5md0JQ@mail.gmail.com>
In-Reply-To: <BANLkTimZpXAH7uGTDmYJSJJWgX=H5md0JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104192342.26670.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 19, 2011, Magnus Damm wrote:
> Hi Rafael,
> 
> On Tue, Apr 19, 2011 at 4:59 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Many different platforms and subsystems may want to disable device
> > clocks during suspend and enable them during resume which is going to
> > be done in a very similar way in all those cases.  For this reason,
> > provide generic routines for the manipulation of device clocks during
> > suspend and resume.
> >
> > Convert the ARM shmobile platform to using the new routines.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >
> > Hi,
> >
> > The previous version of the patch had a build problem for CONFIG_HAVE_CLK
> > unset and a the name of pm_runtime_clock_add_notifier() misspelled (a
> > couple of times).
> 
> Thanks for your work on this. I like that we get closer to a shared code base.
> 
> Do you have any plans to add support for multiple clocks per struct
> device? I had some plans to play around with that myself, but if we're
> moving the code to a common place then this obviously becomes a bit
> more complicated.
> 
> It's rather common that each hardware block in an SoC is connected to
> more than a single clock. This needs to be managed by software
> somehow.
> 
> So if the plan is to make to the code generic, how about allowing the
> architecture to associate clocks with each struct device somehow?

Hmm.  For now, my patchset generally reorganizes the existing code without
adding new functionality.  Of course, it is possible to add new functionality
on top of it, but I'd prefer to focus on the "real" power domains support
first (which I think should be done in a generic way too).

The plan is to share as much code as it makes sense between platforms and
architectures.

Thanks,
Rafael
