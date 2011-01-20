Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1ATUYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:24:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab1ATUYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:24:13 -0500
Message-ID: <4D3899C7.1070805@redhat.com>
Date: Thu, 20 Jan 2011 18:23:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.38-rc2] V4L/DVB fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This series contains fixes on several drivers. There is also the removal of two duplicated
old drivers:
	tda9875 - currently unused, as their functionalities got migrated to tvaudio
	radio-gemtek-pci - that supports the same device as radio-maxiradio

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git media_fixes

Thanks!
Mauro

--

The following changes since commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470:

  Linux 2.6.38-rc1 (2011-01-18 15:14:02 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git media_fixes

Andy Walls (12):
      [media] lirc_zilog: Reword debug message in ir_probe()
      [media] lirc_zilog: Remove disable_tx module parameter
      [media] lirc_zilog: Split struct IR into structs IR, IR_tx, and IR_rx
      [media] lirc_zilog: Don't make private copies of i2c clients
      [media] lirc_zilog: Extensive rework of ir_probe()/ir_remove()
      [media] lirc_zilog: Update IR Rx polling kthread start/stop and some printks
      [media] lirc_zilog: Remove unneeded tests for existence of the IR Tx function
      [media] lirc_zilog: Remove useless struct i2c_driver.command function
      [media] lirc_zilog: Add Andy Walls to copyright notice and authors list
      [media] lirc_zilog: Update TODO.lirc_zilog
      [media] ir-kbd-i2c: Add back defaults setting for Zilog Z8's at addr 0x71
      [media] pvrusb2: Provide more information about IR units to lirc_zilog and ir-kbd-i2c

Antti Palosaari (1):
      [media] af9013: fix AF9013 TDA18271 IF config

Christian Gmeiner (1):
      [media] adv7175: support s_power

Dan Carpenter (1):
      [media] [v3,media] av7110: check for negative array offset

Dmitri Belimov (1):
      [media] tm6000: rework init code

Geert Uytterhoeven (1):
      [media] radio-aimslab.c needs #include <linux/delay.h>

Hans Verkuil (20):
      [media] tda9875: remove duplicate driver
      [media] bttv: remove obsolete 'no_tda9875' field
      [media] saa7146: Convert from .ioctl to .unlocked_ioctl
      [media] cpia2: convert .ioctl to .unlocked_ioctl
      [media] davinci: convert vpif_capture to core-assisted locking
      [media] davinci: convert vpif_display to core-assisted locking
      [media] radio-maxiradio.c: use sensible frequency range
      [media] radio-gemtek-pci: remove duplicate driver
      [media] v4l2-ioctl: fix incorrect error code if VIDIOC_DBG_G/S_REGISTER are unsupported
      [media] v4l2-subdev: remove core.s_config and v4l2_i2c_new_subdev_cfg()
      [media] v4l2-subdev: add (un)register internal ops
      [media] v4l2-ctrls: v4l2_ctrl_handler_setup must set is_new to 1
      [media] v4l2-ctrls: fix missing 'read-only' check
      [media] v4l2-ctrls: queryctrl shouldn't attempt to replace V4L2_CID_PRIVATE_BASE IDs
      [media] DocBook/v4l: fix validation error in dev-rds.xml
      [media] DocBook/v4l: update V4L2 revision and update copyright years
      [media] w9966: zero device state after a detach
      [media] zoran: use video_device_alloc instead of kmalloc
      [media] v4l2-dev: don't memset video_device.dev
      [media] v4l2-device: fix 'use-after-freed' oops

Hans de Goede (19):
      [media] gspca_main: Locking fixes 1
      [media] gspca_main: Locking fixes 2
      [media] gspca_main: Update buffer flags even when user_copy fails
      [media] gspca_main: Remove no longer used users variable
      [media] gspca_main: Set memory type to GSPCA_MEMORY_NO on buffer release
      [media] gspca_main: Simplify read mode memory type checks
      [media] gspca_main: Allow switching from read to mmap / userptr mode
      [media] gspca_main: wake wq on streamoff
      [media] et61x251: remove wrongly claimed usb ids
      [media] sn9c102: Remove not supported and non existing usb ids
      [media] gspca_sonixb: Refactor to unify bridge handling
      [media] gspca_sonixb: Adjust autoexposure window for vga cams so that it is centered
      [media] gspca_sonixb: Fix TAS5110D sensor gain control
      [media] gspca_sonixb: TAS5130C brightness control really is a gain control
      [media] gspca_sonixb: Add usb ids for known sn9c103 cameras
      [media] gspca_sonixj: Enable more usb ids when sn9c102 gets compiled too
      [media] gspca_sonixj: Probe sensor type independent of bridge type
      [media] gspca_sonixj: Add one more commented out usb-id
      [media] gspca_sonixb: Fix mirrored image with ov7630

Jarod Wilson (8):
      [media] rc/imon: fix ffdc device detection oops
      [media] rc/imon: need to submit urb before ffdc type check
      [media] rc: fix up and genericize some time unit conversions
      [media] rc/imon: default to key mode instead of mouse mode
      [media] rc/mceusb: timeout should be in ns, not us
      [media] hdpvr: enable IR part
      [media] hdpvr: reduce latency of i2c read/write w/recycled buffer
      [media] staging/lirc: fix mem leaks and ptr err usage

Jean-François Moine (8):
      [media] gspca: Version change
      [media] gspca: Remove __devinit, __devinitconst and __devinitdata
      [media] gspca: Remove useless instructions
      [media] gspca - ov519: Cleanup source and add a comment
      [media] gspca - ov534: Clearer debug messages
      [media] gspca - ov534: Propagate errors to higher level
      [media] gspca - sonixj: Infrared bug fix and enhancement
      [media] gspca - sonixj: Add LED (illuminator) control to the webcam 0c45:614a

Jesper Juhl (2):
      [media] frontends/ix2505v: Remember to free allocated memory in failure path
      [media] media, tlg2300: Fix memory leak in alloc_bulk_urbs_generic()

Kyle McMartin (1):
      [media] rc/ene_ir: fix oops on module load

Laurent Pinchart (2):
      [media] v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
      [media] v4l: Fix a use-before-set in the control framework

Mats Randgaard (5):
      [media] vpif_cap/disp: Add debug functionality
      [media] vpif: Consolidate formats from capture and display
      [media] vpif_cap/disp: Add support for DV presets
      [media] vpif_cap/disp: Added support for DV timings
      [media] vpif_cap/disp: Cleanup, improved comments

Matti Aaltonen (1):
      [media] V4L2: WL1273 FM Radio: Replace ioctl with unlocked_ioctl

Mauro Carvalho Chehab (12):
      [media] rc-dib0700-nec: Fix keytable for Pixelview SBTVD
      [media] dib0700: Fix IR keycode handling
      [media] ir-kbd-i2c: Make IR debug messages more useful
      [media] em28xx: Fix IR support for WinTV USB2
      [media] tda8290: Make all read operations atomic
      [media] tda8290: Fix a bug if no tuner is detected
      [media] tda8290: Turn tda829x on before touching at the I2C gate
      [media] mb86a20s: Fix i2c read/write error messages
      [media] mb86a20s: Be sure that device is initialized before starting DVB
      [media] saa7134: Fix analog mode for Kworld SBTVD
      [media] saa7134: Fix digital mode on Kworld SBTVD
      [media] saa7134: Kworld SBTVD: make both analog and digital to work

Randy Dunlap (1):
      [media] ir-raw: fix sparse non-ANSI function warning

Stefan Richter (1):
      [media] firedtv: fix remote control with newer Xorg evdev

Tejun Heo (1):
      [media] v4l/cx18: update workqueue usage

Thadeu Lima de Souza Cascardo (1):
      [media] DVB: cx231xx drivers does not use dummy frontend anymore

Tobias Lorenz (2):
      [media] radio-si470x: de-emphasis should be set if requested by module parameter
      [media] radio-si470x: Always report support for RDS

 Documentation/DocBook/dvb/dvbapi.xml               |    2 +-
 Documentation/DocBook/media.tmpl                   |    4 +-
 Documentation/DocBook/v4l/dev-rds.xml              |    6 +-
 Documentation/DocBook/v4l/v4l2.xml                 |    3 +-
 Documentation/video4linux/v4l2-controls.txt        |   12 +
 drivers/media/common/saa7146_core.c                |    2 +-
 drivers/media/common/saa7146_fops.c                |    8 +-
 drivers/media/common/saa7146_vbi.c                 |    2 +-
 drivers/media/common/saa7146_video.c               |   20 +-
 drivers/media/common/tuners/tda8290.c              |  130 +++--
 drivers/media/dvb/dvb-usb/dib0700_core.c           |    6 +-
 drivers/media/dvb/firewire/firedtv-rc.c            |    9 +-
 drivers/media/dvb/frontends/af9013.c               |    4 +-
 drivers/media/dvb/frontends/ix2505v.c              |    2 +-
 drivers/media/dvb/frontends/mb86a20s.c             |   36 +-
 drivers/media/dvb/ttpci/av7110_ca.c                |    2 +-
 drivers/media/radio/Kconfig                        |   14 -
 drivers/media/radio/Makefile                       |    1 -
 drivers/media/radio/radio-aimslab.c                |    1 +
 drivers/media/radio/radio-gemtek-pci.c             |  478 --------------
 drivers/media/radio/radio-maxiradio.c              |    4 +-
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    9 +-
 drivers/media/rc/ene_ir.c                          |   23 +-
 drivers/media/rc/ene_ir.h                          |    2 -
 drivers/media/rc/imon.c                            |   60 +-
 drivers/media/rc/ir-raw.c                          |    2 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |   52 +-
 drivers/media/rc/mceusb.c                          |    3 +-
 drivers/media/video/Kconfig                        |    9 -
 drivers/media/video/Makefile                       |    1 -
 drivers/media/video/adv7175.c                      |   11 +
 drivers/media/video/bt8xx/bttv-cards.c             |   39 --
 drivers/media/video/bt8xx/bttv.h                   |    1 -
 drivers/media/video/cafe_ccic.c                    |   11 +-
 drivers/media/video/cpia2/cpia2.h                  |    2 +-
 drivers/media/video/cpia2/cpia2_core.c             |   65 +--
 drivers/media/video/cpia2/cpia2_v4l.c              |  104 +---
 drivers/media/video/cx18/cx18-driver.c             |   24 +-
 drivers/media/video/cx18/cx18-driver.h             |    3 -
 drivers/media/video/cx18/cx18-streams.h            |    3 +-
 drivers/media/video/cx231xx/cx231xx-dvb.c          |    5 +-
 drivers/media/video/cx25840/cx25840-core.c         |   22 +-
 drivers/media/video/davinci/vpif.c                 |  177 ++++++
 drivers/media/video/davinci/vpif.h                 |   18 +-
 drivers/media/video/davinci/vpif_capture.c         |  451 +++++++++++---
 drivers/media/video/davinci/vpif_capture.h         |    2 +
 drivers/media/video/davinci/vpif_display.c         |  474 +++++++++++----
 drivers/media/video/davinci/vpif_display.h         |    2 +
 drivers/media/video/em28xx/em28xx-cards.c          |   19 +-
 drivers/media/video/et61x251/et61x251.h            |   24 -
 drivers/media/video/gspca/benq.c                   |    2 +-
 drivers/media/video/gspca/conex.c                  |    4 +-
 drivers/media/video/gspca/cpia1.c                  |    2 +-
 drivers/media/video/gspca/etoms.c                  |    4 +-
 drivers/media/video/gspca/finepix.c                |    2 +-
 drivers/media/video/gspca/gl860/gl860.c            |    2 +-
 drivers/media/video/gspca/gspca.c                  |  210 +++----
 drivers/media/video/gspca/gspca.h                  |    2 -
 drivers/media/video/gspca/jeilinj.c                |    2 +-
 drivers/media/video/gspca/jpeg.h                   |    4 +-
 drivers/media/video/gspca/konica.c                 |    2 +-
 drivers/media/video/gspca/m5602/m5602_core.c       |    2 +-
 drivers/media/video/gspca/mars.c                   |    2 +-
 drivers/media/video/gspca/mr97310a.c               |    2 +-
 drivers/media/video/gspca/ov519.c                  |    8 +-
 drivers/media/video/gspca/ov534.c                  |   29 +-
 drivers/media/video/gspca/ov534_9.c                |    2 +-
 drivers/media/video/gspca/pac207.c                 |    2 +-
 drivers/media/video/gspca/pac7302.c                |    4 +-
 drivers/media/video/gspca/pac7311.c                |    4 +-
 drivers/media/video/gspca/sn9c2028.c               |    2 +-
 drivers/media/video/gspca/sn9c20x.c                |    2 +-
 drivers/media/video/gspca/sonixb.c                 |  270 +++++----
 drivers/media/video/gspca/sonixj.c                 |  155 +++---
 drivers/media/video/gspca/spca1528.c               |    2 +-
 drivers/media/video/gspca/spca500.c                |    2 +-
 drivers/media/video/gspca/spca501.c                |    2 +-
 drivers/media/video/gspca/spca505.c                |    2 +-
 drivers/media/video/gspca/spca508.c                |    2 +-
 drivers/media/video/gspca/spca561.c                |    2 +-
 drivers/media/video/gspca/sq905.c                  |    2 +-
 drivers/media/video/gspca/sq905c.c                 |    2 +-
 drivers/media/video/gspca/sq930x.c                 |    2 +-
 drivers/media/video/gspca/stk014.c                 |    2 +-
 drivers/media/video/gspca/stv0680.c                |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |    2 +-
 drivers/media/video/gspca/sunplus.c                |    2 +-
 drivers/media/video/gspca/t613.c                   |    2 +-
 drivers/media/video/gspca/tv8532.c                 |    2 +-
 drivers/media/video/gspca/vc032x.c                 |    2 +-
 drivers/media/video/gspca/xirlink_cit.c            |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 drivers/media/video/hdpvr/Makefile                 |    4 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |   10 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c              |  143 ++---
 drivers/media/video/hdpvr/hdpvr-video.c            |    7 +-
 drivers/media/video/hdpvr/hdpvr.h                  |    5 +-
 drivers/media/video/ir-kbd-i2c.c                   |   12 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    9 +-
 drivers/media/video/mt9v011.c                      |   54 +-
 drivers/media/video/mt9v011.h                      |   36 --
 drivers/media/video/ov7670.c                       |   74 +--
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |   62 ++-
 drivers/media/video/saa7134/saa7134-cards.c        |   51 +--
 drivers/media/video/saa7134/saa7134-dvb.c          |   80 ++--
 drivers/media/video/sn9c102/sn9c102_devtable.h     |   74 +--
 drivers/media/video/sr030pc30.c                    |   10 -
 drivers/media/video/tda9875.c                      |  411 -------------
 drivers/media/video/tlg2300/pd-video.c             |   13 +-
 drivers/media/video/v4l2-common.c                  |   19 +-
 drivers/media/video/v4l2-ctrls.c                   |   34 +-
 drivers/media/video/v4l2-dev.c                     |    9 +-
 drivers/media/video/v4l2-device.c                  |   16 +-
 drivers/media/video/v4l2-ioctl.c                   |   20 +-
 drivers/media/video/w9966.c                        |    1 +
 drivers/media/video/zoran/zoran_card.c             |    2 +-
 drivers/staging/lirc/TODO.lirc_zilog               |   36 +-
 drivers/staging/lirc/lirc_imon.c                   |    1 +
 drivers/staging/lirc/lirc_it87.c                   |    1 +
 drivers/staging/lirc/lirc_parallel.c               |   19 +-
 drivers/staging/lirc/lirc_sasem.c                  |    1 +
 drivers/staging/lirc/lirc_serial.c                 |    3 +-
 drivers/staging/lirc/lirc_sir.c                    |    1 +
 drivers/staging/lirc/lirc_zilog.c                  |  650 +++++++++++---------
 drivers/staging/tm6000/tm6000-video.c              |   46 ++-
 include/media/mt9v011.h                            |   17 +
 include/media/rc-core.h                            |    3 +
 include/media/saa7146.h                            |    2 +-
 include/media/v4l2-common.h                        |   13 +-
 include/media/v4l2-ctrls.h                         |    7 +-
 include/media/v4l2-subdev.h                        |   23 +-
 133 files changed, 2442 insertions(+), 2661 deletions(-)
 delete mode 100644 drivers/media/radio/radio-gemtek-pci.c
 delete mode 100644 drivers/media/video/mt9v011.h
 delete mode 100644 drivers/media/video/tda9875.c
 create mode 100644 include/media/mt9v011.h

