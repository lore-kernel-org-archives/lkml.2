Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0KLVeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:34:20 -0500
Received: from kroah.org ([198.145.64.141]:57073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0KLVeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:34:19 -0500
Date: Fri, 12 Nov 2010 13:32:09 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for .37-rc
Message-ID: <20101112213209.GA9294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of staging tree fixes for your .37-rc tree.

The majority of the size here is reverting a bunch of tidspbridge
patches that went in during the .37-rc1 merge that turned out to be
incorrect, breaking the driver.  So they are now reverted here, and a
tiny fixup was added to get the driver back into working shape.  Part of
that included an OMAP core change, which was acked by the OMAP
maintainer.

Outside of the tidspbridge fixes, there are a number of smaller patches
that resolve a few build fixes and other minor bugs that have shown up.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

All of these patches have been in the -next trees for a while.
These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------


 MAINTAINERS                                        |    2 +-
 arch/arm/plat-omap/devices.c                       |    4 +-
 drivers/staging/ath6kl/Kconfig                     |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    5 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         |    7 +-
 drivers/staging/batman-adv/hard-interface.c        |   15 +-
 drivers/staging/batman-adv/routing.c               |   12 +-
 drivers/staging/batman-adv/routing.h               |    4 +-
 drivers/staging/batman-adv/unicast.c               |    2 +-
 drivers/staging/bcm/Bcmchar.c                      |   49 +-
 drivers/staging/brcm80211/README                   |    2 +-
 drivers/staging/brcm80211/TODO                     |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    2 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   12 +-
 drivers/staging/cpia/cpia.c                        |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |    1 -
 drivers/staging/hv/hv_utils.c                      |    3 -
 .../staging/intel_sst/intel_sst_app_interface.c    |  284 +++---
 drivers/staging/intel_sst/intel_sst_common.h       |    4 +-
 drivers/staging/keucr/init.c                       |   18 +-
 drivers/staging/keucr/ms.c                         |   14 +-
 drivers/staging/keucr/msscsi.c                     |    6 +-
 drivers/staging/keucr/sdscsi.c                     |    4 +-
 drivers/staging/keucr/smilsub.c                    |   18 +-
 drivers/staging/keucr/transport.c                  |    2 +-
 drivers/staging/rt2860/common/cmm_aes.c            |    2 -
 drivers/staging/rt2860/usb_main_dev.c              |    1 +
 drivers/staging/rtl8192e/r8192E_core.c             |    3 +
 drivers/staging/stradis/stradis.c                  |   11 +-
 drivers/staging/tidspbridge/Kconfig                |    1 -
 drivers/staging/tidspbridge/Makefile               |    7 +-
 drivers/staging/tidspbridge/core/_deh.h            |    5 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   19 +-
 drivers/staging/tidspbridge/core/dsp-mmu.c         |  317 ------
 drivers/staging/tidspbridge/core/io_sm.c           |  180 +++-
 drivers/staging/tidspbridge/core/tiomap3430.c      | 1083 ++++++++++++++++++--
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    4 +
 drivers/staging/tidspbridge/core/tiomap_io.c       |   17 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |  115 ++-
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 +
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 ++
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 ++++
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 ++
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  562 ++++++++++
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  163 +++
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 +
 .../staging/tidspbridge/include/dspbridge/dev.h    |   24 +
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 ++
 .../staging/tidspbridge/include/dspbridge/drv.h    |   10 +
 .../tidspbridge/include/dspbridge/dsp-mmu.h        |   67 --
 .../tidspbridge/include/dspbridge/dspdefs.h        |   44 +
 .../tidspbridge/include/dspbridge/dspioctl.h       |    7 +
 .../staging/tidspbridge/include/dspbridge/proc.h   |   46 +
 drivers/staging/tidspbridge/pmgr/dev.c             |   63 ++-
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 ++++++++++
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   34 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |   15 +
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +
 drivers/staging/tidspbridge/rmgr/node.c            |   48 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |  197 ++++-
 drivers/staging/udlfb/udlfb.c                      |    2 +-
 drivers/staging/vt6656/main_usb.c                  |    3 +-
 .../staging/westbridge/astoria/api/src/cyasusb.c   |    1 -
 drivers/staging/wlan-ng/cfg80211.c                 |    6 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    2 +-
 65 files changed, 3755 insertions(+), 795 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/core/dsp-mmu.c
 create mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 create mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 create mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 create mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 create mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 create mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
 create mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c

---------------

Ben Hutchings (2):
      Staging: ath6kl: Fix pointer casts on 64-bit architectures
      Staging: Update parameters for cfg80211 key management operation

Brett Rudley (1):
      staging: brcm80211: Maintainer change

Chris Lang (1):
      Staging: batman-adv: fix interface alternating and bonding reggression

Dan Carpenter (6):
      Staging: sst: dereferencing user pointers
      Staging: sst: more dereferencing user pointers
      Staging: sst: fixups in SNDRV_SST_STREAM_DECODE
      Staging: sst: user pointers in intel_sst_mmap_play_capture()
      Staging: sst: add some __user anotations
      Staging: bcm: use get_user() to access user pointers

Daniel Lichtenberger (1):
      Staging: rtl8192e: fix IOMMU memory leak

Felipe Contreras (14):
      omap: dsp: remove shm from normal memory
      staging: tidspbridge: hardcode SCM macros while fix is upstreamed
      Revert "staging: tidspbridge - update Kconfig to select IOMMU module"
      Revert "staging: tidspbridge - remove dmm custom module"
      Revert "staging: tidspbridge - deprecate reserve/unreserve_memory funtions"
      Revert "staging: tidspbridge - remove reserved memory clean up"
      Revert "staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct"
      Revert "staging: tidspbridge - move all iommu related code to a new file"
      Revert "staging: tidspbridge - remove hw directory"
      Revert "staging: tidspbridge - fix mmufault support"
      Revert "staging: tidspbridge - remove custom mmu code from tiomap3430.c"
      Revert "staging: tidspbridge - rename bridge_brd_mem_map/unmap to a proper name"
      Revert "staging: tidspbridge - move shared memory iommu maps to tiomap3430.c"
      Revert "staging: tidspbridge: replace iommu custom for opensource implementation"

Greg Kroah-Hartman (1):
      Staging: the MAINTAINERS git location was incorrect

Hauke Mehrtens (1):
      Staging: ath6kl: Adapt API changes in cfg80211

Joe Perches (1):
      Staging: udlfb.c: Fix k.alloc switched arguments

Julia Lawall (2):
      drivers/staging: delete double assignment
      drivers/staging/brcm80211/brcmfmac/dhd_linux.c: delete double assignment

Konstantin Katuev (1):
      Staging: keucr driver: fix uninitialized variable & proper memset length

Larry Finger (1):
      staging: rt2870: Add new USB ID for Belkin F6D4050 v1

Marek Lindner (1):
      Staging: batman-adv: suppress false warning when changing the mac address

Maximiliano David Bustos (1):
      Staging: wlan-ng: Fix wrong #ifdef #endif sequence

Randy Dunlap (1):
      Staging: ath6kl: ATH6KL_CFG80211 depends on CFG80211

Vasiliy Kulikov (3):
      staging: cpia: fix camera file owner in cpia_open()
      staging: stradis: fix error handling and information leak to userland
      staging: vt6656: implement missing brackets

