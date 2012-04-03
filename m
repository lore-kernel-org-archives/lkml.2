Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2DCK0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:26:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39533 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2DCK0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:26:03 -0400
Date: Tue, 3 Apr 2012 11:26:00 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1204031123280.21969@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1559683733-1333448761=:21969"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1559683733-1333448761=:21969
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

mainly nouveau fixes, one for a regressions in -rc1, fixes for booting on 
a ppc G5, and a Kconfig fix.
two radeon fix, one oops, one s/r fix.
one udl mmap fix.
and one core drm fix to stop bad fbdev apps overwriting bits of ram.

I have some fixes from Intel I think on the way, but I'm offline until 
post-Easter from tomorrow, so maybe you'll see them maybe you won't :)

Dave.

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix fans after resume

Ben Skeggs (3):
      drm/nouveau: oops, create m2mf for nvd9 too
      Revert "drm/nouveau: inform userspace of new kernel subchannel requirements"
      drm/nouveau: inform userspace of relaxed kernel subchannel requirements

Benjamin Herrenschmidt (2):
      nouveau: Fix crash when pci_ram_rom() returns a size of 0
      nouveau/bios: Fix tracking of BIOS image data

Chris Wilson (1):
      drm: Validate requested virtual size against allocated fb size

Dave Airlie (2):
      Merge branch 'drm-nouveau-fixes' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      drm/nouveau: select POWER_SUPPLY

Konstantin Khlebnikov (1):
      mm, drm/udl: fixup vma flags on mmap

Michel Dänzer (1):
      drm/radeon: Don't dereference possibly-NULL pointer.

 drivers/gpu/drm/drm_fb_helper.c           |    8 ++++++--
 drivers/gpu/drm/nouveau/Kconfig           |    1 +
 drivers/gpu/drm/nouveau/nouveau_bios.c    |    9 ++++++---
 drivers/gpu/drm/nouveau/nouveau_channel.c |   10 +++++-----
 drivers/gpu/drm/nouveau/nouveau_dma.h     |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_state.c   |    2 +-
 drivers/gpu/drm/radeon/atom.c             |   15 ++++++++++++++-
 drivers/gpu/drm/radeon/atom.h             |    1 +
 drivers/gpu/drm/radeon/radeon_object.c    |    3 ++-
 drivers/gpu/drm/udl/udl_drv.c             |    2 +-
 drivers/gpu/drm/udl/udl_drv.h             |    1 +
 drivers/gpu/drm/udl/udl_gem.c             |   14 ++++++++++++++
 12 files changed, 54 insertions(+), 16 deletions(-)
--29444707-1559683733-1333448761=:21969--
