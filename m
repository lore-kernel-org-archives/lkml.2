Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0LUXnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:43:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41868 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab0LUXni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:43:38 -0500
Date: Tue, 21 Dec 2010 23:43:18 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

meant to get this out earlier, but I've been off sick as well as having a 
sick kid, also meant a few things piled up when I wasn't looking

contains a revert for reported regression in intel and also one in radeon,
a few radeon fixes, one for a 15s resume time on certain laptops, and one 
to fix gpu reset on some gpus,

Dave.

The following changes since commit a4851d8f7d6351a395d36ae8fdcf41745a832d76:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2010-12-15 12:41:17 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (7):
      drm/radeon/kms: disable ss fixed ref divide
      drm/radeon/kms: disable the r600 cb offset checker for linear surfaces
      drm/radeon/kms/evergreen: flush hdp cache when flushing gart tlb
      drm/radeon/kms: fix evergreen asic reset
      drm/radeon/kms/evergreen: reset the grbm blocks at resume and init
      drm/radeon/kms: reorder display resume to avoid problems
      drm/radeon/kms: fix bug in r600_gpu_is_lockup

Benjamin Herrenschmidt (1):
      drm/radeon: Add early unregister of firmware fb's

Chris Wilson (5):
      drm/i915/ringbuffer: Handle wrapping of the autoreported HEAD
      drm/i915/sdvo: Only use the SDVO pin if it is in the valid range
      agp/intel: Fix missed cached memory flags setting in i965_write_entry()
      drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
      drm: Include the connector name in the output_poll_execute() debug message

Dave Airlie (3):
      Merge remote branch 'intel/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes
      drm/radeon: use aperture size not vram size for overlap tests
      Revert "drm: Don't try and disable an encoder that was never enabled"

David Flynn (1):
      drm/i915/dp: Fix I2C/EDID handling with active DisplayPort to DVI converter

 drivers/char/agp/intel-gtt.c            |   11 +++++++-
 drivers/gpu/drm/drm_crtc_helper.c       |    7 ++++-
 drivers/gpu/drm/i915/intel_bios.c       |    2 +-
 drivers/gpu/drm/i915/intel_dp.c         |   37 +++++++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_ringbuffer.c |   19 ++++++---------
 drivers/gpu/drm/i915/intel_ringbuffer.h |    5 ++-
 drivers/gpu/drm/i915/intel_sdvo.c       |    9 +++++--
 drivers/gpu/drm/radeon/atombios_crtc.c  |    7 +++--
 drivers/gpu/drm/radeon/evergreen.c      |   27 ++++++++++------------
 drivers/gpu/drm/radeon/evergreend.h     |    1 +
 drivers/gpu/drm/radeon/r600.c           |   10 ++++++-
 drivers/gpu/drm/radeon/r600_cs.c        |    9 +++----
 drivers/gpu/drm/radeon/radeon_device.c  |    9 +++----
 drivers/gpu/drm/radeon/radeon_drv.c     |   19 ++++++++++++++++
 drivers/gpu/drm/radeon/radeon_fb.c      |    2 +-
 15 files changed, 115 insertions(+), 59 deletions(-)
