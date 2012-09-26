Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2IZKkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:40:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39170 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2IZKkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:40:37 -0400
Date: Wed, 26 Sep 2012 12:40:31 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [pull] last drm-intel-next pull for 3.7
Message-ID: <20120926104031.GI3824@bremse>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux bremse 3.6.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Last pile of stuff for 3.7, essentially just a bunch of bigger fixes and a
few less intrusive features:

- cpu freq interface in sysfs from Ben
- cpu edp fixes and some related cleanups
- write-combining ptes for pre-gen6 (Chris)
- basic CADL support (Peter Wu), this fixes quite a few issues with
  backlights ...
- rework of the gem backing pages handling (preps for stolen mem handling)
  from Chris
- some more cleanup-fallout from the modeset-rework

On top of that I've done a backmerge of -rc7(since the conflicts got too
messy and I've pushed out broken merged trees too often). I've also
included 3 fixes on top of what QA beat on:

- Fix for a infoframe handling regression in 3.5 - infoframe blows up too
  often and 3.6 is pretty much done, so I'd like to merge that through
  -next and the stable process and give it more exposure before it lands
  in a stable tree.
- ioctl cosmetics^Wspelling fix in the structs (userspace won't be
  affected, since all existing userspace uses private copies of the ioctl
  struct definitions, and the struct layout itself is abi compatible).
- Bugfix for a regression introduced in this pull's testing cycle.

Besides the regression in the ilk debugfs code QA reported new DP issues,
but afact all old stuff, just new variations of existing bugs. I hope we
can pour quite some manpower into our DP code from Intel's sides for the
next cycle. Maybe even extract some shared logic, since it sounds like
we'll eventually need quircks like for edid in dp-land :(

Cheers, Daniel

PS: Note that due to the backmerge I've manually frobbed the shortlog
again to exclude anything merged through Linus' tree.

The following changes since commit 3b7a89fce3e3dc96b549d6d829387b4439044d0d:

  drm/i915: fix OOPS in lid_notify (2012-09-18 00:59:37 +0200)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel for-airlied

for you to fetch changes up to f531dcb23f9a5c6ad77e451459df965dc9a0c0c8:

  drm/i915: Wrap external callers to IPS state with appropriate locks (2012-09-26 09:24:54 +0200)

----------------------------------------------------------------

Ben Widawsky (10):
      drm/i915: placeholder getparam
      drm/i915: variable renames
      drm/i915: #define gpu freq multipler
      drm/i915: Add current/max/min GPU freq to sysfs
      drm/i915: POSTING_READ the new rps value
      drm/i915: Error checks in gen6_set_rps
      drm/i915: Add setters for min/max frequency
      drm/i915: Show render P state thresholds in sysfs
      drm/i915: Fix !CONFIG_PM sysfs for real this time
      drm/i915: s/cacheing/caching/

Chris Wilson (11):
      drm/i915: Introduce drm_i915_gem_object_ops
      drm/i915: Pin backing pages whilst exporting through a dmabuf vmap
      drm/i915: Pin backing pages for pwrite
      drm/i915: Pin backing pages for pread
      drm/i915: Replace the array of pages with a scatterlist
      drm/i915: Drop the misleading cast to the wrong user pointer type
      drm/i915: Limit the ioremap of the PCI bar to the registers
      agp/intel: Use a write-combining map for updating PTEs
      drm/i915: Convert the dmabuf object to use the new i915_gem_object_ops
      drm/i915: Assert that the exec object lookup table is a power-of-two
      drm/i915: Wrap external callers to IPS state with appropriate locks

Daniel Vetter (12):
      drm/i915: rip out early dp port write for gm45/ilk
      drm/i915: add encoder->pre_enable/post_disable
      drm/i915: clean up the cpu edp pll special case
      drm/i915: robustify edp_pll_on/off
      drm/i915: rip out dp port enabling cludges^Wchecks
      drm/i915: disable the cpu edp port after the cpu pipe
      drm/i915: rip out edp special case from dp_link_down
      drm/i915: rip out intel_disable_pch_ports
      drm/i915: don't disable fdi links harder in ilk_crtc_enable
      drm/i915: don't call dpms funcs after set_mode
      drm/i915: update dpms property in set_mode
      Merge tag 'v3.6-rc7' into drm-intel-next-queued

Lekensteyn (1):
      i915: initialize CADL in opregion

Paulo Zanoni (5):
      drm/i915: extract ironlake_set_pipeconf form ironlake_crtc_mode_set
      drm/i915: simplify setting DSPCNTR inside ironlake_crtc_mode_set
      drm/i915: extract compute_clocks from ironlake_crtc_mode_set
      drm/i915: BUG() on unexpected HDMI register
      drm/i915: make sure we write all the DIP data bytes

Wang Xingchao (1):
      drm/i915: HDMI - Clear Audio Enable bit for Hot Plug unconditionally

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
