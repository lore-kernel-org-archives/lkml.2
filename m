Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2DSTCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:02:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43808 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab2DSTCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:02:44 -0400
Date: Thu, 19 Apr 2012 20:02:42 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1204191958450.28930@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

its like a grab bag of one liners,

core: fix page flip error path, reorder object teardown.
usb: fix the drm_usb module license.
i915: VT switch on SNB with non-native modes fix, and a regression fix 
from 3.3.
radeon: missing unreserve on SI, AGP/VRAM setup fix (fixes radeon on IA64, 
but its a generic bug), an rn50 regression from 3.3, turn off MSIs on 
rv515 (it loses rearms every so often).

Dave.

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/si: add missing radeon_bo_unreserve in si_rlc_init() v2

Chris Wilson (2):
      drm/i915: Hold mode_config lock whilst changing mode for lastclose()
      drm/i915: Do not set "Enable Panel Fitter" on SNB pageflips

Daniel Vetter (1):
      drm/i915: don't clobber the special upscaling lvds timings

Dave Airlie (4):
      drm/radeon: disable MSI on RV515
      drm/usb: fix module license on drm/usb layer.
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      drm/radeon: fix load detect on rn50 with hardcoded EDIDs.

Henrik Rydberg (1):
      nouveau: Set special lane map for the right chipset

Jerome Glisse (1):
      radeon: fix r600/agp when vram is after AGP (v3)

Jim Meyering (1):
      drm/nouveau/pm: don't read/write beyond end of stack buffer

Joonyoung Shim (1):
      drm: fix page_flip error handling

Marcos Paulo de Souza (1):
      drivers: gpu: drm: gma500: mdfld_dsi_output.h: Remove not unneeded include of version.h

Prathyush (1):
      drm: Releasing FBs before releasing GEM objects during drm_release

Takashi Iwai (1):
      drm/radeon/kms: fix the regression of DVI connector check

 drivers/gpu/drm/drm_crtc.c                 |   10 ++++++----
 drivers/gpu/drm/drm_fops.c                 |    6 +++---
 drivers/gpu/drm/drm_usb.c                  |    6 +++++-
 drivers/gpu/drm/gma500/mdfld_dsi_output.h  |    1 -
 drivers/gpu/drm/i915/intel_display.c       |   15 ++++++++++++---
 drivers/gpu/drm/i915/intel_drv.h           |    4 ++++
 drivers/gpu/drm/i915/intel_fb.c            |    4 ++++
 drivers/gpu/drm/i915/intel_lvds.c          |    6 ++++++
 drivers/gpu/drm/i915/intel_panel.c         |    2 --
 drivers/gpu/drm/nouveau/nouveau_pm.c       |    1 +
 drivers/gpu/drm/nouveau/nv50_sor.c         |    2 +-
 drivers/gpu/drm/radeon/r600.c              |    4 ++--
 drivers/gpu/drm/radeon/radeon_connectors.c |    4 ++--
 drivers/gpu/drm/radeon/radeon_irq_kms.c    |    6 ++++++
 drivers/gpu/drm/radeon/rv770.c             |    4 ++--
 drivers/gpu/drm/radeon/si.c                |    5 ++---
 16 files changed, 56 insertions(+), 24 deletions(-)
