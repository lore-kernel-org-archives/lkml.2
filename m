Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0C3Eef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 00:34:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48340 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0C3Eed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 00:34:33 -0400
Date: Tue, 30 Mar 2010 05:34:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1003300530150.5127@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1092764274-1269923654=:5127"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1092764274-1269923654=:5127
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


[re-pull request]

Original pull req below + reverts the fallback placement change which had 
a side effect of causing more lockups on some AGP systems (this is a bug in 
the AGP drivers that needs to be tracked down), adds some further fixes 
from Alex for radeon. Also in case you are wondering why this has a 
v2.6.34-rc2 merge in the middle of it, one of the radeon changes needed an 
i2c change before I could test it.

original pull text:
Some nouveau updates + misc drm core fixes,

radeon kms: mostly fixes, however a cleanup to the ugly asic tables to
avoid drift between C prototypes moves some stuff around, and I've merged
Jerome's GPU recovery code, as I'd much rather users had some of hope of
recovering from their GPU locking up than a dead box. It seems to work
for quite a lot of people that have tested it, and it won't make a GPU
lockup problem worse. This also finally fixes HDMI audio on rv7xx cards.

The following changes since commit 220bf991b0366cc50a94feede3d7341fa5710ee4:
  Linus Torvalds (1):
        Linux 2.6.34-rc2

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Alex Deucher (32):
      drm/radeon: add new RS880 pci id
      drm/radeon/kms/atom: spread spectrum fix
      drm/radeon/kms: use lcd pll limits when available
      drm/radeon/kms: further spread spectrum fixes
      drm/radeon/kms: fix pal tv-out support on legacy IGP chips
      drm/radeon/kms: fix for hw i2c
      drm/radeon/kms: fix i2c prescale calc on older radeons
      drm/radeon/kms/r1xx: enable hw i2c
      drm/radeon/kms/rs4xx: make sure crtcs are enabled when setting timing
      drm/radeon/r600: add missing license and comments to r600_blit_shaders.c
      drm/radeon/kms: expose thermal/fan i2c buses
      drm/radeon/kms/pm: fix segfault in clock code
      drm/radeon/kms: gfx init fixes for r6xx/r7xx
      drm/radeon/kms/pm: fix typo in power table parsing
      drm/radeon/kms: init rdev->num_crtc at asic init
      drm/radeon/kms: display watermark fixes
      drm/radeon/kms: never treat rs4xx as AGP
      drm/radeon/kms: fix display bandwidth setup on rs4xx
      drm/radeon/kms: remove lvds quirks
      drm/radeon/kms/atom: make sure tables are valid (v2)
      drm/radeon/kms: use new pre/post_xfer i2c bit algo hooks
      drm/radeon/kms: add hw_i2c module option
      drm/radeon/r600: remove some regs are not safe regs for command buffers
      drm/radeon/kms: fix some typos in r6xx/r7xx hpd setup
      drm/radeon/r6xx/r7xx: CS parser fixes
      drm/radeon/kms: bump the version for r6xx/r7xx const buffer support
      drm/radeon: bump the UMS driver version for r6xx/r7xx const buffer support
      drm/radeon/r6xx/r7xx: further safe reg clean up
      drm/radeon/kms: fix macbookpro connector quirk
      drm/radeon/kms/atom: minor fixes to transmitter setup
      drm/radeon/kms/dp: remove extraneous training complete call
      drm/radeon/kms: minor fixes for eDP with LCD* device tags (v2)

Ben Skeggs (5):
      drm/nouveau: add option to allow override of dcb connector table types
      drm/nouveau: Gigabyte NX85T connector table lies, it has DVI-I not HDMI
      drm/nv50: fix connector table parsing for some cards
      drm/nouveau: add module option to disable TV detection
      drm/edid: allow certain bogus edids to hit a fixup path rather than fail

Chris Wilson (1):
      drm: Return ENODEV if the inode mapping changes

Daniel Vetter (5):
      drm/radeon: create radeon_asic.c
      drm/radeon: move asic structs to radeon_asic.c
      drm/radeon: unconfuse return value of radeon_asic->clear_surface_reg
      drm/radeon: include radeon_asic.h in the asic specific files
      drm/radeon: collect r100 asic related declarations in radeon_asic.h

Dave Airlie (8):
      drm/ttm: use drm calloc large and free large
      Merge remote branch 'nouveau/for-airlied' into drm-linus
      Merge branch 'radeon-for-airlied' of ../linux-2.6 into drm-linus
      drm/radeon/bo: add some fallback placements for VRAM only objects.
      drm/radeon/kms: don't print error on -ERESTARTSYS.
      Merge branch 'v2.6.34-rc2' into HEAD
      Merge branch 'drm-radeon-fixes' into HEAD
      Revert "drm/radeon/bo: add some fallback placements for VRAM only objects."

Francisco Jerez (2):
      drm/nv04-nv40: Fix up the programmed horizontal sync pulse delay.
      drm/nouveau: Never evict VRAM buffers to system.

Jerome Glisse (6):
      drm/radeon/kms: catch atombios infinite loop and break out of it
      drm/radeon/kms: fence cleanup + more reliable GPU lockup detection V4
      drm/radeon/kms: rename gpu_reset to asic_reset
      drm/radeon/kms: simplify & improve GPU reset V2
      drm/radeon/kms: fix typo in r520 asic functions
      drm/radeon/kms: avoid possible oops (call gart_fini before gart_disable)

Maarten Maathuis (2):
      drm/nouveau: print a message very early during suspend
      drm/nv50: add a memory barrier to pushbuf submission

Marcin Ko¶cielnicki (4):
      drm/nv50: Remove redundant/incorrect ctxvals initialisation.
      drm/nouveau: Fix fbcon corruption with font width not divisible by 8
      drm/nv50: Make ctxprog wait until interrupt handler is done.
      drm/nv50: Improve PGRAPH interrupt handling.

Michel Dänzer (1):
      drm/radeon/kms: Only restrict BO to visible VRAM size when pinning to VRAM.

Pauli Nieminen (1):
      drm/radeon/kms: Fix NULL pointer dereference if memory allocation failed.

Rafa³ Mi³ecki (8):
      drm/radeon/kms: clean HDMI definitions
      drm/radeon/kms: clean assigning HDMI blocks to encoders
      drm/radeon/kms: add HDMI code for pre-DCE3 R6xx GPUs
      drm/radeon/kms: enable audio engine on DCE32
      drm/radeon/kms: remove dead audio/HDMI code
      drm/radeon/kms: improve coding style a little
      drm/radeon/kms: switch to condition waiting for reclocking
      drm/radeon/kms: prepare for more reclocking operations

Randy Dunlap (2):
      drm/vmwgfx: depends on FB
      drm: fix build error when SYSRQ is disabled

Robert P. J. Day (1):
      drm: "kobject_init/kobject_add" -> "kobject_init_and_add".

Zhao Yakui (1):
      drm: remove the EDID blob stored in the EDID property when it is disconnected

 drivers/gpu/drm/drm_crtc_helper.c           |    1 +
 drivers/gpu/drm/drm_edid.c                  |    9 -
 drivers/gpu/drm/drm_fb_helper.c             |    2 +
 drivers/gpu/drm/drm_fops.c                  |   16 +-
 drivers/gpu/drm/nouveau/Makefile            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |   28 +-
 drivers/gpu/drm/nouveau/nouveau_bios.h      |    3 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c        |    3 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_dma.c       |    5 +
 drivers/gpu/drm/nouveau/nouveau_drv.c       |   10 +
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    6 +
 drivers/gpu/drm/nouveau/nouveau_irq.c       |  609 +++++++++++++++++++--
 drivers/gpu/drm/nouveau/nouveau_state.c     |    5 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c         |    6 +-
 drivers/gpu/drm/nouveau/nv04_fbcon.c        |    6 +-
 drivers/gpu/drm/nouveau/nv50_display.c      |    4 +-
 drivers/gpu/drm/nouveau/nv50_fb.c           |   32 ++
 drivers/gpu/drm/nouveau/nv50_fbcon.c        |    2 +-
 drivers/gpu/drm/nouveau/nv50_graph.c        |   22 +-
 drivers/gpu/drm/nouveau/nv50_grctx.c        |   13 +-
 drivers/gpu/drm/radeon/Makefile             |    2 +-
 drivers/gpu/drm/radeon/atom.c               |   91 +++-
 drivers/gpu/drm/radeon/atom.h               |    8 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |   98 +++-
 drivers/gpu/drm/radeon/atombios_dp.c        |    3 -
 drivers/gpu/drm/radeon/evergreen.c          |   19 +-
 drivers/gpu/drm/radeon/r100.c               |  262 +++++----
 drivers/gpu/drm/radeon/r100d.h              |  128 +++++
 drivers/gpu/drm/radeon/r200.c               |    1 +
 drivers/gpu/drm/radeon/r300.c               |  161 +++---
 drivers/gpu/drm/radeon/r300d.h              |   47 ++-
 drivers/gpu/drm/radeon/r420.c               |    6 +-
 drivers/gpu/drm/radeon/r520.c               |   14 +-
 drivers/gpu/drm/radeon/r600.c               |  113 ++---
 drivers/gpu/drm/radeon/r600_audio.c         |   52 +--
 drivers/gpu/drm/radeon/r600_blit_kms.c      |    3 +
 drivers/gpu/drm/radeon/r600_blit_shaders.c  |   35 ++
 drivers/gpu/drm/radeon/r600_cp.c            |    3 +
 drivers/gpu/drm/radeon/r600_cs.c            |   70 +++-
 drivers/gpu/drm/radeon/r600_hdmi.c          |  191 ++++---
 drivers/gpu/drm/radeon/r600_reg.h           |   10 +-
 drivers/gpu/drm/radeon/r600d.h              |   49 ++
 drivers/gpu/drm/radeon/radeon.h             |  175 +++----
 drivers/gpu/drm/radeon/radeon_asic.c        |  786 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_asic.h        |  562 ++-----------------
 drivers/gpu/drm/radeon/radeon_atombios.c    |  461 +++++++++-------
 drivers/gpu/drm/radeon/radeon_combios.c     |    7 +-
 drivers/gpu/drm/radeon/radeon_connectors.c  |    2 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |   15 +-
 drivers/gpu/drm/radeon/radeon_device.c      |  261 ++-------
 drivers/gpu/drm/radeon/radeon_display.c     |   51 ++-
 drivers/gpu/drm/radeon/radeon_drv.c         |    7 +-
 drivers/gpu/drm/radeon/radeon_drv.h         |    3 +-
 drivers/gpu/drm/radeon/radeon_encoders.c    |  106 ++--
 drivers/gpu/drm/radeon/radeon_fence.c       |  107 ++--
 drivers/gpu/drm/radeon/radeon_gart.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_i2c.c         |  153 +++---
 drivers/gpu/drm/radeon/radeon_irq_kms.c     |   14 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    8 +
 drivers/gpu/drm/radeon/radeon_legacy_tv.c   |   29 +-
 drivers/gpu/drm/radeon/radeon_mode.h        |   12 +-
 drivers/gpu/drm/radeon/radeon_object.c      |    6 +-
 drivers/gpu/drm/radeon/radeon_pm.c          |   46 ++-
 drivers/gpu/drm/radeon/reg_srcs/r600        |   75 ---
 drivers/gpu/drm/radeon/rs400.c              |   11 +-
 drivers/gpu/drm/radeon/rs600.c              |   85 +++-
 drivers/gpu/drm/radeon/rs600d.h             |   46 ++
 drivers/gpu/drm/radeon/rs690.c              |   93 ++--
 drivers/gpu/drm/radeon/rv515.c              |  106 +----
 drivers/gpu/drm/radeon/rv515d.h             |   46 ++
 drivers/gpu/drm/radeon/rv770.c              |   37 +-
 drivers/gpu/drm/ttm/ttm_bo.c                |    4 +-
 drivers/gpu/drm/ttm/ttm_memory.c            |   18 +-
 drivers/gpu/drm/ttm/ttm_tt.c                |   23 +-
 drivers/gpu/drm/vmwgfx/Kconfig              |    2 +-
 include/drm/drmP.h                          |   34 +--
 include/drm/drm_mem_util.h                  |   65 +++
 include/drm/drm_pciids.h                    |    1 +
 include/drm/ttm/ttm_bo_driver.h             |    1 -
 80 files changed, 3503 insertions(+), 2109 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/nv50_fb.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_asic.c
 create mode 100644 include/drm/drm_mem_util.h
--29444707-1092764274-1269923654=:5127--
