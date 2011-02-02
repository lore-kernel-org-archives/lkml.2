Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1BBMTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:19:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1BBMTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:19:31 -0500
Message-ID: <4D494BCD.8080002@redhat.com>
Date: Wed, 02 Feb 2011 10:19:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v2.6.38-rc5] V4L/DVB patches
References: <4D493AD9.2040708@redhat.com>
In-Reply-To: <4D493AD9.2040708@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-02-2011 09:07, Mauro Carvalho Chehab escreveu:
> Hi Linus,
> 
> Those are a few new drivers that I was intended to send for -rc1, but the
> videobuf2 tests took me a longer time than what I expected. I opted to
> not send them you last week, as you were at LCA.
> 
> So, please pull from:
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git ..BRANCH.NOT.VERIFIED..

Gah! I should remind to never ever send an email early morning without drinking
a strong cup of cofeee... I sent the pull request from the wrong local branch. Sorry.

The correct one is:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

This series contain:
	- Videobuf2;
	- multi-planar streaming extension to V4L2 API, and the corresponding
	  DocBook patches;
	- staging/cxd2099 (a driver for CI modules found on ngene-based boards)
	  plus the ngene glue;
	- dib9000 driver, plus dibcom drivers glue;
	- Trivial patches to add support for a new saa7134 drevice (Encore FM3).

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Andreas Regel (1):
      [media] stv090x: make sleep/wakeup specific to the demod path

Andrzej Pietrasiewicz (1):
      [media] v4l: videobuf2: add DMA scatter/gather allocator

Hans Verkuil (1):
      [media] DocBook/v4l: fix validation errors

Hyunwoong Kim (5):
      [media] s5p-fimc: fix the value of YUV422 1-plane formats
      [media] s5p-fimc: Configure scaler registers depending on FIMC version
      [media] s5p-fimc: update checking scaling ratio range
      [media] s5p-fimc: Support stop_streaming and job_abort
      [media] s5p-fimc: fix MSCTRL.FIFO_CTRL for performance enhancement

Marek Szyprowski (4):
      [media] v4l: videobuf2: add generic memory handling routines
      [media] v4l: videobuf2: add read() and write() emulator
      [media] v4l: mem2mem: port to videobuf2
      [media] v4l: mem2mem: port m2m_testdev to vb2

Mauro Carvalho Chehab (9):
      [media] technisat-usb2: Don't use a deprecated call
      [media] vb2 core: Fix a few printk warnings
      [media] dib7000p: Fix 4-byte wrong alignments for some case statements
      [media] dib8000: Fix some wrong alignments
      [media] Move CI cxd2099 driver to staging
      [media] ngene: Fix compilation when cxd2099 is not enabled
      [media] tuner-simple: add support for Tena TNF5337 MFD
      [media] saa7134: Properly report when a board doesn't have eeprom
      [media] add support for Encore FM3

Oliver Endriss (12):
      [media] stv090x: Optional external lock routine
      [media] ngene: Firmware 18 support
      [media] ngene: Fixes for TS input over I2S
      [media] ngene: Support up to 4 tuners
      [media] ngene: Clean-up driver initialisation (part 1)
      [media] ngene: Enable CI for Mystique SaTiX-S2 Dual (v2)
      [media] get_dvb_firmware: ngene_18.fw added
      [media] ngene: Fix copy-paste error
      [media] stv090x: Fixed typos in register macros
      [media] stv090x: Fix losing lock in dual DVB-S2 mode
      [media] ngene: Improved channel initialisation and release
      [media] stv090x: 22kHz workaround must also be performed for the 2nd frontend

Olivier Grenie (8):
      [media] DiB0700: add function to change I2C-speed
      [media] DiB8000: add diversity support
      [media] DiBx000: add addition i2c-interface names
      [media] DiB0090: misc improvements
      [media] DIB9000: initial support added
      [media] DiB7090: add support for the dib7090 based
      [media] DiB0700: add support for several board-layouts
      [media] DiBxxxx: Codingstype updates

Patrick Boettcher (3):
      [media] stv090x: added function to control GPIOs from the outside
      [media] stv090x: add tei-field to config-structure
      [media] technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver

Pawel Osciak (9):
      [media] v4l: Add multi-planar API definitions to the V4L2 API
      [media] v4l: Add multi-planar ioctl handling code
      [media] v4l: Add compat functions for the multi-planar API
      [media] v4l: add videobuf2 Video for Linux 2 driver framework
      [media] v4l: videobuf2: add vmalloc allocator
      [media] v4l: videobuf2: add DMA coherent allocator
      [media] Fix mmap() example in the V4L2 API DocBook
      [media] Add multi-planar API documentation
      [media] v4l: vivi: port to videobuf2

Ralph Metzler (3):
      [media] ngene: CXD2099AR Common Interface driver
      [media] ngene: Shutdown workaround
      [media] ngene: Add net device

Sungchun Kang (1):
      [media] s5p-fimc: fimc_stop_capture bug fix

Sylwester Nawrocki (14):
      [media] v4l: Add multiplanar format fourccs for s5p-fimc driver
      [media] v4l: Add DocBook documentation for YU12M, NV12M image formats
      [media] s5p-fimc: Porting to videobuf 2
      [media] s5p-fimc: Conversion to multiplanar formats
      [media] s5p-fimc: Use v4l core mutex in ioctl and file operations
      [media] s5p-fimc: Rename s3c_fimc* to s5p_fimc*
      [media] s5p-fimc: Derive camera bus width from mediabus pixelcode
      [media] s5p-fimc: Enable interworking without subdev s_stream
      [media] s5p-fimc: Use default input DMA burst count
      [media] s5p-fimc: Enable simultaneous rotation and flipping
      [media] s5p-fimc: Add control of the external sensor clock
      [media] s5p-fimc: Move scaler details handling to the register API file
      [media] Add chip identity for NOON010PC30 camera sensor
      [media] Add v4l2 subdev driver for NOON010PC30L image sensor

 Documentation/DocBook/media-entities.tmpl     |    8 +
 Documentation/DocBook/v4l/common.xml          |    2 +
 Documentation/DocBook/v4l/compat.xml          |   11 +
 Documentation/DocBook/v4l/dev-capture.xml     |   13 +-
 Documentation/DocBook/v4l/dev-output.xml      |   13 +-
 Documentation/DocBook/v4l/func-mmap.xml       |   10 +-
 Documentation/DocBook/v4l/func-munmap.xml     |    3 +-
 Documentation/DocBook/v4l/io.xml              |  283 +++-
 Documentation/DocBook/v4l/pixfmt-nv12m.xml    |  154 ++
 Documentation/DocBook/v4l/pixfmt-yuv420m.xml  |  162 ++
 Documentation/DocBook/v4l/pixfmt.xml          |  118 ++-
 Documentation/DocBook/v4l/planar-apis.xml     |   81 +
 Documentation/DocBook/v4l/v4l2.xml            |   22 +-
 Documentation/DocBook/v4l/vidioc-enum-fmt.xml |    2 +
 Documentation/DocBook/v4l/vidioc-g-fmt.xml    |   15 +-
 Documentation/DocBook/v4l/vidioc-qbuf.xml     |   24 +-
 Documentation/DocBook/v4l/vidioc-querybuf.xml |   14 +-
 Documentation/DocBook/v4l/vidioc-querycap.xml |   24 +-
 Documentation/dvb/get_dvb_firmware            |    8 +-
 drivers/media/common/tuners/tuner-types.c     |   21 +
 drivers/media/dvb/dvb-usb/Kconfig             |    8 +
 drivers/media/dvb/dvb-usb/Makefile            |    3 +
 drivers/media/dvb/dvb-usb/dib0700.h           |    2 +
 drivers/media/dvb/dvb-usb/dib0700_core.c      |   47 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c   | 1374 +++++++++++++--
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h       |    6 +
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c    |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h           |    2 +
 drivers/media/dvb/dvb-usb/technisat-usb2.c    |  808 +++++++++
 drivers/media/dvb/frontends/Kconfig           |    8 +
 drivers/media/dvb/frontends/Makefile          |    1 +
 drivers/media/dvb/frontends/dib0090.c         | 1583 +++++++++++++----
 drivers/media/dvb/frontends/dib0090.h         |   31 +
 drivers/media/dvb/frontends/dib7000p.c        | 1945 +++++++++++++++------
 drivers/media/dvb/frontends/dib7000p.h        |   96 +-
 drivers/media/dvb/frontends/dib8000.c         |  821 ++++++----
 drivers/media/dvb/frontends/dib8000.h         |   20 +
 drivers/media/dvb/frontends/dib9000.c         | 2350 +++++++++++++++++++++++++
 drivers/media/dvb/frontends/dib9000.h         |  131 ++
 drivers/media/dvb/frontends/dibx000_common.c  |  279 +++-
 drivers/media/dvb/frontends/dibx000_common.h  |  152 ++-
 drivers/media/dvb/frontends/stv090x.c         |  286 +++-
 drivers/media/dvb/frontends/stv090x.h         |   16 +
 drivers/media/dvb/frontends/stv090x_reg.h     |   16 +-
 drivers/media/dvb/ngene/Makefile              |    3 +
 drivers/media/dvb/ngene/ngene-cards.c         |  179 ++-
 drivers/media/dvb/ngene/ngene-core.c          |  236 ++-
 drivers/media/dvb/ngene/ngene-dvb.c           |   71 +-
 drivers/media/dvb/ngene/ngene.h               |   24 +
 drivers/media/rc/keymaps/Makefile             |    1 +
 drivers/media/rc/keymaps/rc-technisat-usb2.c  |   93 +
 drivers/media/video/Kconfig                   |   36 +-
 drivers/media/video/Makefile                  |    7 +
 drivers/media/video/mem2mem_testdev.c         |  227 ++--
 drivers/media/video/noon010pc30.c             |  792 +++++++++
 drivers/media/video/s5p-fimc/fimc-capture.c   |  550 ++++---
 drivers/media/video/s5p-fimc/fimc-core.c      |  872 +++++-----
 drivers/media/video/s5p-fimc/fimc-core.h      |  134 +-
 drivers/media/video/s5p-fimc/fimc-reg.c       |  199 ++-
 drivers/media/video/s5p-fimc/regs-fimc.h      |   29 +-
 drivers/media/video/saa7134/saa7134-cards.c   |   39 +
 drivers/media/video/saa7134/saa7134-core.c    |   35 +-
 drivers/media/video/saa7134/saa7134-input.c   |    1 +
 drivers/media/video/saa7134/saa7134.h         |    1 +
 drivers/media/video/v4l2-compat-ioctl32.c     |  229 ++-
 drivers/media/video/v4l2-ioctl.c              |  455 +++++-
 drivers/media/video/v4l2-mem2mem.c            |  232 ++--
 drivers/media/video/videobuf2-core.c          | 1804 +++++++++++++++++++
 drivers/media/video/videobuf2-dma-contig.c    |  185 ++
 drivers/media/video/videobuf2-dma-sg.c        |  292 +++
 drivers/media/video/videobuf2-memops.c        |  232 +++
 drivers/media/video/videobuf2-vmalloc.c       |  132 ++
 drivers/media/video/vivi.c                    |  357 +++--
 drivers/staging/Kconfig                       |    2 +
 drivers/staging/Makefile                      |    1 +
 drivers/staging/cxd2099/Kconfig               |   11 +
 drivers/staging/cxd2099/Makefile              |    5 +
 drivers/staging/cxd2099/TODO                  |   12 +
 drivers/staging/cxd2099/cxd2099.c             |  574 ++++++
 drivers/staging/cxd2099/cxd2099.h             |   41 +
 include/linux/videodev2.h                     |  131 ++-
 include/media/noon010pc30.h                   |   28 +
 include/media/rc-map.h                        |    1 +
 include/media/{s3c_fimc.h => s5p_fimc.h}      |   20 +-
 include/media/tuner.h                         |    1 +
 include/media/v4l2-chip-ident.h               |    3 +
 include/media/v4l2-ioctl.h                    |   16 +
 include/media/v4l2-mem2mem.h                  |   56 +-
 include/media/videobuf2-core.h                |  380 ++++
 include/media/videobuf2-dma-contig.h          |   29 +
 include/media/videobuf2-dma-sg.h              |   32 +
 include/media/videobuf2-memops.h              |   45 +
 include/media/videobuf2-vmalloc.h             |   20 +
 93 files changed, 16895 insertions(+), 2935 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12m.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuv420m.xml
 create mode 100644 Documentation/DocBook/v4l/planar-apis.xml
 create mode 100644 drivers/media/dvb/dvb-usb/technisat-usb2.c
 create mode 100644 drivers/media/dvb/frontends/dib9000.c
 create mode 100644 drivers/media/dvb/frontends/dib9000.h
 create mode 100644 drivers/media/rc/keymaps/rc-technisat-usb2.c
 create mode 100644 drivers/media/video/noon010pc30.c
 create mode 100644 drivers/media/video/videobuf2-core.c
 create mode 100644 drivers/media/video/videobuf2-dma-contig.c
 create mode 100644 drivers/media/video/videobuf2-dma-sg.c
 create mode 100644 drivers/media/video/videobuf2-memops.c
 create mode 100644 drivers/media/video/videobuf2-vmalloc.c
 create mode 100644 drivers/staging/cxd2099/Kconfig
 create mode 100644 drivers/staging/cxd2099/Makefile
 create mode 100644 drivers/staging/cxd2099/TODO
 create mode 100644 drivers/staging/cxd2099/cxd2099.c
 create mode 100644 drivers/staging/cxd2099/cxd2099.h
 create mode 100644 include/media/noon010pc30.h
 rename include/media/{s3c_fimc.h => s5p_fimc.h} (75%)
 create mode 100644 include/media/videobuf2-core.h
 create mode 100644 include/media/videobuf2-dma-contig.h
 create mode 100644 include/media/videobuf2-dma-sg.h
 create mode 100644 include/media/videobuf2-memops.h
 create mode 100644 include/media/videobuf2-vmalloc.h

