Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031153Ab1EXBYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:24:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031116Ab1EXBY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:24:29 -0400
Message-ID: <4DDB08B1.3070807@redhat.com>
Date: Mon, 23 May 2011 22:24:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.0-rc1] media updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For the patches for the next version, hopefully Linux 3.0 :) of the kernel.

This series:
	- Extends the DVB API to support the new European terrestrial
	  standard (DVB-T2);
	- Adds support for Kinect color camera;
	- Adds new drivers for cxd2820r and drx-d frontends;
	- Adds support for a Remote controller from a vendor called Redrat (with r);
	- Adds a driver for a new NXP tuner (tda18212);
	- The rest is usual driver enhancements, new boards, fixes, etc.

Thanks!
Mauro

-

The following changes since commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:

  Linux 2.6.39 (2011-05-18 21:06:34 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Alexey Khoroshilov (1):
      [media] lmedm04: Do not unlock mutex if mutex_lock_interruptible failed

Anatolij Gustschin (3):
      [media] fsl-viu: replace .ioctl by .unlocked_ioctl
      [media] fsl_viu: add VIDIOC_OVERLAY ioctl
      [media] media: fsl_viu: fix bug in streamon routine

Andreas Oberritter (11):
      [media] DVB: return meaningful error codes in dvb_frontend
      [media] DVB: Add basic API support for DVB-T2 and bump minor version
      [media] DVB: drxd_hard: handle new bandwidths by returning -EINVAL
      [media] DVB: mxl5005s: handle new bandwidths by returning -EINVAL
      [media] DVB: dtv_property_cache_submit shouldn't modifiy the cache
      [media] DVB: call get_property at the end of dtv_property_process_get
      [media] DVB: dvb_frontend: rename parameters to parameters_in
      [media] DVB: dvb_frontend: remove unused assignments
      [media] DVB: dvb_frontend: use shortcut to access fe->dtv_property_cache
      [media] DVB: dvb_frontend: add parameters_out
      [media] DVB: allow to read back of detected parameters through S2API

Andy Walls (2):
      [media] cx18: Make RF analog TV work for newer HVR-1600 models with silicon tuners
      [media] cx18: Bump driver version, since a new class of HVR-1600 is properly supported

Antonio Ospite (3):
      [media] Add Y10B, a 10 bpp bit-packed greyscale format
      [media] gspca - kinect: New subdriver for Microsoft Kinect
      [media] gspca - kinect: fix comments referring to color camera

Antti Palosaari (23):
      [media] NXP TDA18212HN silicon tuner driver
      [media] anysee: I2C address fix
      [media] anysee: fix multibyte I2C read
      [media] anysee: change some messages
      [media] anysee: reimplement demod and tuner attach
      [media] anysee: add support for TDA18212 based E30 Combo Plus
      [media] anysee: add support for Anysee E7 TC
      [media] anysee: fix E30 Combo Plus TDA18212 GPIO
      [media] anysee: fix E30 Combo Plus TDA18212 DVB-T
      [media] anysee: enhance demod and tuner attach
      [media] anysee: add support for two byte I2C address
      [media] anysee: add more info about known board configs
      [media] cx24116: add config option to split firmware download
      [media] anysee: add support for Anysee E30 S2 Plus
      [media] anysee: add support for Anysee E7 S2
      [media] cx24116: make FW DL split more readable
      [media] tda18271: add DVB-C support
      [media] em28xx: Multi Frontend (MFE) support
      [media] em28xx: add support for EM28174 chip
      [media] Sony CXD2820R DVB-T/T2/C demodulator driver
      [media] Add support for PCTV nanoStick T2 290e [2013:024f]
      [media] cxd2820r: whitespace fix
      [media] cxd2820r: switch automatically between DVB-T and DVB-T2

BjÃ¸rn Mork (2):
      [media] use pci_dev->revision
      [media] mantis: trivial module parameter documentation fix

Bob Liu (2):
      [media] Revert "V4L/DVB: v4l2-dev: remove get_unmapped_area"
      [media] uvcvideo: Add support for NOMMU arch

Dan Carpenter (2):
      [media] pvrusb2: check for allocation failures
      [media] pvrusb2: delete generic_standards_cnt

Daniel Drake (1):
      [media] via-camera: add MODULE_ALIAS

David Härdeman (4):
      [media] rc-core: int to bool conversion for winbond-cir
      [media] rc-core: add TX support to the winbond-cir driver
      [media] rc-core: add trailing silence in rc-loopback tx
      [media] rc-core: use ir_raw_event_store_with_filter in winbond-cir

Detlev Casanova (1):
      [media] v4l: Add mt9v032 sensor driver

Devin Heitmueller (12):
      [media] drxd: add driver to Makefile and Kconfig
      [media] drxd: provide ability to control rs byte
      [media] em28xx: enable support for the drx-d on the HVR-900 R2
      [media] drxd: provide ability to disable the i2c gate control function
      [media] em28xx: fix GPIO problem with HVR-900R2 getting out of sync with drx-d
      [media] em28xx: include model number for PCTV 330e
      [media] em28xx: add digital support for PCTV 330e
      [media] drxd: move firmware to binary blob
      [media] em28xx: remove "not validated" flag for PCTV 330e
      [media] em28xx: add remote control support for PCTV 330e
      [media] drxd: Run lindent across sources
      [media] saa7134: enable IR support for Hauppauge HVR-1150/1120

Dmitri Belimov (1):
      [media] saa7134 add new TV cards

Drew Fisher (2):
      [media] gspca - kinect: move communications buffers out of stack
      [media] gspca - kinect: fix a typo s/steram/stream/

Florian Mickler (21):
      [media] lmedm04: correct indentation
      [media] dib0700: remove unused variable
      [media] a800: get rid of on-stack dma buffers
      [media] vp7045: get rid of on-stack dma buffers
      [media] friio: get rid of on-stack dma buffers
      [media] dw2102: get rid of on-stack dma buffer
      [media] m920x: get rid of on-stack dma buffers
      [media] opera1: get rid of on-stack dma buffer
      [media] vp702x: cleanup: whitespace and indentation
      [media] vp702x: rename struct vp702x_state -> vp702x_adapter_state
      [media] vp702x: preallocate memory on device probe
      [media] vp702x: remove unused variable
      [media] vp702x: get rid of on-stack dma buffers
      [media] vp702x: fix locking of usb operations
      [media] vp702x: use preallocated buffer
      [media] vp702x: use preallocated buffer in vp702x_usb_inout_cmd
      [media] vp702x: use preallocated buffer in the frontend
      [media] ec168: get rid of on-stack dma buffers
      [media] ce6230: get rid of on-stack dma buffer
      [media] au6610: get rid of on-stack dma buffer
      [media] lmedm04: get rid of on-stack dma buffers

Guennadi Liakhovetski (10):
      [media] V4L: soc_camera_platform: add helper functions to manage device instances
      [media] V4L: sh_mobile_ceu_camera: implement .stop_streaming()
      [media] V4L: mx3_camera: implement .stop_streaming()
      [media] V4L: soc-camera: add a livecrop host operation
      [media] V4L: sh_mobile_ceu_camera: implement live cropping
      [media] V4L: soc-camera: avoid huge arrays, caused by changed format codes
      [media] V4L: omap1-camera: fix huge lookup array
      [media] V4L: soc-camera: add a new packing for YUV 4:2:0 type formats
      [media] V4L: soc-camera: add more format look-up entries
      [media] V4L: soc-camera: a missing mediabus code -> fourcc translation is not critical

HIRANO Takahito (1):
      [media] Fix panic on loading earth-pt1

Hans Petter Selasky (1):
      [media] cx24116.c - fix for wrong parameter description

Hans de Goede (2):
      [media] v4l: Add M420 format definition
      [media] uvcvideo: Add M420 format support

Huzaifa Sidhpurwala (1):
      [media] Prevent null pointer derefernce of pdev

Igor Novgorodov (1):
      [media] cx231xx: Add support for Iconbit U100

Jarod Wilson (18):
      [media] rc: add tivo/nero liquidtv keymap
      [media] mceusb: tivo transceiver should default to tivo keymap
      [media] rc: further key name standardization
      [media] rc/nuvoton-cir: only warn about unknown chips
      [media] rc/nuvoton-cir: enable CIR on w83667hg chip variant
      [media] mceusb: Formosa e017 device has no tx
      [media] ttusb-budget: driver has a debug param, use it
      [media] lirc_sasem: key debug spew off debug modparam
      [media] tm6000: fix vbuf may be used uninitialized
      [media] nuvoton-cir: minor tweaks to rc dev init
      [media] imon: clean up disconnect routine
      [media] ite-cir: make IR receive work after resume
      [media] ite-cir: clean up odd spacing in ite8709 bits
      [media] ite-cir: finish tx before suspending
      [media] rc-winfast: fix inverted left/right key mappings
      [media] mceusb: passing ep to request_packet is redundant
      [media] rc: add locking to fix register/show race
      [media] redrat3: new rc-core IR transceiver device driver

Jean Delvare (1):
      [media] zoran: Drop unused module parameters encoder and decoder

Jean-Francois Moine (1):
      [media] pwc: Handle V4L2_CTRL_FLAG_NEXT_CTRL in queryctrl

Jean-François Moine (10):
      [media] gspca - zc3xx: Adjust the mc501cb exchanges
      [media] gspca - cpia1: Fix some warnings
      [media] gspca - kinect: Remove __devinitdata
      [media] gspca - stk014 / t613: Accept the index 0 in querymenu
      [media] gspca - main: Version change to 2.13
      [media] gspca - main: Remove USB traces
      [media] gspca - cpia1: Remove a bad conditional compilation instruction
      [media] gspca: Unset debug by default
      [media] gspca: Fix some warnings tied to 'no debug'
      [media] gspca - sunplus: Fix some warnings and simplify code

Jesper Juhl (4):
      [media] DVB, DiB9000: Fix leak in dib9000_attach()
      [media] cx23885: Don't leak firmware in cx23885_card_setup()
      [media] Media, DVB, Siano, smsusb: Avoid static analysis report about 'use after free'
      [media] gspca/stv06xx_pb0100: Don't potentially deref NULL in pb0100_start()

Jonathan Nieder (7):
      [media] cx88: protect per-device driver list with device lock
      [media] cx88: fix locking of sub-driver operations
      [media] cx88: hold device lock during sub-driver initialization
      [media] cx88: protect cx8802_devlist with a mutex
      [media] cx88: gracefully reject attempts to use unregistered cx88-blackbird driver
      [media] cx88: don't use atomic_t for core->mpeg_users
      [media] cx88: don't use atomic_t for core->users

Joonyoung Shim (3):
      [media] radio-si470x: support seek and tune interrupt enable
      [media] radio-si470x: convert to dev_pm_ops
      [media] radio-si470x: convert to use request_threaded_irq()

Julia Lawall (1):
      [media] imon: Correct call to input_free_device

Kassey Li (2):
      [media] V4L: soc-camera: add JPEG support
      [media] V4L: soc-camera: add MIPI bus flags

Laurent Pinchart (8):
      [media] uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
      [media] uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
      [media] uvcvideo: Add support for V4L2_PIX_FMT_RGB565
      [media] uvcvideo: Add support for JMicron USB2.0 XGA WebCam
      [media] uvcvideo: Override wrong bandwidth value for Hercules Classic Silver
      [media] uvcvideo: Don't report unsupported menu entries
      [media] uvcvideo: Return -ERANGE when userspace sets an unsupported menu entry
      [media] uvcvideo: Make the API public

Malcolm Priestley (11):
      [media] DM04/QQBOX Fix issue with firmware release and cold reset
      [media] DM04/QQBOX stv0288 register 42 - incorrect setting
      [media] STV0288 Register 42 - Incorrect settings
      [media] DM04/QQBOX v1.84 added PID filter
      [media] dvb-usb return device errors to demuxer
      [media] dvb-usb: don't return error if stream stop
      [media] IX2505V Keep I2C gate control alive
      [media] lmedm04: don't write to buffer without a mutex
      [media] lmedm04: PID filtering changes
      [media] STV0299 incorrect standby setting issues register 02 (MCR)
      [media] STV0299 Register 02 on Opera1/Bsru6/z0194a/mantis_vp1033

Mariusz Kozlowski (2):
      [media] dib0700: fix possible NULL pointer dereference
      [media] cpia2: fix typo in variable initialisation

Marko Ristola (1):
      [media] Speed up DVB TS stream delivery from DMA buffer into dvb-core's buffer

Martin Rubli (2):
      [media] uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
      [media] uvcvideo: Add driver documentation

Mauro Carvalho Chehab (14):
      [media] xc5000: Improve it to work better with 6MHz-spaced channels
      [media] em28xx: auto-select drx-k if CUSTOMISE is not set
      [media] drxd_map_firm.h: make checkpatch.pl happier
      [media] drxd_map_firm.h: Remove unused lines
      [media] drxd: don't re-define u8/u16/u32 types
      [media] drxd: Fix some CodingStyle issues
      [media] drxd: Don't use a macro for CHK_ERROR with a break inside
      [media] drxd: CodingStyle cleanups
      [media] Remove the now obsolete drx397xD
      [media] drxd: use mutex instead of semaphore
      [media] tm6000: add detection based on eeprom name
      DocBook/dvb: Improve description of the DVB API v5
      [media] Use a more consistent value for RC repeat period
      [media] video/Kconfig: Fix mis-classified devices

Michael Jones (1):
      [media] ignore Documentation/DocBook/media/

Michael Krufky (2):
      [media] tveeprom: update hauppauge tuner list thru 169
      [media] tveeprom: update hauppauge tuner list thru 174

MÃƒÂ¡rcio Alves (1):
      [media] cx231xx: add support for Kworld

Oliver Endriss (2):
      [media] budget-ci: Add support for TT S-1500 with BSBE1-D01A tuner
      [media] Kconfig: Fix indention of ---help--- for timerdale driver

Olivier Grenie (2):
      [media] DiB0700: get rid of on-stack dma buffers
      [media] DiBxxxx: get rid of DMA buffer on stack

Ondrej Zary (2):
      [media] usbvision: add Nogatech USB MicroCam
      [media] usbvision: remove broken testpattern

Patrice Chotard (5):
      [media] gspca - jeilinj: suppress workqueue
      [media] gspca - jeilinj: use gspca_dev->usb_err to forward error to upper layer
      [media] gspca - jeilinj: add 640*480 resolution support
      [media] gspca - jeilinj: Add SPORTSCAM_DV15 camera support
      [media] gspca - jeilinj: add SPORTSCAM specific controls

Pete Eberlein (1):
      [media] s2255drv: atomic submit urb in completion handler

Ralph Metzler (1):
      drx: add initial drx-d driver

Sensoray Linux Development (2):
      [media] s2255drv: adding MJPEG format
      [media] s2255drv: jpeg enable module parameter

Simon Farnsworth (4):
      [media] cx18: Clean up mmap() support for raw YUV
      [media] cx18: Bump driver version to 1.5.0
      [media] cx18: Fix warnings introduced during cleanup
      [media] cx18: Move spinlock and vb_type initialisation into stream_init

Stefan Ringel (18):
      [media] tm6000: add CARDLIST
      [media] tm6000: add radio capabilities
      [media] tm6000: add tm6010 audio mode setup
      [media] tm6000: change to virtual inputs
      [media] tm6000: vitual input enums
      [media] tm6000: change input control
      [media] tm6000: add eeprom
      [media] tm6000: remove unused capabilities
      [media] tm6000: remove old tuner params
      [media] tm6000: remove duplicated init
      [media] tm6000: move from tm6000_set_reg to tm6000_set_reg_mask
      [media] tm6000: remove input select
      [media] tm6000: all audio packets must swab
      [media] tm6000: change from ioctl to unlocked_ioctl
      [media] tm6000: add pts logging
      [media] tm6000: remove unused exports
      [media] tm6000: remove tm6010 sif audio start and stop
      [media] tm6000: fix uninitialized field, change prink to dprintk

Steve Kerrison (4):
      [media] cxd2820r: make C, T, T2 and core components as linked objects
      [media] em28xx: Disable audio for EM28174
      [media] DocBook/dvb: Update to include DVB-T2 additions
      [media] cxd2820r: Update frontend capabilities to advertise QAM-256

Steven Toth (1):
      [media] cx18: mmap() support for raw YUV video capture

Stéphane Elmaleh (1):
      [media] support for medion dvb stick 1660:1921

Sylwester Nawrocki (4):
      [media] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
      [media] v4l: Move s5p-fimc driver into Video capture devices
      [media] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers
      [media] s5p-csis: Do not use uninitialized variables in s5pcsis_suspend

Teresa Gámez (2):
      [media] V4L: mt9v022: fix pixel clock
      [media] V4L: mt9m111: fix pixel clock

Thiago Farina (1):
      [media] wl128x: Remove unused NO_OF_ENTRIES_IN_ARRAY macro

Timothy Lee (1):
      [media] saa7134: support MagicPro ProHDTV Pro2 Hybrid DMB-TH PCI card

 Documentation/DocBook/.gitignore                   |    1 +
 Documentation/DocBook/dvb/dvbapi.xml               |    8 +
 Documentation/DocBook/dvb/dvbproperty.xml          |  405 +++-
 Documentation/DocBook/dvb/frontend.h.xml           |   20 +-
 Documentation/DocBook/media-entities.tmpl          |    2 +
 Documentation/DocBook/v4l/pixfmt-m420.xml          |  147 +
 Documentation/DocBook/v4l/pixfmt-y10b.xml          |   43 +
 Documentation/DocBook/v4l/pixfmt.xml               |    2 +
 Documentation/DocBook/v4l/subdev-formats.xml       |   46 +
 Documentation/DocBook/v4l/videodev2.h.xml          |    4 +
 Documentation/feature-removal-schedule.txt         |   23 +
 Documentation/ioctl/ioctl-number.txt               |    2 +-
 Documentation/video4linux/CARDLIST.em28xx          |    2 +-
 Documentation/video4linux/Zoran                    |    1 -
 Documentation/video4linux/gspca.txt                |    1 +
 Documentation/video4linux/uvcvideo.txt             |  239 ++
 drivers/media/common/saa7146_core.c                |    7 +-
 drivers/media/common/tuners/Kconfig                |    8 +
 drivers/media/common/tuners/Makefile               |    1 +
 drivers/media/common/tuners/mxl5005s.c             |    2 +
 drivers/media/common/tuners/tda18212.c             |  265 ++
 drivers/media/common/tuners/tda18212.h             |   48 +
 drivers/media/common/tuners/tda18212_priv.h        |   44 +
 drivers/media/common/tuners/tda18271-fe.c          |    4 +
 drivers/media/common/tuners/xc5000.c               |   32 +-
 drivers/media/dvb/b2c2/flexcop-pci.c               |    4 +-
 drivers/media/dvb/bt8xx/bt878.c                    |    2 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |  117 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |  365 ++--
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    3 +
 drivers/media/dvb/dvb-usb/Kconfig                  |    5 +
 drivers/media/dvb/dvb-usb/a800.c                   |   17 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |  620 ++++-
 drivers/media/dvb/dvb-usb/anysee.h                 |   23 +-
 drivers/media/dvb/dvb-usb/au6610.c                 |   22 +-
 drivers/media/dvb/dvb-usb/ce6230.c                 |   11 +-
 drivers/media/dvb/dvb-usb/dib0700.h                |    5 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c           |  220 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    8 +-
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c            |   31 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    1 +
 drivers/media/dvb/dvb-usb/dw2102.c                 |   10 +-
 drivers/media/dvb/dvb-usb/ec168.c                  |   18 +-
 drivers/media/dvb/dvb-usb/friio.c                  |   23 +-
 drivers/media/dvb/dvb-usb/lmedm04.c                |  165 +-
 drivers/media/dvb/dvb-usb/lmedm04.h                |    5 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |   49 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |    2 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   33 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c              |   80 +-
 drivers/media/dvb/dvb-usb/vp702x.c                 |  213 ++-
 drivers/media/dvb/dvb-usb/vp702x.h                 |    7 +
 drivers/media/dvb/dvb-usb/vp7045.c                 |   47 +-
 drivers/media/dvb/frontends/Kconfig                |   19 +-
 drivers/media/dvb/frontends/Makefile               |    6 +-
 drivers/media/dvb/frontends/bsbe1-d01a.h           |  146 +
 drivers/media/dvb/frontends/bsru6.h                |    2 +-
 drivers/media/dvb/frontends/cx24116.c              |   21 +-
 drivers/media/dvb/frontends/cx24116.h              |    3 +
 drivers/media/dvb/frontends/cxd2820r.h             |  118 +
 drivers/media/dvb/frontends/cxd2820r_c.c           |  338 +++
 drivers/media/dvb/frontends/cxd2820r_core.c        |  915 ++++++
 drivers/media/dvb/frontends/cxd2820r_priv.h        |  166 ++
 drivers/media/dvb/frontends/cxd2820r_t.c           |  449 +++
 drivers/media/dvb/frontends/cxd2820r_t2.c          |  423 +++
 drivers/media/dvb/frontends/dib0070.c              |   40 +-
 drivers/media/dvb/frontends/dib0090.c              |   71 +-
 drivers/media/dvb/frontends/dib7000m.c             |   49 +-
 drivers/media/dvb/frontends/dib7000p.c             |   74 +-
 drivers/media/dvb/frontends/dib8000.c              |  126 +-
 drivers/media/dvb/frontends/dib9000.c              |  176 +-
 drivers/media/dvb/frontends/dibx000_common.c       |  109 +-
 drivers/media/dvb/frontends/dibx000_common.h       |    5 +
 drivers/media/dvb/frontends/drx397xD.c             | 1511 ----------
 drivers/media/dvb/frontends/drx397xD.h             |  130 -
 drivers/media/dvb/frontends/drx397xD_fw.h          |   40 -
 drivers/media/dvb/frontends/drxd.h                 |   61 +
 drivers/media/dvb/frontends/drxd_firm.c            |  929 ++++++
 drivers/media/dvb/frontends/drxd_firm.h            |  115 +
 drivers/media/dvb/frontends/drxd_hard.c            | 3001 ++++++++++++++++++++
 drivers/media/dvb/frontends/drxd_map_firm.h        | 1013 +++++++
 drivers/media/dvb/frontends/eds1547.h              |    2 +-
 drivers/media/dvb/frontends/ix2505v.c              |   10 +-
 drivers/media/dvb/frontends/stv0288.c              |    2 +-
 drivers/media/dvb/frontends/stv0299.c              |   10 +-
 drivers/media/dvb/frontends/z0194a.h               |    2 +-
 drivers/media/dvb/mantis/hopper_cards.c            |    2 +-
 drivers/media/dvb/mantis/mantis_cards.c            |    2 +-
 drivers/media/dvb/mantis/mantis_pci.c              |    5 +-
 drivers/media/dvb/mantis/mantis_vp1033.c           |    2 +-
 drivers/media/dvb/pt1/pt1.c                        |    5 +-
 drivers/media/dvb/siano/smsusb.c                   |    3 +-
 drivers/media/dvb/ttpci/Kconfig                    |    2 +
 drivers/media/dvb/ttpci/budget-ci.c                |   21 +
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |   60 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |   60 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   63 +-
 drivers/media/radio/si470x/radio-si470x.h          |    4 +-
 drivers/media/radio/wl128x/fmdrv.h                 |    2 -
 drivers/media/rc/Kconfig                           |   11 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/imon.c                            |   36 +-
 drivers/media/rc/ite-cir.c                         |   60 +-
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |    2 +-
 drivers/media/rc/keymaps/rc-imon-mce.c             |    2 +-
 drivers/media/rc/keymaps/rc-imon-pad.c             |    6 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |    2 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    4 +-
 drivers/media/rc/keymaps/rc-tivo.c                 |   98 +
 drivers/media/rc/keymaps/rc-winfast.c              |    4 +-
 drivers/media/rc/mceusb.c                          |   34 +-
 drivers/media/rc/nuvoton-cir.c                     |   75 +-
 drivers/media/rc/nuvoton-cir.h                     |   17 +-
 drivers/media/rc/rc-loopback.c                     |    6 +
 drivers/media/rc/rc-main.c                         |   54 +-
 drivers/media/rc/redrat3.c                         | 1344 +++++++++
 drivers/media/rc/winbond-cir.c                     |  447 +++-
 drivers/media/video/Kconfig                        |  149 +-
 drivers/media/video/Makefile                       |    2 +
 drivers/media/video/bt8xx/bttv-driver.c            |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |    2 +-
 drivers/media/video/cx18/Kconfig                   |    4 +
 drivers/media/video/cx18/cx18-cards.c              |   18 +-
 drivers/media/video/cx18/cx18-cards.h              |    2 +-
 drivers/media/video/cx18/cx18-driver.c             |   27 +-
 drivers/media/video/cx18/cx18-driver.h             |   25 +
 drivers/media/video/cx18/cx18-fileops.c            |   70 +
 drivers/media/video/cx18/cx18-fileops.h            |    2 +
 drivers/media/video/cx18/cx18-ioctl.c              |  144 +-
 drivers/media/video/cx18/cx18-mailbox.c            |   58 +
 drivers/media/video/cx18/cx18-streams.c            |  177 ++-
 drivers/media/video/cx18/cx18-version.h            |    2 +-
 drivers/media/video/cx18/cx23418.h                 |    6 +
 drivers/media/video/cx231xx/cx231xx-cards.c        |   67 +
 drivers/media/video/cx231xx/cx231xx-dvb.c          |    1 +
 drivers/media/video/cx231xx/cx231xx.h              |    2 +
 drivers/media/video/cx23885/cx23885-cards.c        |    1 +
 drivers/media/video/cx23885/cx23885-core.c         |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c          |   41 +-
 drivers/media/video/cx88/cx88-dvb.c                |    2 +
 drivers/media/video/cx88/cx88-mpeg.c               |   42 +-
 drivers/media/video/cx88/cx88-video.c              |    7 +-
 drivers/media/video/cx88/cx88.h                    |   11 +-
 drivers/media/video/em28xx/Kconfig                 |    2 +
 drivers/media/video/em28xx/em28xx-cards.c          |   49 +-
 drivers/media/video/em28xx/em28xx-core.c           |    9 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |  160 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |    2 +-
 drivers/media/video/em28xx/em28xx-reg.h            |    1 +
 drivers/media/video/em28xx/em28xx.h                |    3 +-
 drivers/media/video/fsl-viu.c                      |   56 +-
 drivers/media/video/gspca/Kconfig                  |    9 +
 drivers/media/video/gspca/Makefile                 |    2 +
 drivers/media/video/gspca/cpia1.c                  |    6 +-
 drivers/media/video/gspca/gl860/gl860.c            |   15 +-
 drivers/media/video/gspca/gspca.c                  |    4 +-
 drivers/media/video/gspca/gspca.h                  |    6 +-
 drivers/media/video/gspca/jeilinj.c                |  581 +++--
 drivers/media/video/gspca/kinect.c                 |  429 +++
 drivers/media/video/gspca/spca508.c                |    5 +-
 drivers/media/video/gspca/stk014.c                 |   15 +-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |    2 +
 drivers/media/video/gspca/sunplus.c                |   99 +-
 drivers/media/video/gspca/t613.c                   |   17 +-
 drivers/media/video/gspca/zc3xx.c                  |   47 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    4 +-
 drivers/media/video/mt9m111.c                      |   14 +-
 drivers/media/video/mt9v022.c                      |    2 +-
 drivers/media/video/mt9v032.c                      |  773 +++++
 drivers/media/video/mx3_camera.c                   |   60 +-
 drivers/media/video/omap1_camera.c                 |   43 +-
 drivers/media/video/pvrusb2/pvrusb2-std.c          |   10 +-
 drivers/media/video/pwc/pwc-if.c                   |    2 +-
 drivers/media/video/pwc/pwc-v4l.c                  |   23 +-
 drivers/media/video/pxa_camera.c                   |    8 +-
 drivers/media/video/s2255drv.c                     |   27 +-
 drivers/media/video/s5p-fimc/Makefile              |    6 +-
 drivers/media/video/s5p-fimc/mipi-csis.c           |  724 +++++
 drivers/media/video/s5p-fimc/mipi-csis.h           |   22 +
 drivers/media/video/saa7134/saa7134-cards.c        |  125 +
 drivers/media/video/saa7134/saa7134-core.c         |    2 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   34 +
 drivers/media/video/saa7134/saa7134-input.c        |    8 +
 drivers/media/video/saa7134/saa7134.h              |    3 +
 drivers/media/video/saa7164/saa7164-core.c         |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  148 +-
 drivers/media/video/soc_camera.c                   |   29 +-
 drivers/media/video/soc_mediabus.c                 |  265 ++-
 drivers/media/video/tveeprom.c                     |   32 +-
 drivers/media/video/usbvision/usbvision-cards.c    |   33 +-
 drivers/media/video/usbvision/usbvision-cards.h    |    2 +
 drivers/media/video/usbvision/usbvision-core.c     |  165 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |    2 +-
 drivers/media/video/usbvision/usbvision-video.c    |    3 +-
 drivers/media/video/usbvision/usbvision.h          |    6 +
 drivers/media/video/uvc/uvc_ctrl.c                 |  367 ++-
 drivers/media/video/uvc/uvc_driver.c               |   28 +
 drivers/media/video/uvc/uvc_queue.c                |   34 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   68 +-
 drivers/media/video/uvc/uvcvideo.h                 |   64 +-
 drivers/media/video/v4l2-dev.c                     |   18 +
 drivers/media/video/via-camera.c                   |    1 +
 drivers/media/video/zoran/zoran_card.c             |   10 +-
 drivers/staging/lirc/lirc_sasem.c                  |   13 +-
 drivers/staging/tm6000/CARDLIST                    |   16 +
 drivers/staging/tm6000/tm6000-alsa.c               |    3 -
 drivers/staging/tm6000/tm6000-cards.c              |  381 +++-
 drivers/staging/tm6000/tm6000-core.c               |  109 +-
 drivers/staging/tm6000/tm6000-i2c.c                |   33 +-
 drivers/staging/tm6000/tm6000-stds.c               |  923 ++-----
 drivers/staging/tm6000/tm6000-usb-isoc.h           |    2 +-
 drivers/staging/tm6000/tm6000-video.c              |  212 +-
 drivers/staging/tm6000/tm6000.h                    |   46 +-
 include/linux/Kbuild                               |    1 +
 include/linux/dvb/frontend.h                       |   20 +-
 include/linux/dvb/version.h                        |    2 +-
 include/linux/uvcvideo.h                           |   69 +
 include/linux/v4l2-mediabus.h                      |    3 +
 include/linux/videodev2.h                          |    4 +
 include/media/mt9v032.h                            |   12 +
 include/media/rc-core.h                            |    7 +-
 include/media/rc-map.h                             |    1 +
 include/media/soc_camera.h                         |   15 +-
 include/media/soc_camera_platform.h                |   50 +
 include/media/soc_mediabus.h                       |   25 +-
 include/media/v4l2-dev.h                           |    2 +
 228 files changed, 18716 insertions(+), 4767 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-m420.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10b.xml
 create mode 100644 Documentation/video4linux/uvcvideo.txt
 create mode 100644 drivers/media/common/tuners/tda18212.c
 create mode 100644 drivers/media/common/tuners/tda18212.h
 create mode 100644 drivers/media/common/tuners/tda18212_priv.h
 create mode 100644 drivers/media/dvb/frontends/bsbe1-d01a.h
 create mode 100644 drivers/media/dvb/frontends/cxd2820r.h
 create mode 100644 drivers/media/dvb/frontends/cxd2820r_c.c
 create mode 100644 drivers/media/dvb/frontends/cxd2820r_core.c
 create mode 100644 drivers/media/dvb/frontends/cxd2820r_priv.h
 create mode 100644 drivers/media/dvb/frontends/cxd2820r_t.c
 create mode 100644 drivers/media/dvb/frontends/cxd2820r_t2.c
 delete mode 100644 drivers/media/dvb/frontends/drx397xD.c
 delete mode 100644 drivers/media/dvb/frontends/drx397xD.h
 delete mode 100644 drivers/media/dvb/frontends/drx397xD_fw.h
 create mode 100644 drivers/media/dvb/frontends/drxd.h
 create mode 100644 drivers/media/dvb/frontends/drxd_firm.c
 create mode 100644 drivers/media/dvb/frontends/drxd_firm.h
 create mode 100644 drivers/media/dvb/frontends/drxd_hard.c
 create mode 100644 drivers/media/dvb/frontends/drxd_map_firm.h
 create mode 100644 drivers/media/rc/keymaps/rc-tivo.c
 create mode 100644 drivers/media/rc/redrat3.c
 create mode 100644 drivers/media/video/gspca/kinect.c
 create mode 100644 drivers/media/video/mt9v032.c
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.c
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.h
 create mode 100644 drivers/staging/tm6000/CARDLIST
 create mode 100644 include/linux/uvcvideo.h
 create mode 100644 include/media/mt9v032.h

