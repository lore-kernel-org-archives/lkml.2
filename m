Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2CVPDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:03:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36145 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804Ab2CVPDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:03:47 -0400
Date: Thu, 22 Mar 2012 15:03:45 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm nouveau destaging + Kelper modesetting support
Message-ID: <alpine.DEB.2.00.1203221458351.20827@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This pull request is unexpected and not something I had mentioned 
previously.

so NVIDIA announced new Kepler GPUs this morning, and Ben has killed
himself getting modesetting support for them together to have on launch 
day. Most of the code to support the new chips has already gone in, 
however this pull contains a few more pieces along with the final enables
so the driver binds to the new Kepler cards. Its quite amazing that 
nouveau can support a GPU on its launch day even if its just unaccelerated
modesetting, and I'd like to have support in the next kernel.

In order to sweeten the deal, Ben has also requested nouveau destage and
become ABI stable, the only change is the version number bump which he
prepared userspace for quite a long time ago. The driver hasn't broken ABI 
since that one big break that caused a lot of fuss.

It's also quite a small set of code, and not likely to break anything.

Dave.

The following changes since commit 5466c7b1683a23dbbcfb7ee4a71c4f23886001c7:

  drm/i915: use DDC_ADDR instead of hard-coding it (2012-03-21 10:20:38 +0000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-nouveau-destage

Ben Skeggs (14):
      drm/nouveau/ttm: always do buffer moves on kernel channel
      drm/nouveau: remove subchannel names from places where it doesn't matter
      drm/nouveau: move fence sequence check to start of loop
      drm/nvc0-/disp: reimplement flip completion method as fifo method
      drm/nouveau: remove m2mf creation on userspace channels
      drm/nouveau: inform userspace of new kernel subchannel requirements
      drm/nouveau: oops, increase channel dispc_vma to 4
      drm/nvd0/disp: ignore clock set if no pclk
      drm/nouveau: bump version to 1.0.0
      drm/nouveau: move out of staging drivers
      drm/nouveau: add bios connector type for dms59
      drm/nve0: initial modesetting support for kepler chipsets
      drm/nve0/disp: nvidia randomly decided to move the dithering method
      drm/nouveau/dp: support version 4.0 of DP table

Dave Airlie (1):
      Merge branch 'drm-nouveau-next' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-next

 drivers/gpu/drm/Kconfig                     |    2 +
 drivers/gpu/drm/nouveau/nouveau_bios.c      |    3 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h      |    2 +
 drivers/gpu/drm/nouveau/nouveau_bo.c        |   11 +--
 drivers/gpu/drm/nouveau/nouveau_channel.c   |   34 +++---
 drivers/gpu/drm/nouveau/nouveau_connector.c |   13 +--
 drivers/gpu/drm/nouveau/nouveau_display.c   |   14 ++-
 drivers/gpu/drm/nouveau/nouveau_dma.c       |   61 +-----------
 drivers/gpu/drm/nouveau/nouveau_dma.h       |    4 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c        |   11 ++
 drivers/gpu/drm/nouveau/nouveau_drv.h       |   40 +++++---
 drivers/gpu/drm/nouveau/nouveau_fence.c     |   35 +++---
 drivers/gpu/drm/nouveau/nouveau_gem.c       |   10 +--
 drivers/gpu/drm/nouveau/nouveau_state.c     |  152 +++++++++++++++++++++++----
 drivers/gpu/drm/nouveau/nv50_display.c      |   12 +-
 drivers/gpu/drm/nouveau/nvc0_fifo.c         |   36 ++++++-
 drivers/gpu/drm/nouveau/nvc0_graph.c        |    9 --
 drivers/gpu/drm/nouveau/nvd0_display.c      |   23 ++++-
 drivers/staging/Kconfig                     |    2 -
 19 files changed, 288 insertions(+), 186 deletions(-)
