Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab2HCQCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:02:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43253 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2HCQC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:02:28 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 0/5] i915 changes for hybrid graphics support on Macbooks
Date: Fri,  3 Aug 2012 11:02:16 -0500
Message-Id: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are part of a larger series I've been working on
to get vga_switcheroo working on hybrid graphics Macbooks. Some of these
machines are not providing a VBT, and since the LVDS panel is connected
to the discrete GPU at boot we can't get a mode for the panel during
initialization. As a result the LVDS connector is not registered with
DRM, and graphics switching is not possible.

These patches fix this issue by registering the connector even if we
can't get a mode for the panel. If we don't have an EDID we check again
from the vga_switcheroo reprobe callback.

This is working, except for the framebuffer console which isn't
displaying when switched to the integrated GPU, which I still need to
debug. I'm not entirely sure whether or not this is the correct approach
though, so I wanted to go ahead and get some feedback on the patches now
to make sure I'm on the right track.

Thanks,
Seth


Andreas Heider (1):
  drm/i915: Add support for vga_switcheroo reprobe

Seth Forshee (4):
  drm/i915: separate out code to get EDID from LVDS panel
  drm/i915: register LVDS connector even if we can't get a panel mode
  drm/i915: make intel_lvds_get_edid() more robust
  drm/i915: check LVDS for EDID on GPU switches

 drivers/gpu/drm/i915/i915_dma.c   |    9 ++-
 drivers/gpu/drm/i915/intel_drv.h  |    1 +
 drivers/gpu/drm/i915/intel_lvds.c |  156 +++++++++++++++++++++----------------
 3 files changed, 97 insertions(+), 69 deletions(-)

