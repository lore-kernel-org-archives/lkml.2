Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1AQERM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 23:17:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49865 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab1AQERL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 23:17:11 -0500
Date: Mon, 17 Jan 2011 04:16:47 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1101170415080.5315@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A bunch of radeon and nouveau fixes. Ben says this should fix any 
corruption people are seeing with plymouth splash screens, and the radeon 
fixes are scattered around, the main one being not enabling PCIE GEN2 mode 
by default, seems like AGP PCIE vendors make crappy chipsets.

Dave.

The following changes since commit e78bf5e6cbe837daa6ab628a5f679548742994d3:

  drivers/nfc/pn544.c: fix min_t warnings (2011-01-16 17:28:21 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (4):
      drm/radeon/kms: fix typo in evergreen safe reg
      drm/radeon/kms: add module option for pcie gen2
      drm/radeon/kms: remove duplicate card_posted() functions
      drm/radeon/kms: balance asic_reset functions

Ben Skeggs (5):
      drm/nv40: make detection of 0x4097-ful chipsets available everywhere
      drm/nv40: initialise 0x17xx on all chipsets that have it
      drm/nvc0: enable protection of system-use-only structures in vm
      drm/nouveau: greatly simplify mm, killing some bugs in the process
      drm/nouveau: fix gpu page faults triggered by plymouthd

Dave Airlie (1):
      Merge remote branch 'nouveau/drm-nouveau-next' of /ssd/git/drm-nouveau-next into drm-fixes

 drivers/gpu/drm/nouveau/nouveau_drv.h     |   15 +++
 drivers/gpu/drm/nouveau/nouveau_fbcon.c   |    4 +-
 drivers/gpu/drm/nouveau/nouveau_mem.c     |   26 ++---
 drivers/gpu/drm/nouveau/nouveau_mm.c      |  182 +++++++----------------------
 drivers/gpu/drm/nouveau/nouveau_mm.h      |    4 +-
 drivers/gpu/drm/nouveau/nv40_graph.c      |    3 +-
 drivers/gpu/drm/nouveau/nv40_grctx.c      |   21 +---
 drivers/gpu/drm/nouveau/nv40_mc.c         |   14 +--
 drivers/gpu/drm/nouveau/nv50_instmem.c    |    7 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c      |    3 +-
 drivers/gpu/drm/nouveau/nvc0_vm.c         |    4 +-
 drivers/gpu/drm/radeon/evergreen.c        |   30 +----
 drivers/gpu/drm/radeon/r100.c             |   11 +-
 drivers/gpu/drm/radeon/r300.c             |   11 +-
 drivers/gpu/drm/radeon/r600.c             |   23 +---
 drivers/gpu/drm/radeon/radeon.h           |    1 +
 drivers/gpu/drm/radeon/radeon_drv.c       |    4 +
 drivers/gpu/drm/radeon/reg_srcs/evergreen |    2 +-
 drivers/gpu/drm/radeon/rs600.c            |   16 ++--
 drivers/gpu/drm/radeon/rv770.c            |    5 +-
 20 files changed, 124 insertions(+), 262 deletions(-)
