Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2HEVj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:39:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58622 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2HEVj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:39:57 -0400
Date: Sun, 5 Aug 2012 23:40:16 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
Message-ID: <20120805214016.GH12232@phenom.ffwll.local>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
 <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
 <20120803161416.GA22563@srcf.ucam.org>
 <20120803162451.GF8165@thinkpad-t410>
 <20120803162702.GA22896@srcf.ucam.org>
 <20120804165727.GA4980@thinkpad-t410>
 <20120805211412.GG12232@phenom.ffwll.local>
 <20120805211838.GA27188@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120805211838.GA27188@srcf.ucam.org>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 10:18:38PM +0100, Matthew Garrett wrote:
> On Sun, Aug 05, 2012 at 11:14:12PM +0200, Daniel Vetter wrote:
> 
> > I like this approach more - the only other solution I see is to ask the
> > currently active driver (i.e. radeon) at bootime for the right mode. Which
> > sounds much more hellish and fragile ...
> 
> The "correct" approach is clearly to just have the drm core change the 
> i2c mux before requesting edid, but that's made difficult because of the 
> absence of ordering guarantees in initialisation. I don't like quirking 
> this, since we're then back to the situation of potentially having to 
> add every new piece of related hardware to the quirk list.

The "correct" approach of switching the mux before we fetch the edid is
actualy the one I fear will result in fragile code: Only run on few
machines, and as you say with tons of funky interactions with the init
sequence ordering. And I guess people will bitch&moan about the flickering
this will cause ;-)

As long as it's only apple shipping multi-gpu machines with
broken/non-existing vbt, I'll happily stomach the quirk list entries.
They're bad, but imo the lesser evil.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
