Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1AGCUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1AGCUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:20:39 -0500
Message-ID: <4D26785A.7060606@redhat.com>
Date: Fri, 07 Jan 2011 00:20:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] media updates for 2.6.38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

It contains several updates to V4L, DVB and RC. The most relevant one is the removal
of V4L1 API. There were just two old V4L1 drivers left, that were moved to staging.
One will likely be converted into a gspca sub-driver. The other one will be removed,
if nobody manifests, as its conversion is not trivial and no developer has the
hardware for testing.

It also contains a rename at the RC core stuff, in order to provide a more consistent
API, and to not use an uppercase directory for the subsystem.

There are several new drivers and patches to existing drivers in order to support the
ISDB-T digital TV standard, used in Japan and in deployment in South America.

The rest are some post-BKL removal cleanups and the usual drivers/core fixes 
and improvements.

I still have some other patches pending on my queue, that I need some time to review
and test before sending you. So, I'll likely send you a new pull request next week
with the remaining patches.

Thanks!
Mauro

-

The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:

  Linux 2.6.37 (2011-01-04 16:50:19 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Alberto Panizzo (2):
      [media] V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV2640 sensor
      [media] soc_camera: Add the ability to bind regulators to soc_camedra devices

Alexey Chernov (2):
      [media] Patch for cx18 module with added support of GoTView PCI DVD3 Hybrid tuner
      [media] support of GoTView PCI-E X5 3D Hybrid in cx23885

Anatolij Gustschin (3):
      [media] media: fsl-viu: fix support for streaming with mmap method
      [media] saa7115: allow input standard autodetection for more chips
      [media] fsl_viu: add VIDIOC_QUERYSTD and VIDIOC_G_STD support

Andy Walls (7):
      [media] ivtv, cx18: Make ioremap failure messages more useful for users
      [media] cx18: Only allocate a struct cx18_dvb for the DVB TS stream
      [media] ivtv: ivtv_write_vbi() should use copy_from_user() for user data buffers
      [media] ivtv: Return EFAULT when copy_from_user() fails in ivtv_write_vbi_from_user()
      [media] hdpvr: Add I2C and ir-kdb-i2c registration of the Zilog Z8 IR chip
      [media] ir-kbd-i2c: Add HD PVR IR Rx support to ir-kbd-i2c
      [media] lirc_zilog: Remove use of deprecated struct i2c_adapter.id field

Ang Way Chuang (1):
      [media] cx88-dvb.c: DVB net latency using Hauppauge HVR4000

Axel Lin (1):
      [media] tea6415c: return -EIO if i2c_check_functionality fails

Ben Hutchings (1):
      [media] Mantis: Rename gpio_set_bits to mantis_gpio_set_bits

Bjørn Mork (1):
      [media] Mantis: use dvb_attach to avoid double dereferencing on module removal

Dan Carpenter (7):
      [media] saa7164: make buffer smaller
      [media] lirc_dev: add some __user annotations
      [media] cx231xx: stray unlock on error path
      [media] zoran: bit-wise vs logical and
      [media] timblogiw: too large value for strncpy()
      [media] cx231xxx: fix typo in saddr_len check
      [media] cx231xx: use bitwise negate instead of logical

Daniel Drake (1):
      [media] cafe_ccic: fix colorspace corruption on resume

David Cohen (2):
      [media] ov9640: use macro to request OmniVision OV9640 sensor private data
      [media] ov9640: fix OmniVision OV9640 sensor driver's priv data retrieving

David Henningsson (3):
      [media] DVB: Set scanmask for Budget/SAA7146 cards
      [media] MEDIA: RC: Provide full scancodes for TT-1500 remote control
      [media] DVB: IR support for TechnoTrend CT-3650

David HÃ¤rdeman (10):
      [media] ir-core: remove remaining users of the ir-functions keyhandlers
      [media] ir-core: more cleanups of ir-functions.c
      [media] ir-core: make struct rc_dev the primary interface
      [media] saa7134: remove unused module parameter
      [media] saa7134: use full keycode for BeholdTV
      [media] saa7134: some minor cleanups
      [media] saa7134: merge saa7134_card_ir->timer and saa7134_card_ir->timer_end
      [media] bttv: rename struct card_ir to bttv_ir
      [media] bttv: merge ir decoding timers
      [media] rc-core: fix some leftovers from the renaming patches

David Härdeman (4):
      [media] ir-core: convert drivers/media/video/cx88 to ir-core
      [media] rc-core: Code cleanup after merging rc-sysfs and rc-map into rc-main
      [media] rc-core: convert winbond-cir
      [media] rc-core: add loopback driver

Devin Heitmueller (9):
      [media] au8522: Properly set default brightness
      [media] au0828: set max packets per URB to match Windows driver
      [media] au0828: Fix field alignment for video frames delivered by driver
      [media] au8522: cleanup code which disables audio decoder
      [media] au8522: fix clamp control for different video modes
      [media] au8522: Handle differences in comb filter config for s-video input
      [media] au0828: continue video streaming even when no ITU-656 coming in
      [media] au0828: fixes for timeout on no video
      [media] au0828: enable VBI timeout when calling read() without streamon()

Dmitri Belimov (2):
      [media] tm6000: rework and fix IR
      [media] tm6000: Fix mutex unbalance

Guennadi Liakhovetski (2):
      [media] v4l: ov772x: simplify pointer dereference
      [media] v4l: soc-camera: switch to .unlocked_ioctl

Hans Verkuil (25):
      [media] V4L: remove V4L1 compatibility mode
      [media] zoran: remove V4L1 compat code and zoran custom ioctls
      [media] videobuf-dma-sg: remove obsolete comments
      [media] documentation: update some files to reflect the V4L1 compat removal
      [media] usbvideo: remove deprecated drivers
      [media] usbvideo: deprecate the vicam driver
      [media] se401: deprecate driver, move to staging
      [media] cpia, stradis: remove deprecated V4L1 drivers
      [media] feature-removal: update V4L1 removal status
      [media] stk-webcam: remove V4L1 compatibility code, replace with V4L2 controls
      [media] saa6588: rename rds.h to saa6588.h
      [media] bt819: the ioctls in the header are internal to the kernel
      [media] usbvision: convert to unlocked_ioctl
      [media] usbvision: get rid of camelCase
      [media] usbvision: convert // to /* */
      [media] usbvision: coding style
      [media] v4l2-ctrls: use const char * const * for the menu arrays
      [media] v4l2-ctrls: only check def for menu, integer and boolean controls
      [media] em28xx: fix incorrect s_ctrl error code and wrong call to res_free
      [media] v4l: fix handling of v4l2_input.capabilities
      [media] timblogiw: fix compile warning
      [media] ngene: fix compile warning
      [media] tda18218: fix compile warning
      [media] zoran: fix compiler warning
      [media] v4l2-compat-ioctl32: fix compile warning

Hans de Goede (13):
      [media] gspca: submit interrupt urbs *after* isoc urbs
      [media] gspca: only set gspca->int_urb if submitting it succeeds
      [media] gspca_xirlink_cit: various usb bandwidth allocation improvements / fixes
      [media] gspca_xirlink_cit: Frames have a 4 byte footer
      [media] gspca_xirlink_cit: Add support camera button
      [media] gspca_ov519: generate release button event on stream stop if needed
      [media] gspca-stv06xx: support bandwidth changing
      [media] pwc: do not start isoc stream on /dev/video open
      [media] pwc: Also set alt setting to alt0 when no error occured
      [media] pwc: failure to submit an urb is a fatal error
      [media] gspca_sonixb: Make sonixb handle 0c45:6007 instead of sn9c102
      [media] gspca_sonixb: Rewrite start of frame detection
      [media] gspca_sonixb: Add support for 0c45:602a

Igor M. Liplianin (1):
      [media] cx23885, cimax2.c: Fix case of two CAM insertion irq

Jarkko Nikula (1):
      [media] radio-si4713: Add regulator framework support

Jean Delvare (2):
      [media] TM6000: Clean-up i2c initialization
      [media] TM6000: Drop unused macro

Jean-François Moine (37):
      [media] gspca - main: Version change
      [media] gspca - main: Fix a small code error
      [media] gspca - zc3xx: Bad clocksetting for mt9v111_3 with 640x480 resolution
      [media] gspca - sonixj: Simplify and clarify the hv7131r probe function
      [media] gspca: Convert some uppercase hexadecimal values to lowercase
      [media] gspca - ov519: Handle the snapshot on capture stop when CONFIG_INPUT=m
      [media] gspca - ov519: Don't do USB exchanges after disconnection
      [media] gspca - ov519: Change types '__xx' to 'xx'
      [media] gspca - ov519: Reduce the size of some variables
      [media] gspca - ov519: Define the sensor types in an enum
      [media] gspca - ov519: Cleanup source
      [media] gspca - ov519: Set their numbers in the ov519 and ov7670 register names
      [media] gspca - ov519: Define the disabled controls in a table
      [media] gspca - ov519: Propagate errors to higher level
      [media] gspca - ov519: Clearer debug and error messages
      [media] gspca - ov519: Check the disabled controls at start time only
      [media] gspca - ov519: Simplify the LED control functions
      [media] gspca - ov519: Change the ov519 start and stop sequences
      [media] gspca - ov519: Initialize the ov519 snapshot register
      [media] gspca - ov519: Re-initialize the webcam at resume time
      [media] gspca - ov519: New sensor ov7660 with bridge ov530 (ov519)
      [media] gspca - sq930x: Don't register a webcam when there are USB errors
      [media] gspca - sq930x: Some detected sensors are not handled yet
      [media] gspca - sq930x: Fix a bad comment
      [media] gspca - main: Check the isoc packet status before its length
      [media] gspca: Use the global error status for get/set streamparm
      [media] gspca - ov519: Bad detection of some ov7670 sensors
      [media] gspca - ov534_9: Remove an useless instruction
      [media] gspca - main: Fix some warnings
      [media] gspca - pac7302/pac7311: Fix some warnings
      [media] gspca: Bad comment
      [media] gspca - zc3xx: Keep sorted the device table
      [media] gspca - zc3xx: Use the new video control mechanism
      [media] gspca - zc3xx: The sensor of the VF0250 is a GC0303
      [media] gspca - vc032x: Cleanup source
      [media] gspca - stv06xx/st6422: Use the new video control mechanism
      [media] gspca - sonixj: Bad clock for om6802 in 640x480

Jesper Juhl (2):
      [media] cx231xx-417: Remove unnecessary casts of void ptr returning alloc function return values
      [media] saa7164: Remove pointless conditional and save a few bytes in saa7164_downloadfirmware()

Joe Perches (7):
      [media] drivers/media: Removed unnecessary KERN_<level>s from dprintk uses
      [media] drivers/media/video: Update WARN uses
      [media] drivers/media: Use vzalloc
      [media] drivers/staging/cx25821: Use pr_fmt and pr_<level>
      [media] drivers/media/video: Remove unnecessary semicolons
      [media] ngene-core.c: Remove unnecessary casts of pci_get_drvdata
      [media] media: Remove unnecessary casts of usb_get_intfdata

Malcolm Priestley (4):
      [media] lmed04: Improve frontend handling
      [media] Documentation/lmedm04: Fix firmware extract information
      [media] lmedm04: change USB Timeouts to avoid troubles
      [media] DM04/QQBOX Frontend attach change

Manu Abraham (3):
      [media] Mantis, hopper: use MODULE_DEVICE_TABLE
      [media] stb6100: Improve tuner performance
      [media] stb0899: fix diseqc messages getting lost

Marek Szyprowski (1):
      [media] v4l: mem2mem_testdev: remove BKL usage

Mariusz Białończyk (2):
      [media] Fix rc-tbs-nec table after converting the cx88 driver to ir-core
      [media] ir-nec-decoder: fix repeat key issue

Marko Ristola (1):
      [media] Mantis: append tasklet maintenance for DVB stream delivery

Matthias Schwarzott (1):
      [media] IX2505V: i2c transfer error code ignored

Matti Aaltonen (2):
      [media] MFD: WL1273 FM Radio: MFD driver for the FM radio
      [media] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver

Mauro Carvalho Chehab (71):
      [media] Re-write the s921 frontend
      [media] em28xx: Add support for Leadership ISDB-T
      [media] add a driver for mb86a20s
      [media] Add analog support for Pixelvied Hybrid SBTVD
      [media] add digital support for PV SBTVD hybrid
      [media] cx231xx: use callback to set agc on PixelView
      [media] mb86a20s: add support for serial streams
      [media] Add support for Kworld SBTVD board
      [media] Add DVB support for SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG
      [media] cx231xx: Add a driver for I2C-based IR
      [media] cx231xx: Add IR support for Pixelview Hybrid SBTVD
      [media] rename drivers/media/IR to drives/media/rc
      [media] Rename rc-core files from ir- to rc-
      [media] rc-core: Merge rc-sysfs.c into rc-main.c
      [media] rc-core: merge rc-map.c into rc-main.c
      [media] ir-kbd-i2c: add rc_dev as a parameter to the driver
      [media] cx231xx: Fix i2c support at cx231xx-input
      [media] saa7134: use rc-core raw decoders for Encore FM 5.3
      [media] saa7134: Remove legacy IR decoding logic inside the module
      [media] rc: Remove ir-common module
      [media] rc: remove ir-common module
      [media] rc: Remove ir-common.h
      [media] rc: rename the remaining things to rc_core
      [media] Rename all public generic RC functions from ir_ to rc_
      [media] cx231xx: Properly name rc_map name
      [media] rc: Rename remote controller type to rc_type instead of ir_type
      [media] rc: Properly name the rc_map struct
      [media] rc: Name RC keymap tables as rc_map_table
      [media] rc: use rc_map_ prefix for all rc map tables
      [media] rc: Rename IR raw interface to ir-raw.c
      [media] stb6100: warning cleanup
      [media] Fix parameter description for disable_ir
      [media] bttv: remove custom_irq and gpioq from bttv struct
      [media] rc-core: Initialize return value to zero
      [media] gspca/sn9c20x: Test if sensor is a OV sensor
      [media] gspca/sn9c20x: Get rid of scale "magic" numbers
      [media] gspca core: Fix regressions gspca breaking devices with audio
      [media] gspca/sn9c20x: Fix support for mt9m001 (mi1300) sensor
      [media] cx231xx: Fix inverted bits for RC on PV Hybrid
      [media] Add a keymap for Pixelview 002-T remote
      [media] cx231xx: Fix IR keymap for Pixelview SBTVD Hybrid
      [media] staging: Add TODO files for se401 and usbvideo/vicam
      [media] Remove VIDEO_V4L1 Kconfig option
      [media] V4L1 removal: Remove linux/videodev.h
      [media] Documentation/ioctl/ioctl-number.txt: Remove some now freed ioctl ranges
      [media] Fix videodev.h references at the V4L DocBook
      [media] Remove the old V4L1 v4lgrab.c file
      [media] omap_vout: Remove an obsolete comment
      [media] staging/lirc: Fix compilation when LIRC=m
      [media] feature_removal_schedule.txt: mark VIDIOC_*_OLD ioctls to die
      [media] dmxdev: Fix a compilation warning due to a bad type
      [media] radio-wl1273: Fix two warnings
      [media] lirc_zilog: Fix a warning
      [media] dib7000m/dib7000p: Add support for TRANSMISSION_MODE_4K
      [media] gspca: Fix a warning for using len before filling it
      [media] stv090x: Fix some compilation warnings
      [media] af9013: Fix a compilation warning
      [media] streamzap: Fix a compilation warning when compiled builtin
      [media] dabusb: Move it to staging to be deprecated
      [media] cardlist: Update lists for em28xx and saa7134
      [media] em28xx: Fix audio input for Terratec Grabby
      [media] bttv-input: Add a note about PV951 RC
      [media] cx88: Add RC logic for Leadtek PVR 2000
      [media] ivtv: Add Adaptec Remote Controller
      [media] ivtv-i2c: Don't use IR legacy mode for Zilog IR
      [media] Remove staging/lirc/lirc_i2c driver
      [media] cx88: Remove the obsolete i2c_adapter.id field
      [media] staging/lirc: Update lirc TODO files
      [media] ivtv-i2c: Fix two warnings
      [media] cx25821: Fix compilation breakage due to BKL dependency
      [media] radio-aimslab.c: Fix gcc 4.5+ bug

Nicolas Kaiser (2):
      [media] gspca - cpia1: Fix error check
      [media] drivers/media: nuvoton: fix chip id probe v2

Paul Bender (1):
      [media] rc: fix sysfs entry for mceusb and streamzap

Pete Eberlein (1):
      [media] s2255drv: remove BKL

Philippe Bourdin (1):
      [media] Terratec Cinergy Hybrid T USB XS

Ramiro Morales (1):
      [media] saa7134: Add support for Compro VideoMate Vista M1F

Randy Dunlap (4):
      [media] timblogiw: fix kconfig & build error
      [media] media: fix em28xx build, needs hardirq.h
      [media] staging: usbvideo/vicam depends on USB
      [media] staging: se401 depends on USB

Richard RÃ¶jfors (1):
      [media] mfd: Add timberdale video-in driver to timberdale

Richard Röjfors (1):
      [media] media: Add timberdale video-in driver

Richard Zidlicky (1):
      [media] keycodes for DSR-0112 remote bundled with Haupauge MiniStick

Sam Doshi (1):
      [media] drivers:media:dvb: add USB PIDs for Elgato EyeTV Sat

Stefan Ringel (1):
      [media] tm6000: add revision check

Stephen Rothwell (1):
      [media] timblogiw: const and __devinitdata do not mix

Steven Toth (1):
      [media] saa7164: Checkpatch compliance cleanup

Theodore Kilgore (1):
      [media] gspca - sq905c: Adds the Lego Bionicle

VDR User (1):
      [media] dvb-usb-gp8psk: get firmware and fpga versions

Vasiliy Kulikov (3):
      [media] media: rc: lirc_dev: check kobject_set_name() result
      [media] rc: ir-lirc-codec: fix potential integer overflow
      [media] media: video: pvrusb2: fix memory leak

Wolfram Sang (2):
      [media] media: video: do not clear 'driver' from an i2c_client
      [media] i2c: Remove obsolete cleanup for clientdata

 Documentation/DocBook/v4l/func-ioctl.xml           |    5 +-
 Documentation/DocBook/v4l/pixfmt.xml               |    4 +-
 Documentation/Makefile                             |    2 +-
 Documentation/dvb/lmedm04.txt                      |    2 +-
 Documentation/feature-removal-schedule.txt         |   50 +-
 Documentation/ioctl/ioctl-number.txt               |    6 -
 Documentation/video4linux/CARDLIST.em28xx          |    6 +-
 Documentation/video4linux/CARDLIST.saa7134         |    2 +
 Documentation/video4linux/Makefile                 |    8 -
 Documentation/video4linux/README.cpia              |  191 -
 Documentation/video4linux/Zoran                    |   74 +-
 Documentation/video4linux/bttv/Cards               |    4 -
 Documentation/video4linux/gspca.txt                |    1 +
 Documentation/video4linux/meye.txt                 |   10 +-
 Documentation/video4linux/v4lgrab.c                |  201 -
 Documentation/video4linux/videobuf                 |    7 +-
 MAINTAINERS                                        |    6 -
 drivers/input/misc/Kconfig                         |   18 -
 drivers/input/misc/Makefile                        |    1 -
 drivers/input/misc/winbond-cir.c                   | 1608 --------
 drivers/media/IR/ir-functions.c                    |  356 --
 drivers/media/IR/ir-keytable.c                     |  710 ----
 drivers/media/IR/ir-sysfs.c                        |  362 --
 drivers/media/IR/keymaps/rc-tbs-nec.c              |   73 -
 drivers/media/IR/keymaps/rc-tt-1500.c              |   82 -
 drivers/media/IR/rc-map.c                          |  107 -
 drivers/media/Kconfig                              |   53 +-
 drivers/media/Makefile                             |    2 +-
 drivers/media/common/saa7146_video.c               |   32 -
 drivers/media/common/tuners/max2165.c              |   10 +-
 drivers/media/common/tuners/tda18218.c             |    2 +-
 drivers/media/dvb/dm1105/Kconfig                   |    3 +-
 drivers/media/dvb/dm1105/dm1105.c                  |   44 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |    4 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    2 +-
 drivers/media/dvb/dvb-usb/a800.c                   |    6 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c          |   16 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |   16 +-
 drivers/media/dvb/dvb-usb/af9005.h                 |    4 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |   22 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    4 +-
 drivers/media/dvb/dvb-usb/az6027.c                 |   13 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c         |    6 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |   62 +-
 drivers/media/dvb/dvb-usb/dib0700.h                |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   18 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  146 +-
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    4 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |   16 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c              |    4 +-
 drivers/media/dvb/dvb-usb/dibusb.h                 |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |   14 +-
 drivers/media/dvb/dvb-usb/dtt200u.c                |   18 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |  103 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h                |   28 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |   54 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |   28 +
 drivers/media/dvb/dvb-usb/gp8psk.h                 |    8 +-
 drivers/media/dvb/dvb-usb/lmedm04.c                |  329 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |   24 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |   18 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   16 +-
 drivers/media/dvb/dvb-usb/ttusb2.c                 |   35 +
 drivers/media/dvb/dvb-usb/vp702x.c                 |   12 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |   12 +-
 drivers/media/dvb/frontends/Kconfig                |   10 +-
 drivers/media/dvb/frontends/Makefile               |    2 +-
 drivers/media/dvb/frontends/af9013.c               |    2 +-
 drivers/media/dvb/frontends/atbm8830.c             |    8 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |   51 +-
 drivers/media/dvb/frontends/au8522_priv.h          |    2 +
 drivers/media/dvb/frontends/dib7000m.c             |   10 +-
 drivers/media/dvb/frontends/dib7000p.c             |   10 +-
 drivers/media/dvb/frontends/ix2505v.c              |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c              |   11 +-
 drivers/media/dvb/frontends/mb86a20s.c             |  615 +++
 drivers/media/dvb/frontends/mb86a20s.h             |   52 +
 drivers/media/dvb/frontends/s921.c                 |  548 +++
 drivers/media/dvb/frontends/s921.h                 |   47 +
 drivers/media/dvb/frontends/s921_core.c            |  216 --
 drivers/media/dvb/frontends/s921_core.h            |  114 -
 drivers/media/dvb/frontends/s921_module.c          |  192 -
 drivers/media/dvb/frontends/s921_module.h          |   49 -
 drivers/media/dvb/frontends/stb0899_drv.c          |    2 +-
 drivers/media/dvb/frontends/stb6100.c              |  198 +-
 drivers/media/dvb/frontends/stv090x.c              |    6 +-
 drivers/media/dvb/mantis/Kconfig                   |    2 +-
 drivers/media/dvb/mantis/hopper_cards.c            |    2 +
 drivers/media/dvb/mantis/hopper_vp3028.c           |    6 +-
 drivers/media/dvb/mantis/mantis_cards.c            |    2 +
 drivers/media/dvb/mantis/mantis_common.h           |    4 +-
 drivers/media/dvb/mantis/mantis_dvb.c              |   17 +-
 drivers/media/dvb/mantis/mantis_input.c            |   76 +-
 drivers/media/dvb/mantis/mantis_ioc.c              |    4 +-
 drivers/media/dvb/mantis/mantis_ioc.h              |    2 +-
 drivers/media/dvb/mantis/mantis_vp1033.c           |    2 +-
 drivers/media/dvb/mantis/mantis_vp1034.c           |   10 +-
 drivers/media/dvb/mantis/mantis_vp1041.c           |    6 +-
 drivers/media/dvb/mantis/mantis_vp2033.c           |    4 +-
 drivers/media/dvb/mantis/mantis_vp2040.c           |    4 +-
 drivers/media/dvb/mantis/mantis_vp3030.c           |    8 +-
 drivers/media/dvb/ngene/ngene-core.c               |    8 +-
 drivers/media/dvb/siano/Kconfig                    |    2 +-
 drivers/media/dvb/siano/smscoreapi.c               |    2 +-
 drivers/media/dvb/siano/smsir.c                    |   52 +-
 drivers/media/dvb/siano/smsir.h                    |    5 +-
 drivers/media/dvb/siano/smsusb.c                   |    9 +-
 drivers/media/dvb/ttpci/Kconfig                    |    3 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |    4 +
 drivers/media/dvb/ttpci/budget-av.c                |    6 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   54 +-
 drivers/media/radio/Kconfig                        |   16 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-aimslab.c                |   23 +-
 drivers/media/radio/radio-wl1273.c                 | 2330 +++++++++++
 drivers/media/radio/si470x/radio-si470x.h          |    1 -
 drivers/media/radio/si4713-i2c.c                   |   74 +-
 drivers/media/radio/si4713-i2c.h                   |    5 +-
 drivers/media/{IR => rc}/Kconfig                   |   70 +-
 drivers/media/{IR => rc}/Makefile                  |    8 +-
 drivers/media/{IR => rc}/ene_ir.c                  |  131 +-
 drivers/media/{IR => rc}/ene_ir.h                  |    3 +-
 drivers/media/{IR => rc}/imon.c                    |  107 +-
 drivers/media/{IR => rc}/ir-jvc-decoder.c          |   17 +-
 drivers/media/{IR => rc}/ir-lirc-codec.c           |  132 +-
 drivers/media/{IR => rc}/ir-nec-decoder.c          |   27 +-
 drivers/media/{IR/ir-raw-event.c => rc/ir-raw.c}   |  197 +-
 drivers/media/{IR => rc}/ir-rc5-decoder.c          |   17 +-
 drivers/media/{IR => rc}/ir-rc5-sz-decoder.c       |   17 +-
 drivers/media/{IR => rc}/ir-rc6-decoder.c          |   21 +-
 drivers/media/{IR => rc}/ir-sony-decoder.c         |   15 +-
 drivers/media/{IR => rc}/keymaps/Kconfig           |    2 +-
 drivers/media/{IR => rc}/keymaps/Makefile          |    2 +
 .../{IR => rc}/keymaps/rc-adstech-dvb-t-pci.c      |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-alink-dtu-m.c  |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-anysee.c       |   10 +-
 .../media/{IR => rc}/keymaps/rc-apac-viewcomp.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-asus-pc39.c    |   10 +-
 .../{IR => rc}/keymaps/rc-ati-tv-wonder-hd-600.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-avermedia-a16d.c   |   10 +-
 .../{IR => rc}/keymaps/rc-avermedia-cardbus.c      |   10 +-
 .../media/{IR => rc}/keymaps/rc-avermedia-dvbt.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-avermedia-m135a.c  |   10 +-
 .../{IR => rc}/keymaps/rc-avermedia-m733a-rm-k6.c  |   10 +-
 .../media/{IR => rc}/keymaps/rc-avermedia-rm-ks.c  |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-avermedia.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-avertv-303.c   |   10 +-
 .../{IR => rc}/keymaps/rc-azurewave-ad-tu700.c     |   10 +-
 .../media/{IR => rc}/keymaps/rc-behold-columbus.c  |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-behold.c       |   78 +-
 .../media/{IR => rc}/keymaps/rc-budget-ci-old.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-cinergy-1400.c |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-cinergy.c      |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-dib0700-nec.c  |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-dib0700-rc5.c  |   10 +-
 .../{IR => rc}/keymaps/rc-digitalnow-tinytwin.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-digittrade.c   |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-dm1105-nec.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-dntv-live-dvb-t.c  |   10 +-
 .../{IR => rc}/keymaps/rc-dntv-live-dvbt-pro.c     |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-em-terratec.c  |   10 +-
 .../{IR => rc}/keymaps/rc-encore-enltv-fm53.c      |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-encore-enltv.c |   10 +-
 .../media/{IR => rc}/keymaps/rc-encore-enltv2.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-evga-indtube.c |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-eztv.c         |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-flydvb.c       |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-flyvideo.c     |   10 +-
 .../media/{IR => rc}/keymaps/rc-fusionhdtv-mce.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-gadmei-rm008z.c    |   10 +-
 .../{IR => rc}/keymaps/rc-genius-tvgo-a11mce.c     |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-gotview7135.c  |   10 +-
 .../media/{IR => rc}/keymaps/rc-hauppauge-new.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-imon-mce.c     |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-imon-pad.c     |   10 +-
 .../media/{IR => rc}/keymaps/rc-iodata-bctv7e.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-kaiomy.c       |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-kworld-315u.c  |   10 +-
 .../{IR => rc}/keymaps/rc-kworld-plus-tv-analog.c  |   10 +-
 .../media/{IR => rc}/keymaps/rc-leadtek-y04g0051.c |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-lirc.c         |   12 +-
 drivers/media/{IR => rc}/keymaps/rc-lme2510.c      |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-manli.c        |   10 +-
 .../media/{IR => rc}/keymaps/rc-msi-digivox-ii.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-msi-digivox-iii.c  |   10 +-
 .../{IR => rc}/keymaps/rc-msi-tvanywhere-plus.c    |   10 +-
 .../media/{IR => rc}/keymaps/rc-msi-tvanywhere.c   |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-nebula.c       |   10 +-
 .../keymaps/rc-nec-terratec-cinergy-xs.c           |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-norwood.c      |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-npgtech.c      |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-pctv-sedna.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-pinnacle-color.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-pinnacle-grey.c    |   10 +-
 .../media/{IR => rc}/keymaps/rc-pinnacle-pctv-hd.c |   10 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |   77 +
 .../media/{IR => rc}/keymaps/rc-pixelview-mk12.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-pixelview-new.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-pixelview.c    |   10 +-
 .../{IR => rc}/keymaps/rc-powercolor-real-angel.c  |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-proteus-2309.c |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-purpletv.c     |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-pv951.c        |   10 +-
 .../{IR => rc}/keymaps/rc-rc5-hauppauge-new.c      |   48 +-
 drivers/media/{IR => rc}/keymaps/rc-rc5-tv.c       |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-rc6-mce.c      |   10 +-
 .../{IR => rc}/keymaps/rc-real-audio-220-32-keys.c |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-streamzap.c    |   10 +-
 drivers/media/rc/keymaps/rc-tbs-nec.c              |   75 +
 .../{IR => rc}/keymaps/rc-terratec-cinergy-xs.c    |   10 +-
 .../media/{IR => rc}/keymaps/rc-terratec-slim.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-tevii-nec.c    |   10 +-
 .../{IR => rc}/keymaps/rc-total-media-in-hand.c    |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-trekstor.c     |   10 +-
 drivers/media/rc/keymaps/rc-tt-1500.c              |   82 +
 drivers/media/{IR => rc}/keymaps/rc-twinhan1027.c  |   10 +-
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |   92 +
 .../media/{IR => rc}/keymaps/rc-videomate-s350.c   |   10 +-
 .../media/{IR => rc}/keymaps/rc-videomate-tv-pvr.c |   10 +-
 .../{IR => rc}/keymaps/rc-winfast-usbii-deluxe.c   |   10 +-
 drivers/media/{IR => rc}/keymaps/rc-winfast.c      |   10 +-
 drivers/media/{IR => rc}/lirc_dev.c                |    8 +-
 drivers/media/{IR => rc}/mceusb.c                  |  114 +-
 drivers/media/{IR => rc}/nuvoton-cir.c             |   94 +-
 drivers/media/{IR => rc}/nuvoton-cir.h             |    3 +-
 .../media/{IR/ir-core-priv.h => rc/rc-core-priv.h} |   34 +-
 drivers/media/rc/rc-loopback.c                     |  260 ++
 drivers/media/rc/rc-main.c                         | 1135 ++++++
 drivers/media/{IR => rc}/streamzap.c               |   81 +-
 drivers/media/rc/winbond-cir.c                     |  932 +++++
 drivers/media/video/Kconfig                        |   36 +-
 drivers/media/video/Makefile                       |   12 +-
 drivers/media/video/au0828/au0828-video.c          |  118 +-
 drivers/media/video/au0828/au0828.h                |    6 +-
 drivers/media/video/bt8xx/Kconfig                  |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   48 +-
 drivers/media/video/bt8xx/bttv-input.c             |  238 +-
 drivers/media/video/bt8xx/bttv.h                   |    1 -
 drivers/media/video/bt8xx/bttvp.h                  |   34 +-
 drivers/media/video/cafe_ccic.c                    |    5 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |   38 -
 drivers/media/video/cx18/Kconfig                   |    3 +-
 drivers/media/video/cx18/cx18-cards.c              |   64 +-
 drivers/media/video/cx18/cx18-controls.c           |    2 +-
 drivers/media/video/cx18/cx18-driver.c             |   11 +-
 drivers/media/video/cx18/cx18-driver.h             |   13 +-
 drivers/media/video/cx18/cx18-dvb.c                |   64 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx18/cx18-mailbox.c            |    6 +-
 drivers/media/video/cx18/cx18-streams.c            |   45 +-
 drivers/media/video/cx18/cx18-streams.h            |    3 +-
 drivers/media/video/cx231xx/Kconfig                |   19 +-
 drivers/media/video/cx231xx/Makefile               |    5 +-
 drivers/media/video/cx231xx/cx231xx-417.c          |    4 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |    7 +-
 drivers/media/video/cx231xx/cx231xx-cards.c        |   65 +-
 drivers/media/video/cx231xx/cx231xx-core.c         |   12 +-
 drivers/media/video/cx231xx/cx231xx-dvb.c          |   40 +
 drivers/media/video/cx231xx/cx231xx-input.c        |  112 +
 drivers/media/video/cx231xx/cx231xx-video.c        |   12 -
 drivers/media/video/cx231xx/cx231xx.h              |   26 +-
 drivers/media/video/cx2341x.c                      |    8 +-
 drivers/media/video/cx23885/Kconfig                |    2 +-
 drivers/media/video/cx23885/cimax2.c               |   24 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   33 +
 drivers/media/video/cx23885/cx23885-input.c        |   70 +-
 drivers/media/video/cx23885/cx23885-video.c        |   33 -
 drivers/media/video/cx23885/cx23885.h              |    6 +-
 drivers/media/video/cx23885/cx23888-ir.c           |    2 +-
 drivers/media/video/cx25840/cx25840-ir.c           |    2 +-
 drivers/media/video/cx88/Kconfig                   |    3 +-
 drivers/media/video/cx88/cx88-blackbird.c          |    2 +-
 drivers/media/video/cx88/cx88-cards.c              |    2 +-
 drivers/media/video/cx88/cx88-dvb.c                |    8 +-
 drivers/media/video/cx88/cx88-i2c.c                |    1 -
 drivers/media/video/cx88/cx88-input.c              |  282 +-
 drivers/media/video/cx88/cx88-video.c              |   12 -
 drivers/media/video/cx88/cx88-vp3054-i2c.c         |    1 -
 drivers/media/video/davinci/vpfe_capture.c         |    2 +-
 drivers/media/video/em28xx/Kconfig                 |    5 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   76 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   16 +
 drivers/media/video/em28xx/em28xx-input.c          |   78 +-
 drivers/media/video/em28xx/em28xx-vbi.c            |    1 +
 drivers/media/video/em28xx/em28xx-video.c          |   30 +-
 drivers/media/video/em28xx/em28xx.h                |    4 +-
 drivers/media/video/et61x251/et61x251_core.c       |    1 +
 drivers/media/video/fsl-viu.c                      |   26 +
 drivers/media/video/gspca/cpia1.c                  |   12 +-
 drivers/media/video/gspca/gspca.c                  |   64 +-
 drivers/media/video/gspca/gspca.h                  |    4 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |    2 +-
 drivers/media/video/gspca/ov519.c                  | 1683 +++++----
 drivers/media/video/gspca/ov534.c                  |   14 +-
 drivers/media/video/gspca/ov534_9.c                |    1 -
 drivers/media/video/gspca/pac207.c                 |    4 +-
 drivers/media/video/gspca/pac7302.c                |    2 +-
 drivers/media/video/gspca/pac7311.c                |    2 +-
 drivers/media/video/gspca/sn9c20x.c                |  141 +-
 drivers/media/video/gspca/sonixb.c                 |  236 +-
 drivers/media/video/gspca/sonixj.c                 |   20 +-
 drivers/media/video/gspca/spca561.c                |    2 +-
 drivers/media/video/gspca/sq905c.c                 |    1 +
 drivers/media/video/gspca/sq930x.c                 |   28 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   57 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |   11 +-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |   18 +-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h |    3 +
 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |    4 +
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |  291 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.h |   13 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    9 +-
 drivers/media/video/gspca/t613.c                   |    2 +-
 drivers/media/video/gspca/tv8532.c                 |    2 +-
 drivers/media/video/gspca/vc032x.c                 |   74 +-
 drivers/media/video/gspca/w996Xcf.c                |  325 +-
 drivers/media/video/gspca/xirlink_cit.c            |  194 +-
 drivers/media/video/gspca/zc3xx.c                  |  292 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |    5 +
 drivers/media/video/hdpvr/hdpvr-i2c.c              |   53 +
 drivers/media/video/hdpvr/hdpvr.h                  |    6 +
 drivers/media/video/hexium_gemini.c                |   18 +-
 drivers/media/video/hexium_orion.c                 |   18 +-
 drivers/media/video/imx074.c                       |    1 -
 drivers/media/video/ir-kbd-i2c.c                   |   76 +-
 drivers/media/video/ivtv/Kconfig                   |    3 +-
 drivers/media/video/ivtv/ivtv-cards.c              |    5 +-
 drivers/media/video/ivtv/ivtv-cards.h              |    4 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   28 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    4 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |   43 +-
 drivers/media/video/ivtv/ivtv-vbi.c                |  115 +-
 drivers/media/video/ivtv/ivtv-vbi.h                |    5 +-
 drivers/media/video/mem2mem_testdev.c              |   21 +-
 drivers/media/video/mt9m001.c                      |    1 -
 drivers/media/video/mt9m111.c                      |    1 -
 drivers/media/video/mt9t031.c                      |    1 -
 drivers/media/video/mt9v022.c                      |    1 -
 drivers/media/video/mx1_camera.c                   |    7 +-
 drivers/media/video/mx2_camera.c                   |    3 +-
 drivers/media/video/mx3_camera.c                   |    5 +-
 drivers/media/video/mxb.c                          |    8 +-
 drivers/media/video/omap/omap_vout.c               |    1 -
 drivers/media/video/omap1_camera.c                 |    4 +-
 drivers/media/video/ov2640.c                       | 1205 ++++++
 drivers/media/video/ov772x.c                       |   17 +-
 drivers/media/video/ov9640.c                       |   19 +-
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    4 +-
 drivers/media/video/pwc/pwc-ctrl.c                 |    7 +-
 drivers/media/video/pwc/pwc-if.c                   |   68 +-
 drivers/media/video/pwc/pwc-v4l.c                  |   30 +-
 drivers/media/video/pwc/pwc.h                      |    1 -
 drivers/media/video/pxa_camera.c                   |    2 +-
 drivers/media/video/rj54n1cb0c.c                   |    1 -
 drivers/media/video/s2255drv.c                     |   43 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |    2 +-
 drivers/media/video/saa6588.c                      |   14 +-
 drivers/media/video/saa7115.c                      |   11 +-
 drivers/media/video/saa7134/Kconfig                |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c        |  148 +
 drivers/media/video/saa7134/saa7134-dvb.c          |   69 +
 drivers/media/video/saa7134/saa7134-input.c        |  435 +--
 drivers/media/video/saa7134/saa7134-tvaudio.c      |   12 +-
 drivers/media/video/saa7134/saa7134-video.c        |   26 +-
 drivers/media/video/saa7134/saa7134.h              |   26 +-
 drivers/media/video/saa7164/saa7164-api.c          |  123 +-
 drivers/media/video/saa7164/saa7164-buffer.c       |   92 +-
 drivers/media/video/saa7164/saa7164-bus.c          |   16 +-
 drivers/media/video/saa7164/saa7164-cards.c        |    2 +-
 drivers/media/video/saa7164/saa7164-cmd.c          |   10 +-
 drivers/media/video/saa7164/saa7164-core.c         |   40 +-
 drivers/media/video/saa7164/saa7164-encoder.c      |   33 +-
 drivers/media/video/saa7164/saa7164-fw.c           |   12 +-
 drivers/media/video/saa7164/saa7164-i2c.c          |    4 +-
 drivers/media/video/saa7164/saa7164-vbi.c          |   37 +-
 drivers/media/video/saa7164/saa7164.h              |   17 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |    1 +
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    4 +-
 drivers/media/video/soc_camera.c                   |  133 +-
 drivers/media/video/sr030pc30.c                    |    2 +-
 drivers/media/video/stk-webcam.c                   |  148 +-
 drivers/media/video/tea6415c.c                     |    2 +-
 drivers/media/video/timblogiw.c                    |  893 +++++
 drivers/media/video/tlg2300/Kconfig                |    4 +-
 drivers/media/video/usbvideo/Kconfig               |   45 -
 drivers/media/video/usbvideo/Makefile              |    4 -
 drivers/media/video/usbvideo/ibmcam.c              | 3977 -------------------
 drivers/media/video/usbvideo/konicawc.c            |  992 -----
 drivers/media/video/usbvideo/ultracam.c            |  685 ----
 drivers/media/video/usbvision/usbvision-cards.c    | 1860 +++++-----
 drivers/media/video/usbvision/usbvision-core.c     | 1635 ++++-----
 drivers/media/video/usbvision/usbvision-i2c.c      |   55 +-
 drivers/media/video/usbvision/usbvision-video.c    |  625 ++--
 drivers/media/video/usbvision/usbvision.h          |  267 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |    7 +-
 drivers/media/video/v4l1-compat.c                  | 1277 -------
 drivers/media/video/v4l2-common.c                  |    6 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |  330 --
 drivers/media/video/v4l2-ctrls.c                   |   55 +-
 drivers/media/video/v4l2-ioctl.c                   |   86 -
 drivers/media/video/via-camera.c                   |   13 -
 drivers/media/video/videobuf-core.c                |   30 -
 drivers/media/video/videobuf-dma-sg.c              |   34 +-
 drivers/media/video/vino.c                         |    3 -
 drivers/media/video/vivi.c                         |   12 -
 drivers/media/video/zoran/zoran.h                  |  107 -
 drivers/media/video/zoran/zoran_card.c             |    2 +-
 drivers/media/video/zoran/zoran_device.c           |    2 +-
 drivers/media/video/zoran/zoran_driver.c           |  328 +--
 drivers/mfd/Kconfig                                |   10 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/timberdale.c                           |   61 +-
 drivers/mfd/timberdale.h                           |    2 +-
 drivers/mfd/wl1273-core.c                          |  148 +
 drivers/staging/Kconfig                            |    6 +-
 drivers/staging/Makefile                           |    5 +-
 drivers/staging/cpia/Kconfig                       |   39 -
 drivers/staging/cpia/Makefile                      |    5 -
 drivers/staging/cpia/TODO                          |    8 -
 drivers/staging/cpia/cpia.c                        | 4028 --------------------
 drivers/staging/cpia/cpia.h                        |  432 ---
 drivers/staging/cpia/cpia_pp.c                     |  869 -----
 drivers/staging/cpia/cpia_usb.c                    |  640 ----
 drivers/staging/cx25821/Kconfig                    |    4 +-
 drivers/staging/cx25821/cx25821-alsa.c             |   71 +-
 drivers/staging/cx25821/cx25821-audio-upstream.c   |   66 +-
 drivers/staging/cx25821/cx25821-cards.c            |    2 +
 drivers/staging/cx25821/cx25821-core.c             |  191 +-
 drivers/staging/cx25821/cx25821-i2c.c              |   19 +-
 drivers/staging/cx25821/cx25821-medusa-video.c     |    7 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   63 +-
 drivers/staging/cx25821/cx25821-video-upstream.c   |   90 +-
 drivers/staging/cx25821/cx25821-video.c            |  116 +-
 drivers/staging/cx25821/cx25821-video.h            |   15 +-
 drivers/staging/cx25821/cx25821.h                  |    9 +-
 drivers/staging/dabusb/Kconfig                     |   14 +
 drivers/staging/dabusb/Makefile                    |    2 +
 drivers/staging/dabusb/TODO                        |    5 +
 drivers/{media/video => staging/dabusb}/dabusb.c   |    0
 drivers/{media/video => staging/dabusb}/dabusb.h   |    0
 drivers/staging/dt3155v4l/dt3155v4l.c              |    3 -
 drivers/staging/go7007/Kconfig                     |    4 +-
 drivers/staging/lirc/Kconfig                       |   29 +-
 drivers/staging/lirc/Makefile                      |    1 -
 drivers/staging/lirc/TODO.lirc_i2c                 |    3 -
 drivers/staging/lirc/TODO.lirc_zilog               |   13 +
 drivers/staging/lirc/lirc_i2c.c                    |  536 ---
 drivers/staging/lirc/lirc_zilog.c                  |   48 +-
 drivers/staging/se401/Kconfig                      |   13 +
 drivers/staging/se401/Makefile                     |    1 +
 drivers/staging/se401/TODO                         |    5 +
 drivers/{media/video => staging/se401}/se401.c     |    0
 drivers/{media/video => staging/se401}/se401.h     |    2 +-
 .../linux => drivers/staging/se401}/videodev.h     |   22 -
 drivers/staging/stradis/Kconfig                    |    7 -
 drivers/staging/stradis/Makefile                   |    3 -
 drivers/staging/stradis/TODO                       |    6 -
 drivers/staging/stradis/stradis.c                  | 2222 -----------
 drivers/staging/tm6000/Kconfig                     |    2 +-
 drivers/staging/tm6000/TODO                        |    2 +
 drivers/staging/tm6000/tm6000-cards.c              |   48 +-
 drivers/staging/tm6000/tm6000-core.c               |   29 +-
 drivers/staging/tm6000/tm6000-i2c.c                |   39 +-
 drivers/staging/tm6000/tm6000-input.c              |  287 +-
 drivers/staging/tm6000/tm6000-video.c              |   17 +-
 drivers/staging/tm6000/tm6000.h                    |    3 +
 drivers/staging/usbvideo/Kconfig                   |   15 +
 drivers/staging/usbvideo/Makefile                  |    2 +
 drivers/staging/usbvideo/TODO                      |    5 +
 .../{media/video => staging}/usbvideo/usbvideo.c   |    0
 .../{media/video => staging}/usbvideo/usbvideo.h   |    2 +-
 drivers/{media/video => staging}/usbvideo/vicam.c  |    2 +-
 .../linux => drivers/staging/usbvideo}/videodev.h  |   22 -
 fs/compat_ioctl.c                                  |    2 +-
 include/linux/Kbuild                               |    1 -
 include/linux/input.h                              |    2 +
 include/linux/mfd/wl1273-core.h                    |  288 ++
 include/media/bt819.h                              |    5 +-
 include/media/cx2341x.h                            |    2 +-
 include/media/ir-common.h                          |  107 -
 include/media/ir-core.h                            |  214 --
 include/media/ir-kbd-i2c.h                         |   13 +-
 include/media/lirc_dev.h                           |    6 +-
 include/media/ovcamchip.h                          |   90 -
 include/media/rc-core.h                            |  220 ++
 include/media/rc-map.h                             |   44 +-
 include/media/{rds.h => saa6588.h}                 |   18 +-
 include/media/si4713.h                             |    3 +-
 include/media/soc_camera.h                         |    5 +
 include/media/timb_radio.h                         |    1 -
 include/media/timb_video.h                         |   33 +
 include/media/v4l2-chip-ident.h                    |    1 +
 include/media/v4l2-common.h                        |    6 +-
 include/media/v4l2-ctrls.h                         |    4 +-
 include/media/v4l2-ioctl.h                         |   22 +-
 include/media/videobuf-core.h                      |    8 -
 501 files changed, 18283 insertions(+), 29711 deletions(-)
 delete mode 100644 Documentation/video4linux/Makefile
 delete mode 100644 Documentation/video4linux/README.cpia
 delete mode 100644 Documentation/video4linux/v4lgrab.c
 delete mode 100644 drivers/input/misc/winbond-cir.c
 delete mode 100644 drivers/media/IR/ir-functions.c
 delete mode 100644 drivers/media/IR/ir-keytable.c
 delete mode 100644 drivers/media/IR/ir-sysfs.c
 delete mode 100644 drivers/media/IR/keymaps/rc-tbs-nec.c
 delete mode 100644 drivers/media/IR/keymaps/rc-tt-1500.c
 delete mode 100644 drivers/media/IR/rc-map.c
 create mode 100644 drivers/media/dvb/frontends/mb86a20s.c
 create mode 100644 drivers/media/dvb/frontends/mb86a20s.h
 create mode 100644 drivers/media/dvb/frontends/s921.c
 create mode 100644 drivers/media/dvb/frontends/s921.h
 delete mode 100644 drivers/media/dvb/frontends/s921_core.c
 delete mode 100644 drivers/media/dvb/frontends/s921_core.h
 delete mode 100644 drivers/media/dvb/frontends/s921_module.c
 delete mode 100644 drivers/media/dvb/frontends/s921_module.h
 create mode 100644 drivers/media/radio/radio-wl1273.c
 rename drivers/media/{IR => rc}/Kconfig (75%)
 rename drivers/media/{IR => rc}/Makefile (78%)
 rename drivers/media/{IR => rc}/ene_ir.c (91%)
 rename drivers/media/{IR => rc}/ene_ir.h (99%)
 rename drivers/media/{IR => rc}/imon.c (96%)
 rename drivers/media/{IR => rc}/ir-jvc-decoder.c (91%)
 rename drivers/media/{IR => rc}/ir-lirc-codec.c (71%)
 rename drivers/media/{IR => rc}/ir-nec-decoder.c (90%)
 rename drivers/media/{IR/ir-raw-event.c => rc/ir-raw.c} (61%)
 rename drivers/media/{IR => rc}/ir-rc5-decoder.c (91%)
 rename drivers/media/{IR => rc}/ir-rc5-sz-decoder.c (88%)
 rename drivers/media/{IR => rc}/ir-rc6-decoder.c (92%)
 rename drivers/media/{IR => rc}/ir-sony-decoder.c (91%)
 rename drivers/media/{IR => rc}/keymaps/Kconfig (96%)
 rename drivers/media/{IR => rc}/keymaps/Makefile (97%)
 rename drivers/media/{IR => rc}/keymaps/rc-adstech-dvb-t-pci.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-alink-dtu-m.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-anysee.c (94%)
 rename drivers/media/{IR => rc}/keymaps/rc-apac-viewcomp.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-asus-pc39.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-ati-tv-wonder-hd-600.c (86%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-a16d.c (86%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-cardbus.c (91%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-dvbt.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-m135a.c (94%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-m733a-rm-k6.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-rm-ks.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-avertv-303.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-azurewave-ad-tu700.c (93%)
 rename drivers/media/{IR => rc}/keymaps/rc-behold-columbus.c (91%)
 rename drivers/media/{IR => rc}/keymaps/rc-behold.c (68%)
 rename drivers/media/{IR => rc}/keymaps/rc-budget-ci-old.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-cinergy-1400.c (87%)
 rename drivers/media/{IR => rc}/keymaps/rc-cinergy.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-dib0700-nec.c (93%)
 rename drivers/media/{IR => rc}/keymaps/rc-dib0700-rc5.c (96%)
 rename drivers/media/{IR => rc}/keymaps/rc-digitalnow-tinytwin.c (93%)
 rename drivers/media/{IR => rc}/keymaps/rc-digittrade.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-dm1105-nec.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-dntv-live-dvb-t.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-dntv-live-dvbt-pro.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-em-terratec.c (86%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv-fm53.c (87%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv2.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-evga-indtube.c (85%)
 rename drivers/media/{IR => rc}/keymaps/rc-eztv.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-flydvb.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-flyvideo.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-fusionhdtv-mce.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-gadmei-rm008z.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-genius-tvgo-a11mce.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-gotview7135.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-hauppauge-new.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-imon-mce.c (95%)
 rename drivers/media/{IR => rc}/keymaps/rc-imon-pad.c (95%)
 rename drivers/media/{IR => rc}/keymaps/rc-iodata-bctv7e.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-kaiomy.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-kworld-315u.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-kworld-plus-tv-analog.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-leadtek-y04g0051.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-lirc.c (79%)
 rename drivers/media/{IR => rc}/keymaps/rc-lme2510.c (87%)
 rename drivers/media/{IR => rc}/keymaps/rc-manli.c (94%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-digivox-ii.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-digivox-iii.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-tvanywhere-plus.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-tvanywhere.c (86%)
 rename drivers/media/{IR => rc}/keymaps/rc-nebula.c (91%)
 rename drivers/media/{IR => rc}/keymaps/rc-nec-terratec-cinergy-xs.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-norwood.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-npgtech.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-pctv-sedna.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-color.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-grey.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-pctv-hd.c (86%)
 create mode 100644 drivers/media/rc/keymaps/rc-pixelview-002t.c
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview-mk12.c (90%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview-new.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-powercolor-real-angel.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-proteus-2309.c (87%)
 rename drivers/media/{IR => rc}/keymaps/rc-purpletv.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-pv951.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc5-hauppauge-new.c (70%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc5-tv.c (91%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc6-mce.c (94%)
 rename drivers/media/{IR => rc}/keymaps/rc-real-audio-220-32-keys.c (86%)
 rename drivers/media/{IR => rc}/keymaps/rc-streamzap.c (91%)
 create mode 100644 drivers/media/rc/keymaps/rc-tbs-nec.c
 rename drivers/media/{IR => rc}/keymaps/rc-terratec-cinergy-xs.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-terratec-slim.c (91%)
 rename drivers/media/{IR => rc}/keymaps/rc-tevii-nec.c (89%)
 rename drivers/media/{IR => rc}/keymaps/rc-total-media-in-hand.c (92%)
 rename drivers/media/{IR => rc}/keymaps/rc-trekstor.c (92%)
 create mode 100644 drivers/media/rc/keymaps/rc-tt-1500.c
 rename drivers/media/{IR => rc}/keymaps/rc-twinhan1027.c (87%)
 create mode 100644 drivers/media/rc/keymaps/rc-videomate-m1f.c
 rename drivers/media/{IR => rc}/keymaps/rc-videomate-s350.c (88%)
 rename drivers/media/{IR => rc}/keymaps/rc-videomate-tv-pvr.c (87%)
 rename drivers/media/{IR => rc}/keymaps/rc-winfast-usbii-deluxe.c (87%)
 rename drivers/media/{IR => rc}/keymaps/rc-winfast.c (92%)
 rename drivers/media/{IR => rc}/lirc_dev.c (98%)
 rename drivers/media/{IR => rc}/mceusb.c (94%)
 rename drivers/media/{IR => rc}/nuvoton-cir.c (95%)
 rename drivers/media/{IR => rc}/nuvoton-cir.h (99%)
 rename drivers/media/{IR/ir-core-priv.h => rc/rc-core-priv.h} (83%)
 create mode 100644 drivers/media/rc/rc-loopback.c
 create mode 100644 drivers/media/rc/rc-main.c
 rename drivers/media/{IR => rc}/streamzap.c (91%)
 create mode 100644 drivers/media/rc/winbond-cir.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-input.c
 create mode 100644 drivers/media/video/ov2640.c
 create mode 100644 drivers/media/video/timblogiw.c
 delete mode 100644 drivers/media/video/usbvideo/Kconfig
 delete mode 100644 drivers/media/video/usbvideo/Makefile
 delete mode 100644 drivers/media/video/usbvideo/ibmcam.c
 delete mode 100644 drivers/media/video/usbvideo/konicawc.c
 delete mode 100644 drivers/media/video/usbvideo/ultracam.c
 delete mode 100644 drivers/media/video/v4l1-compat.c
 create mode 100644 drivers/mfd/wl1273-core.c
 delete mode 100644 drivers/staging/cpia/Kconfig
 delete mode 100644 drivers/staging/cpia/Makefile
 delete mode 100644 drivers/staging/cpia/TODO
 delete mode 100644 drivers/staging/cpia/cpia.c
 delete mode 100644 drivers/staging/cpia/cpia.h
 delete mode 100644 drivers/staging/cpia/cpia_pp.c
 delete mode 100644 drivers/staging/cpia/cpia_usb.c
 create mode 100644 drivers/staging/dabusb/Kconfig
 create mode 100644 drivers/staging/dabusb/Makefile
 create mode 100644 drivers/staging/dabusb/TODO
 rename drivers/{media/video => staging/dabusb}/dabusb.c (100%)
 rename drivers/{media/video => staging/dabusb}/dabusb.h (100%)
 delete mode 100644 drivers/staging/lirc/TODO.lirc_i2c
 create mode 100644 drivers/staging/lirc/TODO.lirc_zilog
 delete mode 100644 drivers/staging/lirc/lirc_i2c.c
 create mode 100644 drivers/staging/se401/Kconfig
 create mode 100644 drivers/staging/se401/Makefile
 create mode 100644 drivers/staging/se401/TODO
 rename drivers/{media/video => staging/se401}/se401.c (100%)
 rename drivers/{media/video => staging/se401}/se401.h (99%)
 copy {include/linux => drivers/staging/se401}/videodev.h (95%)
 delete mode 100644 drivers/staging/stradis/Kconfig
 delete mode 100644 drivers/staging/stradis/Makefile
 delete mode 100644 drivers/staging/stradis/TODO
 delete mode 100644 drivers/staging/stradis/stradis.c
 create mode 100644 drivers/staging/usbvideo/Kconfig
 create mode 100644 drivers/staging/usbvideo/Makefile
 create mode 100644 drivers/staging/usbvideo/TODO
 rename drivers/{media/video => staging}/usbvideo/usbvideo.c (100%)
 rename drivers/{media/video => staging}/usbvideo/usbvideo.h (99%)
 rename drivers/{media/video => staging}/usbvideo/vicam.c (99%)
 rename {include/linux => drivers/staging/usbvideo}/videodev.h (95%)
 create mode 100644 include/linux/mfd/wl1273-core.h
 delete mode 100644 include/media/ir-common.h
 delete mode 100644 include/media/ir-core.h
 delete mode 100644 include/media/ovcamchip.h
 create mode 100644 include/media/rc-core.h
 rename include/media/{rds.h => saa6588.h} (76%)
 create mode 100644 include/media/timb_video.h

