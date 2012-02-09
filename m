Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2BIUVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:21:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35424 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2BIUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:21:46 -0500
Date: Thu, 9 Feb 2012 12:21:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging patches for 3.3-rc3
Message-ID: <20120209202104.GA22143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git staging-3.3-rc3

for you to fetch changes up to 67435319866f89b55721fc88ca0dbda51629e3d6:

  staging: pohmelfs: remove drivers/staging/pohmelfs (2012-02-08 16:19:06 -0800)

----------------------------------------------------------------
Staging tree patches for 3.3-rc3

Big things here is the deletion of the Android pmem driver, as it's
obsolete and no one uses it, the gma500 driver as it's already in the
drm portion of the kernel tree, and the pohmelfs filesystem as it's
obsolete and a rewritten version is being proposed for the fs/ section
of the kernel.

Other than that, a smattering of different bugfixes and regressions, and
some omap drm api merge fixups that were needed due to api changes in
the main portion of the drm tree, allowing this code to build properly
again.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ameya Palande (1):
      MAINTAINERS: staging: iio: add iio information

Anton Vorontsov (1):
      staging: android/ram_console: Don't build on arches w/o ioremap

Arve Hjønnevåg (3):
      Staging: android: binder: Don't call dump_stack in binder_vma_open
      Staging: android: binder: Fix crashes when sharing a binder file between processes
      staging: android: lowmemorykiller: Don't wait more than one second for a process to die

Bart Westgeest (1):
      staging: usbip: fix to prevent potentially using uninitialized spinlock

Dan Magenheimer (2):
      zcache: fix deadlock condition
      zcache: Set SWIZ_BITS to 8 to reduce tmem bucket lock contention.

Evgeniy Polyakov (1):
      staging: pohmelfs: remove drivers/staging/pohmelfs

Greg Kroah-Hartman (1):
      staging: delete gma500 driver

Julia Lawall (1):
      drivers/staging/omapdrm/omap_fbdev.c: move free after uses

Larry Finger (3):
      staging: r8712u: Add new Sitecom UsB ID
      staging: r8712u: Fix problem when CONFIG_R8712_AP is set
      staging: r8712u: Use asynchronous firmware loading

Omar Ramirez Luna (2):
      staging: tidspbridge: fix bridge_open memory leaks
      staging: tidspbridge: fix incorrect free to drv_datap

Pekka Paalanen (2):
      Staging: asus_oled: fix image processing
      Staging: asus_oled: fix NULL-ptr crash on unloading

Randy Dunlap (1):
      staging: fix go7007-usb license

Rob Clark (7):
      staging: drm/omap: drm API update: make fops struct const
      staging: drm/omap: drm API update: addfb2
      staging: drm/omap: add drm_plane support
      staging: drm/omap: multiplanar and YUV support
      staging: drm/omap: updates for DSS fifomerge API changes
      staging: drm/omap: fix minimum width/height
      staging: drm/omap: fix locking issue

Seth Jennings (1):
      staging: zcache: fix serialization bug in zv stats

Shuah Khan (1):
      Staging: android: Remove pmem driver

 MAINTAINERS                                      |    6 +
 drivers/staging/Kconfig                          |    4 -
 drivers/staging/Makefile                         |    2 -
 drivers/staging/android/Kconfig                  |    5 +-
 drivers/staging/android/Makefile                 |    1 -
 drivers/staging/android/android_pmem.h           |   93 -
 drivers/staging/android/binder.c                 |   13 +-
 drivers/staging/android/lowmemorykiller.c        |    5 +-
 drivers/staging/android/pmem.c                   | 1345 --------------
 drivers/staging/asus_oled/asus_oled.c            |   13 +-
 drivers/staging/gma500/Kconfig                   |   33 -
 drivers/staging/gma500/Makefile                  |   52 -
 drivers/staging/gma500/TODO                      |   15 -
 drivers/staging/gma500/accel_2d.c                |  414 -----
 drivers/staging/gma500/backlight.c               |   49 -
 drivers/staging/gma500/cdv_device.c              |  350 ----
 drivers/staging/gma500/cdv_device.h              |   36 -
 drivers/staging/gma500/cdv_intel_crt.c           |  326 ----
 drivers/staging/gma500/cdv_intel_display.c       | 1508 ----------------
 drivers/staging/gma500/cdv_intel_hdmi.c          |  376 ----
 drivers/staging/gma500/cdv_intel_lvds.c          |  721 --------
 drivers/staging/gma500/displays/hdmi.h           |   33 -
 drivers/staging/gma500/displays/pyr_cmd.h        |   34 -
 drivers/staging/gma500/displays/pyr_vid.h        |   34 -
 drivers/staging/gma500/displays/tmd_cmd.h        |   34 -
 drivers/staging/gma500/displays/tmd_vid.h        |   34 -
 drivers/staging/gma500/displays/tpo_cmd.h        |   35 -
 drivers/staging/gma500/displays/tpo_vid.h        |   33 -
 drivers/staging/gma500/framebuffer.c             |  856 ---------
 drivers/staging/gma500/framebuffer.h             |   48 -
 drivers/staging/gma500/gem.c                     |  292 ---
 drivers/staging/gma500/gem_glue.c                |   89 -
 drivers/staging/gma500/gem_glue.h                |    2 -
 drivers/staging/gma500/gtt.c                     |  553 ------
 drivers/staging/gma500/gtt.h                     |   64 -
 drivers/staging/gma500/intel_bios.c              |  303 ----
 drivers/staging/gma500/intel_bios.h              |  430 -----
 drivers/staging/gma500/intel_i2c.c               |  170 --
 drivers/staging/gma500/intel_opregion.c          |   81 -
 drivers/staging/gma500/mdfld_device.c            |  714 --------
 drivers/staging/gma500/mdfld_dsi_dbi.c           |  761 --------
 drivers/staging/gma500/mdfld_dsi_dbi.h           |  173 --
 drivers/staging/gma500/mdfld_dsi_dbi_dpu.c       |  778 --------
 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h       |  154 --
 drivers/staging/gma500/mdfld_dsi_dpi.c           |  805 ---------
 drivers/staging/gma500/mdfld_dsi_dpi.h           |   78 -
 drivers/staging/gma500/mdfld_dsi_output.c        | 1014 -----------
 drivers/staging/gma500/mdfld_dsi_output.h        |  138 --
 drivers/staging/gma500/mdfld_dsi_pkg_sender.c    | 1484 ----------------
 drivers/staging/gma500/mdfld_dsi_pkg_sender.h    |  184 --
 drivers/staging/gma500/mdfld_intel_display.c     | 1404 ---------------
 drivers/staging/gma500/mdfld_msic.h              |   31 -
 drivers/staging/gma500/mdfld_output.c            |  171 --
 drivers/staging/gma500/mdfld_output.h            |   41 -
 drivers/staging/gma500/mdfld_pyr_cmd.c           |  558 ------
 drivers/staging/gma500/mdfld_tmd_vid.c           |  206 ---
 drivers/staging/gma500/mdfld_tpo_cmd.c           |  509 ------
 drivers/staging/gma500/mdfld_tpo_vid.c           |  140 --
 drivers/staging/gma500/medfield.h                |  268 ---
 drivers/staging/gma500/mid_bios.c                |  270 ---
 drivers/staging/gma500/mid_bios.h                |   21 -
 drivers/staging/gma500/mmu.c                     |  858 ---------
 drivers/staging/gma500/mrst.h                    |  252 ---
 drivers/staging/gma500/mrst_crtc.c               |  604 -------
 drivers/staging/gma500/mrst_device.c             |  634 -------
 drivers/staging/gma500/mrst_hdmi.c               |  852 ---------
 drivers/staging/gma500/mrst_hdmi_i2c.c           |  328 ----
 drivers/staging/gma500/mrst_lvds.c               |  407 -----
 drivers/staging/gma500/power.c                   |  318 ----
 drivers/staging/gma500/power.h                   |   67 -
 drivers/staging/gma500/psb_device.c              |  321 ----
 drivers/staging/gma500/psb_drm.h                 |  219 ---
 drivers/staging/gma500/psb_drv.c                 | 1230 -------------
 drivers/staging/gma500/psb_drv.h                 |  952 ----------
 drivers/staging/gma500/psb_intel_display.c       | 1429 ---------------
 drivers/staging/gma500/psb_intel_display.h       |   28 -
 drivers/staging/gma500/psb_intel_drv.h           |  230 ---
 drivers/staging/gma500/psb_intel_lvds.c          |  854 ---------
 drivers/staging/gma500/psb_intel_modes.c         |   77 -
 drivers/staging/gma500/psb_intel_reg.h           | 1235 -------------
 drivers/staging/gma500/psb_intel_sdvo.c          | 1293 --------------
 drivers/staging/gma500/psb_intel_sdvo_regs.h     |  338 ----
 drivers/staging/gma500/psb_irq.c                 |  627 -------
 drivers/staging/gma500/psb_irq.h                 |   45 -
 drivers/staging/gma500/psb_lid.c                 |   88 -
 drivers/staging/gma500/psb_reg.h                 |  582 ------
 drivers/staging/media/go7007/go7007-usb.c        |    1 +
 drivers/staging/omapdrm/Makefile                 |    1 +
 drivers/staging/omapdrm/omap_crtc.c              |  191 +--
 drivers/staging/omapdrm/omap_drv.c               |   81 +-
 drivers/staging/omapdrm/omap_drv.h               |   52 +-
 drivers/staging/omapdrm/omap_fb.c                |  224 ++-
 drivers/staging/omapdrm/omap_fbdev.c             |   59 +-
 drivers/staging/omapdrm/omap_gem.c               |   23 +-
 drivers/staging/omapdrm/omap_plane.c             |  344 ++++
 drivers/staging/omapdrm/omap_priv.h              |   12 +-
 drivers/staging/pohmelfs/Kconfig                 |   20 -
 drivers/staging/pohmelfs/Makefile                |    3 -
 drivers/staging/pohmelfs/config.c                |  611 -------
 drivers/staging/pohmelfs/crypto.c                |  878 ---------
 drivers/staging/pohmelfs/dir.c                   | 1102 ------------
 drivers/staging/pohmelfs/inode.c                 | 2055 ----------------------
 drivers/staging/pohmelfs/lock.c                  |  182 --
 drivers/staging/pohmelfs/mcache.c                |  171 --
 drivers/staging/pohmelfs/net.c                   | 1209 -------------
 drivers/staging/pohmelfs/netfs.h                 |  919 ----------
 drivers/staging/pohmelfs/path_entry.c            |  120 --
 drivers/staging/pohmelfs/trans.c                 |  706 --------
 drivers/staging/rtl8712/drv_types.h              |    7 +
 drivers/staging/rtl8712/hal_init.c               |   62 +-
 drivers/staging/rtl8712/os_intfs.c               |   14 +-
 drivers/staging/rtl8712/rtl8712_hal.h            |    1 +
 drivers/staging/rtl8712/rtl871x_sta_mgt.c        |    1 +
 drivers/staging/rtl8712/usb_intf.c               |   10 +-
 drivers/staging/tidspbridge/core/tiomap3430.c    |    2 -
 drivers/staging/tidspbridge/rmgr/drv_interface.c |   58 +-
 drivers/staging/usbip/stub_main.c                |    4 +-
 drivers/staging/zcache/zcache-main.c             |   25 +-
 118 files changed, 868 insertions(+), 40542 deletions(-)
 delete mode 100644 drivers/staging/android/android_pmem.h
 delete mode 100644 drivers/staging/android/pmem.c
 delete mode 100644 drivers/staging/gma500/Kconfig
 delete mode 100644 drivers/staging/gma500/Makefile
 delete mode 100644 drivers/staging/gma500/TODO
 delete mode 100644 drivers/staging/gma500/accel_2d.c
 delete mode 100644 drivers/staging/gma500/backlight.c
 delete mode 100644 drivers/staging/gma500/cdv_device.c
 delete mode 100644 drivers/staging/gma500/cdv_device.h
 delete mode 100644 drivers/staging/gma500/cdv_intel_crt.c
 delete mode 100644 drivers/staging/gma500/cdv_intel_display.c
 delete mode 100644 drivers/staging/gma500/cdv_intel_hdmi.c
 delete mode 100644 drivers/staging/gma500/cdv_intel_lvds.c
 delete mode 100644 drivers/staging/gma500/displays/hdmi.h
 delete mode 100644 drivers/staging/gma500/displays/pyr_cmd.h
 delete mode 100644 drivers/staging/gma500/displays/pyr_vid.h
 delete mode 100644 drivers/staging/gma500/displays/tmd_cmd.h
 delete mode 100644 drivers/staging/gma500/displays/tmd_vid.h
 delete mode 100644 drivers/staging/gma500/displays/tpo_cmd.h
 delete mode 100644 drivers/staging/gma500/displays/tpo_vid.h
 delete mode 100644 drivers/staging/gma500/framebuffer.c
 delete mode 100644 drivers/staging/gma500/framebuffer.h
 delete mode 100644 drivers/staging/gma500/gem.c
 delete mode 100644 drivers/staging/gma500/gem_glue.c
 delete mode 100644 drivers/staging/gma500/gem_glue.h
 delete mode 100644 drivers/staging/gma500/gtt.c
 delete mode 100644 drivers/staging/gma500/gtt.h
 delete mode 100644 drivers/staging/gma500/intel_bios.c
 delete mode 100644 drivers/staging/gma500/intel_bios.h
 delete mode 100644 drivers/staging/gma500/intel_i2c.c
 delete mode 100644 drivers/staging/gma500/intel_opregion.c
 delete mode 100644 drivers/staging/gma500/mdfld_device.c
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_dbi.c
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_dbi.h
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_dbi_dpu.c
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_dpi.c
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_dpi.h
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_output.c
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_output.h
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_pkg_sender.c
 delete mode 100644 drivers/staging/gma500/mdfld_dsi_pkg_sender.h
 delete mode 100644 drivers/staging/gma500/mdfld_intel_display.c
 delete mode 100644 drivers/staging/gma500/mdfld_msic.h
 delete mode 100644 drivers/staging/gma500/mdfld_output.c
 delete mode 100644 drivers/staging/gma500/mdfld_output.h
 delete mode 100644 drivers/staging/gma500/mdfld_pyr_cmd.c
 delete mode 100644 drivers/staging/gma500/mdfld_tmd_vid.c
 delete mode 100644 drivers/staging/gma500/mdfld_tpo_cmd.c
 delete mode 100644 drivers/staging/gma500/mdfld_tpo_vid.c
 delete mode 100644 drivers/staging/gma500/medfield.h
 delete mode 100644 drivers/staging/gma500/mid_bios.c
 delete mode 100644 drivers/staging/gma500/mid_bios.h
 delete mode 100644 drivers/staging/gma500/mmu.c
 delete mode 100644 drivers/staging/gma500/mrst.h
 delete mode 100644 drivers/staging/gma500/mrst_crtc.c
 delete mode 100644 drivers/staging/gma500/mrst_device.c
 delete mode 100644 drivers/staging/gma500/mrst_hdmi.c
 delete mode 100644 drivers/staging/gma500/mrst_hdmi_i2c.c
 delete mode 100644 drivers/staging/gma500/mrst_lvds.c
 delete mode 100644 drivers/staging/gma500/power.c
 delete mode 100644 drivers/staging/gma500/power.h
 delete mode 100644 drivers/staging/gma500/psb_device.c
 delete mode 100644 drivers/staging/gma500/psb_drm.h
 delete mode 100644 drivers/staging/gma500/psb_drv.c
 delete mode 100644 drivers/staging/gma500/psb_drv.h
 delete mode 100644 drivers/staging/gma500/psb_intel_display.c
 delete mode 100644 drivers/staging/gma500/psb_intel_display.h
 delete mode 100644 drivers/staging/gma500/psb_intel_drv.h
 delete mode 100644 drivers/staging/gma500/psb_intel_lvds.c
 delete mode 100644 drivers/staging/gma500/psb_intel_modes.c
 delete mode 100644 drivers/staging/gma500/psb_intel_reg.h
 delete mode 100644 drivers/staging/gma500/psb_intel_sdvo.c
 delete mode 100644 drivers/staging/gma500/psb_intel_sdvo_regs.h
 delete mode 100644 drivers/staging/gma500/psb_irq.c
 delete mode 100644 drivers/staging/gma500/psb_irq.h
 delete mode 100644 drivers/staging/gma500/psb_lid.c
 delete mode 100644 drivers/staging/gma500/psb_reg.h
 create mode 100644 drivers/staging/omapdrm/omap_plane.c
 delete mode 100644 drivers/staging/pohmelfs/Kconfig
 delete mode 100644 drivers/staging/pohmelfs/Makefile
 delete mode 100644 drivers/staging/pohmelfs/config.c
 delete mode 100644 drivers/staging/pohmelfs/crypto.c
 delete mode 100644 drivers/staging/pohmelfs/dir.c
 delete mode 100644 drivers/staging/pohmelfs/inode.c
 delete mode 100644 drivers/staging/pohmelfs/lock.c
 delete mode 100644 drivers/staging/pohmelfs/mcache.c
 delete mode 100644 drivers/staging/pohmelfs/net.c
 delete mode 100644 drivers/staging/pohmelfs/netfs.h
 delete mode 100644 drivers/staging/pohmelfs/path_entry.c
 delete mode 100644 drivers/staging/pohmelfs/trans.c
