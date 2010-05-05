Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428Ab0EECEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:04:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42521 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab0EECEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:04:39 -0400
Date: Wed, 5 May 2010 03:04:20 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [git pull] drm + gpu fixes
Message-ID: <alpine.DEB.2.00.1005050302190.16004@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1905677848-1273025060=:16004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1905677848-1273025060=:16004
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Some misc gpu/drm core fixes for off-by-one and exit paths,
2 radeon modesetting fix + one command strem parser fix + one fix for an 
oops for an odd combo of config flags.

The following changes since commit 88b045077a1462a47503137fd4ca0c31772819ca:
  David Miller (1):
        drm/radeon: Fix sparc regression in r300_scratch()

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Alex Deucher (2):
      drm/radeon/kms: fix panel scaling adjusted mode setup
      drm/radeon/kms/legacy: only enable load detection property on DVI-I

Dan Carpenter (4):
      drivers/gpu/drm/via/via_video.c: fix off by one issue
      drivers/gpu/drm/drm_memory.c: fix check for end of loop
      drivers/gpu/drm/radeon/radeon_atombios.c: range check issues
      drivers/gpu/drm/drm_sysfs.c: sysfs files error handling

Jiri Slaby (1):
      gpu: vga_switcheroo, fix lock imbalance

Marek Ol¨ák (1):
      drm/radeon/kms: r300 fix CS checker to allow zbuffer-only fastfill

Robert Fitzsimons (1):
      drm/radeon/kms/agp The wrong AGP chipset can cause a NULL pointer dereference

 drivers/gpu/drm/drm_memory.c                    |    2 +-
 drivers/gpu/drm/drm_sysfs.c                     |   21 +++++---
 drivers/gpu/drm/radeon/atombios.h               |    2 +-
 drivers/gpu/drm/radeon/r100.c                   |    2 +-
 drivers/gpu/drm/radeon/r100_track.h             |    2 +-
 drivers/gpu/drm/radeon/r300.c                   |    2 +-
 drivers/gpu/drm/radeon/radeon_agp.c             |   10 ++--
 drivers/gpu/drm/radeon/radeon_atombios.c        |    4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c      |    2 +
 drivers/gpu/drm/radeon/radeon_encoders.c        |   61 ++++++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   12 +----
 drivers/gpu/drm/radeon/radeon_mode.h            |    2 +
 drivers/gpu/drm/via/via_video.c                 |    2 +-
 drivers/gpu/vga/vga_switcheroo.c                |    6 ++-
 14 files changed, 83 insertions(+), 47 deletions(-)
--29444707-1905677848-1273025060=:16004--
