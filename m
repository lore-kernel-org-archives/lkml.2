Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab2HEVNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:13:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33431 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2HEVNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:13:53 -0400
Date: Sun, 5 Aug 2012 23:14:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Matthew Garrett <mjg59@srcf.ucam.org>, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120805211412.GG12232@phenom.ffwll.local>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
 <20120803162451.GF8165@thinkpad-t410>
 <20120803162702.GA22896@srcf.ucam.org>
 <20120804165727.GA4980@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120804165727.GA4980@thinkpad-t410>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 11:57:27AM -0500, Seth Forshee wrote:
> On Fri, Aug 03, 2012 at 05:27:02PM +0100, Matthew Garrett wrote:
> > On Fri, Aug 03, 2012 at 11:24:51AM -0500, Seth Forshee wrote:
> > 
> > > This is one of the things I wasn't so sure about. There are various
> > > checks in intel_lvds_init() that can cause it to bail out before we try
> > > to get the EDID, and I don't fully understand all of them. If non-laptop
> > > machines are expected to bail out before the EDID check then the
> > > approach I've taken seems reasonable. Otherwise adding a quirk probably
> > > is a good idea.
> > 
> > I know we've previously had problems with machines with phantom LVDS 
> > hardware, but I'm not sure what the current state of affairs is.
> 
> It turns out that the framebuffer console issue is due to not having a
> mode when initializing LVDS. As a result 1024x768 is getting used for
> the framebuffer.
> 
> So quirking is going to fix this situation. In fact, with the changes
> below switcheroo seems to work perfectly, without any of these patches
> at all.

I like this approach more - the only other solution I see is to ask the
currently active driver (i.e. radeon) at bootime for the right mode. Which
sounds much more hellish and fragile ...
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
