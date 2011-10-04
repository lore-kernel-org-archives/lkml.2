Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab1JDQbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:31:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57582 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab1JDQbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:31:05 -0400
Date: Tue, 4 Oct 2011 17:34:12 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1110041731390.29734@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1629830783-1317746052=:29734"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1629830783-1317746052=:29734
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

all radeon fixes, one nasty startup crash and/or memory corruption on one 
family of radeon hd6450s resulted in a patch to stop setting a bunch of 
regs in the drivers and let the BIOS set them correctly, displayport 
regression fix, and some off-by-one in the cursor code around the corners 
of the screens.

its a bit bigger than I'd like but the register setting removal had to 
remove the unused functions.

Dave.

The following changes since commit 9b13776977d45505469edc6decc93e9e3799afe2:

  Merge branch 'for-linus' of git://git.infradead.org/users/sameo/mfd-2.6 (2011-10-02 19:23:44 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

Alex Deucher (4):
      drm/radeon/kms: fix regression in DP aux defer handling
      drm/radeon/kms: add retry limits for native DP aux defer
      drm/radeon/kms: Fix logic error in DP HPD handler
      drm/radeon/kms: fix channel_remap setup (v2)

Michel Dänzer (3):
      drm/radeon: Simplify cursor x/yorigin calculation.
      drm/radeon: Update AVIVO cursor coordinate origin before x/yorigin calculation.
      drm/radeon: Set cursor x/y to 0 when x/yorigin > 0.

Nicholas Miell (1):
      drm/radeon/kms: fix cursor image off-by-one error

 drivers/gpu/drm/radeon/atombios_dp.c       |   16 +++++---
 drivers/gpu/drm/radeon/evergreen.c         |   44 ------------------------
 drivers/gpu/drm/radeon/ni.c                |   32 -----------------
 drivers/gpu/drm/radeon/radeon_connectors.c |    8 ++--
 drivers/gpu/drm/radeon/radeon_cursor.c     |   40 ++++++++++-----------
 drivers/gpu/drm/radeon/rv770.c             |   51 ----------------------------
 6 files changed, 33 insertions(+), 158 deletions(-)
--29444707-1629830783-1317746052=:29734--
