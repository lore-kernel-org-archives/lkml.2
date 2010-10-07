Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab0JGAQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:16:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab0JGAQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:16:39 -0400
Date: Wed, 6 Oct 2010 21:16:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.36-rc7] V4L/DVB fixes
Message-ID: <20101006211624.024f0a61@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus


It is basically a few fixes at V4L drivers, plus some fixes at IR core and 
one at V4L core (at videobuf).

All the patches are available at linux-next and should compile fine.


The following changes since commit b30a3f6257ed2105259b404d419b4964e363928c:

  Linux 2.6.36-rc5 (2010-09-20 16:56:53 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Andy Walls (1):
      V4L/DVB: cx25840: Fix typo in volume control initialization: 65335 vs. 65535

Baruch Siach (1):
      V4L/DVB: mx2_camera: fix a race causing NULL dereference

Brian Rogers (1):
      V4L/DVB: ir-core: Fix null dereferences in the protocols sysfs interface

Dan Carpenter (5):
      V4L/DVB: unlock on error path
      V4L/DVB: IR: ir-raw-event: null pointer dereference
      V4L/DVB: opera1: remove unneeded NULL check
      V4L/DVB: pvrusb2: remove unneeded NULL checks
      V4L/DVB: saa7164: move dereference under NULL check

Dan Rosenberg (1):
      V4L/DVB: ivtvfb: prevent reading uninitialized stack memory

Dmitri Belimov (1):
      V4L/DVB: Fix regression for BeholdTV Columbus

Hans Verkuil (1):
      V4L/DVB: videobuf-dma-sg: set correct size in last sg element

Ionut Gabriel Popescu (1):
      V4L/DVB: mt9v022.c: Fixed compilation warning

Jarod Wilson (1):
      V4L/DVB: mceusb: add two new ASUS device IDs

Jason Wang (1):
      V4L/DVB: gspca - main: Fix a crash of some webcams on ARM arch

Jean-François Moine (1):
      V4L/DVB: gspca - sn9c20x: Bad transfer size of Bayer images

Laurent Pinchart (2):
      V4L/DVB: uvcvideo: Fix support for Medion Akoya All-in-one PC integrated webcam
      V4L/DVB: uvcvideo: Restrict frame rates for Chicony CNF7129 webcam

Marek Szyprowski (1):
      V4L/DVB: v4l: radio: si470x: fix unneeded free_irq() call

Mauro Carvalho Chehab (3):
      V4L/DVB: Don't identify PV SBTVD Hybrid as a DibCom device
      V4L/DVB: rc-core: increase repeat time
      V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)

Maxim Levitsky (3):
      V4L/DVB: IR: fix duty cycle capability
      V4L/DVB: IR: fix keys beeing stuck down forever
      V4L/DVB: IR: extend MCE keymap

Michael Grzeschik (2):
      V4L/DVB: mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE
      V4L/DVB: mt9m111: added current colorspace at g_fmt

Olivier Grenie (2):
      V4L/DVB: dib7770: enable the current mirror
      V4L/DVB: dib7000p: add disable sample and hold, and diversity delay parameter

Pawel Osciak (4):
      V4L/DVB: v4l: mem2mem_testdev: fix errorenous comparison
      V4L/DVB: v4l: mem2mem_testdev: add missing release for video_device
      V4L/DVB: v4l: s5p-fimc: Fix return value on probe() failure
      V4L/DVB: v4l: videobuf: prevent passing a NULL to dma_free_coherent()

Randy Dunlap (1):
      V4L/DVB: tm6000: depends on IR_CORE

Richard Zidlicky (1):
      V4L/DVB: dvb: fix smscore_getbuffer() logic

Stefan Ringel (1):
      V4L/DVB: tm6000: bugfix data handling

Sylwester Nawrocki (1):
      V4L/DVB: v4l: s5p-fimc: Fix 3-planar formats handling and pixel offset error on S5PV210 SoCs

lawrence rust (1):
      V4L/DVB: cx88: Kconfig: Remove EXPERIMENTAL dependency from VIDEO_CX88_ALSA

 drivers/media/IR/ir-keytable.c                |    9 ++-
 drivers/media/IR/ir-lirc-codec.c              |    2 +-
 drivers/media/IR/ir-raw-event.c               |    4 +-
 drivers/media/IR/ir-sysfs.c                   |   17 +++--
 drivers/media/IR/keymaps/rc-rc6-mce.c         |    3 +
 drivers/media/IR/mceusb.c                     |    4 +
 drivers/media/dvb/dvb-usb/dib0700_core.c      |    3 -
 drivers/media/dvb/dvb-usb/dib0700_devices.c   |   56 ++++++++++++++-
 drivers/media/dvb/dvb-usb/opera1.c            |    4 +-
 drivers/media/dvb/frontends/dib7000p.c        |    8 ++-
 drivers/media/dvb/frontends/dib7000p.h        |    5 ++
 drivers/media/dvb/siano/smscoreapi.c          |   31 +++-----
 drivers/media/radio/si470x/radio-si470x-i2c.c |    2 +-
 drivers/media/video/cx231xx/Makefile          |    1 +
 drivers/media/video/cx231xx/cx231xx-cards.c   |   17 +++--
 drivers/media/video/cx25840/cx25840-core.c    |    2 +-
 drivers/media/video/cx88/Kconfig              |    2 +-
 drivers/media/video/gspca/gspca.c             |    1 +
 drivers/media/video/gspca/sn9c20x.c           |    3 +-
 drivers/media/video/ivtv/ivtvfb.c             |    2 +
 drivers/media/video/mem2mem_testdev.c         |    3 +-
 drivers/media/video/mt9m111.c                 |    8 ++-
 drivers/media/video/mt9v022.c                 |    3 -
 drivers/media/video/mx2_camera.c              |    4 +
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c    |    6 +-
 drivers/media/video/s5p-fimc/fimc-core.c      |   94 +++++++++++--------------
 drivers/media/video/saa7134/saa7134-cards.c   |   10 ++--
 drivers/media/video/saa7164/saa7164-buffer.c  |    5 +-
 drivers/media/video/uvc/uvc_driver.c          |   24 ++++++
 drivers/media/video/uvc/uvcvideo.h            |    1 +
 drivers/media/video/videobuf-dma-contig.c     |    6 +-
 drivers/media/video/videobuf-dma-sg.c         |   11 ++-
 drivers/staging/tm6000/Kconfig                |    2 +-
 drivers/staging/tm6000/tm6000-input.c         |   61 ++++++++++------
 include/media/videobuf-dma-sg.h               |    1 +
 35 files changed, 271 insertions(+), 144 deletions(-)

