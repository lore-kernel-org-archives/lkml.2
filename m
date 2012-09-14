Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2INNdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:33:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:58026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2INNdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:33:42 -0400
Message-Id: <b94cdc$6jrqfm@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,423,1344236400"; 
   d="scan'208";a="222161398"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] i915: Quirk out disconnected backlight
To: David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1347628339.21322.16.camel@shinybook.infradead.org>
References: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca> <84c8a8$5o3dgr@orsmga001.jf.intel.com> <CACxGe6u0+LC4G-87PsEK3ys7qqeJ2WnqnCdaegMK7=M9xpA8ug@mail.gmail.com> <1347628339.21322.16.camel@shinybook.infradead.org>
Date: Fri, 14 Sep 2012 14:33:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012 14:12:19 +0100, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2012-09-14 at 14:09 +0100, Grant Likely wrote:
> > On Fri, Sep 14, 2012 at 2:01 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > > On Fri, 14 Sep 2012 13:57:06 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
> > >> Some platforms (for instance MacbookPros) have custom backlight drivers
> > >> and don't use the integrated i915 backlight control. This patch adds a
> > >> quirk to disable registering the intel backlight when unused on a
> > >> platform.
> > >>
> > >> Tested on MacbookPro8,3. Without this patch both the intel_backlight and
> > >> gmux_backlight devices get registered and userspace doesn't know which
> > >> it should use.
> > >
> > > Userspace is informed throught the backlight/type property.
> > 
> > Perhaps, but userspace (Ubuntu) isn't doing anything with it, and it
> > still remains that it makes no sense whatsoever to register a
> > backlight device that doesn't exist. 
> 
> Indeed. Userspace (well, gnome-settings-daemon) will use the backlight
> provided by X, in preference to anything it finds
> in /sys/class/backlight. So if the Intel one is present (and thus
> exposed via X) then userspace will never bother with comparing types and
> choosing the sanest backlight to use.
> 
> See https://bugzilla.redhat.com/show_bug.cgi?id=752595

And if you look at that bug, it starts off by complaining that a
workaround is required in order to use the intel_backlight. By the time
you hit the issue with apple_gmux, the upstream ddx already carried the
fix for a couple of months and even had it in a release. And more
recently we took a patch to allow the user to override which backlight is
preferred to handle the case of a broken platform/firmware interface
being selected instead of intel_backlight.

Userspace is indeed trying to do the right thing with the information
provided by the kernel. apple_gmux is not the only device with a phantom
PWM BLC, which is why the default preference is to use the
platform/firmware provided backlight interface, if any.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
