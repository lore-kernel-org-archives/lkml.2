Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2FQHmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 03:42:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59018 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab2FQHmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 03:42:36 -0400
Date: Sun, 17 Jun 2012 08:42:28 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.1206170838050.26175@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1472687627-1339918948=:26175"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1472687627-1339918948=:26175
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

radeon is most of the work, one regression, one BUG fix in the new prime 
code, some fixes to init code to make streamout not lock up the hardware, 
and just some code to enable users to test HDMI audio on later hw (its off by 
default).

Intel adds edp edid caching for some strange Dell Vostros that black 
screen on startup if keep reading their EDID, and a fix for a DP 
regression.

Otherwise fix for via/sis and one to stop udl binding to multiple 
non-video usb.

Dave.

The following changes since commit 9b15b817f3d62409290fd56fe3cbb076a931bb0a:

  swap: fix shmem swapping when more than 8 areas (2012-06-15 21:48:14 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to c4af5c4597a7a5d64e058703e1328f315a59794e:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2012-06-16 14:45:17 +0100)

----------------------------------------------------------------

Alex Deucher (3):
      drm/radeon: fix regression in dynpm due to multi-ring rework
      drm/radeon: add some additional 6xx/7xx/EG register init
      drm/radeon: add support for STRMOUT_BASE_UPDATE on 7xx

Daniel Vetter (2):
      drm/i915: eDP aux needs vdd
      Revert "drm/i915/dp: Use auxch precharge value of 5 everywhere"

Dave Airlie (3):
      drm/udl: only bind to the video devices on the hub.
      drm/radeon/prime: reserve/unreserve around pin
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Jesse Barnes (2):
      drm/i915: don't enumerate HDMID if an eDP panel is already active on the port
      drm/i915: cache the EDID for eDP panels

Márton Németh (2):
      drm via: initialize object_idr
      drm sis: initialize object_idr

Rafa³ Mi³ecki (1):
      drm/radeon: enable HDMI on DCE5 (AKA NI excluding Aruba)

Randy Dunlap (1):
      vga_switcheroo.h: fix pci_dev warning

 drivers/gpu/drm/i915/intel_display.c       |    2 +-
 drivers/gpu/drm/i915/intel_dp.c            |   60 ++++++++++++++++++++++++----
 drivers/gpu/drm/radeon/atombios_encoders.c |    4 +-
 drivers/gpu/drm/radeon/evergreen.c         |    3 ++
 drivers/gpu/drm/radeon/evergreen_hdmi.c    |    3 --
 drivers/gpu/drm/radeon/evergreend.h        |    1 +
 drivers/gpu/drm/radeon/ni.c                |    5 +++
 drivers/gpu/drm/radeon/r600.c              |    1 +
 drivers/gpu/drm/radeon/r600_audio.c        |    2 +-
 drivers/gpu/drm/radeon/r600_cs.c           |   42 +++++++++++++++++++
 drivers/gpu/drm/radeon/r600_hdmi.c         |    7 +---
 drivers/gpu/drm/radeon/r600d.h             |    2 +
 drivers/gpu/drm/radeon/radeon_drv.c        |    3 +-
 drivers/gpu/drm/radeon/radeon_pm.c         |   10 +++--
 drivers/gpu/drm/radeon/radeon_prime.c      |   10 ++++-
 drivers/gpu/drm/radeon/rv770.c             |    5 ++-
 drivers/gpu/drm/radeon/rv770d.h            |    3 ++
 drivers/gpu/drm/sis/sis_drv.c              |    2 +-
 drivers/gpu/drm/udl/udl_drv.c              |   15 ++++++-
 drivers/gpu/drm/via/via_map.c              |    3 +-
 include/linux/vga_switcheroo.h             |    2 +
 21 files changed, 156 insertions(+), 29 deletions(-)
--29444707-1472687627-1339918948=:26175--
