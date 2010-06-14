Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0FNSnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:43:09 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:35253 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750850Ab0FNSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:43:07 -0400
Date: Mon, 14 Jun 2010 14:42:44 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Dave Airlie <airlied@gmail.com>
Cc: tytso@mit.edu, Dave Airlie <airlied@redhat.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Message-ID: <20100614184244.GA11480@elliptictech.com>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>, tytso@mit.edu,
	Dave Airlie <airlied@redhat.com>,
	David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
 <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
 <20100613194949.GC8055@thunk.org>
 <AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06:00 Mon 14 Jun     , Dave Airlie wrote:
> On Mon, Jun 14, 2010 at 5:49 AM,  <tytso@mit.edu> wrote:
> > It's a Lenovo T400, with an Intel GPU:
> >
[...]
> > Why does KMS need to poll so frequently?  40 minutes of CPU time
> > accumulated in 4 hours of uptime translates to 16% of the CPU being
> > consumed by kslowd daemons, which seems... excessive.
> >
[...]
> > I have the following patch which I'm going to install later tonight to
> > see if I can figure out if it really is drm_crtc_helper.c which is
> > really responsible for all of the kslowd time being burned, but an
> > examination of the source doesn't seem to show any other that I'm
> > using that would likely be using the slow workqueue.
> 
> It most likely is, but polling shouldn't really be taking huge amounts
> of CPU, unless there are some u/mdelays in there which would be bad.
> 
> In theory on Intel with hotplug irqs we shouldn't be poilling at all,
> I must check why, the other thing is you could be suffering from the
> hotplug irq problem that others have reported, this would cause slow
> work triggers which aren't part of the normal poll cycle.

This sounds exactly like the issue I've been seeing on a T500 laptop, as
well (GM45 board).  The slowdowns render the system essentially
unusable, as it can spend a loooong time just moving the mouse cursor a
few pixels on the screen.  During this time, nothing else on the display
is updating (glxgears drops to 0fps).  Things generally seem to be
working fine if I am not moving the mouse, or if I'm not running X.

I do not have this issue on a desktop machine with a G45.

Unfortunately, bisection is proving difficult because the exact set of
conditions to trigger the problems seem to be eluding me: sometimes the
kernel will work perfectly fine for quite some time, and then go
downhill from there.  However, this is definitely a regression
introduced after 2.6.35-rc1.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
