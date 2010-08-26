Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0HZS0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:26:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48574 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0HZS0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:26:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Thu, 26 Aug 2010 20:24:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <htejun@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008241811.22991.stephan.diestelhorst@amd.com> <201008261815.34574.stephan.diestelhorst@amd.com>
In-Reply-To: <201008261815.34574.stephan.diestelhorst@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008262024.35551.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 26, 2010, Stephan Diestelhorst wrote:
> On Tuesday 24 August 2010 18:11:22 Stephan Diestelhorst wrote:
> > On Tuesday 24 August 2010 18:07:23 Stephan Diestelhorst wrote:
> > > On Monday 23 August 2010 14:03:40 Tejun Heo wrote:
> > > > On 08/19/2010 06:23 PM, Stephan Diestelhorst wrote:
> > > > > It says "max_performance", I have not touched anyhting. So it has been
> > > > > like that all the time. Would this explain why your patch did not show
> > > > > the debug printout?
> > > > 
> > > > Hmm... okay.  Yeah, if you haven't been using IPM at all, there won't
> > > > be any debug messages but at the same time the posted patch should
> > > > have had the same effect as Rafael's patch as IPM path isn't traveled
> > > > at all.  Can you please check the followings?
> > > > 
> [...]
> > > > * Rafael's patch actually fixes the problem.  If you haven't been
> > > >   using IPM at all, Rafael's patch and mine should behave exactly the
> > > >   same (ie. no IPM operation at all during suspend/resume).  It could
> > > >   be that you're seeing a different issue.
> > > 
> > > That next on my list...
> 
> Just did the following: Rebased Rafaels patch to 2.6.35 and tried it
> again (with added prints to make sure I am running the right one) and
> did >10 suspend to ram / resume cycles under I/O write load. All of
> them worked fine (for comparison: your patch resulted in RO HDD at
> first attempt).
> 
> (I had some extra prints around the suspend functions changed in
>  Rafael's patch, tried with and without, no change--works flawlessly.)
> 
> What do you make of this?

I think my patch actually does more than the Tejun's one.  I need to have a
deeper look at them both.

I'm still testing the Tejun's patch on my system where I was able to reproduce
the problem, but so far it's been working.

Thanks,
Rafael
