Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1D0OJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:09:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab1D0OJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:09:17 -0400
Message-ID: <4DB8236A.2020402@redhat.com>
Date: Wed, 27 Apr 2011 11:08:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.39-rc5] media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For a series of fixes at some drivers. Most are usual driver fixes. The omap3isp is a new
driver added for .39, and some issues were noticed on it. Also, the V4L2 API Docbook has 
some additions to support some changes that were merged for .39.

Thanks!
Mauro

-

The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:

  Linux 2.6.39-rc5 (2011-04-26 20:48:50 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Andy Walls (1):
      [media] cx18: Fix list BUG for IDX stream, triggerable in cx18_probe() error clean up,

David Cohen (1):
      [media] omap3isp: stat: update struct ispstat_generic_config's comments

Guennadi Liakhovetski (8):
      [media] videobuf2: fix core to correctly identify allocation failures
      [media] videobuf2: fix an error message
      [media] v4l2-device: fix a macro definition
      [media] soc-camera: fix a recent multi-camera breakage on sh-mobile
      [media] imx074: return a meaningful error code instead of -1
      [media] soc-camera: don't dereference I2C client after it has been removed
      [media] sh_mobile_csi2: fix module reloading
      [media] V4L: sh_mobile_ceu_camera: fix typos in documentation

Laurent Pinchart (8):
      [media] media: Use correct ioctl name in MEDIA_IOC_SETUP_LINK documentation
      [media] omap3isp: resizer: Center the crop rectangle
      [media] omap3isp: resizer: Use 4-tap mode equations when the ratio is <= 512
      [media] media: Properly handle link flags in link setup, link notify callback
      [media] omap3isp: isp: Reset the ISP when the pipeline can't be stopped
      [media] omap3isp: Don't increment node entity use count when poweron fails
      [media] v4l: Don't register media entities for subdev device nodes
      [media] omap3isp: queue: Don't corrupt buf->npages when get_user_pages() fails

Marek Szyprowski (2):
      [media] media: vb2: fix incorrect v4l2_buffer->flags handling
      [media] media: vb2: correct queue initialization order

Mauro Carvalho Chehab (1):
      cx23885: Fix stv0367 Kconfig dependency

Michael Jones (5):
      [media] omap3isp: Fix trivial typos
      [media] v4l: add V4L2_PIX_FMT_Y12 format
      [media] media: add missing 8-bit bayer formats and Y12
      [media] omap3isp: ccdc: support Y10/12, 8-bit bayer fmts
      [media] omap3isp: lane shifter support

Michael Krufky (5):
      [media] tda18271: fix calculation bug in tda18271_rf_tracking_filters_init
      [media] tda18271: prog_cal and prog_tab variables should be s32, not u8
      [media] tda18271: fix bad calculation of main post divider byte
      [media] tda18271: update tda18271_rf_band as per NXP's rev.04 datasheet
      [media] tda18271: update tda18271c2_rf_cal as per NXP's rev.04 datasheet

Patrick Boettcher (4):
      [media] DIB0700: fix typo in dib0700_devices.c
      [media] FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci
      [media] dib0700: fix possible NULL pointer dereference
      [media] Fix dependencies for Technisat USB2.0 DVB-S/S2

Sakari Ailus (1):
      [media] omap3isp: resizer: Improved resizer rsz factor formula

Stanimir Varbanov (1):
      [media] omap3isp: Use isp xclk defines

Sylwester Nawrocki (4):
      [media] s5p-fimc: Fix FIMC3 pixel limits on Exynos4
      [media] s5p-fimc: Do not allow changing format after REQBUFS
      [media] s5p-fimc: Fix bytesperline and plane payload setup
      [media] s5p-fimc: Add support for the buffer timestamps and sequence

Uwe Kleine-König (1):
      [media] V4L: mx3_camera: select VIDEOBUF2_DMA_CONTIG instead of VIDEOBUF_DMA_CONTIG

 Documentation/DocBook/media-entities.tmpl          |    1 +
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |    2 +-
 Documentation/DocBook/v4l/pixfmt-y12.xml           |   79 ++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml               |    1 +
 Documentation/DocBook/v4l/subdev-formats.xml       |   59 +++++++++++
 Documentation/video4linux/sh_mobile_ceu_camera.txt |    6 +-
 drivers/media/common/tuners/tda18271-common.c      |   11 +--
 drivers/media/common/tuners/tda18271-fe.c          |   21 ++--
 drivers/media/common/tuners/tda18271-maps.c        |   12 +-
 drivers/media/dvb/b2c2/flexcop-pci.c               |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    4 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    6 +-
 drivers/media/media-entity.c                       |    8 +-
 drivers/media/video/Kconfig                        |    2 +-
 drivers/media/video/cx18/cx18-streams.c            |   10 ++-
 drivers/media/video/cx23885/Kconfig                |    1 +
 drivers/media/video/imx074.c                       |    2 +-
 drivers/media/video/omap3isp/isp.c                 |   38 +++++--
 drivers/media/video/omap3isp/isp.h                 |   12 +-
 drivers/media/video/omap3isp/ispccdc.c             |   37 ++++++--
 drivers/media/video/omap3isp/isppreview.c          |    2 +-
 drivers/media/video/omap3isp/ispqueue.c            |    6 +-
 drivers/media/video/omap3isp/ispresizer.c          |   75 +++++++++++---
 drivers/media/video/omap3isp/ispstat.h             |    6 +-
 drivers/media/video/omap3isp/ispvideo.c            |  108 +++++++++++++++++---
 drivers/media/video/omap3isp/ispvideo.h            |    3 +
 drivers/media/video/s5p-fimc/fimc-capture.c        |    8 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |   74 +++++++++-----
 drivers/media/video/sh_mobile_ceu_camera.c         |   10 +-
 drivers/media/video/sh_mobile_csi2.c               |   11 ++-
 drivers/media/video/soc_camera.c                   |    7 +-
 drivers/media/video/v4l2-dev.c                     |   15 ++-
 drivers/media/video/videobuf2-core.c               |   17 ++-
 drivers/media/video/videobuf2-dma-contig.c         |    2 +-
 include/linux/v4l2-mediabus.h                      |    7 +-
 include/linux/videodev2.h                          |    1 +
 include/media/v4l2-device.h                        |    2 +-
 37 files changed, 514 insertions(+), 154 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

