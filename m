Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab2JKTgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:36:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759205Ab2JKTgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:36:06 -0400
Date: Thu, 11 Oct 2012 16:36:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.7-rc1] media updates - part 2
Message-ID: <20121011163602.333dc78f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the second part of media patches for v3.7-rc1.

Despite its size, most of the stuff here is trivial. This series contain:

	- s5p-mfc: additions at the driver and at the core to support H.264
	  hardware codec;
	- Some improvements at s5p and davinci embedded drivers;
	- Some V4L2 compliance fixes applied on a few drivers;
	- Several random trivial patches, including several fixes
	  and a few new board support additions;

---

Notes:

1) Some Exynos media patches were dependent on some -arm fixes that got
merged on changeset 782cd9e. That's why this pull request is based that
changeset.

2) As promised, I reviewed the pending VB2 DMABUF series. 

While setting a test environment, it was noticed that the upstream support
for Samsung Exynos 4 boards (smdk310 and Origen) are broken upstream,
likely due to regressions: both defconfigs are wrong and regulator 
settings for both boards are broken. That, allied with some bug at 
the dummy regulator driver, causes OOPSes during boot time.

Long story short: even fixing the above, the proposed patches OOPSed
when running the DMABUF test. Not sure yet if the OOPSes are due to
some other undetected regressions, or due to some bug on the patches.

Due to the above, DMABUF patches for vb2 got NACKed for 3.7.

Thanks!
Mauro

-

The following changes since commit 782cd9ee985b1523f1ddad57657a24d7855d9e4d:

  Merge branch 'fixes2' into fixes (2012-10-09 08:48:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to bf3b202b41999f88f091632f13842b7234bd58b7:

  Merge branch 'staging/for_v3.7' into v4l_for_linus (2012-10-11 15:07:19 -0300)

----------------------------------------------------------------

Alfredo Jesús Delaiti (1):
      [media] Mygica X8507 audio for YPbPr, AV and S-Video

Andy Shevchenko (1):
      [media] dvb-usb: print small buffers via %*ph

Antti Palosaari (2):
      [media] cxd2820r: silence compiler warning
      [media]  dvb: LNA implementation changes

Arun Kumar K (6):
      [media] v4l: Add fourcc definitions for new formats
      [media] v4l: Add control definitions for new H264 encoder features
      [media] s5p-mfc: Prepare driver for callback based re-architecture
      [media] s5p-mfc: Update MFCv5 driver for callback based architecture
      [media] s5p-mfc: Add MFC variant data to device context
      [media] s5p-mfc: Set vfl_dir for encoder

Dan Carpenter (3):
      [media] rc: divide by zero bugs in s_tx_carrier()
      [media] rc-core: fix return codes in ir_lirc_ioctl()
      [media] cx25821: testing the wrong variable

Ezequiel Garcia (3):
      [media] em28xx: Replace memcpy with struct assignment
      [media] uvc: Add return code check at vb2_queue_init()
      [media] stk1160: Add support for S-Video input

Frank Schäfer (1):
      [media] ov2640: select sensor register bank before applying h/v-flip settings

Guilherme Herrmann Destefani (1):
      [media] bt8xx: Add video4linux control V4L2_CID_COLOR_KILLER

Hans Verkuil (24):
      [media] dm644x: replace the obsolete preset API by the timings API
      [media] s5p-g2d: fix compiler warning
      [media] s5p-fimc: fix compiler warning
      [media] fsl-viu: fix compiler warning
      [media] vpif_capture: remove unused data structure
      [media] vpif_display: remove unused data structures
      [media] vpif_capture: move input_idx to channel_obj
      [media] vpif_display: move output_id to channel_obj
      [media] vpif_capture: remove unnecessary can_route flag
      [media] vpif_capture: move routing info from subdev to input
      [media] vpif_capture: first init subdevs, then register device nodes
      [media] vpif_display: first init subdevs, then register device nodes
      [media] vpif_display: fix cleanup code
      [media] vpif_capture: fix cleanup code
      [media] vpif_capture: separate subdev from input
      [media] vpif_display: use a v4l2_subdev pointer to call a subdev
      [media] davinci: move struct vpif_interface to chan_cfg
      [media] tvp514x: s_routing should just change routing, not try to detect a signal
      [media] videobuf2-core: move plane verification out of __fill_v4l2/vb_buffer
      [media] videobuf2-core: fill in length field for multiplanar buffers
      [media] v4l2-ioctl.c: handle PREPARE_BUF like QUERYBUF
      [media] DocBook: various updates w.r.t. v4l2_buffer and multiplanar
      [media] v4l2-ioctl: add blocks check for VIDIOC_SUBDEV_G/S_EDID
      [media] v4l2-ioctl: fix W=1 warnings

Hans-Frieder Vogt (1):
      [media] af9033: prevent unintended underflow

Ido Yariv (1):
      [media] omap3isp: Fix compilation error in ispreg.h

Javier Martin (1):
      [media] media: mx2_camera: Don't modify non volatile parameters in try_fmt

Jeongtae Park (2):
      [media] s5p-mfc: MFCv6 register definitions
      [media] s5p-mfc: Update MFC v4l2 driver to support MFC6.x

Lad, Prabhakar (10):
      [media] media: davinci: vpfe: fix build error
      [media] media: davinci: vpbe: fix build warning
      [media] davinci: vpbe: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with V4L2_OUT_CAP_DV_TIMINGS
      [media] media: v4l2-ctrls: add control for test pattern
      [media] media: v4l2-ctrl: add a helper function to add standard control with driver specific menu
      [media] media: mt9p031/mt9t001/mt9v032: use V4L2_CID_TEST_PATTERN for test pattern control
      [media] media: davinci: vpif: add check for NULL handler
      [media] media: davinci: vpif: display: separate out subdev from output
      [media] media: davinci: vpif: Add return code check at vb2_queue_init()
      [media] media: davinci: vpif: set device capabilities

Laurent Pinchart (1):
      [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check

Manjunath Hadli (3):
      [media] ths7303: enable THS7303 for HD modes
      [media] ARM: davinci: da850: Add SoC related definitions for VPIF
      [media] ARM: davinci: da850 evm: Add EVM specific code for VPIF to work

Mauro Carvalho Chehab (5):
      Merge branch 'samsung_platform_data' into staging/for_v3.7
      [media] mt2063: properly handle return error codes
      [media] tda18271-common: hold the I2C adapter during write transfers
      Revert "[media] omap3isp: Replace cpu_is_omap3630() with ISP revision check"
      Merge branch 'staging/for_v3.7' into v4l_for_linus

Patrick Boettcher (1):
      [media] technisat-usb2: add a MODULE_DEVICE_TABLE for udev autoload

Peter Senna Tschudin (16):
      [media] drivers/media/pci/cx88/cx88-blackbird.c: removes unnecessary semicolon
      [media] drivers/media/dvb-frontends/itd1000.c: removes unnecessary semicolon
      [media] drivers/media/dvb-frontends/sp8870.c: removes unnecessary semicolon
      [media] drivers/media/radio/si4713-i2c.c: removes unnecessary semicolon
      [media] drivers/media/platform/soc_camera/mx2_camera.c: fix error return code
      [media] drivers/media/platform/soc_camera/soc_camera.c: fix error return code
      [media] drivers/media/dvb-frontends/dvb_dummy_fe.c: Removes useless kfree()
      [media] drivers/media/dvb-frontends/lg2160.c: Removes useless kfree()
      [media] drivers/media/dvb-frontends/s5h1432.c: Removes useless kfree()
      [media] drivers/media/dvb-frontends/s921.c: Removes useless kfree()
      [media] drivers/media/dvb-frontends/stb6100.c: Removes useless kfree()
      [media] drivers/media/dvb-frontends/tda665x.c: Removes useless kfree()
      [media] drivers/media/platform/davinci/vpbe.c: Removes useless kfree()
      [media] drivers/media/tuners/mt2063.c: Removes useless kfree()
      [media] drivers/media/platform/davinci/vpbe.c: Remove unused label and rename remaining labels
      [media] drivers/media: Remove unnecessary semicolon

Rémi Cardona (1):
      [media] ds3000: add module parameter to force firmware upload

Sachin Kamat (6):
      [media] soc_camera: Use module_platform_driver macro
      [media] soc_camera: Use devm_kzalloc function
      [media] mem2mem_testdev: Fix incorrect location of v4l2_m2m_release()
      [media] mem2mem_testdev: Add missing braces around sizeof
      [media] mem2mem_testdev: Use pr_err instead of printk
      [media] mem2mem_testdev: Use devm_kzalloc() in probe

Sean Young (2):
      [media] iguanair: cannot send data from the stack
      [media] winbond: remove space from driver name

Sylwester Nawrocki (16):
      [media] V4L: Add s_rx_buffer subdev video operation
      [media] V4L: Add [get/set]_frame_desc subdev callbacks
      [media] V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus format
      [media] V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
      [media] s5p-csis: Add support for non-image data packets capture
      [media] s5p-fimc: Add support for V4L2_PIX_FMT_S5C_UYVY_JPG fourcc
      [media] m5mols: Implement .get_frame_desc subdev callback
      [media] ARM: samsung: Remove unused fields from FIMC and CSIS platform data
      [media] ARM: samsung: Change __s5p_mipi_phy_control() function signature
      [media] s5p-csis: Change regulator supply names
      [media] ARM: EXYNOS: Change MIPI-CSIS device regulator supply names
      [media] s5p-csis: Replace phy_enable platform data callback with direct call
      [media] s5p-fimc: Remove unused platform data structure fields
      [media] s5p-csis: Allow to specify pixel clock's source through platform data
      [media] soc-camera: Use new selection target definitions
      [media] m5mols: Add missing #include <linux/sizes.h>

Thomas Abraham (1):
      [media] s5p-jpeg: use clk_prepare_enable and clk_disable_unprepare

Tomasz Stanislawski (1):
      [media] media: s5p-hdmi: add HPD GPIO to platform data

Wolfgang Bail (1):
      [media] rc-msi-digivox-ii: Add full scan keycodes

 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/controls.xml       |  278 ++-
 Documentation/DocBook/media/v4l/io.xml             |    6 +-
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |   17 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |   38 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |   44 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |    3 +-
 .../DocBook/media/v4l/vidioc-querybuf.xml          |   11 +-
 Documentation/video4linux/v4l2-controls.txt        |   24 +
 arch/arm/mach-davinci/Kconfig                      |    7 +
 arch/arm/mach-davinci/board-da850-evm.c            |  179 ++
 arch/arm/mach-davinci/board-dm644x-evm.c           |   15 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |   80 +-
 arch/arm/mach-davinci/da850.c                      |  152 ++
 arch/arm/mach-davinci/dm644x.c                     |   17 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |   11 +
 arch/arm/mach-davinci/include/mach/mux.h           |   42 +
 arch/arm/mach-davinci/include/mach/psc.h           |    1 +
 arch/arm/mach-exynos/mach-nuri.c                   |    7 +-
 arch/arm/mach-exynos/mach-origen.c                 |    4 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |    7 +-
 arch/arm/plat-samsung/setup-mipiphy.c              |   20 +-
 drivers/media/dvb-core/dvb_frontend.c              |   20 +-
 drivers/media/dvb-core/dvb_frontend.h              |    4 +-
 drivers/media/dvb-frontends/a8293.c                |    2 +-
 drivers/media/dvb-frontends/af9013.c               |    6 +-
 drivers/media/dvb-frontends/af9033.c               |   16 +-
 drivers/media/dvb-frontends/bcm3510.c              |    2 +-
 drivers/media/dvb-frontends/cx24110.c              |    6 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |    3 +-
 drivers/media/dvb-frontends/drxd_hard.c            |    2 +-
 drivers/media/dvb-frontends/ds3000.c               |   12 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c         |   21 +-
 drivers/media/dvb-frontends/isl6405.c              |    2 +-
 drivers/media/dvb-frontends/isl6421.c              |    2 +-
 drivers/media/dvb-frontends/itd1000.c              |    2 +-
 drivers/media/dvb-frontends/lg2160.c               |    8 +-
 drivers/media/dvb-frontends/lnbp21.c               |    4 +-
 drivers/media/dvb-frontends/lnbp22.c               |    2 +-
 drivers/media/dvb-frontends/s5h1432.c              |    8 +-
 drivers/media/dvb-frontends/s921.c                 |    9 +-
 drivers/media/dvb-frontends/si21xx.c               |    4 +-
 drivers/media/dvb-frontends/sp8870.c               |    6 +-
 drivers/media/dvb-frontends/sp887x.c               |    6 +-
 drivers/media/dvb-frontends/stb6100.c              |    8 +-
 drivers/media/dvb-frontends/stv0299.c              |    6 +-
 drivers/media/dvb-frontends/stv0900_core.c         |    4 +-
 drivers/media/dvb-frontends/tda665x.c              |    8 +-
 drivers/media/dvb-frontends/tda8083.c              |    4 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |    2 +-
 drivers/media/i2c/m5mols/m5mols.h                  |   10 +
 drivers/media/i2c/m5mols/m5mols_capture.c          |    3 +
 drivers/media/i2c/m5mols/m5mols_core.c             |   47 +
 drivers/media/i2c/m5mols/m5mols_reg.h              |    1 +
 drivers/media/i2c/mt9p031.c                        |   19 +-
 drivers/media/i2c/mt9t001.c                        |   22 +-
 drivers/media/i2c/mt9v032.c                        |   54 +-
 drivers/media/i2c/soc_camera/ov2640.c              |    5 +
 drivers/media/i2c/ths7303.c                        |  106 +-
 drivers/media/i2c/tvp514x.c                        |   77 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   30 +-
 drivers/media/pci/bt8xx/bttvp.h                    |    1 +
 drivers/media/pci/bt8xx/dst_ca.c                   |    2 +-
 drivers/media/pci/cx23885/altera-ci.c              |    4 +-
 drivers/media/pci/cx23885/cimax2.c                 |    2 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |    3 +
 drivers/media/pci/cx23885/cx23885-video.c          |    3 +-
 .../media/pci/cx25821/cx25821-video-upstream-ch2.c |    2 +-
 drivers/media/pci/cx25821/cx25821-video-upstream.c |    2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    6 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    2 +-
 drivers/media/pci/cx88/cx88-tvaudio.c              |    4 +-
 drivers/media/pci/cx88/cx88-video.c                |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/platform/Kconfig                     |    4 +-
 drivers/media/platform/davinci/vpbe.c              |  136 +-
 drivers/media/platform/davinci/vpbe_display.c      |   80 +-
 drivers/media/platform/davinci/vpbe_venc.c         |   25 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   17 +-
 drivers/media/platform/davinci/vpif_capture.c      |  370 ++--
 drivers/media/platform/davinci/vpif_capture.h      |   16 +-
 drivers/media/platform/davinci/vpif_display.c      |  275 ++-
 drivers/media/platform/davinci/vpif_display.h      |   18 +-
 drivers/media/platform/exynos-gsc/gsc-regs.c       |    4 +-
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/media/platform/mem2mem_testdev.c           |   14 +-
 drivers/media/platform/omap3isp/ispreg.h           |    6 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c     |  135 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   19 +-
 drivers/media/platform/s5p-fimc/fimc-core.h        |   28 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |   25 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c         |   23 +-
 drivers/media/platform/s5p-fimc/fimc-reg.h         |    3 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |   75 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    6 +-
 drivers/media/platform/s5p-mfc/Makefile            |    7 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |  408 ++++
 drivers/media/platform/s5p-mfc/regs-mfc.h          |   41 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  294 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c       |  111 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h       |   17 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |  166 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h    |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |  156 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h    |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  191 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  202 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  258 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h       |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  236 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h       |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_intr.c      |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       | 1418 +-------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  137 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    | 1794 ++++++++++++++++++
 .../s5p-mfc/{s5p_mfc_shm.h => s5p_mfc_opr_v5.h}    |   41 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 1956 ++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |   50 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c       |   47 -
 drivers/media/platform/soc_camera/mx2_camera.c     |    7 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   40 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    2 +-
 drivers/media/radio/si4713-i2c.c                   |   12 +-
 drivers/media/rc/ene_ir.c                          |    5 +-
 drivers/media/rc/iguanair.c                        |  147 +-
 drivers/media/rc/ir-lirc-codec.c                   |    4 +-
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |   36 +-
 drivers/media/rc/nuvoton-cir.c                     |    3 +
 drivers/media/rc/redrat3.c                         |    3 +
 drivers/media/rc/winbond-cir.c                     |    2 +-
 drivers/media/tuners/mt2063.c                      |   44 +-
 drivers/media/tuners/mt2063.h                      |    4 -
 drivers/media/tuners/tda18271-common.c             |  104 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |    4 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |    2 +-
 drivers/media/usb/dvb-usb/a800.c                   |    2 +-
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |    3 +-
 drivers/media/usb/dvb-usb/dibusb-common.c          |    2 +-
 drivers/media/usb/dvb-usb/digitv.c                 |    2 +-
 drivers/media/usb/dvb-usb/dtt200u.c                |    2 +-
 drivers/media/usb/dvb-usb/m920x.c                  |    2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |    1 +
 drivers/media/usb/em28xx/em28xx-cards.c            |    2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   13 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   15 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    7 +-
 drivers/media/usb/stk1160/stk1160.h                |    3 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   10 +-
 drivers/media/usb/uvc/uvc_video.c                  |    4 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   74 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    8 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   79 +-
 include/linux/dvb/version.h                        |    2 +-
 include/linux/platform_data/mipi-csis.h            |   30 +-
 include/linux/v4l2-controls.h                      |   42 +
 include/linux/v4l2-mediabus.h                      |    5 +
 include/linux/videodev2.h                          |    5 +
 include/media/davinci/vpbe.h                       |   14 +-
 include/media/davinci/vpbe_types.h                 |    8 +-
 include/media/davinci/vpbe_venc.h                  |    2 +-
 include/media/davinci/vpif_types.h                 |   26 +-
 include/media/s5p_fimc.h                           |    2 -
 include/media/s5p_hdmi.h                           |    2 +
 include/media/v4l2-ctrls.h                         |   23 +
 include/media/v4l2-subdev.h                        |   48 +
 171 files changed, 8076 insertions(+), 3212 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v6.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
 rename drivers/media/platform/s5p-mfc/{s5p_mfc_shm.h => s5p_mfc_opr_v5.h} (76%)
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
 delete mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_shm.c
