Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0IOBpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:45:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51965 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab0IOBpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:45:12 -0400
Date: Wed, 15 Sep 2010 02:44:59 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1009150239580.18320@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-405548144-1284515099=:18320"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-405548144-1284515099=:18320
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is slightly larger than I'd like but Chris's patch to limit polling 
devices thats can be destructive solves a lot of problems on Intel but it 
requires an api change across drivers. The other worrisome one is a race 
condition fixer between device nodes being openable and the driver 
being loaded that I can't say why we started seeing it (bkl removal 
maybe, userspace timing change maybe), I started working on an alternate 
fix but it grew too large for this point in a release cycle.

Other updates are fixes for radeon from Alex and Marek, adding the 
copyright headers probably a/c for 1/4 of the patchset.

The following changes since commit 49553c2ef88749dd502687f4eb9c258bb10a4f44:

  Linux 2.6.36-rc4 (2010-09-12 16:07:37 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (7):
      drm/radeon/kms: fix regression in RMX code (v2)
      drm/radeon/kms: add connector table for Mac x800
      drm/radeon/kms: don't enable underscan with interlaced modes
      drm/radeon: add some missing copyright headers
      drm/radeon/kms/evergreen: fix backend setup
      drm/radeon/kms: force legacy pll algo for RV620 LVDS
      drm/radeon/kms: only warn on mipmap size checks in r600 cs checker (v2)

Chris Wilson (4):
      drm: Fix regression in disable polling e58f637
      drm: Only decouple the old_fb from the crtc is we call mode_set*
      drm: Use a nondestructive mode for output detect when polling
      drm: Use a nondestructive mode for output detect when polling (v2)

Dave Airlie (1):
      drm: fix race between driver loading and userspace open.

Marek Ol¨ák (2):
      drm/radeon/kms: increase lockup detection interval to 10 sec for r100-r500
      drm/radeon/kms: fix the colorbuffer CS checker for r300-r500

 drivers/gpu/drm/drm_crtc_helper.c           |   10 +++---
 drivers/gpu/drm/drm_pci.c                   |    4 ++
 drivers/gpu/drm/drm_platform.c              |    5 +++
 drivers/gpu/drm/drm_sysfs.c                 |    2 +-
 drivers/gpu/drm/i915/intel_crt.c            |    6 +++-
 drivers/gpu/drm/i915/intel_dp.c             |    2 +-
 drivers/gpu/drm/i915/intel_dvo.c            |    3 +-
 drivers/gpu/drm/i915/intel_hdmi.c           |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c           |    7 +++-
 drivers/gpu/drm/i915/intel_sdvo.c           |    5 ++-
 drivers/gpu/drm/i915/intel_tv.c             |   11 +++---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    6 ++--
 drivers/gpu/drm/radeon/atombios_crtc.c      |    5 ++-
 drivers/gpu/drm/radeon/evergreen.c          |   27 +++++++++++----
 drivers/gpu/drm/radeon/r100.c               |   24 ++++----------
 drivers/gpu/drm/radeon/r600_blit_kms.c      |   25 ++++++++++++++
 drivers/gpu/drm/radeon/r600_blit_shaders.h  |   24 ++++++++++++++
 drivers/gpu/drm/radeon/r600_cs.c            |    5 +--
 drivers/gpu/drm/radeon/radeon_combios.c     |   47 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c  |   15 ++++++---
 drivers/gpu/drm/radeon/radeon_display.c     |    9 +++--
 drivers/gpu/drm/radeon/radeon_mode.h        |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c         |    7 ++--
 include/drm/drm_crtc.h                      |   10 +++++-
 24 files changed, 197 insertions(+), 67 deletions(-)
--29444707-405548144-1284515099=:18320--
