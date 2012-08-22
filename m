Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2HVEGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:06:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39019 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab2HVEGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:06:05 -0400
Date: Wed, 22 Aug 2012 05:06:00 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes + one fbcon one
Message-ID: <alpine.DEB.2.00.1208220501320.761@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-969739899-1345608360=:761"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-969739899-1345608360=:761
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Intel: edid fixes, power consumption fix, s/r fix, haswell fix
radeon: BIOS loading fixes for UEFI and Thunderbolt machines, better MSAA 
validation, lockup timeout fixes, modesetting fixes
one udl dpms fix,
one vmwgfx fix,
couple of trivial core changes

There is an export added to ACPI as part of the radeon bios fixes,

I've also included the fbcon flashing cursor vs deinit race fix, that 
seems the simplest place to start, so that distros can pick it up easier.

Dave.

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to d8636a2717bb3da2a7ce2154bf08de90bb8c87b0:

  fbcon: fix race condition between console lock and cursor timer (v1.1) (2012-08-22 14:00:35 +1000)

----------------------------------------------------------------
Alan Cox (1):
      drm: stop vmgfx driver explosion

Alex Deucher (5):
      ACPI: export symbol acpi_get_table_with_size
      drm/radeon: convert radeon vfct code to use acpi_get_table_with_size
      drm/radeon: split ATRM support out from the ATPX handler (v3)
      Revert "drm/radeon: fix bo creation retry path"
      drm/radeon/ss: use num_crtc rather than hardcoded 6

Ben Widawsky (1):
      drm/i915/contexts: fix list corruption

Christian König (1):
      drm/radeon: init lockup timeout on ring init

Damien Lespiau (1):
      drm: Remove two unused fields from struct drm_display_mode

Daniel Vetter (2):
      drm/i915: fix hsw uncached pte
      drm/i915: use hsw rps tuning values everywhere on gen6+

Dave Airlie (4):
      Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      drm/udl: dpms off the crtc when disabled.
      fbcon: fix race condition between console lock and cursor timer (v1.1)

David Lamparter (1):
      drm/radeon: implement ACPI VFCT vbios fetch (v3)

Jani Nikula (3):
      drm/i915: fix EDID memory leak in SDVO
      drm/i915: extract connector update from intel_ddc_get_modes() for reuse
      drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads

Jerome Glisse (1):
      drm/radeon: avoid turning off spread spectrum for used pll

Marek Ol¨ák (2):
      drm/radeon: allow CMASK and FMASK in the CS checker on r600-r700
      drm/radeon: fix checking of MSAA renderbuffers on r600-r700

Sachin Kamat (1):
      drm: Add missing static storage class specifiers in drm_proc.c file

Tvrtko Ursulin (1):
      drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to cover later silicon stepping

 drivers/acpi/acpica/tbxface.c                |    1 +
 drivers/char/agp/intel-agp.h                 |    1 +
 drivers/char/agp/intel-gtt.c                 |  105 +++++++++++++-------
 drivers/gpu/drm/drm_modes.c                  |    3 -
 drivers/gpu/drm/drm_proc.c                   |    4 +-
 drivers/gpu/drm/i915/i915_gem.c              |    8 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c          |    5 +-
 drivers/gpu/drm/i915/i915_reg.h              |    1 +
 drivers/gpu/drm/i915/intel_crt.c             |   36 ++++++-
 drivers/gpu/drm/i915/intel_drv.h             |    2 +
 drivers/gpu/drm/i915/intel_modes.c           |   31 ++++--
 drivers/gpu/drm/i915/intel_pm.c              |   15 +--
 drivers/gpu/drm/i915/intel_sdvo.c            |    1 +
 drivers/gpu/drm/radeon/atombios_crtc.c       |   25 ++++-
 drivers/gpu/drm/radeon/r600_cs.c             |  105 ++++++++++++++++----
 drivers/gpu/drm/radeon/r600d.h               |   17 ++++
 drivers/gpu/drm/radeon/radeon.h              |   15 ---
 drivers/gpu/drm/radeon/radeon_atombios.c     |    2 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   56 +----------
 drivers/gpu/drm/radeon/radeon_bios.c         |  138 +++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_drv.c          |    3 +-
 drivers/gpu/drm/radeon/radeon_object.c       |    3 +-
 drivers/gpu/drm/radeon/radeon_ring.c         |    1 +
 drivers/gpu/drm/radeon/reg_srcs/r600         |    8 --
 drivers/gpu/drm/udl/udl_modeset.c            |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c          |    6 +-
 drivers/video/console/fbcon.c                |    9 +-
 include/drm/drm_crtc.h                       |    2 -
 28 files changed, 424 insertions(+), 182 deletions(-)
--29444707-969739899-1345608360=:761--
