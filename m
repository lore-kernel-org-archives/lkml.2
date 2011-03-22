Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1CVXr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:47:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58122 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1CVXrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:47:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay.sievers@suse.de>
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Date: Wed, 23 Mar 2011 00:47:58 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103222305.01808.rjw@sisk.pl> <1300835111.1815.69.camel@zag>
In-Reply-To: <1300835111.1815.69.camel@zag>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103230047.58221.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 23, 2011, Kay Sievers wrote:
> On Tue, 2011-03-22 at 23:05 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, March 22, 2011, Kay Sievers wrote:
> 
> > >> Because they are devices, and there is a lot to win, if the kernel
> > > exports all "devices" in the same way. This is not about saving an inode
> > > in /sys, it's the ability to do runtime device configuration with common
> > > tools.
> > 
> > If I understand you correctly, the goal is to have everything under
> > /sys/devices/ been represented by struct device objects and there are good
> > reasons to do that.
> > 
> > In that case we either have to move the things exported via sysdevs somewhere
> > else (presumably having to create that "somewhere" before), or we have to
> > introduce struct device objects specifically for exporting them.  I don't
> > really think the latter approach will be very popular, so quite likely we'll
> > need to have a plan for moving those things to different locations.
> 
> Ok, now that we sorted the misunderstanding out, let's start this topic
> from here again. (I really read your reply as: "let's move the CPUS
> somewhere else")

Well, I didn't mean that. :-)

> What's the list of stuff you discovered using sysdevs, which is not a
> device at all, and has never more than a single instance of stuff of the
> same type? The clocksource?
> 
> And let's find some place for them to put their properties instead of
> messing around with device from the driver core.

On x86 the clocksource will be the only remaining one after my changes
recently posted.  In fact, it will be the only remaining one except for the
CPUs. :-)

The other architectures are a mixed bag, though.  First, there's some exported
stuff similar to the clocksource.  For one example, there's the "leds" sysdev
in arch/arm/kernel/leds.c that appears to export one attribute (in addition
to implementing suspend/resume/shutdown which I'm going to move to syscore_ops).
Second, there's some outright abuse here-and-there that may be removed entirely.
Finally, there are things that probably may be converted to struct devices,
in the powerpc tree in particular IIRC.

IMHO all of these things will have to be considered on the case-by-case basis
and discussed with the appropriate maintainers.

Thanks,
Rafael
