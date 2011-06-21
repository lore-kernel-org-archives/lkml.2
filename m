Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1FUA2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:28:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40335 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab1FUA2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:28:36 -0400
Date: Tue, 21 Jun 2011 01:27:57 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon + nouveau fixes.
Message-ID: <alpine.DEB.2.00.1106210124360.9507@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just some nouveau and radeon fixes, nothing major, couple of fixes for 
rv730 since I plugged in the 30" monitor and it didn't work, one fix for 
the switchy GPU machines getting spammed when radeon shared an irq and 
some nouveau regression fixes from Ben.

Dave.

The following changes since commit de505e709ffb09a7382ca8e0d8c7dbb171ba5830:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-06-18 20:33:31 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (3):
      drm/radeon/kms/atom: fix duallink on some early DCE3.2 cards
      drm/radeon/kms: add missing param for dce3.2 DP transmitter setup
      drm/radeon/kms/r6xx+: voltage fixes

Ben Skeggs (3):
      drm/nouveau: fix big-endian switch
      drm/nv50/disp: fix gamma with page flipping overlay turned on
      drm/nouveau: fix assumption that semaphore dmaobj is valid in x-chan sync

Dave Airlie (3):
      drm/radeon: avoid warnings from r600/eg irq handlers on powered off card.
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      drm/nouveau: drop leftover debugging

Emil Velikov (1):
      drm/nouveau/pm: Prevent overflow in nouveau_perf_init()

 drivers/gpu/drm/nouveau/nouveau_acpi.c   |    1 -
 drivers/gpu/drm/nouveau/nouveau_fence.c  |   59 +++++++++++++-----------------
 drivers/gpu/drm/nouveau/nouveau_perf.c   |    5 +++
 drivers/gpu/drm/nouveau/nouveau_state.c  |    4 +-
 drivers/gpu/drm/nouveau/nv50_display.c   |   17 +++++++--
 drivers/gpu/drm/radeon/evergreen.c       |   23 +++++++-----
 drivers/gpu/drm/radeon/r600.c            |   18 +++++----
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 ++
 drivers/gpu/drm/radeon/radeon_encoders.c |   11 ++++--
 drivers/gpu/drm/radeon/rv770.c           |    3 ++
 10 files changed, 84 insertions(+), 61 deletions(-)
