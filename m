Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0ESWSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:18:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0ESWSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:18:43 -0400
Date: Wed, 19 May 2010 19:18:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.35] V4L/DVB updates
Message-ID: <20100519191837.6a01c559@pedra>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.35

For most of the patches that we have for 2.6.35. I still have a bunch of 
pending patches here, that arrived on the last couple weeks, but I won't want to
postpone submitting everything because I'm just human, and I can't review
patches faster or while travelling.

This series contain a new staging driver (tm6000) that is not panic'ing/oopsing anymore.
The original idea were to add it to staging at 2.6.34, to allow more people to help with,
but it were too buggy on that time, even for staging. It is still crap, as the hardware/firmware
bugs need lots of workaround, and the current driver provides video  only (it lacks stream 
filling at the alsa driver), suffering several coding style issues, but it is not worse 
than other staging drivers, and it is getting serious attention this year.

It also contains the new Remote Controller subsystem, that is ready for LIRC addition
(or a lirc-like code). The new subsystem already supports all the V4L drivers, plus
one pure Remote Controller driver (irmon).

The rest of the series are one new omap driver, some core improvements for embedded systems
and the usual driver improvements and fixes.

Cheers,
Mauro

---

The following changes since commit ba2e1c5f25a99dec3873745031ad23ce3fd79bff:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../geert/linux-m68k

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.35

Abylay Ospan (3):
      V4L/DVB: Allow to enable TS continuity and TEI check on loaded module
      V4L/DVB: get_frontend for STV0900
      V4L/DVB: configurable IRQ from CAM

Andreas Bombe (1):
      V4L/DVB: V4L2: Replace loops for finding max buffers in VIDIOC_REQBUFS callbacks

Andreas Regel (1):
      V4L/DVB: Budget/STV090x/STV6110x: Initialize the demodulator immediately after the tuner is attached

Andrew Morton (1):
      V4L/DVB: dib7000p: reduce large stack usage fix

Andy Walls (4):
      V4L/DVB: ivtv: Combine capture start delays into a single delay
      V4L/DVB: cx18: Add support for component video inputs
      V4L/DVB: cx18: Add a component video input to the PVR2100 and DVR3200H card entries
      V4L/DVB: ivtv, ivtvfb: Use a define for the output line and field register address

Antonio Larrosa (1):
      V4L/DVB: em28xx: Support for Kworld VS-DVB-T 323UR

Antonio Ospite (3):
      V4L/DVB: gspca - ov534: Remove hue control
      V4L/DVB: gspca - ov534: Fix and document setting manual exposure
      V4L/DVB: gspca - ov534: Cosmetics: fix indentation and hex digits

Antti Palosaari (2):
      V4L/DVB: af9015: support for KWorld USB DVB-T Stick Mobile (UB383-T)
      V4L/DVB: af9015: support for KWorld TV Stick II (395UR)

Arnout Vandecappelle (1):
      V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen

Bee Hock Goh (2):
      V4L/DVB: TM6000: Fix code which cause memory corruption
      V4L/DVB: tm6000: Add additional GPIO for UT821 during frmware loading

Bjørn Mork (1):
      V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"

Brian Johnson (8):
      V4L/DVB: gspca - sn9c20x: Add support for camera LEDs
      V4L/DVB: gspca - sn9c20x: Add upside down detection
      V4L/DVB: gspca - sn9c20x: Add support for cameras using the MT9M112 sensor
      V4L/DVB: gspca - sn9c20x: Fix bug with OV9655 code
      V4L/DVB: gspca - sn9c20x: Add another laptop to upsidedown device list
      V4L/DVB: gspca - sn9c20x: Add another MSI laptop to upsidedown device list
      V4L/DVB: gspca - sn9c20x: HAS_BUTTON flag -> HAS_NO_BUTTON flag
      V4L/DVB: gspca - sn9c20x: Fix non working mt9v111 sensor

Chris Pascoe (1):
      V4L/DVB (12821): tm6000: update USB request names and clean up i2c routine

Christoph Fritz (1):
      V4L/DVB: pwc Kconfig dependency fix

Christopher Pascoe (1):
      V4L/DVB (12820): tm6000: fix i2c readings

Costantino Leandro (1):
      V4L/DVB: gspca - t613: Add color controls

Dan Carpenter (22):
      V4L/DVB: ivtv: sizeof() => ARRAY_SIZE()
      V4L/DVB: cx231xx: card->driver "Conexant cx231xx Audio" too long
      V4L/DVB: em28xx: "Empia Em28xx Audio" too long
      V4L/DVB: cx23885: strcpy() => strlcpy()
      V4L/DVB: davinci: don't return under lock on error path
      V4L/DVB: video/au0828: off by one bug
      V4L/DVB: video/cx231xx: cleanup. remove unneed null checks
      V4L/DVB: video/zc0301: improve error handling
      V4L/DVB: video/et61x251: improve error handling
      V4L/DVB: video/sn9c102: improve error handling
      V4L/DVB: cx231xx: improve error handling
      V4L/DVB: cx88: improve error handling
      V4L/DVB: media/IR/imon: precendence issue: ! vs ==
      V4L/DVB: media/IR/imon: testing the wrong variable
      V4L/DVB: media/IR/imon: potential double unlock on error
      V4L/DVB: media/az6027: doing dma on the stack
      V4L/DVB: media/az6027: handle -EIO failure
      V4L/DVB: dvb/stv6110x: cleanup error handling
      V4L/DVB: media/mem2mem: dereferencing free memory
      V4L/DVB: ov511: cleanup: remove unneeded null check
      V4L/DVB: s2255drv: return if vdev not found
      V4L/DVB: s2255drv: remove dead code

David Härdeman (16):
      V4L/DVB: drivers/media/IR - improve keytable code
      V4L/DVB: ir-core: improve keyup/keydown logic
      V4L/DVB: Convert drivers/media/dvb/ttpci/budget-ci.c to use ir-core
      V4L/DVB: rename sysfs remote controller devices from rcrcv to rc
      V4L/DVB: Teach drivers/media/IR/ir-raw-event.c to use durations
      V4L/DVB: Add RC5x support to ir-core
      V4L/DVB: Add NECx support to ir-core
      V4L/DVB: Add RC6 support to ir-core
      V4L/DVB: ir-core: change duration to be coded as a u32 integer
      V4L/DVB: ir-core: Add JVC support to ir-core
      V4L/DVB: ir-core: Add Sony support to ir-core
      V4L/DVB: ir-core: remove ir-functions usage from dm1105
      V4L/DVB: ir-core: fix double spinlock init in drivers/media/IR/rc-map.c
      V4L/DVB: ir-core: fix some confusing comments
      V4L/DVB: ir-core: remove IR_TYPE_PD
      V4L/DVB: ir-core: remove ir-functions usage from cx231xx

Dean Anderson (14):
      V4L/DVB: s2255drv: adding video input status capability
      V4L/DVB: s2255drv: fixes for big endian arch
      V4L/DVB: s2255drv: cleanup of V4L2 controls
      V4L/DVB: s2255drv: Add support for 2257 device
      V4L/DVB: s2255drv: support for frame skipping
      V4L/DVB: s2255drv: cleanup of driver disconnect code
      V4L/DVB: s2255drv: code cleanup
      V4L/DVB: s2255drv: video_device_alloc call not checked fix
      V4L/DVB: s2255drv: removal of big kernel lock
      V4L/DVB: s2255drv: cleanup of debug messages
      V4L/DVB: s2255drv: adding v4l2_device structure. video_register_device cleanup
      V4L/DVB: s2255drv: fix: v4l2_dev should be registered once only.
      V4L/DVB: s2255drv: removes kref tracking and videodev parent
      V4L/DVB: s2255drv: firmware reload on timeout

Devin Heitmueller (17):
      V4L/DVB: xc3028: fix regression in firmware loading time
      V4L/DVB: au8522: fix race condition in switching from digital to analog mode
      V4L/DVB: au8522: fix case where we don't perform the first tune after going digital
      V4L/DVB: em28xx: adjust number of packets per URB
      V4L/DVB: em28xx: reduce cropping for VBI area
      V4L/DVB: em28xx: rework buffer pointer tracking for offset to start of video
      V4L/DVB: saa7115: enable anti-alias filter
      V4L/DVB: videodev2: introduce a common control for chroma gain
      V4L/DVB: saa115: add support for chroma AGC and chroma gain
      V4L/DVB: v4l2-common: add ability to use v4l2_ctrl_query_fill for chroma gain
      V4L/DVB: em28xx: add em286x/tvp5150 reference design
      V4L/DVB: ngene: properly support boards where channel 0 isn't a TS input
      V4L/DVB: ngene: add initial support for digital side of Avermedia m780
      V4L/DVB: ngene: split out i2c code into a separate file
      V4L/DVB: ngene: split out card specific code into a separate file
      V4L/DVB: ngene: start separating out DVB functions into separate file
      V4L/DVB: ngene: Add lgdt3303 and mt2131 deps to Kconfig

Dmitri Belimov (10):
      V4L/DVB (13403): Add new TV cards of Beholder
      V4L/DVB: tm6000: fix some info messages
      V4L/DVB: tm6000 register defines
      V4L/DVB: fix broken I2C IR for Beholder
      V4L/DVB: Add SPI support to V4L2
      V4L/DVB: Add CHIP ID of the uPD61151
      V4L/DVB: Fix default state Beholder H6 tuner
      V4L/DVB: tm6000: fix i2c read
      V4L/DVB: Rework for support xc5000
      V4L/DVB: saa7134: Add support new Behold TV cards

Erik Andrén (1):
      V4L/DVB: gspca - pac207: Let all pac207 ctrls have a coherent naming

Frank Schaefer (1):
      V4L/DVB: v4l2_ctrl_get_name(): add missing control names, 	and make title for V4L2_CID_BG_COLOR consistent

German Galkin (1):
      V4L/DVB: gspca - sn9c20x: Fix exposure control for HV7131R sensor

Guennadi Liakhovetski (6):
      V4L/DVB: sh_mobile_ceu_camera.c: preserve output window on VIDIOC_S_CROP
      V4L/DVB: soc-camera: update comment
      V4L/DVB: sh_mobile_ceu_camera.c: update documentation to reflect the new cropping
      V4L/DVB: videobuf-dma-contig.c: simplify pointer dereference
      V4L/DVB: V4L: SuperH Video Output Unit (VOU) driver
      V4L/DVB: V4L: v4l2-subdev driver for AK8813 and AK8814 TV-encoders from AKM

HIRANO Takahito (1):
      V4L/DVB: pt1: Support Earthsoft PT2

Hans Verkuil (62):
      V4L/DVB: videobuf-core: fix spelling mistake in debug message
      V4L/DVB: v4l doc: fix font of field name
      V4L/DVB: v4l2: sort chip IDs in v4l2-chip-ident.h
      V4L/DVB: c-qcam: coding style cleanup
      V4L/DVB: bw-qcam: coding style cleanup
      V4L/DVB: arv: coding style cleanup
      V4L/DVB: w9966: coding style cleanup
      V4L/DVB: v4l: add V4L2_PIX_FMT_Y4 and V4L2_PIX_FMT_Y6 pixelformats
      V4L/DVB: pms: remove unnecessary exclusive open/close
      V4L/DVB: w9966: reorganize the order of functions
      V4L/DVB: w9966: remove camelCase
      V4L/DVB: meye: remove last V4L1 remnants from the code and add v4l2_device
      V4L/DVB: zoran: remove V4L1 videodev.h include
      V4L/DVB: arv: convert to V4L2
      V4L/DVB: V4L2 Spec: fix V4L2_CTRL_TYPE_CTRL_CLASS documentation
      V4L/DVB: videodev2.h: move definition of enum v4l2_ctrl_type to the other control types
      V4L/DVB: video_ioctl2: do not replace arg with NULL for _IO() ioctls
      V4L/DVB: video_ioctl2: don't return, use break
      V4L/DVB: usbvision: remove non-working vbi device
      V4L/DVB: DocBook/v4l/compat.xml: add missing </section>
      V4L/DVB: w9966: convert to V4L2
      V4L/DVB: v4l2-framework.txt: fix incorrect statement
      V4L/DVB: video_ioctl2: handle the v4l1 compat bit first and move VIDIOCGMBUF into the switch
      V4L/DVB: ivtv: move the _IO() decoder ioctls into vidioc_default
      V4L/DVB: v4l videobuf: remove unused mmap callback
      V4L/DVB: v4l videobuf: remove mmap_free callback
      V4L/DVB: v4l videobuf: remove unused is_mmapped field
      V4L/DVB: v4l videobuf: use struct videobuf_buffer * instead of void * for videobuf_alloc
      V4L/DVB: v4l videobuf: rename .vmalloc to .vaddr
      V4L/DVB: v4l videobuf: rename videobuf_queue_to_vmalloc to videobuf_queue_to_vaddr
      V4L/DVB: v4l videobuf: move video_copy_to_user and copy_stream to core
      V4L/DVB: v4l videobuf: add videobuf_buffer *buf as argument to mmap_mapper
      V4L/DVB: vivi: clean up and a major overhaul
      V4L/DVB: v4l: add VSYNC and EOS events for use with ivtv
      V4L/DVB: ivtv: support the new events API
      V4L/DVB: v4l spec: document what odd and even fields are
      V4L/DVB: v4l spec: document new events
      V4L/DVB: videobuf: Add support for V4L2_BUF_FLAG_ERROR
      V4L/DVB: v4l: move vbi-specific video ops to a new vbi ops struct
      V4L/DVB: v4l: add new subdev vbi ops to handle raw and sliced vbi
      V4L/DVB: saa7115: support new vbi ops to set/get VBI format
      V4L/DVB: cx25840: support new vbi ops to set/get VBI format
      V4L/DVB: cx18: support new vbi ops to set/get VBI format
      V4L/DVB: saa7127: support new vbi ops to set/get VBI format
      V4L/DVB: tvp5150: support new vbi ops to set/get VBI format
      V4L/DVB: ivtv: switch to new vbi subdev ops
      V4L/DVB: cx18: switch to new vbi subdev ops
      V4L/DVB: pvrusb2: switch to new vbi subdev ops
      V4L/DVB: cx231xx: switch to new vbi subdev ops
      V4L/DVB: em28xx: switch to new vbi subdev ops
      V4L/DVB: cx18/cx25840/saa7115/tvp5150: remove vbi support from s_fmt
      V4L/DVB: Documentation: fix small error in the ENUMINPUT doc
      V4L/DVB: bttv: remove bogus prio check in g_frequency
      V4L/DVB: v4l2-common: simplify prio utility functions
      V4L/DVB: tvp7002: fix query_dv_preset
      V4L/DVB: em28xx: g_tuner must set type field
      V4L/DVB: v4l2-dev: remove unnecessary lock around atomic clear_bit
      V4L/DVB: radio-am800: let v4l2_device_(un)register handle usb_get/set_intfdata
      V4L/DVB: hdpvr: fix disconnect sequence
      V4L/DVB: usbvision: don't use usb_set_intfdata, let v4l2_device_register handle this
      V4L/DVB: usbvision: add delay before detecting the saa711x
      V4L/DVB: ivtv: fix VIDIOC_S_PRIORITY handling

Hans de Goede (3):
      V4L/DVB: gspca_spca561: Fix LED on rev12a cameras
      V4L/DVB: gspca_spca561: Add support for camera button
      V4L/DVB: sn9c102: Make hv7131d sensor code also recognize the HV7131E

Henrik Kurelid (1):
      V4L/DVB: firedtv: correct version number and current/next in CA_PMT

Herton Ronaldo Krzesinski (1):
      Revert "V4L/DVB (11906): saa7134: Use v4l bounding/alignment function"

Huang Weiyi (2):
      V4L/DVB: tlg2300: remove unused #include <linux/version.h>
      V4L/DVB: DVB: ngene, remove unused #include <linux/version.h>

Ian Armstrong (3):
      V4L/DVB: ivtv: Really stop capture on device close
      V4L/DVB: cx2341x: Remove temporal filter control restriction
      V4L/DVB: ivtv: Avoid hard system lock on decoder output mode change

Istvan Varga (1):
      V4L/DVB: cx88: fix setting input when using DVB

Jarod Wilson (7):
      V4L/DVB: ir-core: make ir_g_keycode_from_table a public function
      V4L/DVB: ir-core: add imon pad and mce keymaps
      V4L/DVB: ir-core: add imon driver
      V4L/DVB: IR/imon: convert to ir-core protocol change handling
      V4L/DVB: IR/imon: minor change_protocol fixups
      V4L/DVB: IR/imon: add proper auto-repeat support
      V4L/DVB: IR/imon: remove dead IMON_KEY_RELEASE_OFFSET

Jean Delvare (1):
      V4L/DVB: saa7134: Fix IR support of some ASUS TV-FM 7135 variants

Jean-François Moine (22):
      V4L/DVB: gspca - t613: Check the result of kmalloc
      V4L/DVB: gspca - cpia1 / sn9c2028: Make control descriptors constant
      V4L/DVB: gspca - sonixj: More static const and better array initialization
      V4L/DVB: gspca - sonixj: Add webcam 0c45:6142 with sensors gc0307 and po2030n
      V4L/DVB: sn9c102 / zc0301: Handle webcams when no gspca subdriver conflict
      V4L/DVB: gspca: Change some copyrights and module authors
      V4L/DVB: gspca - sonixj: Let the JPEG header in the device
      V4L/DVB: gspca - sonixj: Add autogain for sensor gc0307
      V4L/DVB: gspca - vc032x: Change the ov7670 format to YUYV
      V4L/DVB: gspca - main: Check the file doing stream on/off
      V4L/DVB: gspca - main: Restart streaming after reqbuf
      V4L/DVB: gspca - main: Stop the webcam when bandwidth too small
      V4L/DVB: gspca - sonixj: Split the init sequence of sensor ov7630
      V4L/DVB: gspca - sonixj: Adjust debug output.  - fix bad function name  - add debug info for i2c buffer write
      V4L/DVB: gspca - sonixj: Set the colors at startup time
      V4L/DVB: gspca - sonixj: Adjust minor values of sensor ov7630.  - set the color gains to null at init time  - change value of register 0x9a
      V4L/DVB: gspca - sonixj: Reset the bridge after sensor probe
      V4L/DVB: gspca - sonixj: Add sensor soi768
      V4L/DVB: gspca - zc3xx: Fix the light frequency values for pas202b and pb0330
      V4L/DVB: gspca - zc3xx.c: Remove the brightness control
      V4L/DVB: gspca - zc3xx: Fix the gamma calculation from the contrast
      V4L/DVB: gspca - main: Convert wMaxPacketSize from little endian 16 to cpu

Jiri Slaby (1):
      V4L/DVB: dvb-usb: gp8psk, fix potential null derefernce

Joe Perches (2):
      V4L/DVB: ov511: Fix continuation lines
      V4L/DVB: pvrusb2-v4l2: Rename dev_info to pdi

Jonathan Corbet (8):
      V4L/DVB: ov7670: Use CCIR601 in all video modes
      V4L/DVB: ov7670: Avoid reading clkrc
      V4L/DVB: ov7670: Don't use SMBUS I/O
      V4L/DVB: ov7670: Wire up V4L2_CID_GAIN and V4L2_CID_AUTOGAIN
      V4L/DVB: ov7670: wire up controls for exposure and autoexposure
      V4L/DVB: ov7670: Restore SMBUS I/O for the XO 1.0
      V4L/DVB: ov7670: Always rewrite clkrc when setting format
      V4L/DVB: ov7670: silence some compiler warnings

Julia Lawall (4):
      V4L/DVB: drivers/staging/tm6000/tm6000-video.c: correct NULL test
      V4L/DVB: drivers/media: drop redundant memset
      V4L/DVB: drivers/media/video: move dereference after NULL test
      V4L/DVB: drivers/media/video: avoid NULL dereference

Kirill Smelkov (1):
      V4L/DVB: bttv: Add another ids for IVC-200

Klaus Schmidinger (1):
      V4L/DVB: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices

Laurent Pinchart (11):
      V4L/DVB (13556a): v4l: Remove unneeded video_device::minor assignments
      V4L/DVB: uvcvideo: Add support for unbranded Arkmicro 18ec:3290 webcams
      V4L/DVB: uvcvideo: Add support for Packard Bell EasyNote MX52 integrated webcam
      V4L/DVB: v4l: Add V4L2_CID_IRIS_ABSOLUTE and V4L2_CID_IRIS_RELATIVE controls
      V4L/DVB: uvcvideo: Support iris absolute and relative controls
      V4L/DVB: uvcvideo: Use POLLOUT and POLLWRNORM for output devices
      V4L/DVB: event: Export the v4l2_event_init and v4l2_event_dequeue functions
      V4L/DVB: uvcvideo: Add support for V4L2_PIX_FMT_Y16
      V4L/DVB: uvcvideo: Flag relative controls as write-only
      V4L/DVB: uvcvideo: Prevent division by 0 when control step value is 0
      V4L/DVB: MAINTAINERS: Update uvcvideo web site address

Manu Abraham (4):
      V4L/DVB: [STV090x] Code simplification
      V4L/DVB: [STV090x, STV6110x] Use tuner sleep within the demodulator control
      V4L/DVB: [STV090x] Use gate control, while tuner is being accessed
      V4L/DVB: stv090x: Add some notes about the internal tuner I/O control

Marton Balint (1):
      V4L/DVB: cx88: increase BUFFER_TIMEOUT to 2 seconds

Mats Randgaard (3):
      V4L/DVB: v4l2-subdev.h: Add support for enum_dv_preset
      V4L/DVB: tvp7002.c: Add support for enum_dv_presets
      V4L/DVB: tvp7002.c: fix some copy-paste errors in the comments

Matthieu CASTET (1):
      V4L/DVB: fix dvb frontend lockup

Mauro Carvalho Chehab (153):
      V4L/DVB (12770): Add tm6000 driver to staging tree
      V4L/DVB (12776): tm6000: decrement users count
      V4L/DVB (12781): tm6000: Start adding support for GPIO device-specific parameters
      V4L/DVB (12784): tm6000: Some cleanups at the driver
      V4L/DVB (12789): tm6000: fix DVB dependency
      V4L/DVB (12790): tm6000: check for errors on usb->status
      V4L/DVB (12791): tm6000: fix poll() method
      V4L/DVB (12793): tm6000: On some kernels, eeprom reading were generating a bug
      V4L/DVB (12794): tm6000: handle also PAL/SECAM resolutions
      V4L/DVB (12795): tm6000: Fix buffering size
      V4L/DVB (12796): tm6000: Add a hack for PAL standards
      V4L/DVB (12797): tm6000: Allow selecting audio bitrate
      V4L/DVB (12798): tm6000: Split header processing from header find
      V4L/DVB (12799): tm6000: avoid troubles if a header is broken on separate URBs
      V4L/DVB (12800): tm6000: fix tm6000 analog video buffer handling
      V4L/DVB (12802): tm6000: adds command to enable audio output at tm6000
      V4L/DVB (12803): tm6000: make tm6000_devused static
      V4L/DVB (12805): tm6000: Fix a memory leak at tm6000-video
      V4L/DVB (12806): tm6000: Select VIDEO_TUNER for tm6000 devices
      V4L/DVB (12807): tm6000: Properly select xc2028 parameters
      V4L/DVB (12808): tm6000: Move analog tv standards to tm6000-stds
      V4L/DVB (12809): tm6000: Remove an old hack
      V4L/DVB (12810): tm6000: Avoid sending xc3028 setups for other tuners
      V4L/DVB (12811): tm6000: a few registers is needed from the sif/noif setings
      V4L/DVB (12813): tm6000: all read messages should use prev_reg
      V4L/DVB (12814): tm6000: fix eeprom reading on tm6000
      V4L/DVB (12815): tm6000: follow videobuf API changes
      V4L/DVB (12819): tm6000: mts parameter has changed on tuner-xc2028.c
      V4L/DVB (12822): tm6000: Add support for tm6010
      V4L/DVB (12823): tm6000: Uses another method for handling incomplete packets
      V4L/DVB (12824): tuner-xc2028: adds an option to send i2c data on slower speed
      V4L/DVB (12825): tm6000: I2C reading operations is not reliable on tm6000
      V4L/DVB (12826): tm6000: adds 10ms delay between two consecutive i2c write ops
      V4L/DVB (12827): tm6000: fix image hangs
      V4L/DVB (12828): tm6000: fixes several CodingStyle and do some cleanups
      V4L/DVB (12829): tm6000: several changes on usb preparation trying to avoid -EPROTO errors
      V4L/DVB (12830): tm6000: copy cx88-alsa as tm6000-alsa
      V4L/DVB (12831): tm6000: Convert cx88-alsa into tm6000-alsa
      V4L/DVB (12832): tm6000: allow compilation of tm6000-alsa module
      V4L/DVB (12833): tm6000: add a proper init code for -alsa
      V4L/DVB (12834): tm6000: Fix two warnings
      V4L/DVB (12835): tm6000: Cleanups to work like em28xx-video
      V4L/DVB (12836): tm6000: revert to an old way to copy video
      V4L/DVB (12838): tm6000: Fix color support on tm6010
      V4L/DVB (12839): tm6000: Another trial to fix analog streaming
      V4L/DVB (12840): tm6000: add support for HVR900H
      V4L/DVB (12841): tm6000: Fix compilation with newer v4l2-dev API
      V4L/DVB (12842): tm6000: avoid kernel panic while retrieving the filling buffer
      V4L/DVB (12843): tm6000: cleanup: remove a test debug code
      V4L/DVB (12844): tm6000: avoid writing on a floating pointer
      V4L/DVB (12845): tm6000: more buffer handling fixes
      V4L/DVB (12846): tuner-xc2028: Fix skip code for devices with broken read (tm6000)
      V4L/DVB (12848): tm6000: Add README with todo list
      V4L/DVB (12852): tm6000: Fix compilation against 2.6.31
      V4L/DVB (12853): tm6000: Fix almost all warnings at the driver
      V4L/DVB (12854): tm6000: i2c addresses should now be specified in 7bit formats
      tm6000: Remove legacy code to work with older kernel versions
      V4L/DVB (13555a): v4l: Use video_device_node_name() instead of the minor number
      V4L-DVB: tm6000: add missing BEHOLDER board definitions
      V4L/DVB: tm6000: add Terratec Cinergy Hybrid XE
      V4L/DVB: tm6000: Allow tm6000 driver compilation
      V4L/DVB: tm6000: move board-specific init to tm6000-cards
      V4L/DVB: tm6000: only register after initialized
      V4L/DVB: tm6000: fix mutex lock unbalance
      V4L/DVB: soc-camera: add runtime pm support for subdevices
      V4L/DVB: Fix bad whitespacing
      V4L/DVB: ir: use a real device instead of a virtual class
      V4L/DVB: ir-core: Add a macro to properly create IR tables
      V4L/DVB: ir-core: Export IR name via uevent
      V4L/DVB: ir-core: export driver name used by IR via uevent
      V4L/DVB: tm6000: Replace all Req 7 group of regs with another naming convention
      V4L/DVB: tm6000: Replace all Req 8 group of regs with another naming convention
      V4L/DVB: tm6000: Add request at Req07/Req08 register definitions
      V4L/DVB: tm6000: Replace all magic values by a register alias
      V4L/DVB: tm6000: Replace naming convention for registers of req 05 group
      V4L/DVB: tm6000: add request to registers of the group 05
      V4L/DVB: tm6000: replace occurences of req05 magic by a naming alias
      V4L/DVB: gspca - sn9c20x: use gspca's input device handling
      V4L/DVB: Fix cx88 and em28xx cardlists
      V4L/DVB: saa7134: Use the same name on CARDLIST as found at the driver
      V4L/DVB: stv0900: Whitespace cleanup
      V4L/DVB: gspca: fixes compilation when input is not selected
      V4L/DVB: cx25821-audio-upstream.c: Fixed some checkpatch.pl warnings/errors
      V4L/DVB: cx25821-video.c: fix table indent
      V4L/DVB: cx25821: prepend cx25821_ to video exported symbols
      V4L/DVB: ir-core: be less pedantic with RC protocol name
      V4L/DVB: saa7134: use a full scancode table for M135A
      V4L/DVB: saa7134: add code to allow changing IR protocol
      V4L/DVB: ir-core: Add logic to decode IR protocols at the IR core
      V4L/DVB: ir-core: add two functions to report keyup/keydown events
      V4L/DVB: ir-core/saa7134: Move ir keyup/keydown code to the ir-core
      V4L/DVB: saa7134: don't wait too much to generate an IR event on raw_decode
      V4L/DVB: ir-core: dynamically load the compiled IR protocols
      V4L/DVB: ir-core: prepare to add more operations for ir decoders
      V4L/DVB: ir-nec-decoder: Add sysfs node to enable/disable per irrcv
      V4L/DVB: saa7134: clear warning noise
      V4L/DVB: ir-core: rename sysfs remote controller class from ir to rc
      V4L/DVB: ir-core: Add callbacks for input/evdev open/close on IR core
      V4L/DVB: cx88: Only start IR if the input device is opened
      V4L/DVB: ir-common: Use a function to declare an IR table
      V4L/DVB: ir-common: re-order keytables by name and remove duplicates
      V4L/DVB: ir: use IR_KEYTABLE where an IR table is needed
      V4L/DVB: rename all *_rc_keys to ir_codes_*_nec_table
      V4L/DVB: ir-common: Use macros to define the keytables
      V4L/DVB: ir-common: move IR tables from ir-keymaps.c to a separate file
      V4L/DVB: ir-core: Add support for RC map code register
      V4L/DVB: Break Remote Controller keymaps into modules
      V4L/DVB: ir: prepare IR code for a parameter change at register function
      V4L/DVB: ir-core: Make use of the new IR keymap modules
      V4L/DVB: ir-common: remove keymap tables from the module
      V4L/DVB: saa7134: Fix IRQ2 bit names for the register map
      V4L/DVB: saa7134: Add support for both positive and negative edge IRQ
      V4L/DVB: ir-core: re-add some debug functions for keytable changes
      V4L/DVB: ir-nec-decoder: Reimplement the entire decoder
      V4L/DVB: ir-nec-decoder: Cleanups
      V4L-DVB: ir-rc5-decoder: Add a decoder for RC-5 IR protocol
      V4L/DVB: cx88: don't handle IR on Pixelview too fast
      V4L-DVB: ir-core: remove the ancillary buffer
      V4L/DVB: ir-core: move rc map code to rc-map.h
      V4L/DVB: ir-core: Add support for badly-implemented hardware decoders
      V4L/DVB: re-add enable/disable check to the IR decoders
      V4L/DVB: ir-rc5-decoder: fix state machine
      V4L/DVB: em28xx: fix a regression caused by the rc-map changes
      V4L/DVB: ir: Make sure that the spinlocks are properly initialized
      V4L/DVB: ir-core: Distinguish sysfs attributes for in-hardware and raw decoders
      V4L/DVB: ir-core: properly present the supported and current protocols
      V4L/DVB: ir-core: fix gcc warning noise
      V4L/DVB: ir-core: move subsystem internal calls to ir-core-priv.h
      V4L/DVB: ir-core: Remove warining noise if decoders compiled builtin
      V4L/DVB: cpia1: comment unused command_setlights()
      V4L/DVB: tm6000: fix compilation due to the lack of a semicolon
      V4L/DVB: ir-core-priv: fix a typo for RC6 config option
      V4L/DVB: ir Kconfig: better describe the options
      ir-core: Remove the quotation mark from the uevent names
      ir-core: Fix the delete logic
      V4L/DVB: ir-core-priv.h: Fix a few CodingStyle errors
      V4L/DVB: irmon: Cleanup some warning noise
      V4L/DVB: ir-core: fix table resize during keymap init
      Revert "V4L/DVB: Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable DVB devices"
      V4L/DVB: Add firmware v2.4 to xc2028/xc3028 extracting tool
      V4L/DVB: videobuf-dma-sg: Avoid using a wrong size
      V4L/DVB: tm6000: Properly set alternate when preparing to stream
      V4L/DVB: tm6000: Fix a panic if buffer become NULL
      V4L/DVB: tm6000: Don't copy outside the buffer
      V4L/DVB: Fix color format with tm6010
      V4L/DVB: tm6000: update the todo list
      Fix compilation breakage with tm6000
      V4L/DVB: em28xx: fix locks during dvb init sequence
      V4L/DVB: videobuf-dma-sg: remove external function videobuf_dma_sync()
      V4L/DVB: videobuf-vmalloc: remove __videobuf_sync()
      V4L-DVB: ngene: make sure that tuner headers are included
      V4L/DVB: Fix unlock logic at medusa_video_init
      V4L/DVB (13554a): v4l: Use the video_drvdata function in drivers

Max Thrun (7):
      V4L/DVB: gspca- ov534: Remove ambiguous controls
      V4L/DVB: gspca - ov534: Fix autogain control, enable it by default
      V4L/DVB: gspca - ov534: Add Auto Exposure
      V4L/DVB: gspca - ov534: Fix Auto White Balance control
      V4L/DVB: gspca - ov534: Fixes for sharpness control
      V4L/DVB: gspca - ov534: Fix unsetting hflip and vflip bits
      V4L/DVB: gspca - ov534: Update copyright info

Maykel Moya (1):
      V4L/DVB (12837): tm6000: make tree buildable

Michael Krufky (1):
      V4L/DVB: dvb-usb: enable specifying a separate generic bulk ctrl response endpoint

Michael Müller (1):
      V4L/DVB: Add Elgato EyeTV Diversity to dibcom driver

Michel Ludwig (19):
      V4L/DVB (12772): tm6000: fix module load/unload
      V4L/DVB (12773): tm6000: fix module unregister
      V4L/DVB (12774): tm6000: fix module load/unload
      V4L/DVB (12775): tm6000: fix usb_submit_urb to be called inside interrupt context
      V4L/DVB (12777): tm6000: Add support for Freecom Hybrid Stick / Moka DVB-T Receiver Dual
      V4L/DVB (12778): tm6000: Fix SMBus Read Byte command
      V4L/DVB (12779): tm6000: Correct dev init & Add general USB ctrl msg pause
      V4L/DVB (12780): tm6000: Improve handling of SMBus Write Byte commands followed by a read command.
      V4L/DVB (12782): tm6000: Correct some device capabilities
      V4L/DVB (12783): tm6000: add xc2028/3028 to dvb
      V4L/DVB (12785): tm6000: allow user gpio address for tuner reset
      V4L/DVB (12786): tm6000: Remove code dealing with the ZL10353
      V4L/DVB (12788): tm6000: Add initial DVB-T support
      V4L/DVB (12801): tm6000: Add support for ADSTech Mini Dual TV (PTV-339).
      V4L/DVB (12804): tm6000: Build the module properly if CONFIG_VIDEO_TM6000_DVB is selected.
      V4L/DVB (12812): tm6000: fix build dependencies for tm6000 and tuner-xc2028
      V4L/DVB (12816): tm6000: fix tm6000 attach method and fix a few CodingStyles
      V4L/DVB (12817): tm6000: add a missing symbol_put
      V4L/DVB (12818): tm6000: Use dvb_frontend_detach instead of single symbol_put commands

Mosalam Ebrahimi (1):
      V4L/DVB: gspca - ov534: Add Powerline Frequency control

Márton Németh (6):
      V4L/DVB: The first two parameters of soc_camera_limit_side() are usually pointers  to struct v4l2_rect elements. They are signed, so adjust the prototype  accordingly
      V4L/DVB: tlg2300: cleanups when power management is not configured
      V4L/DVB: nGene: use NULL when pointer is needed
      V4L/DVB: tlg2300: make local variables and functions static
      V4L/DVB: az6027: remove redundant condition check
      V4L/DVB: gspca cpia1: make local functions static

Nicolas Noirbent (1):
      V4L/DVB: ds3000: fix divide-by-zero error in ds3000_read_snr()

Oleg Roitburd (2):
      V4L/DVB: AZ6027: Add support for Technisat V1 device
      V4L/DVB: AZ6027: Fix initialization for some cards

Olimpiu Pascariu (6):
      V4L/DVB: Staging: cx25821: fix coding style issues in cx25821-alsa.c
      V4L/DVB: cx25821: fix coding style issues in cx25821-core.c
      V4L/DVB: cx25821: fix coding style issues in cx25821-gpio.c
      V4L/DVB: cx25821: fix coding style issues in cx25821-medusa-video.c
      V4L/DVB: cx25821: fix coding style issues in cx25821-i2c.c
      V4L/DVB: cx25821: fix coding style issues in cx25821-video-upstream.c

Oliver Endriss (1):
      V4L/DVB: ngene: Add support for cineS2 v5 and SaTiX-S2 Dual v2

Paulo Assis (1):
      V4L/DVB: gspca - main: Use ktime instead of jiffies for buffer timestamping

Pawel Osciak (7):
      V4L/DVB: v4l: videobuf: code cleanup
      V4L/DVB: add memory-to-memory device helper framework for videobuf
      V4L/DVB: [v5,2/2] v4l: Add a mem-to-mem videobuf framework test device
      V4L/DVB: v4l: videobuf: qbuf now uses relevant v4l2_buffer fields for OUTPUT 	types
      V4L/DVB: Add a new ERROR flag for DQBUF after recoverable streaming errors
      V4L/DVB: Add documentation for the new error flag
      V4L/DVB: videobuf: make poll() report proper flags for output video devices

Peter Huewe (1):
      V4L/DVB: media/IR: Add missing include file to rc-map.c

Pierre Gronlier (1):
      V4L/DVB: Read MAC for TeVii S470 PCI-e DVB-S2 card

Randy Dunlap (6):
      V4L/DVB: tm6000: fix build errors
      V4L/DVB: [-next] gspca: fix build for INPUT=m or INPUT=n
      V4L/DVB: dib7000p: reduce large stack usage
      V4L/DVB: dib3000mc: reduce large stack usage
      V4L/DVB: [-next] media: fix vivi build error
      V4L/DVB: vivi and mem2mem_testdev need slab.h to build

Ricardo Maraschini (2):
      V4L/DVB: cx88-dvb: fix on switch identation
      V4L/DVB: cx25821-video-upstream.c: Added severity to printk calls

Roel Van Nyen (1):
      V4L/DVB: tm6000: fix coding style issues of tm6000-cards.c

Sakari Ailus (7):
      V4L/DVB: V4L: File handles
      V4L/DVB: V4L: File handles: Add documentation
      V4L/DVB: V4L: Events: Add new ioctls for events
      V4L/DVB: V4L: Events: Add backend
      V4L/DVB: V4L: Events: Support event handling in do_ioctl
      V4L/DVB: V4L: Events: Add documentation
      V4L/DVB: V4L: Events: Replace bad WARN_ON() with assert_spin_locked()

Stefan Ringel (30):
      V4L/DVB: tm6000: fix driver compilation
      V4L/DVB: tm6000: add digital init for tm6010
      V4L/DVB: tm6000: fix: avoid unregister the driver after success
      V4L/DVB: tm6000: typo fix: the identifer string is wrong
      V4L/DVB: tm6000: add special usb request to quit i2c tuner transfer
      V4L/DVB: tm6000: add tuner callback for dvb frontend
      V4L/DVB: tm6000: add tuner parameter for DVB devices
      V4L/DVB: tm6000: remove unused function
      V4L/DVB: tm6000: Fix several bugs at the usb DVB transfer
      V4L/DVB: tm6000: add a different set param values
      V4L/DVB: tm6000: add additional init register for tm6010
      V4L/DVB: tm6000: add different tuner reset for terratec
      V4L/DVB: tm6000: add card setup for terratec cinergy hybrid
      V4L/DVB: tm6000: reset the numbers of feeds to 8
      V4L/DVB: tm6000: special request for all tuner
      V4L/DVB: tm6000: change version to 0.0.2
      V4L/DVB: tm6000: remove hack.c hack.h, switch to zl10353 module
      V4L/DVB: tm6000: fix i2c addr test
      V4L/DVB: tm6000: add send and recv function
      V4L/DVB: tm6000: bugfix reading problems with demodulator zl10353
      V4L/DVB: tm6000: add new hybrid-stick
      V4L/DVB: tm6000: switch to gpio strcut
      V4L/DVB: tm6000: add gpios to board struct
      V4L/DVB: tm6000: add gpios for tm6010 generic board
      V4L/DVB: tm6000: tm6000_i2c_xfer: request labeling
      V4L/DVB: tm6000: request labeling board version check
      V4L/DVB: tm6000: bugfix analog init for tm6010
      V4L/DVB: tm6000: renaming firmware
      V4L/DVB: tm6000: README - add vbi
      V4L/DVB: tm6000: bugfix image position

Vaibhav Hiremath (9):
      V4L/DVB: V4L: dm644x_ccdc: Debug register read prints removed
      V4L/DVB: V4L: vpfe_capture: Add call back function for interrupt clear for vpfe_cfg
      V4L/DVB: V4L: dm644x_ccdc: Add 10bit BT support
      V4L/DVB: V4L: vpfe_capture: Return 0 from suspend/resume
      V4L/DVB: V4L: dm644x_ccdc: Add Suspend/Resume Support
      V4L/DVB: V4L: vpfe_capture: Add support for USERPTR mode of operation
      V4L/DVB: V4L: tvp514x: Add Powerup sequence during s_input to lock the signal properly
      V4L/DVB: V4L2: Add support for OMAP2/3 V4L2 display driver on top of DSS2
      V4L/DVB: omap_vout:V4L2 Display: Changed enum return type to int

Valentin Longchamp (1):
      V4L/DVB: mt9t031: use runtime pm support to restore ADDRESS_MODE registers

Vladimir Ermakov (2):
      V4L/DVB: saa7134: add capture boards Hawell HW-404M7 and HW-808M7
      V4L/DVB: saa7134: fix GPIO HW-404M7

Wolfram Sang (1):
      V4L/DVB: dvb/dib8000: fix build warning

Xiaolin Zhang (1):
      V4L/DVB: core: add support for more color effects

istvan_v@mailbox.hu (1):
      V4L/DVB: cx88: fix checks for analog TV inputs

sai (2):
      V4L/DVB: staging:cx2581: fixes coding style issues in cx25821-cards.c
      V4L/DVB: staging:cx25821:fixes coding styles in cx25821-i2c.c

sai gopal (1):
      V4L/DVB: cx25821: fix coding style issues in cx25821-alsa.c

 Documentation/DocBook/media-entities.tmpl          |   11 +
 Documentation/DocBook/v4l/compat.xml               |  126 +-
 Documentation/DocBook/v4l/controls.xml             |   36 +-
 Documentation/DocBook/v4l/dev-event.xml            |   31 +
 Documentation/DocBook/v4l/io.xml                   |   18 +-
 Documentation/DocBook/v4l/pixfmt.xml               |   12 +
 Documentation/DocBook/v4l/v4l2.xml                 |    3 +
 Documentation/DocBook/v4l/videodev2.h.xml          |   10 +
 Documentation/DocBook/v4l/vidioc-dqevent.xml       |  131 +
 Documentation/DocBook/v4l/vidioc-enuminput.xml     |    2 +-
 Documentation/DocBook/v4l/vidioc-qbuf.xml          |   14 +-
 Documentation/DocBook/v4l/vidioc-queryctrl.xml     |    2 +-
 Documentation/DocBook/v4l/vidioc-reqbufs.xml       |    2 +-
 .../DocBook/v4l/vidioc-subscribe-event.xml         |  133 +
 Documentation/video4linux/CARDLIST.bttv            |    2 +-
 Documentation/video4linux/CARDLIST.cx88            |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    4 +-
 Documentation/video4linux/CARDLIST.saa7134         |    3 +
 Documentation/video4linux/extract_xc3028.pl        |  817 +++++-
 Documentation/video4linux/gspca.txt                |    5 +
 Documentation/video4linux/sh_mobile_ceu_camera.txt |   80 +-
 Documentation/video4linux/v4l2-framework.txt       |  143 +-
 MAINTAINERS                                        |    2 +-
 drivers/media/IR/Kconfig                           |   59 +
 drivers/media/IR/Makefile                          |   14 +-
 drivers/media/IR/imon.c                            | 2396 ++++++++++++++
 drivers/media/IR/ir-core-priv.h                    |  126 +
 drivers/media/IR/ir-functions.c                    |    1 +
 drivers/media/IR/ir-jvc-decoder.c                  |  320 ++
 drivers/media/IR/ir-keymaps.c                      | 3494 --------------------
 drivers/media/IR/ir-keytable.c                     |  687 ++--
 drivers/media/IR/ir-nec-decoder.c                  |  328 ++
 drivers/media/IR/ir-raw-event.c                    |  251 ++
 drivers/media/IR/ir-rc5-decoder.c                  |  324 ++
 drivers/media/IR/ir-rc6-decoder.c                  |  419 +++
 drivers/media/IR/ir-sony-decoder.c                 |  312 ++
 drivers/media/IR/ir-sysfs.c                        |  202 +-
 drivers/media/IR/keymaps/Kconfig                   |   15 +
 drivers/media/IR/keymaps/Makefile                  |   67 +
 drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c    |   89 +
 drivers/media/IR/keymaps/rc-apac-viewcomp.c        |   80 +
 drivers/media/IR/keymaps/rc-asus-pc39.c            |   91 +
 drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c |   69 +
 drivers/media/IR/keymaps/rc-avermedia-a16d.c       |   75 +
 drivers/media/IR/keymaps/rc-avermedia-cardbus.c    |   97 +
 drivers/media/IR/keymaps/rc-avermedia-dvbt.c       |   78 +
 .../media/IR/keymaps/rc-avermedia-m135a-rm-jx.c    |   90 +
 drivers/media/IR/keymaps/rc-avermedia.c            |   86 +
 drivers/media/IR/keymaps/rc-avertv-303.c           |   85 +
 drivers/media/IR/keymaps/rc-behold-columbus.c      |  108 +
 drivers/media/IR/keymaps/rc-behold.c               |  141 +
 drivers/media/IR/keymaps/rc-budget-ci-old.c        |   92 +
 drivers/media/IR/keymaps/rc-cinergy-1400.c         |   84 +
 drivers/media/IR/keymaps/rc-cinergy.c              |   78 +
 drivers/media/IR/keymaps/rc-dm1105-nec.c           |   76 +
 drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c      |   78 +
 drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c   |   97 +
 drivers/media/IR/keymaps/rc-em-terratec.c          |   69 +
 drivers/media/IR/keymaps/rc-empty.c                |   44 +
 drivers/media/IR/keymaps/rc-encore-enltv-fm53.c    |   81 +
 drivers/media/IR/keymaps/rc-encore-enltv.c         |  112 +
 drivers/media/IR/keymaps/rc-encore-enltv2.c        |   90 +
 drivers/media/IR/keymaps/rc-evga-indtube.c         |   61 +
 drivers/media/IR/keymaps/rc-eztv.c                 |   96 +
 drivers/media/IR/keymaps/rc-flydvb.c               |   77 +
 drivers/media/IR/keymaps/rc-flyvideo.c             |   70 +
 drivers/media/IR/keymaps/rc-fusionhdtv-mce.c       |   98 +
 drivers/media/IR/keymaps/rc-gadmei-rm008z.c        |   81 +
 drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c   |   84 +
 drivers/media/IR/keymaps/rc-gotview7135.c          |   79 +
 drivers/media/IR/keymaps/rc-hauppauge-new.c        |  100 +
 drivers/media/IR/keymaps/rc-imon-mce.c             |  142 +
 drivers/media/IR/keymaps/rc-imon-pad.c             |  156 +
 drivers/media/IR/keymaps/rc-iodata-bctv7e.c        |   88 +
 drivers/media/IR/keymaps/rc-kaiomy.c               |   87 +
 drivers/media/IR/keymaps/rc-kworld-315u.c          |   83 +
 .../media/IR/keymaps/rc-kworld-plus-tv-analog.c    |   99 +
 drivers/media/IR/keymaps/rc-manli.c                |  135 +
 drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c  |  123 +
 drivers/media/IR/keymaps/rc-msi-tvanywhere.c       |   69 +
 drivers/media/IR/keymaps/rc-nebula.c               |   96 +
 .../media/IR/keymaps/rc-nec-terratec-cinergy-xs.c  |  105 +
 drivers/media/IR/keymaps/rc-norwood.c              |   85 +
 drivers/media/IR/keymaps/rc-npgtech.c              |   80 +
 drivers/media/IR/keymaps/rc-pctv-sedna.c           |   80 +
 drivers/media/IR/keymaps/rc-pinnacle-color.c       |   94 +
 drivers/media/IR/keymaps/rc-pinnacle-grey.c        |   89 +
 drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c     |   73 +
 drivers/media/IR/keymaps/rc-pixelview-mk12.c       |   83 +
 drivers/media/IR/keymaps/rc-pixelview-new.c        |   83 +
 drivers/media/IR/keymaps/rc-pixelview.c            |   82 +
 .../media/IR/keymaps/rc-powercolor-real-angel.c    |   81 +
 drivers/media/IR/keymaps/rc-proteus-2309.c         |   69 +
 drivers/media/IR/keymaps/rc-purpletv.c             |   81 +
 drivers/media/IR/keymaps/rc-pv951.c                |   78 +
 drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c    |  103 +
 drivers/media/IR/keymaps/rc-rc5-tv.c               |   81 +
 .../media/IR/keymaps/rc-real-audio-220-32-keys.c   |   78 +
 drivers/media/IR/keymaps/rc-tbs-nec.c              |   73 +
 drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c  |   92 +
 drivers/media/IR/keymaps/rc-tevii-nec.c            |   88 +
 drivers/media/IR/keymaps/rc-tt-1500.c              |   82 +
 drivers/media/IR/keymaps/rc-videomate-s350.c       |   85 +
 drivers/media/IR/keymaps/rc-videomate-tv-pvr.c     |   87 +
 drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c |   82 +
 drivers/media/IR/keymaps/rc-winfast.c              |  102 +
 drivers/media/IR/rc-map.c                          |   84 +
 drivers/media/common/tuners/tuner-xc2028.c         |   25 +-
 drivers/media/common/tuners/tuner-xc2028.h         |    2 +
 drivers/media/dvb/bt8xx/dst.c                      |    2 -
 drivers/media/dvb/dm1105/dm1105.c                  |   25 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |   11 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   25 +-
 drivers/media/dvb/dvb-usb/a800.c                   |    6 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c          |   16 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |    8 +-
 drivers/media/dvb/dvb-usb/af9005.h                 |    4 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |   43 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |   18 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    6 +-
 drivers/media/dvb/dvb-usb/az6027.c                 |  114 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c         |    6 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |   51 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  100 +-
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    4 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |    8 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c              |    2 +-
 drivers/media/dvb/dvb-usb/dibusb.h                 |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |    6 +-
 drivers/media/dvb/dvb-usb/dtt200u.c                |   18 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    9 +-
 drivers/media/dvb/dvb-usb/dvb-usb-urb.c            |    2 +
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    7 +
 drivers/media/dvb/dvb-usb/dw2102.c                 |   44 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |    4 +
 drivers/media/dvb/dvb-usb/m920x.c                  |   18 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |   18 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   16 +-
 drivers/media/dvb/dvb-usb/vp702x.c                 |   12 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |   12 +-
 drivers/media/dvb/firewire/firedtv-avc.c           |    2 +-
 drivers/media/dvb/frontends/atbm8830_priv.h        |    2 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |    7 +
 drivers/media/dvb/frontends/au8522_dig.c           |   26 +
 drivers/media/dvb/frontends/au8522_priv.h          |    5 +
 drivers/media/dvb/frontends/dib3000mc.c            |   35 +-
 drivers/media/dvb/frontends/dib7000p.c             |   36 +-
 drivers/media/dvb/frontends/dib8000.h              |    1 +
 drivers/media/dvb/frontends/ds3000.c               |    2 +-
 drivers/media/dvb/frontends/stv0900_core.c         |   16 +-
 drivers/media/dvb/frontends/stv090x.c              |   94 +-
 drivers/media/dvb/frontends/stv090x.h              |    1 +
 drivers/media/dvb/frontends/stv6110x.c             |   34 +-
 drivers/media/dvb/frontends/stv6110x.h             |    1 +
 drivers/media/dvb/mantis/mantis_input.c            |    4 +-
 drivers/media/dvb/mantis/mantis_vp1041.c           |   10 +-
 drivers/media/dvb/ngene/Kconfig                    |    2 +
 drivers/media/dvb/ngene/Makefile                   |    4 +-
 drivers/media/dvb/ngene/ngene-cards.c              |  328 ++
 drivers/media/dvb/ngene/ngene-core.c               |  518 +---
 drivers/media/dvb/ngene/ngene-dvb.c                |  172 +
 drivers/media/dvb/ngene/ngene-i2c.c                |  179 +
 drivers/media/dvb/ngene/ngene.h                    |   30 +
 drivers/media/dvb/pt1/pt1.c                        |  271 ++-
 drivers/media/dvb/pt1/va1j5jf8007s.c               |   32 +-
 drivers/media/dvb/pt1/va1j5jf8007s.h               |    8 +-
 drivers/media/dvb/pt1/va1j5jf8007t.c               |   31 +-
 drivers/media/dvb/pt1/va1j5jf8007t.h               |    8 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   52 +-
 drivers/media/dvb/ttpci/budget.c                   |   47 +-
 drivers/media/radio/radio-mr800.c                  |   19 +-
 drivers/media/video/Kconfig                        |   52 +-
 drivers/media/video/Makefile                       |   14 +-
 drivers/media/video/ak881x.c                       |  368 ++
 drivers/media/video/arv.c                          |  524 ++--
 drivers/media/video/au0828/au0828-video.c          |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c             |    4 +
 drivers/media/video/bt8xx/bttv-driver.c            |   27 +-
 drivers/media/video/bt8xx/bttv-input.c             |   30 +-
 drivers/media/video/bw-qcam.c                      |  452 ++--
 drivers/media/video/c-qcam.c                       |  483 ++--
 drivers/media/video/cpia2/cpia2_v4l.c              |    4 +-
 drivers/media/video/cx18/cx18-av-core.c            |   54 +-
 drivers/media/video/cx18/cx18-av-core.h            |   24 +-
 drivers/media/video/cx18/cx18-av-vbi.c             |   42 +-
 drivers/media/video/cx18/cx18-cards.c              |    4 +-
 drivers/media/video/cx18/cx18-cards.h              |    4 +-
 drivers/media/video/cx18/cx18-controls.c           |    2 +-
 drivers/media/video/cx18/cx18-fileops.c            |    2 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx18/cx18-ioctl.c              |   22 +-
 drivers/media/video/cx18/cx18-streams.c            |    5 +-
 drivers/media/video/cx18/cx18-vbi.c                |    2 +-
 drivers/media/video/cx231xx/cx231xx-audio.c        |    2 +-
 drivers/media/video/cx231xx/cx231xx-core.c         |   13 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |   52 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |    9 +-
 drivers/media/video/cx231xx/cx231xx.h              |    2 +-
 drivers/media/video/cx2341x.c                      |   14 -
 drivers/media/video/cx23885/cimax2.c               |   12 +-
 drivers/media/video/cx23885/cx23885-417.c          |    2 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |   16 +
 drivers/media/video/cx23885/cx23885-input.c        |    8 +-
 drivers/media/video/cx23885/cx23885-video.c        |    4 +-
 drivers/media/video/cx25840/cx25840-core.c         |   17 +-
 drivers/media/video/cx25840/cx25840-core.h         |    5 +-
 drivers/media/video/cx25840/cx25840-vbi.c          |   40 +-
 drivers/media/video/cx88/cx88-core.c               |    3 +-
 drivers/media/video/cx88/cx88-dvb.c                |    2 +-
 drivers/media/video/cx88/cx88-input.c              |  149 +-
 drivers/media/video/cx88/cx88-mpeg.c               |   11 +-
 drivers/media/video/cx88/cx88-video.c              |   20 +-
 drivers/media/video/cx88/cx88.h                    |    8 +-
 drivers/media/video/davinci/dm644x_ccdc.c          |  131 +-
 drivers/media/video/davinci/dm644x_ccdc_regs.h     |   10 +-
 drivers/media/video/davinci/isif_regs.h            |    2 +-
 drivers/media/video/davinci/vpfe_capture.c         |   83 +-
 drivers/media/video/davinci/vpif_capture.c         |    8 +-
 drivers/media/video/davinci/vpif_display.c         |    6 +-
 drivers/media/video/em28xx/em28xx-audio.c          |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   56 +-
 drivers/media/video/em28xx/em28xx-core.c           |   25 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   11 +-
 drivers/media/video/em28xx/em28xx-input.c          |   29 +-
 drivers/media/video/em28xx/em28xx-video.c          |   66 +-
 drivers/media/video/em28xx/em28xx.h                |    7 +-
 drivers/media/video/et61x251/et61x251_core.c       |    6 +-
 drivers/media/video/font.h                         |  407 ---
 drivers/media/video/gspca/Kconfig                  |    6 -
 drivers/media/video/gspca/cpia1.c                  |   36 +-
 drivers/media/video/gspca/gspca.c                  |  124 +-
 drivers/media/video/gspca/gspca.h                  |    6 +-
 drivers/media/video/gspca/ov534.c                  |  563 ++--
 drivers/media/video/gspca/pac207.c                 |    4 +-
 drivers/media/video/gspca/sn9c2028.c               |    2 +-
 drivers/media/video/gspca/sn9c20x.c                |  359 +--
 drivers/media/video/gspca/sonixj.c                 |  585 +++-
 drivers/media/video/gspca/spca561.c                |   58 +-
 drivers/media/video/gspca/t613.c                   |  172 +-
 drivers/media/video/gspca/vc032x.c                 |  747 +++--
 drivers/media/video/gspca/zc3xx.c                  |   95 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |   33 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |   18 +
 drivers/media/video/hdpvr/hdpvr.h                  |    5 +
 drivers/media/video/ir-kbd-i2c.c                   |   28 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    5 +-
 drivers/media/video/ivtv/ivtv-driver.h             |   10 +
 drivers/media/video/ivtv/ivtv-fileops.c            |   55 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    6 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |  119 +-
 drivers/media/video/ivtv/ivtv-irq.c                |   23 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   17 +-
 drivers/media/video/ivtv/ivtv-vbi.c                |   18 +-
 drivers/media/video/ivtv/ivtvfb.c                  |    2 +-
 drivers/media/video/mem2mem_testdev.c              | 1052 ++++++
 drivers/media/video/meye.c                         |   78 +-
 drivers/media/video/meye.h                         |   10 +-
 drivers/media/video/mt9t031.c                      |   66 +-
 drivers/media/video/mt9v022.c                      |    2 +-
 drivers/media/video/mx1_camera.c                   |    4 +-
 drivers/media/video/mx3_camera.c                   |    4 +-
 drivers/media/video/omap/Kconfig                   |   11 +
 drivers/media/video/omap/Makefile                  |    7 +
 drivers/media/video/omap/omap_vout.c               | 2643 +++++++++++++++
 drivers/media/video/omap/omap_voutdef.h            |  147 +
 drivers/media/video/omap/omap_voutlib.c            |  293 ++
 drivers/media/video/omap/omap_voutlib.h            |   34 +
 drivers/media/video/omap24xxcam.c                  |    4 +-
 drivers/media/video/ov511.c                        |   11 +-
 drivers/media/video/ov7670.c                       |  286 ++-
 drivers/media/video/ov9640.c                       |    6 +-
 drivers/media/video/pms.c                          |   18 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   28 +-
 drivers/media/video/pwc/Kconfig                    |    2 +-
 drivers/media/video/pxa_camera.c                   |    4 +-
 drivers/media/video/rj54n1cb0c.c                   |   18 +-
 drivers/media/video/s2255drv.c                     | 1161 ++++---
 drivers/media/video/saa7115.c                      |   74 +-
 drivers/media/video/saa7127.c                      |   31 +-
 drivers/media/video/saa7134/saa7134-alsa.c         |    2 -
 drivers/media/video/saa7134/saa7134-cards.c        |  111 +
 drivers/media/video/saa7134/saa7134-core.c         |   22 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |    9 +
 drivers/media/video/saa7134/saa7134-input.c        |  283 ++-
 drivers/media/video/saa7134/saa7134-reg.h          |   24 +-
 drivers/media/video/saa7134/saa7134-video.c        |   25 +-
 drivers/media/video/saa7134/saa7134.h              |    7 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  613 ++--
 drivers/media/video/sh_vou.c                       | 1476 +++++++++
 drivers/media/video/sn9c102/sn9c102_core.c         |    6 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |   18 +-
 drivers/media/video/sn9c102/sn9c102_hv7131d.c      |    2 +-
 drivers/media/video/soc_camera.c                   |   21 +-
 drivers/media/video/tlg2300/pd-dvb.c               |    6 +-
 drivers/media/video/tlg2300/pd-main.c              |    7 +-
 drivers/media/video/tlg2300/pd-radio.c             |   21 +-
 drivers/media/video/tlg2300/pd-video.c             |   18 +-
 drivers/media/video/tvp514x.c                      |   13 +
 drivers/media/video/tvp5150.c                      |   67 +-
 drivers/media/video/tvp7002.c                      |   53 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    3 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |    3 +
 drivers/media/video/usbvision/usbvision-video.c    |   82 +-
 drivers/media/video/usbvision/usbvision.h          |    6 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |   50 +-
 drivers/media/video/uvc/uvc_driver.c               |   25 +-
 drivers/media/video/uvc/uvc_queue.c                |    8 +-
 drivers/media/video/uvc/uvcvideo.h                 |    4 +-
 drivers/media/video/v4l2-common.c                  |  101 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    3 +
 drivers/media/video/v4l2-dev.c                     |    6 +-
 drivers/media/video/v4l2-device.c                  |   11 +
 drivers/media/video/v4l2-event.c                   |  292 ++
 drivers/media/video/v4l2-fh.c                      |   79 +
 drivers/media/video/v4l2-ioctl.c                   |  103 +-
 drivers/media/video/v4l2-mem2mem.c                 |  633 ++++
 drivers/media/video/videobuf-core.c                |  244 +-
 drivers/media/video/videobuf-dma-contig.c          |  115 +-
 drivers/media/video/videobuf-dma-sg.c              |  383 +--
 drivers/media/video/videobuf-dvb.c                 |    2 +-
 drivers/media/video/videobuf-vmalloc.c             |  183 +-
 drivers/media/video/vivi.c                         |  806 ++---
 drivers/media/video/w9966.c                        | 1149 ++++----
 drivers/media/video/zc0301/zc0301_core.c           |    6 +-
 drivers/media/video/zc0301/zc0301_sensor.h         |    2 +-
 drivers/media/video/zoran/zoran.h                  |   24 +-
 drivers/media/video/zoran/zoran_driver.c           |   16 +-
 drivers/media/video/zr364xx.c                      |    4 +-
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/cx25821/cx25821-alsa.c             |  103 +-
 drivers/staging/cx25821/cx25821-audio-upstream.c   |  146 +-
 drivers/staging/cx25821/cx25821-audups11.c         |   84 +-
 drivers/staging/cx25821/cx25821-cards.c            |    4 +-
 drivers/staging/cx25821/cx25821-core.c             |  160 +-
 drivers/staging/cx25821/cx25821-gpio.c             |   25 +-
 drivers/staging/cx25821/cx25821-i2c.c              |   14 +-
 drivers/staging/cx25821/cx25821-medusa-video.c     |  260 +-
 drivers/staging/cx25821/cx25821-video-upstream.c   |  145 +-
 drivers/staging/cx25821/cx25821-video.c            |  145 +-
 drivers/staging/cx25821/cx25821-video.h            |   78 +-
 drivers/staging/cx25821/cx25821-video0.c           |   88 +-
 drivers/staging/cx25821/cx25821-video1.c           |   88 +-
 drivers/staging/cx25821/cx25821-video2.c           |   88 +-
 drivers/staging/cx25821/cx25821-video3.c           |   88 +-
 drivers/staging/cx25821/cx25821-video4.c           |   88 +-
 drivers/staging/cx25821/cx25821-video5.c           |   88 +-
 drivers/staging/cx25821/cx25821-video6.c           |   88 +-
 drivers/staging/cx25821/cx25821-video7.c           |   88 +-
 drivers/staging/cx25821/cx25821-videoioctl.c       |   84 +-
 drivers/staging/cx25821/cx25821-vidups10.c         |   84 +-
 drivers/staging/cx25821/cx25821-vidups9.c          |   84 +-
 drivers/staging/tm6000/Kconfig                     |   32 +
 drivers/staging/tm6000/Makefile                    |   17 +
 drivers/staging/tm6000/README                      |   22 +
 drivers/staging/tm6000/tm6000-alsa.c               |  414 +++
 drivers/staging/tm6000/tm6000-cards.c              |  973 ++++++
 drivers/staging/tm6000/tm6000-core.c               |  602 ++++
 drivers/staging/tm6000/tm6000-dvb.c                |  346 ++
 drivers/staging/tm6000/tm6000-i2c.c                |  370 +++
 drivers/staging/tm6000/tm6000-regs.h               |  541 +++
 drivers/staging/tm6000/tm6000-stds.c               |  873 +++++
 drivers/staging/tm6000/tm6000-usb-isoc.h           |   53 +
 drivers/staging/tm6000/tm6000-video.c              | 1557 +++++++++
 drivers/staging/tm6000/tm6000.h                    |  301 ++
 include/linux/meye.h                               |   12 +-
 include/linux/videodev2.h                          |   75 +-
 include/media/ak881x.h                             |   25 +
 include/media/davinci/vpfe_capture.h               |    2 +
 include/media/ir-common.h                          |   74 +-
 include/media/ir-core.h                            |  142 +-
 include/media/ir-kbd-i2c.h                         |    6 +-
 include/media/rc-map.h                             |  121 +
 include/media/sh_vou.h                             |   34 +
 include/media/soc_camera.h                         |   12 +-
 include/media/v4l2-chip-ident.h                    |  127 +-
 include/media/v4l2-common.h                        |   27 +-
 include/media/v4l2-dev.h                           |    5 +
 include/media/v4l2-event.h                         |   67 +
 include/media/v4l2-fh.h                            |   65 +
 include/media/v4l2-ioctl.h                         |    7 +
 include/media/v4l2-mem2mem.h                       |  201 ++
 include/media/v4l2-subdev.h                        |   70 +-
 include/media/videobuf-core.h                      |   35 +-
 include/media/videobuf-dma-sg.h                    |   26 +-
 include/media/videobuf-vmalloc.h                   |   12 +-
 387 files changed, 36270 insertions(+), 11937 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/dev-event.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-dqevent.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subscribe-event.xml
 create mode 100644 drivers/media/IR/imon.c
 create mode 100644 drivers/media/IR/ir-core-priv.h
 create mode 100644 drivers/media/IR/ir-jvc-decoder.c
 delete mode 100644 drivers/media/IR/ir-keymaps.c
 create mode 100644 drivers/media/IR/ir-nec-decoder.c
 create mode 100644 drivers/media/IR/ir-raw-event.c
 create mode 100644 drivers/media/IR/ir-rc5-decoder.c
 create mode 100644 drivers/media/IR/ir-rc6-decoder.c
 create mode 100644 drivers/media/IR/ir-sony-decoder.c
 create mode 100644 drivers/media/IR/keymaps/Kconfig
 create mode 100644 drivers/media/IR/keymaps/Makefile
 create mode 100644 drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
 create mode 100644 drivers/media/IR/keymaps/rc-apac-viewcomp.c
 create mode 100644 drivers/media/IR/keymaps/rc-asus-pc39.c
 create mode 100644 drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-a16d.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-cardbus.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-dvbt.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia.c
 create mode 100644 drivers/media/IR/keymaps/rc-avertv-303.c
 create mode 100644 drivers/media/IR/keymaps/rc-behold-columbus.c
 create mode 100644 drivers/media/IR/keymaps/rc-behold.c
 create mode 100644 drivers/media/IR/keymaps/rc-budget-ci-old.c
 create mode 100644 drivers/media/IR/keymaps/rc-cinergy-1400.c
 create mode 100644 drivers/media/IR/keymaps/rc-cinergy.c
 create mode 100644 drivers/media/IR/keymaps/rc-dm1105-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
 create mode 100644 drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
 create mode 100644 drivers/media/IR/keymaps/rc-em-terratec.c
 create mode 100644 drivers/media/IR/keymaps/rc-empty.c
 create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
 create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv.c
 create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv2.c
 create mode 100644 drivers/media/IR/keymaps/rc-evga-indtube.c
 create mode 100644 drivers/media/IR/keymaps/rc-eztv.c
 create mode 100644 drivers/media/IR/keymaps/rc-flydvb.c
 create mode 100644 drivers/media/IR/keymaps/rc-flyvideo.c
 create mode 100644 drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
 create mode 100644 drivers/media/IR/keymaps/rc-gadmei-rm008z.c
 create mode 100644 drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
 create mode 100644 drivers/media/IR/keymaps/rc-gotview7135.c
 create mode 100644 drivers/media/IR/keymaps/rc-hauppauge-new.c
 create mode 100644 drivers/media/IR/keymaps/rc-imon-mce.c
 create mode 100644 drivers/media/IR/keymaps/rc-imon-pad.c
 create mode 100644 drivers/media/IR/keymaps/rc-iodata-bctv7e.c
 create mode 100644 drivers/media/IR/keymaps/rc-kaiomy.c
 create mode 100644 drivers/media/IR/keymaps/rc-kworld-315u.c
 create mode 100644 drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
 create mode 100644 drivers/media/IR/keymaps/rc-manli.c
 create mode 100644 drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
 create mode 100644 drivers/media/IR/keymaps/rc-msi-tvanywhere.c
 create mode 100644 drivers/media/IR/keymaps/rc-nebula.c
 create mode 100644 drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
 create mode 100644 drivers/media/IR/keymaps/rc-norwood.c
 create mode 100644 drivers/media/IR/keymaps/rc-npgtech.c
 create mode 100644 drivers/media/IR/keymaps/rc-pctv-sedna.c
 create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-color.c
 create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-grey.c
 create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
 create mode 100644 drivers/media/IR/keymaps/rc-pixelview-mk12.c
 create mode 100644 drivers/media/IR/keymaps/rc-pixelview-new.c
 create mode 100644 drivers/media/IR/keymaps/rc-pixelview.c
 create mode 100644 drivers/media/IR/keymaps/rc-powercolor-real-angel.c
 create mode 100644 drivers/media/IR/keymaps/rc-proteus-2309.c
 create mode 100644 drivers/media/IR/keymaps/rc-purpletv.c
 create mode 100644 drivers/media/IR/keymaps/rc-pv951.c
 create mode 100644 drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
 create mode 100644 drivers/media/IR/keymaps/rc-rc5-tv.c
 create mode 100644 drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
 create mode 100644 drivers/media/IR/keymaps/rc-tbs-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
 create mode 100644 drivers/media/IR/keymaps/rc-tevii-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-tt-1500.c
 create mode 100644 drivers/media/IR/keymaps/rc-videomate-s350.c
 create mode 100644 drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
 create mode 100644 drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
 create mode 100644 drivers/media/IR/keymaps/rc-winfast.c
 create mode 100644 drivers/media/IR/rc-map.c
 create mode 100644 drivers/media/dvb/ngene/ngene-cards.c
 create mode 100644 drivers/media/dvb/ngene/ngene-dvb.c
 create mode 100644 drivers/media/dvb/ngene/ngene-i2c.c
 create mode 100644 drivers/media/video/ak881x.c
 delete mode 100644 drivers/media/video/font.h
 create mode 100644 drivers/media/video/mem2mem_testdev.c
 create mode 100644 drivers/media/video/omap/Kconfig
 create mode 100644 drivers/media/video/omap/Makefile
 create mode 100644 drivers/media/video/omap/omap_vout.c
 create mode 100644 drivers/media/video/omap/omap_voutdef.h
 create mode 100644 drivers/media/video/omap/omap_voutlib.c
 create mode 100644 drivers/media/video/omap/omap_voutlib.h
 create mode 100644 drivers/media/video/sh_vou.c
 create mode 100644 drivers/media/video/v4l2-event.c
 create mode 100644 drivers/media/video/v4l2-fh.c
 create mode 100644 drivers/media/video/v4l2-mem2mem.c
 create mode 100644 drivers/staging/tm6000/Kconfig
 create mode 100644 drivers/staging/tm6000/Makefile
 create mode 100644 drivers/staging/tm6000/README
 create mode 100644 drivers/staging/tm6000/tm6000-alsa.c
 create mode 100644 drivers/staging/tm6000/tm6000-cards.c
 create mode 100644 drivers/staging/tm6000/tm6000-core.c
 create mode 100644 drivers/staging/tm6000/tm6000-dvb.c
 create mode 100644 drivers/staging/tm6000/tm6000-i2c.c
 create mode 100644 drivers/staging/tm6000/tm6000-regs.h
 create mode 100644 drivers/staging/tm6000/tm6000-stds.c
 create mode 100644 drivers/staging/tm6000/tm6000-usb-isoc.h
 create mode 100644 drivers/staging/tm6000/tm6000-video.c
 create mode 100644 drivers/staging/tm6000/tm6000.h
 create mode 100644 include/media/ak881x.h
 create mode 100644 include/media/rc-map.h
 create mode 100644 include/media/sh_vou.h
 create mode 100644 include/media/v4l2-event.h
 create mode 100644 include/media/v4l2-fh.h
 create mode 100644 include/media/v4l2-mem2mem.h





Cheers,
Mauro
