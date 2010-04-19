Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab0DSE3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 00:29:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47180 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab0DSE3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 00:29:07 -0400
Date: Mon, 19 Apr 2010 05:28:45 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1004190525550.16598@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-686502780-1271651325=:16598"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-686502780-1271651325=:16598
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Just radeon fixes, the most important one being a one char typo in the 
rs600 setup that caused memory corruption with KMS on this particular 
chipset. RS600s are a really rare chipset, so it took a while for Jerome 
to track one down to reproduce. Others are mainly fixes to open bugs and a 
regression in the smooth booting process thats caused flicker when X 
started up. Along with some register updates to the command stream parser.

The following changes since commit 930b9d94579fa1ea9604cbf7ba56cedf99ba9b5c:
  Dave Airlie (1):
        Merge remote branch 'nouveau/for-airlied' of ../drm-nouveau-next into drm-linus

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Alex Deucher (6):
      drm/radeon/kms: more atom parser fixes (v2)
      drm/radeon/kms/atom: fix dual-link DVI on DCE3.2/4.0
      drm/radeon/kms/evergreen: don't enable hdmi audio stuff
      drm/radeon/kms: fix tv dac conflict resolver
      drm/radeon/kms: adjust pll settings for tv
      drm/radeon/kms: disable the tv encoder when tv/cv is not in use

Corbin Simpson (1):
      drivers/gpu/radeon: Add MSPOS regs to safe list.

Dave Airlie (1):
      drm/radeon/kms: only change mode when coherent value changes.

Jerome Glisse (2):
      drm/radeon/kms: print GPU family and device id when loading
      drm/radeon/kms: fix rs600 tlb flush

Marek Ol¨ák (2):
      drm/radeon/kms: fix calculation of mipmapped 3D texture sizes
      drm/radeon/kms: allow R500 regs VAP_ALT_NUM_VERTICES and VAP_INDEX_OFFSET

 drivers/gpu/drm/radeon/atom.c              |   10 +++++
 drivers/gpu/drm/radeon/atombios_crtc.c     |    4 ++
 drivers/gpu/drm/radeon/r100.c              |   21 ++++++++---
 drivers/gpu/drm/radeon/r100_track.h        |    1 +
 drivers/gpu/drm/radeon/r300.c              |   15 ++++++--
 drivers/gpu/drm/radeon/r600_audio.c        |    2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c         |    9 +++++
 drivers/gpu/drm/radeon/radeon_connectors.c |   13 ++++++-
 drivers/gpu/drm/radeon/radeon_device.c     |   53 +++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_drv.c        |    3 +-
 drivers/gpu/drm/radeon/radeon_encoders.c   |   12 +++++-
 drivers/gpu/drm/radeon/radeon_family.h     |    3 +-
 drivers/gpu/drm/radeon/reg_srcs/r300       |    2 +
 drivers/gpu/drm/radeon/reg_srcs/r420       |    2 +
 drivers/gpu/drm/radeon/reg_srcs/rs600      |    2 +
 drivers/gpu/drm/radeon/reg_srcs/rv515      |    3 ++
 drivers/gpu/drm/radeon/rs600.c             |    2 +-
 17 files changed, 138 insertions(+), 19 deletions(-)
--29444707-686502780-1271651325=:16598--
