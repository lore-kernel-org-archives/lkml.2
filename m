Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2FNJzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:55:02 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58806 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2FNJzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:55:00 -0400
Date: Thu, 14 Jun 2012 11:56:17 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915: ignore pipe select bit when checking for
 LVDS register initialization
Message-ID: <20120614095617.GA4797@phenom.ffwll.local>
Mail-Followup-To: dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20120613162544.GJ4829@phenom.ffwll.local>
 <1339613218-4699-1-git-send-email-seth.forshee@canonical.com>
 <20120613194614.GP4829@phenom.ffwll.local>
 <20120613202600.GA3761@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613202600.GA3761@thinkpad-t410>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 03:26:00PM -0500, Seth Forshee wrote:
> On Wed, Jun 13, 2012 at 09:46:15PM +0200, Daniel Vetter wrote:
> > On Wed, Jun 13, 2012 at 01:46:58PM -0500, Seth Forshee wrote:
> > > The Lenovo Thinkpad T410 has the LVDS_PIPEB_SELECT bit set in the LVDS
> > > register when booted with the lid closed, even though the LVDS hasn't
> > > really been initialized. Ignore this bit so that the VBT value will be
> > > used instead.
> > > 
> > > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > Queued for -next, thanks for the patch. Chris had some reservations about
> > the sanity of this patch, but given that it works around bios-insanity I'm
> > gonna just take this chance to stab myself with lvds-machines blowing up
> > left and right ;-)
> 
> Let's hope that doesn't happen ;)
> 
> I do find myself wondering though whether it might be better to prefer
> the value from the VBT whenever there's one available, and only rely on
> the actual register value as a fallback, since the bios can't be trusted
> to initialize the register. I'm pretty ignorant about all this graphics
> stuff though; I assume there's a reason it isn't done this way?

The usual reasoning is that if it's in the register, it's the value that
makes something show up on the screen and hence has a higher change of
being right. Yep, BIOS routinely store total garbage in vbt (or the newer
OpRegion) and somehow fix that up when copying things to the hw :(
Obviously there's also the other case where the hw values aren't set up,
in which case we try to try to fall back to vbt values.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
