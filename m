Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1E0OMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab1E0OMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:12:39 -0400
Message-ID: <4DDFB150.2000804@redhat.com>
Date: Fri, 27 May 2011 11:12:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for -rc1] media updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For a few more stuff for 3.0-rc1 (or 2.6.40-rc1).

This series contain a few bug fixes, and some stuff that were ready for the
merge window, but they took me some time to finish my review. Basically:
	- an 8-megapixel sensor driver, used on some Samsung arm-based boards;
	- a Remote Controller driver for a SuperIO chipset from Fintek;
	- Media controller support for uvcvideo driver;
	- DM04/QQBOX port to use the RC subsystem, instead of having its own implementation for IR.

Thanks!
Mauro


The following changes since commit cf25220677b3f10468a74278130fe224f73632a6:

  [media] gspca - sunplus: Fix some warnings and simplify code (2011-05-21 09:36:15 -0300)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Hans Petter Selasky (4):
      [media] cpia2: fix warning about invalid trigraph sequence
      [media] Remove invalid parameter description
      [media] Inlined functions should be static
      [media] Add missing include guard to header file

Hans Verkuil (2):
      [media] wl12xx: g_volatile_ctrl fix: wrong field set
      [media] Media DocBook: fix validation errors

HeungJun, Kim (1):
      [media] Add support for M-5MOLS 8 Mega Pixel camera ISP

Igor M. Liplianin (1):
      [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked

Jarod Wilson (2):
      [media] fintek-cir: new driver for Fintek LPC SuperIO CIR function
      [media] gspca/kinect: wrap gspca_debug with GSPCA_DEBUG

Laurent Pinchart (3):
      [media] uvcvideo: Register a v4l2_device
      [media] uvcvideo: Register subdevices for each entity
      [media] uvcvideo: Connect video devices to media entities

Malcolm Priestley (1):
      [media] v1.88 DM04/QQBOX Move remote to use rc_core dvb-usb-remote

Mauro Carvalho Chehab (2):
      [media] Documentation/DocBook: Rename media fops xml files
      [media] add V4L2-PIX-FMT-SRGGB12 & friends to docbook

Randy Dunlap (1):
      [media] fix kconfig dependency warning for VIDEO_TIMBERDALE

Sylwester Nawrocki (1):
      [media] s5p-csis: Add missing dependency on PLAT_S5P

 Documentation/DocBook/dvb/dvbproperty.xml      |    5 +-
 Documentation/DocBook/media-entities.tmpl      |    7 +-
 Documentation/DocBook/v4l/media-controller.xml |    6 +-
 Documentation/DocBook/v4l/pixfmt.xml           |    1 +
 Documentation/DocBook/v4l/subdev-formats.xml   |   10 +-
 drivers/media/dvb/dm1105/dm1105.c              |  272 ++++++-
 drivers/media/dvb/dvb-usb/lmedm04.c            |  107 +--
 drivers/media/dvb/frontends/stb0899_algo.c     |    2 +-
 drivers/media/dvb/frontends/tda8261.c          |    1 -
 drivers/media/radio/radio-wl1273.c             |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c        |    2 +-
 drivers/media/rc/Kconfig                       |   12 +
 drivers/media/rc/Makefile                      |    1 +
 drivers/media/rc/fintek-cir.c                  |  684 ++++++++++++++++
 drivers/media/rc/fintek-cir.h                  |  243 ++++++
 drivers/media/rc/keymaps/rc-lme2510.c          |  134 ++--
 drivers/media/video/Kconfig                    |    6 +-
 drivers/media/video/Makefile                   |    1 +
 drivers/media/video/cpia2/cpia2_v4l.c          |    4 +-
 drivers/media/video/gspca/kinect.c             |    2 +-
 drivers/media/video/m5mols/Kconfig             |    5 +
 drivers/media/video/m5mols/Makefile            |    3 +
 drivers/media/video/m5mols/m5mols.h            |  296 +++++++
 drivers/media/video/m5mols/m5mols_capture.c    |  191 +++++
 drivers/media/video/m5mols/m5mols_controls.c   |  299 +++++++
 drivers/media/video/m5mols/m5mols_core.c       | 1004 ++++++++++++++++++++++++
 drivers/media/video/m5mols/m5mols_reg.h        |  399 ++++++++++
 drivers/media/video/uvc/Makefile               |    3 +
 drivers/media/video/uvc/uvc_driver.c           |   66 ++-
 drivers/media/video/uvc/uvc_entity.c           |  118 +++
 drivers/media/video/uvc/uvcvideo.h             |   20 +
 include/media/m5mols.h                         |   35 +
 include/media/videobuf-dvb.h                   |    4 +
 33 files changed, 3750 insertions(+), 195 deletions(-)
 create mode 100644 drivers/media/rc/fintek-cir.c
 create mode 100644 drivers/media/rc/fintek-cir.h
 create mode 100644 drivers/media/video/m5mols/Kconfig
 create mode 100644 drivers/media/video/m5mols/Makefile
 create mode 100644 drivers/media/video/m5mols/m5mols.h
 create mode 100644 drivers/media/video/m5mols/m5mols_capture.c
 create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
 create mode 100644 drivers/media/video/m5mols/m5mols_core.c
 create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
 create mode 100644 drivers/media/video/uvc/uvc_entity.c
 create mode 100644 include/media/m5mols.h

