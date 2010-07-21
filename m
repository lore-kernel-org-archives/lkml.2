Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967Ab0GUAmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:42:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:32849 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761665Ab0GUAmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:42:13 -0400
Date: Wed, 21 Jul 2010 01:41:56 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1007210136490.8263@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

core: build fixes + a vgaarb header fix
radeon: IGP fixes to fix some issues since 2.6.34, a quirk + another fix 
for messy shared DDC lines
nouveau: two regression fixes
i915: I know you normally get these from Eric, but I wanted to get this 
upstream asap, as its a major stabilisation fix for 945GM systems, a large 
selection of 945GM machines have had stability problems and lockups over 
the past few years, I finally managed to get an enterprise reason to track 
it down and fix it. Keith's patch just adds docs for the necessary bits.

The following changes since commit 1c5474a65bf15a4cb162dfff86d6d0b5a08a740c:

  Linux 2.6.35-rc5 (2010-07-12 14:55:33 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (6):
      drm/radeon/kms: fix legacy tv-out pal mode
      drm/radeon/kms: fix possible mis-detection of sideport on rs690/rs740
      drm/radeon/kms: fix gtt MC base alignment on rs4xx/rs690/rs740 asics
      drm/radeon/kms: fix shared ddc harder
      drm/radeon/kms: add quirk for ASUS HD 3600 board
      drm/r600: fix possible NULL pointer derefernce

Ben Hutchings (1):
      drm/ttm: Fix build on architectures without AGP

Ben Skeggs (1):
      drm/nouveau: fix pcirom vbios shadow breakage from acpi rom patch

Dan Carpenter (2):
      fb: handle allocation failure in alloc_apertures()
      vmwgfx: return -EFAULT if copy_to_user fails

Dave Airlie (1):
      drm/i915: enable low power render writes on GEN3 hardware.

Doug Goldstein (1):
      include/linux/vgaarb.h: add missing part of include guard

Francisco Jerez (1):
      drm/nouveau: Fix crashes during fbcon init on single head cards.

Keith Packard (1):
      drm/i915: Define MI_ARB_STATE bits

Kulikov Vasiliy (1):
      drm: radeon: check kzalloc() result

 drivers/gpu/drm/i915/i915_gem.c            |   10 ++++
 drivers/gpu/drm/i915/i915_reg.h            |   64 ++++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_bios.c     |   33 ++++----------
 drivers/gpu/drm/nouveau/nouveau_fbcon.c    |    3 +-
 drivers/gpu/drm/radeon/r100.c              |    1 +
 drivers/gpu/drm/radeon/r300.c              |    3 +
 drivers/gpu/drm/radeon/r520.c              |    1 +
 drivers/gpu/drm/radeon/r600.c              |    1 +
 drivers/gpu/drm/radeon/r600_blit.c         |    5 ++-
 drivers/gpu/drm/radeon/radeon.h            |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |   20 ++++++++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   23 ++++------
 drivers/gpu/drm/radeon/radeon_device.c     |    8 ++--
 drivers/gpu/drm/radeon/radeon_legacy_tv.c  |    4 +-
 drivers/gpu/drm/radeon/rs400.c             |    5 ++-
 drivers/gpu/drm/radeon/rs600.c             |    1 +
 drivers/gpu/drm/radeon/rs690.c             |    1 +
 drivers/gpu/drm/radeon/rv515.c             |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c       |    2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c        |    1 +
 include/linux/fb.h                         |    2 +
 include/linux/vgaarb.h                     |    1 +
 22 files changed, 142 insertions(+), 49 deletions(-)
