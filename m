Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2FMU0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:26:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2FMU0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:26:05 -0400
Date: Wed, 13 Jun 2012 15:26:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915: ignore pipe select bit when checking for
 LVDS register initialization
Message-ID: <20120613202600.GA3761@thinkpad-t410>
Mail-Followup-To: dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20120613162544.GJ4829@phenom.ffwll.local>
 <1339613218-4699-1-git-send-email-seth.forshee@canonical.com>
 <20120613194614.GP4829@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613194614.GP4829@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:46:15PM +0200, Daniel Vetter wrote:
> On Wed, Jun 13, 2012 at 01:46:58PM -0500, Seth Forshee wrote:
> > The Lenovo Thinkpad T410 has the LVDS_PIPEB_SELECT bit set in the LVDS
> > register when booted with the lid closed, even though the LVDS hasn't
> > really been initialized. Ignore this bit so that the VBT value will be
> > used instead.
> > 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> Queued for -next, thanks for the patch. Chris had some reservations about
> the sanity of this patch, but given that it works around bios-insanity I'm
> gonna just take this chance to stab myself with lvds-machines blowing up
> left and right ;-)

Let's hope that doesn't happen ;)

I do find myself wondering though whether it might be better to prefer
the value from the VBT whenever there's one available, and only rely on
the actual register value as a fallback, since the bios can't be trusted
to initialize the register. I'm pretty ignorant about all this graphics
stuff though; I assume there's a reason it isn't done this way?

Seth

