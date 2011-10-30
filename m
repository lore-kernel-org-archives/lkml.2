Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab1J3KOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 06:14:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40155 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933378Ab1J3KOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 06:14:14 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18bbd4D42gbvQGCGv9MKZmQirFvDJ2VlMGWm6pRzf
	OYW78Ild6fox+q
Message-ID: <4EAD236F.6070608@gmx.de>
Date: Sun, 30 Oct 2011 10:14:07 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev updates for 3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes to the fbdev subsystem. It contains

- a series from Laurent which touches many different drivers to sanitize their
panning behavior

- two patches to fix the suspend/resume locking issue

- a little fix to our EDID parsing

- a new driver for SMSC UFX6000/7000 USB display devices

- a new driver for Aeroflex Gaisler GRVGA IP core

- a lot of driver updates for OMAP, sh_mobile, fsl-diu-fb, au1200fb, udlfb and
viafb, a few patches to others

It's the same tree (only a different branch) you used to pull viafb updates from
so, I think, you can trust it. You will probably experience some (trivial) merge
conflicts related to xgifb and OMAP, please let me know if you want me to handle
them.


Thanks,

Florian Tobias Schandinat


The following changes since commit 976d167615b64e14bc1491ca51d424e2ba9a5e84:

  Linux 3.1-rc9 (2011-10-04 18:11:50 -0700)

are available in the git repository at:
  git://github.com/schandinat/linux-2.6.git fbdev-next

Ajay Kumar (1):
      video: s3c-fb: Add S5P64X0 specific s3c_fb_driverdata

Anatolij Gustschin (1):
      video: mb862xx-i2c: fix for reliable decoder register access

Andrew Kephart (1):
      udlfb: Search config descriptor if not at device level

Andy Doan (1):
      OMAPFB: make debug message more useful

Archit Taneja (26):
      OMAP: DSS2: DISPC: Prepare dispc_dump_regs() for shortening
      OMAP: DSS2: DISPC: Shorten dispc_dump_regs()
      OMAP: DSS2: DISPC: dispc_save_context() and dispc_restore_context() cleanup
      OMAP: DSS2: DISPC: Shorten _dispc_set_color_conv_coef()
      OMAP: DSS2: Use a macro to declare size of the fifo_size array in dispc.c
      OMAP: DSS2: Use MIPI DSI enums from include/video/mipi_display.h
      OMAP: DSS2: DSI: Represent L4 and VP as sources of VC instead of modes
      OMAP: DSS2: Create enum for DSI operation modes
      OMAP: DSS2: DSI: Introduce generic write functions
      OMAP: DSS2: DSI: Remove functions dsi_vc_dcs_read_1() and dsi_vc_dcs_read_2()
      OMAP: DSS2: DSI: Split dsi_vc_dcs_read() into 2 functions
      OMAP: DSS2: DSI: Introduce generic read functions
      OMAP: DSS2: Clean up stallmode and io pad mode selection
      OMAP: DSS2: Create an enum for DSI pixel formats
      OMAP: DSS2: DSI: Send zero length packet in dsi_vc_send_null()
      OMAP: DSS2: DSI Video mode support
      OMAPDSS: DISPC: Reduce the number of arguments in dispc_ovl_setup()
      OMAPDSS: DISPC: Pass overlay params as arguments to dispc_ovl_setup()
      OMAPDSS: DISPC: Create helper function dispc_mgr_is_lcd()
      OMAPDSS: DISPC: Get correct pixel clock for TV manager
      OMAPDSS: DISPC: Remove hardcoded use of PPL in five tap clock calculation
      OMAPDSS: DISPC: Clean up scaling related clock and five tap calculations
      OMAPDSS: FEATURES: Create a range param to get max downscaling
      OMAPDSS/OMAP_VOUT: Fix incorrect OMAP3-alpha compatibility setting
      OMAPDSS: DISPC: VIDEO3 pipeline support
      OMAPDSS: DISPC: zorder support for DSS overlays

Arnd Bergmann (1):
      video/omap: fix build dependencies

Axel Lin (3):
      video: mxsfb: add missing include of linux/module.h
      video: nuc900fb: remove include of mach/clkdev.h
      video: platinumfb: Add __devexit_p at necessary place

Bernie Thompson (4):
      drivers/video/udlfb match class, subclass, and protocol
      udlfb: add more comprehensive support for DPMS FB_BLANK_* modes
      udlfb: Enable fb_defio by default
      udlfb: Enable fbcon access to framebuffer by default

Bruno Prémont (1):
      fb: sh-mobile: Fix deadlock risk between lock_fb_info() and console_lock()

Damian Hobson-Garcia (5):
      fbdev: sh_mobile_meram: Enable runtime PM
      fbdev: sh_mobile_meram: Enable/disable MERAM along with LCDC
      fbdev: sh_mobile_meram: Move private data from .h to .c
      fbdev: sh_mobile_meram: Backup/restore device registers on shutdown/resume
      fbdev: sh_mobile_meram: Assign meram to the SH7372_A4LC power domain

Dan Carpenter (1):
      smscufx: change edid data to u8 instead of char

Daniel Morsing (1):
      OMAP: DSS2: Don't allow moving managers away from enabled displays

Dima Zavin (1):
      OMAP: DSS: dispc: enable/disable clocks in error handler

Dr. David Alan Gilbert (1):
      udlfb: fix issues found with Sparse static analysis

Florian Tobias Schandinat (21):
      viafb: use display information in info not in var for panning
      viafb: improve pitch handling
      viafb: use more compact modesetting functions
      viafb: kill viafb_load_crtc_timing
      viafb: remove superfluous register unlocking/locking
      viafb: remove superfluous mode lookup
      viafb: simplify viafb_fill_crtc_timing
      viafb: remove 640x480-60 CRT special case
      viafb: add new funcions to select a single mode
      viafb: eliminate viafb_get_pixclock
      viafb: use information in var for modesetting
      viafb: seperate hardware initialization
      viafb: eliminate modetable dependancy of LCD modesetting
      viafb: get rid of the remaining modetable structure assumptions
      Merge commit 'v3.1-rc2' into HEAD
      Merge branch 'pan-fixes' of git://linuxtv.org/pinchartl/fbdev into fbdev-next
      Merge branch 'master' of git://git.kernel.org/.../lethal/fbdev-3.x into
fbdev-next
      Merge branch 'sh-mobile-lcdc' of git://linuxtv.org/pinchartl/fbdev into
fbdev-next
      Merge branch 'viafb-next' of git://github.com/schandinat/linux-2.6 into
fbdev-next
      Merge commit 'v3.1-rc9' into fbdev-next
      Merge branch 'for-florian' of git://gitorious.org/linux-omap-dss2/linux
into fbdev-next

Herton Ronaldo Krzesinski (1):
      fb: avoid possible deadlock caused by fb_set_suspend

Jean Delvare (1):
      carminefb: Fix module parameters permissions

Jesper Juhl (1):
      Remove unneeded version.h includes from drivers/video/

Jingoo Han (1):
      video: s3c-fb: Add support EXYNOS4 FIMD

Joe Perches (1):
      video: Fix speficied typo

Julia Lawall (1):
      drivers/video/msm/mdp.c: adjust error handling code

Kay Sievers (1):
      drivers/video/udlfb bind framebuffer to interface.

Kristoffer Glembo (1):
      video: Add Aeroflex Gaisler GRVGA framebuffer device driver

Laurent Pinchart (77):
      vfb: use display information in info not in var for panning
      staging: xgifb: use display information in info not in var for panning
      acornfb: Dont BUG() on invalid pan parameters
      s3fb: use display information in info not in var for panning
      mx3fb: use display information in info not in var for panning
      neofb: use display information in info not in var for panning
      savagefb: use display information in info not in var for panning
      sm501fb: use display information in info not in var for panning
      imsttfb: use display information in info not in var for panning
      gxt4500: use display information in info not in var for panning
      pm2fb: use display information in info not in var for panning
      sisfb: use display information in info not in var for panning
      atmel_lcdfb: use display information in info not in var for panning
      intelfb: use display information in info not in var for panning
      tridentfb: use display information in info not in var for panning
      vga16fb: use display information in info not in var for panning
      radeonfb: use display information in info not in var for panning
      hgafb: use display information in info not in var for panning
      pm3fb: use display information in info not in var for panning
      acornfb: use display information in info not in var for panning
      fbdev: unicore32: use display information in info not in var for panning
      s3c-fb: use display information in info not in var for panning
      mb862xxfb: use display information in info not in var for panning
      g364fb: use display information in info not in var for panning
      arkfb: use display information in info not in var for panning
      68328fb: use display information in info not in var for panning
      vt8623fb: use display information in info not in var for panning
      vt8500lcdfb: use display information in info not in var for panning
      fbdev: da8xx: use display information in info not in var for panning
      fbdev: sh_mobile_lcdc: Turn dot clock on before resuming from runtime PM
      fbdev: sh_mobile_lcdc: Replace hardcoded register values with macros
      fbdev: sh_mobile_lcdc: Don't acknowlege interrupts unintentionally
      fbdev: sh_mobile_lcdc: Compute clock pattern using divider denominator
      fbdev: sh_mobile_lcdc: Split LCDC start code from sh_mobile_lcdc_start
      fbdev: sh_mobile_lcdc: Store the frame buffer base address when panning
      fbdev: sh_mobile_lcdc: Restart LCDC in runtime PM resume handler
      fbdev: sh_mobile_meram: Replace hardcoded register values with macros
      fbdev: sh_mobile_meram: Validate ICB configuration outside mutex
      fbdev: sh_mobile_meram: Fix MExxCTL register save on runtime PM suspend
      fbdev: sh_mobile_meram: Remove unneeded sh_mobile_meram.h
      68328fb: use display information in info not in var for panning
      acornfb: Dont BUG() on invalid pan parameters
      acornfb: use display information in info not in var for panning
      arkfb: use display information in info not in var for panning
      atmel_lcdfb: use display information in info not in var for panning
      radeonfb: use display information in info not in var for panning
      fbdev: da8xx: use display information in info not in var for panning
      fbdev: unicore32: use display information in info not in var for panning
      g364fb: use display information in info not in var for panning
      gxt4500: use display information in info not in var for panning
      hgafb: use display information in info not in var for panning
      imsttfb: use display information in info not in var for panning
      intelfb: use display information in info not in var for panning
      mb862xxfb: use display information in info not in var for panning
      mx3fb: use display information in info not in var for panning
      neofb: use display information in info not in var for panning
      pm2fb: use display information in info not in var for panning
      pm3fb: use display information in info not in var for panning
      s3c-fb: use display information in info not in var for panning
      s3fb: use display information in info not in var for panning
      savagefb: use display information in info not in var for panning
      sisfb: use display information in info not in var for panning
      sm501fb: use display information in info not in var for panning
      tridentfb: use display information in info not in var for panning
      vfb: use display information in info not in var for panning
      vga16fb: use display information in info not in var for panning
      vt8500lcdfb: use display information in info not in var for panning
      vt8623fb: use display information in info not in var for panning
      staging: xgifb: use display information in info not in var for panning
      sh_mobile_meram: Reset ICBs at unregistration time
      fbdev: sh_mobile_lcdc: Adjust requested parameters in .fb_check_var
      fbdev: sh_mobile_lcdc: Add support for format changes at runtime
      fbdev: sh_mobile_lcdc: use display information in info for panning
      fbdev: sh_mobile_lcdc: Update fix.line_length in .fb_set_par()
      fbdev: sh_mobile_lcdc: Avoid forward declarations
      fbdev: sh_mobile_lcdc: Split channel initialization from probe function
      fbdev: sh_mobile_lcdc: Remove sh_mobile_lcdc_set_bpp()

Manjunathappa, Prakash (2):
      video: da8xx-fb: Interrupt configuration of revised LCDC IP
      video: da8xx-fb: Increased resolution configuration of revised LCDC IP

Manuel Lauss (7):
      au1200fb: use framebuffer_alloc()
      au1200fb: fixup PM
      au1200fb: make number of windows configurable at load time.
      au1200fb: switch to FB_SYS helpers
      au1200fb: fix hardcoded IRQ
      fbdev: au1200fb: silence debug output
      fb: fix au1100fb bitrot.

Mayuresh Janorkar (1):
      OMAP: DSS2: Add picodlp panel driver

Mythri P K (14):
      OMAP4: DSS2: HDMI: HDMI clean up to pass base_address
      OMAP4: DSS2: HDMI: Move pll and video configuration
      OMAP4: DSS2: HDMI: Use specific HDMI timings structure
      OMAP4: DSS2: HDMI: Move HDMI IP independent generic header
      OMAP4: DSS2: HDMI: Move the EDID definition from HDMI
      OMAP4: DSS2: HDMI: Split the current HDMI driver to move
      OMAP4: DSS2: HDMI: Move the HDMI IP dependent audio
      OMAP4: DSS2: HDMI: Rename the functions in HDMI IP library
      OMAP4: DSS2: HDMI: Function pointer approach to call
      OMAP4: DSS2: Rename hdmi_omap4_panel.c to hdmi_panel.c
      OMAPDSS: HDMI: Move the comments in avi infoframe
      OMAPDSS: HDMI: Replace hdmi_reg struct with u16
      OMAPDSS: HDMI: Add missing register definitions
      OMAPDSS: HDMI: Add support to dump registers through debugfs

Paul Mundt (4):
      Merge branch 'fbdev/panning-fixes'
      Merge branch 'fbdev/stable-updates'
      Merge branch 'fbdev/stable-updates'
      Merge branch 'viafb-next' of git://github.com/schandinat/linux-2.6

Steve Glendinning (2):
      Add support for SMSC UFX6000/7000 USB display adapters
      smscufx: reduce number of casts in ufx_raw_rect

Stuart Hopkins (1):
      udlfb: Add module option to do without shadow framebuffer

Tejun Heo (1):
      video: don't use flush_scheduled_work() in fb_defio

Thomas Weber (2):
      OMAP: DSS2: Support for Innolux AT070TN83
      OMAP: Devkit8000: Change lcd driver to AT070TN83

Timur Tabi (24):
      drivers/video: use strings to specify the Freescale DIU monitor port
      fbdev: fix indentation in modedb.c
      drivers/video: fsl-diu-fb: clean up whitespace and formatting
      drivers/video: fsl-diu-fb: clean up printk usage
      drivers/video: fsl-diu-fb: remove unused ioctls
      drivers/video: fsl-diu-fb: fix compilation warning
      drivers/video: fsl-diu-fb: improve device tree usage
      drivers/video: fsl-diu-fb: remove redundant default video mode
      drivers/video: fsl-diu-fb: improve local variable usage in some functions
      drivers/video: fsl-diu-fb: set the driver name to "fsl-diu-fb"
      drivers/video: fsl-diu-fb: fix potential memcpy buffer overflow bug
      drivers/video: fsl-diu-fb: fix memory leak on error
      drivers/video: fsl-diu-fb: use a normal for-loop to uninstall framebuffers
      drivers/video: fsl-diu-fb: the video buffer is not I/O memory
      drivers/video: fsl-diu-fb: remove unusued MEM_ALLOC_THRESHOLD
      drivers/video: fsl-diu-fb: fix some ioctls
      drivers/video: fsl-diu-fb: move some definitions out of the header file
      drivers/video: fsl-diu-fb: remove broken screen blanking support
      drivers/video: fsl-diu-fb: add several new video modes
      drivers/video: fsl-diu-fb: use an enum for the AOI index
      drivers/video: fsl-diu-fb: remove unused panel operating mode support
      drivers/video: fsl-diu-fb: only DIU modes 0 and 1 are supported
      drivers/video: fsl-diu-fb: merge diu_hw into fsl_diu_data
      drivers/video: fsl-diu-fb: merge diu_pool into fsl_diu_data

Tomi Valkeinen (64):
      fbdev: fix parsing of standard timings
      OMAP: DSS2: PicoDLP: fix error handling in power_on
      OMAP: DSS2: check for manager when enabling display
      Revert "HACK: OMAP: DSS2: clk hack for OMAP2/3"
      Revert "OMAP: DSS2: HDMI: fix hdmi clock name"
      OMAP: DSS2: remove unneeded fck enable/disables
      OMAP: DSS2: Change DSI device naming
      OMAP4: TWL: Add common omapdss supplies
      OMAP: DSS2: DSI: Improve dsi_mux_pads parameters
      OMAP: DSS2: Implement dsi_mux_pads for OMAP4
      OMAP: OMAPFB: make omapfb start even when a display is missing a driver
      OMAP: DSS2: fix clock sources on error and uninit
      OMAP: DSS2: Handle manager change in apply
      OMAP: DSS2: Remove "EXPERIMENTAL" from Kconfig
      OMAP: DSS2: Remove support for non-DISPC overlays
      OMAP: DSS2: DISPC: use lookup tables for bit shifts
      OMAP: DSS2: Add overlay caps to DSS features
      OMAP: DSS2: Add GLOBAL_ALPHA & PRE_MULT_ALPHA to ovl caps
      OMAP: DSS2: string parsing cleanups
      OMAP: OMAPFB: string parsing cleanups
      OMAP: DSS2: DISPC: remove non-existing func prototypes
      OMAP: DSS2: DISPC: rename overlay related funcs
      OMAP: DSS2: DISPC: rename manager related funcs
      OMAP: DSS2: reorganize functions in dss.h
      OMAP: DSS2: DISPC: Fix minimum PCD value
      OMAP: DSS2: HDMI: use default dividers
      OMAP: DSS2: HDMI: change regn definition
      OMAP: DSS2: DSI: Add comment about regn
      OMAP: DSS2: DISPC: Add missing IRQ  definitions
      OMAP: DSS2: add dss_get_hdmi_venc_clk_source()
      OMAP: DSS2: DISPC: improve dispc_mgr_enable_digit_out()
      OMAP: DSS2: HDMI: improve hdmi output enable
      OMAP: DSS2: add read_edid() to omap_dss_driver struct
      OMAP: DSS2: add detect() to omap_dss_driver struct
      OMAP: DSS2: HDMI: make set_timing saner
      OMAP: DSS2: HDMI: implement read_edid()
      OMAP: DSS2: HDMI: remove edid parsing
      OMAP: DSS2: HDMI: split hdmi_core_ddc_edid
      OMAP: DSS2: HDMI: clean up edid reading & fix checksum
      OMAP: DSS2: HDMI: remove error prints in check_timings
      OMAP: DSS2: HDMI: implement detect()
      OMAP: DSS2: add panel-dvi driver
      OMAP: use dvi panel driver instead of generic-dpi
      OMAP: stalker: Remove LCD device from board file
      OMAP: DSS2: panel-generic-dpi: remove "generic" panel
      OMAP: Add DDC i2c_bus_num to board files
      OMAPFB: find best mode from edid
      OMAPDSS: Taal: remove external backlight support
      OMAPFB: Remove unused lcd drivers
      OMAPDSS: Port 2430sdp display driver to DSS2
      OMAPDSS: Port the H4 display driver to DSS2
      OMAPDSS: Port the Apollon display driver to DSS2
      OMAPDSS: Add N800 panel driver
      OMAPDSS: remove vaddr from overlay info
      OMAP: 4430SDP: Remove unneeded lcd config
      OMAP4: 4430SDP: Add panel support to board file
      OMAP4: 4430SDP: Add picodlp support to board file
      OMAP: RX51: Remove unused old omapfb stuff
      OMAP: omap3touchbook: Remove unused lcd stuff
      OMAP: 2420SDP: Port the display driver to new DSS2
      OMAP: LDP: Port the display driver to new DSS2
      OMAP: H4: Port the display driver to new DSS2
      OMAP: Apollon: Port the display driver to new DSS2
      OMAPDSS: picodlp: add missing #include <linux/module.h>

Wang Shaoyan (2):
      viafb: fix pointer type missmatch
      viafb: replace strict_strtoul to kstrto* and check return value

Wolfram Sang (1):
      video: s3c2410: remove unused variable

Wolfram Stering (1):
      mx3fb: fix NULL pointer dereference in screen blanking.

Yong Zhang (1):
      video: irq: Remove IRQF_DISABLED

 Documentation/fb/udlfb.txt                         |   39 +-
 MAINTAINERS                                        |    6 +
 arch/arm/mach-omap2/board-2430sdp.c                |   78 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    7 +-
 arch/arm/mach-omap2/board-4430sdp.c                |  208 ++-
 arch/arm/mach-omap2/board-am3517evm.c              |    6 +-
 arch/arm/mach-omap2/board-apollon.c                |   35 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    6 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   10 +-
 arch/arm/mach-omap2/board-h4.c                     |   42 +-
 arch/arm/mach-omap2/board-igep0020.c               |    8 +-
 arch/arm/mach-omap2/board-ldp.c                    |  123 ++-
 arch/arm/mach-omap2/board-omap3beagle.c            |    8 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    7 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   40 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   18 -
 arch/arm/mach-omap2/board-omap4panda.c             |    8 +-
 arch/arm/mach-omap2/board-overo.c                  |    7 +-
 arch/arm/mach-omap2/board-rx51.c                   |   25 -
 arch/arm/mach-omap2/display.c                      |   60 +-
 arch/arm/mach-omap2/twl-common.c                   |   11 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    1 +
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   24 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |   47 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |   55 +-
 arch/powerpc/sysdev/fsl_soc.h                      |   25 +-
 drivers/media/video/omap/omap_vout.c               |   18 +-
 drivers/staging/xgifb/XGI_main_26.c                |   22 +-
 drivers/video/68328fb.c                            |    4 +-
 drivers/video/Kconfig                              |   34 +-
 drivers/video/Makefile                             |    2 +
 drivers/video/acornfb.c                            |    5 +-
 drivers/video/arkfb.c                              |    9 +-
 drivers/video/atmel_lcdfb.c                        |   15 +-
 drivers/video/aty/radeon_base.c                    |   10 +-
 drivers/video/au1100fb.c                           |  181 +--
 drivers/video/au1100fb.h                           |    6 +-
 drivers/video/au1200fb.c                           |  299 ++--
 drivers/video/backlight/adp8860_bl.c               |    1 -
 drivers/video/backlight/adp8870_bl.c               |    1 -
 drivers/video/bf54x-lq043fb.c                      |    2 +-
 drivers/video/bfin-lq035q1-fb.c                    |    2 +-
 drivers/video/bfin-t350mcqb-fb.c                   |    2 +-
 drivers/video/bfin_adv7393fb.c                     |    2 +-
 drivers/video/carminefb.c                          |    6 +-
 drivers/video/controlfb.c                          |    2 +-
 drivers/video/da8xx-fb.c                           |  186 ++-
 drivers/video/fb-puv3.c                            |    4 +-
 drivers/video/fb_defio.c                           |    3 +-
 drivers/video/fbmem.c                              |    3 -
 drivers/video/fbmon.c                              |   21 +-
 drivers/video/fbsysfs.c                            |    3 +
 drivers/video/fsl-diu-fb.c                         |  992 +++++-----
 drivers/video/g364fb.c                             |    5 +-
 drivers/video/grvga.c                              |  579 ++++++
 drivers/video/gxt4500.c                            |    4 +-
 drivers/video/hgafb.c                              |    4 +-
 drivers/video/imsttfb.c                            |    2 +-
 drivers/video/intelfb/intelfbhw.c                  |    6 +-
 drivers/video/mb862xx/mb862xx-i2c.c                |    2 +-
 drivers/video/mb862xx/mb862xxfbdrv.c               |    6 +-
 drivers/video/modedb.c                             |  444 +++---
 drivers/video/msm/mddi.c                           |    2 +-
 drivers/video/msm/mdp.c                            |    6 +-
 drivers/video/mx3fb.c                              |   19 +-
 drivers/video/mxsfb.c                              |    1 +
 drivers/video/neofb.c                              |    4 +-
 drivers/video/nuc900fb.c                           |    3 +-
 drivers/video/omap/Kconfig                         |   29 -
 drivers/video/omap/Makefile                        |    8 -
 drivers/video/omap/lcd_2430sdp.c                   |  203 --
 drivers/video/omap/lcd_apollon.c                   |  136 --
 drivers/video/omap/lcd_h4.c                        |  117 --
 drivers/video/omap/lcd_ldp.c                       |  201 --
 drivers/video/omap/lcd_omap3beagle.c               |  130 --
 drivers/video/omap/lcd_omap3evm.c                  |  193 --
 drivers/video/omap/lcd_overo.c                     |  180 --
 drivers/video/omap2/displays/Kconfig               |   28 +-
 drivers/video/omap2/displays/Makefile              |    3 +
 drivers/video/omap2/displays/panel-dvi.c           |  363 ++++
 drivers/video/omap2/displays/panel-generic-dpi.c   |  113 +-
 drivers/video/omap2/displays/panel-n8x0.c          |  747 ++++++++
 drivers/video/omap2/displays/panel-picodlp.c       |  594 ++++++
 drivers/video/omap2/displays/panel-picodlp.h       |  288 +++
 drivers/video/omap2/displays/panel-taal.c          |  125 +-
 drivers/video/omap2/dss/Kconfig                    |    2 +-
 drivers/video/omap2/dss/Makefile                   |    2 +-
 drivers/video/omap2/dss/core.c                     |    4 +
 drivers/video/omap2/dss/dispc.c                    | 1700 +++++++----------
 drivers/video/omap2/dss/dispc.h                    |   57 +
 drivers/video/omap2/dss/display.c                  |   31 +-
 drivers/video/omap2/dss/dpi.c                      |   28 +-
 drivers/video/omap2/dss/dsi.c                      |  929 ++++++----
 drivers/video/omap2/dss/dss.c                      |   18 +-
 drivers/video/omap2/dss/dss.h                      |  156 +-
 drivers/video/omap2/dss/dss_features.c             |  130 ++-
 drivers/video/omap2/dss/dss_features.h             |   17 +-
 drivers/video/omap2/dss/hdmi.c                     | 1260 ++-----------
 .../omap2/dss/{hdmi_omap4_panel.c => hdmi_panel.c} |   68 +-
 drivers/video/omap2/dss/manager.c                  |  191 +--
 drivers/video/omap2/dss/overlay.c                  |  122 +-
 drivers/video/omap2/dss/rfbi.c                     |   45 +-
 drivers/video/omap2/dss/sdi.c                      |   19 +-
 drivers/video/omap2/dss/ti_hdmi.h                  |  138 ++
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c          | 1239 ++++++++++++
 .../video/omap2/dss/{hdmi.h => ti_hdmi_4xxx_ip.h}  |  400 ++---
 drivers/video/omap2/dss/venc.c                     |   27 +-
 drivers/video/omap2/omapfb/Kconfig                 |    2 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |  134 ++-
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |    6 +-
 drivers/video/platinumfb.c                         |    4 +-
 drivers/video/pm2fb.c                              |    6 +-
 drivers/video/pm3fb.c                              |    6 +-
 drivers/video/ps3fb.c                              |    2 +-
 drivers/video/pxa3xx-gcu.c                         |    4 +-
 drivers/video/pxafb.c                              |    2 +-
 drivers/video/s3c-fb.c                             |  117 ++-
 drivers/video/s3c2410fb.c                          |    3 +-
 drivers/video/s3fb.c                               |    9 +-
 drivers/video/sa1100fb.c                           |    3 +-
 drivers/video/savage/savagefb_driver.c             |   16 +-
 drivers/video/sh_mobile_hdmi.c                     |   47 +-
 drivers/video/sh_mobile_lcdcfb.c                   | 1162 ++++++------
 drivers/video/sh_mobile_lcdcfb.h                   |   12 +-
 drivers/video/sh_mobile_meram.c                    |  208 ++-
 drivers/video/sh_mobile_meram.h                    |   41 -
 drivers/video/sis/sis_main.c                       |   30 +-
 drivers/video/skeletonfb.c                         |    2 +-
 drivers/video/sm501fb.c                            |    6 +-
 drivers/video/smscufx.c                            | 1994 ++++++++++++++++++++
 drivers/video/tmiofb.c                             |    2 +-
 drivers/video/tridentfb.c                          |    4 +-
 drivers/video/udlfb.c                              |  187 ++-
 drivers/video/valkyriefb.c                         |    2 +-
 drivers/video/vfb.c                                |    4 +-
 drivers/video/vga16fb.c                            |    2 +-
 drivers/video/via/dvi.c                            |   34 +-
 drivers/video/via/dvi.h                            |    3 +-
 drivers/video/via/global.c                         |    2 +
 drivers/video/via/global.h                         |    2 +
 drivers/video/via/hw.c                             |  544 +-----
 drivers/video/via/hw.h                             |  285 +---
 drivers/video/via/lcd.c                            |   53 +-
 drivers/video/via/lcd.h                            |    7 +-
 drivers/video/via/share.h                          |   23 +-
 drivers/video/via/via-core.c                       |    2 +-
 drivers/video/via/via_modesetting.c                |  104 +
 drivers/video/via/via_modesetting.h                |   23 +
 drivers/video/via/viafbdev.c                       |  182 +-
 drivers/video/via/viamode.c                        |   60 +-
 drivers/video/via/viamode.h                        |    4 +-
 drivers/video/vt8500lcdfb.c                        |    6 +-
 drivers/video/vt8623fb.c                           |    9 +-
 drivers/video/xilinxfb.c                           |    1 -
 include/linux/fsl-diu-fb.h                         |   92 +-
 include/video/omap-panel-dvi.h                     |   37 +
 include/video/omap-panel-n8x0.h                    |   15 +
 include/video/omap-panel-nokia-dsi.h               |    8 +-
 include/video/omap-panel-picodlp.h                 |   23 +
 include/video/omapdss.h                            |  100 +-
 include/video/sh_mobile_lcdc.h                     |  135 ++-
 include/video/udlfb.h                              |    1 +
 163 files changed, 12022 insertions(+), 7619 deletions(-)
 create mode 100644 drivers/video/grvga.c
 delete mode 100644 drivers/video/omap/lcd_2430sdp.c
 delete mode 100644 drivers/video/omap/lcd_apollon.c
 delete mode 100644 drivers/video/omap/lcd_h4.c
 delete mode 100644 drivers/video/omap/lcd_ldp.c
 delete mode 100644 drivers/video/omap/lcd_omap3beagle.c
 delete mode 100644 drivers/video/omap/lcd_omap3evm.c
 delete mode 100644 drivers/video/omap/lcd_overo.c
 create mode 100644 drivers/video/omap2/displays/panel-dvi.c
 create mode 100644 drivers/video/omap2/displays/panel-n8x0.c
 create mode 100644 drivers/video/omap2/displays/panel-picodlp.c
 create mode 100644 drivers/video/omap2/displays/panel-picodlp.h
 rename drivers/video/omap2/dss/{hdmi_omap4_panel.c => hdmi_panel.c} (79%)
 create mode 100644 drivers/video/omap2/dss/ti_hdmi.h
 create mode 100644 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
 rename drivers/video/omap2/dss/{hdmi.h => ti_hdmi_4xxx_ip.h} (54%)
 delete mode 100644 drivers/video/sh_mobile_meram.h
 create mode 100644 drivers/video/smscufx.c
 create mode 100644 include/video/omap-panel-dvi.h
 create mode 100644 include/video/omap-panel-n8x0.h
 create mode 100644 include/video/omap-panel-picodlp.h
