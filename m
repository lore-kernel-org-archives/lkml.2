Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2CVO6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:58:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36085 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab2CVO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:58:35 -0400
Date: Thu, 22 Mar 2012 14:58:33 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm - radeon southern islands / trinity support
Message-ID: <alpine.DEB.2.00.1203221454350.20827@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-42145380-1332428313=:20827"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-42145380-1332428313=:20827
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This applies after my drm-next pull request sent yesterday.

It is support from AMD for their newest GPU and APUs. The products called
RadeonHD 7xxx, and the Trinity APU series.

This did come in a bit late, due to some over-complicated AMD 
internal review process, which from the outside seems unnecessary once the 
company has decided it wants to support open source. However as I said 
previously I'd rather not put the people who've got this hw for 3 months 
now being forced to use fglrx on it if there is open code.

Its pretty well self contained and just plugs into the driver in various
places.

The following changes since commit da0df92b57311aa1b26a2a90599ed16e1e968b90:

  drm: allow loading an EDID as firmware to override broken monitor (2012-03-20 10:09:28 +0000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-radeon-sitn-support

Alex Deucher (46):
      drm/radeon/kms: Upstream ObjectID.h updates
      drm/radeon/kms: upstream atombios.h updates
      drm/radeon/kms: upstream power table updates
      drm/radeon/kms: add SI chip families
      drm/radeon/kms: add initial DCE6 display watermark support
      drm/radeon/kms: fix up atom HPD gpio parsing for DCE6
      drm/radeon/kms/atom: DCE6 no longer has crtcmemreq bits
      drm/radeon/kms/atom: add support for crtc power gating
      drm/radeon/kms: DCE6 disp eng pll updates
      drm/radeon/kms/atom: add support for DCE6.x dig transmitters
      drm/radeon/kms: DP aux updates for DCE6
      drm/radeon/kms: update comments about dig encoders/transmitters
      drm/radeon/kms/atom: add support for SI SetVoltage table
      drm/radeon/kms: update power table parsing for SI
      drm/radeon/kms: add support for internal thermal sensor on SI
      drm/radeon/kms: add gpu init support for SI
      drm/radeon/kms: Add support for SI GPU reset
      drm/radeon/kms: add support for MC/VM setup on SI
      drm/radeon/kms: add support for the CONST IB to the CS ioctl
      drm/radeon/kms: add VM CS checker for SI
      drm/radeon/kms: Only VM CS ioctl is supported on SI (v2)
      drm/radeon/kms: add ucode loading for SI
      drm/radeon/kms: add support for MC ucode loading on SI
      drm/radeon/kms: add support for CP setup on SI
      drm/radeon/kms: add IB and fence dispatch functions for SI
      drm/radeon/kms: Add support for RLC init on SI
      drm/radeon/kms: add support for interrupts on SI
      drm/radeon/kms: fill in startup/shutdown callbacks for SI
      drm/radeon/kms: add support for compute rings in CS ioctl on SI
      drm/radeon/kms: add radeon_asic struct for SI
      drm/radeon/kms: Add SI pci ids
      drm/radeon/kms: add trinity (TN) chip family
      drm/radeon/kms: no support for internal thermal sensor on TN yet
      drm/radeon/kms: DCE6.1 watermark updates for TN
      drm/radeon/kms: DCE6.1 disp eng pll updates
      drm/radeon/kms: Adjust pll picker for DCE6.1
      drm/radeon/kms: disable PPLL0 on DCE6.1 when not in use
      drm/radeon/kms/DCE6.1: ss is not supported on the internal pplls
      drm/radeon/kms: Add checks for TN in the DP bridge code
      drm/radeon/kms: cayman gpu init updates for trinity
      drm/radeon/kms: Update evergreen functions for trinity
      drm/radeon/kms/vm: set vram base offset properly for TN
      drm/radeon/kms: add support for ucode loading on trinity (v2)
      drm/radeon/kms: add radeon_asic struct for trinity
      drm/radeon/kms: add trinity pci ids
      drm/radeon/kms: update duallink checks for DCE6

Michel Dänzer (1):
      drm/radeon: Update radeon_info_ioctl for SI. (v2)

Tom Stellard (1):
      drm/radeon/kms: add info query for max pipes

 drivers/gpu/drm/radeon/Makefile             |    2 +-
 drivers/gpu/drm/radeon/ObjectID.h           |    5 +
 drivers/gpu/drm/radeon/atombios.h           | 1109 +++++++-
 drivers/gpu/drm/radeon/atombios_crtc.c      |  100 +-
 drivers/gpu/drm/radeon/atombios_dp.c        |    6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c  |   71 +-
 drivers/gpu/drm/radeon/evergreen.c          |   25 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |    2 +-
 drivers/gpu/drm/radeon/ni.c                 |  141 +-
 drivers/gpu/drm/radeon/nid.h                |    1 +
 drivers/gpu/drm/radeon/r600.c               |   25 +-
 drivers/gpu/drm/radeon/r600d.h              |    4 +
 drivers/gpu/drm/radeon/radeon.h             |   55 +-
 drivers/gpu/drm/radeon/radeon_asic.c        |  208 ++
 drivers/gpu/drm/radeon/radeon_asic.h        |   25 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |   78 +-
 drivers/gpu/drm/radeon/radeon_connectors.c  |    2 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |   63 +-
 drivers/gpu/drm/radeon/radeon_device.c      |    6 +-
 drivers/gpu/drm/radeon/radeon_display.c     |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c         |    3 +-
 drivers/gpu/drm/radeon/radeon_encoders.c    |    6 +-
 drivers/gpu/drm/radeon/radeon_family.h      |    4 +
 drivers/gpu/drm/radeon/radeon_kms.c         |   32 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c          |    7 +
 drivers/gpu/drm/radeon/radeon_reg.h         |    1 +
 drivers/gpu/drm/radeon/radeon_ring.c        |    1 +
 drivers/gpu/drm/radeon/si.c                 | 4128 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/si_blit_shaders.c    |  252 ++
 drivers/gpu/drm/radeon/si_blit_shaders.h    |   32 +
 drivers/gpu/drm/radeon/si_reg.h             |   33 +
 drivers/gpu/drm/radeon/sid.h                |  886 ++++++
 include/drm/drm_pciids.h                    |   54 +
 include/drm/radeon_drm.h                    |    3 +
 35 files changed, 7230 insertions(+), 144 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/si.c
 create mode 100644 drivers/gpu/drm/radeon/si_blit_shaders.c
 create mode 100644 drivers/gpu/drm/radeon/si_blit_shaders.h
 create mode 100644 drivers/gpu/drm/radeon/si_reg.h
 create mode 100644 drivers/gpu/drm/radeon/sid.h
--29444707-42145380-1332428313=:20827--
