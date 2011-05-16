Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1EPCVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 22:21:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44406 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1EPCVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 22:21:17 -0400
Date: Mon, 16 May 2011 03:20:43 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] final drm fixes
Message-ID: <alpine.DEB.2.00.1105160318370.8999@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

two regression fixes, one on Intel Q67 with semaphores, and one in the 
switcheroo code. One black screen on radeon problem, oops on undock fix,
and a couple of minor updates to some changed regs on newer radeon hw.

Dave.

The following changes since commit ca1376d10810bc2c20c8d0821a9ee04ca2507c01:

  Merge branch 'fix/asoc' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-05-12 12:41:30 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (3):
      drm/radeon/kms: fix tiling reg on fusion
      drm/radeon/kms: fix extended lvds info parsing
      drm/radeon/kms: add some evergreen/ni safe regs

Andy Lutomirski (1):
      drm/i915: Revert i915.semaphore=1 default from 47ae63e0

Chris Wilson (1):
      drm: Take lock around probes for drm_fb_helper_hotplug_event

Florian Mickler (1):
      vga_switcheroo: don't toggle-switch devices

 drivers/gpu/drm/drm_fb_helper.c           |   26 ++++++++++++++++++++++----
 drivers/gpu/drm/i915/i915_drv.c           |    2 +-
 drivers/gpu/drm/radeon/evergreen.c        |    5 ++++-
 drivers/gpu/drm/radeon/evergreend.h       |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c  |   14 +++++++++++---
 drivers/gpu/drm/radeon/reg_srcs/cayman    |    1 +
 drivers/gpu/drm/radeon/reg_srcs/evergreen |    1 +
 drivers/gpu/vga/vga_switcheroo.c          |    6 +++---
 include/drm/drm_fb_helper.h               |    2 +-
 9 files changed, 45 insertions(+), 13 deletions(-)
