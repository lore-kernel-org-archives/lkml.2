Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1CXL4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1CXL4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:56:05 -0400
Message-ID: <4D8B312A.2080501@redhat.com>
Date: Thu, 24 Mar 2011 08:55:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.39] drivers/media updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For lots of improvements, including:

- The addition of the Media Controller API, required to adjust stream 
  parameters on SoC media devices;
- A new Videobuf core (videobuf2);
- V4L2 core additions to deal with the V4L2 priority ioctls;
- The merge of Omap3isp media driver;
- New frontend drivers for: dib9000 and stv0367;
- New FM driver: wl128x;
- New Remote Controller driver: ite-cir;
- Fixes at Hauppauge Remote Controller maps;
- New webcam drivers for gspca: nw80x, vicam;
- New sensor drivers: noon010pc30, ov9740;
- New staging drivers for CI criptographic modules:
	cxd2099 - API is somewhat abused here, so, we opted to
		  put it on staging while the API is not improved to
		  better support it;
	altera-stabl - Required to load firmware for the altera-ci
		       driver used by some cx23885 devices;
- Removed some deprecated drivers whose devices are supported by
  a not-orphaned driver: lirc_it97, lirc_ite8709, se401, usbvideo;
- Removed one deprecated driver (not used by any commercial
  product): dabusb;
- Several other driver and core improvements.

As I based my pull request on vanilla 2.6.38, there are a few context 
merge conflicts, due to some changes already merged on your tree from
staging and arm changes. They are trivial to solve:

	http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=c39590f38c4726b60efa6641780ebc103db837ea

The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:

  Linux 2.6.38 (2011-03-14 18:20:32 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Abylay Ospan (6):
      [media] stv0900: Update status when LOCK is missed
      [media] cx23885: Altera FPGA CI interface reworked
      [media] stv0367: change default value for AGC register
      [media] stv0367: implement uncorrected blocks counter
      [media] Fix CI code for NetUP Dual DVB-T/C CI RF card
      [media] Force xc5000 firmware loading for NetUP Dual DVB-T/C CI RF card

Alberto Panizzo (2):
      [media] V4L: soc_mediabus: add a method to obtain the number of samples per pixel
      [media] V4L: mx3_camera: fix capture issues for non 8-bit per pixel formats

Alexander Strakh (1):
      [media] drivers/media/video/tlg2300/pd-video.c: Remove second mutex_unlock in pd_vidioc_s_fmt

Alina Friedrichsen (1):
      [media] tuner-xc2028: More firmware loading retries

Anatolij Gustschin (2):
      [media] V4L: soc-camera: start stream after queueing the buffers
      [media] V4L: mx3_camera: correct 'sizeimage' value reporting

Andreas Regel (1):
      [media] stv090x: make sleep/wakeup specific to the demod path

Andrew Chew (1):
      [media] V4L: Initial submit of OV9740 driver

Andrzej Pietrasiewicz (3):
      [media] v4l: videobuf2: add DMA scatter/gather allocator
      [media] v4l2: vb2-dma-sg: fix memory leak
      [media] v4l2: vb2-dma-sg: fix potential security hole

Andy Walls (14):
      [media] ivtv: Fix sparse warning regarding a user pointer in ivtv_write_vbi_from_user()
      [media] lirc_zilog: Restore checks for existence of the IR_tx object
      [media] lirc_zilog: Remove broken, ineffective reference counting
      [media] lirc_zilog: Convert ir_device instance array to a linked list
      [media] lirc_zilog: Convert the instance open count to an atomic_t
      [media] lirc_zilog: Use kernel standard methods for marking device non-seekable
      [media] lirc_zilog: Don't acquire the rx->buf_lock in the poll() function
      [media] lirc_zilog: Remove unneeded rx->buf_lock
      [media] lirc_zilog: Always allocate a Rx lirc_buffer object
      [media] lirc_zilog: Move constants from ir_probe() into the lirc_driver template
      [media] lirc_zilog: Add ref counting of struct IR, IR_tx, and IR_rx
      [media] lirc_zilog: Add locking of the i2c_clients when in use
      [media] lirc_zilog: Fix somewhat confusing information messages in ir_probe()
      [media] lirc_zilog: Update TODO list based on work completed and revised plans

Antti Koskipaa (1):
      [media] v4l: v4l2_subdev userspace crop API

Antti Palosaari (6):
      [media] af9015: small RC change
      [media] add TerraTec remote
      [media] af9015: map remote for TerraTec Cinergy T Stick RC
      [media] af9015: reimplement firmware download
      [media] af9013: download FW earlier in attach()
      [media] af9013: reimplement firmware download

Arnd Bergmann (1):
      [media] staging/cx25721: serialize access to devlist

Dan Carpenter (5):
      [media] stv090x: handle allocation failures
      [media] dib8000: fix small memory leak on error
      [media] dib9000: fix return type in dib9000_mbx_send_attr()
      [media] stv0367: signedness bug in stv0367_get_tuner_freq()
      [media] stv0367: typo in function parameter

Daniel Drake (2):
      [media] via-camera: Add suspend/resume support
      [media] via-camera: Fix OLPC serial check

David Cohen (1):
      [media] omap3isp: Statistics

Dmitri Belimov (6):
      [media] tm6000: add/rework reg.defines
      [media] xc5000: add set_config and other
      [media] tm6000: add new TV cards of Beholder
      [media] tm6000: add radio support to the driver
      [media] tm6000: add audio conf for new cards
      [media] tm6000: fix s-video input

Guennadi Liakhovetski (8):
      [media] V4L: omap1_camera: join split format lines
      [media] V4L: add missing EXPORT_SYMBOL* statements to vb2
      [media] V4L: soc-camera: extend to also support videobuf2
      [media] V4L: soc-camera: add helper functions for videobuf queue handling
      [media] V4L: sh_mobile_ceu_camera: convert to videobuf2
      [media] V4L: mx3_camera: convert to videobuf2
      [media] V4l: sh_mobile_ceu_camera: fix cropping offset calculation
      [media] V4L: soc-camera: explicitly require V4L2_BUF_TYPE_VIDEO_CAPTURE

Hans Verkuil (50):
      [media] DocBook/v4l: fix validation errors
      [media] cs5345: use the control framework
      [media] cx18: Use the control framework
      [media] adv7343: use control framework
      [media] bt819: use control framework
      [media] saa7110: use control framework
      [media] tlv320aic23b: use control framework
      [media] tvp514x: use the control framework
      [media] tvp5150: use the control framework
      [media] vpx3220: use control framework
      [media] tvp7002: use control framework
      [media] vivi: convert to the control framework and add test controls
      [media] vivi: fix compiler warning
      [media] pwc: convert to core-assisted locking
      [media] pwc: convert to video_ioctl2
      [media] cpia2: convert to video_ioctl2
      [media] v4l2-ctrls: Fix control enumeration for multiple subdevs with ctrl
      [media] se401: remove last V4L1 driver
      [media] dabusb: remove obsolete driver
      [media] v4l: removal of old, obsolete ioctls
      [media] firedtv: remove obsolete ieee1394 backend code
      [media] saa7134-empress: add missing MPEG controls
      [media] cx18: fix kernel oops when setting MPEG control before capturing
      [media] tuner-xc2028.c: fix compile warning
      [media] stv0367.c: fix compiler warning
      [media] altera-ci.c: fix compiler warnings
      [media] fmdrv_common.c: fix compiler warning
      [media] cx88-alsa: fix compiler warning
      [media] altera-ci.h: add missing inline
      [media] V4L doc fixes
      [media] V4L DocBook: update V4L2 version
      [media] Fix 'ID nv12mt already defined' error
      [media] v4l2_prio: move from v4l2-common to v4l2-dev
      [media] v4l2: add v4l2_prio_state to v4l2_device and video_device
      [media] v4l2-fh: implement v4l2_priority support
      [media] v4l2-fh: add v4l2_fh_open and v4l2_fh_release helper functions
      [media] v4l2-fh: add v4l2_fh_is_singular
      [media] v4l2-ioctl: add priority handling support
      [media] ivtv: convert to core priority handling
      [media] v4l2-framework.txt: improve v4l2_fh/priority documentation
      [media] cx18: use v4l2_fh as preparation for adding core priority support
      [media] cx18: use core priority handling
      [media] v4l2-device: add kref and a release function
      [media] v4l2-framework.txt: document new v4l2_device release() callback
      [media] dsbr100: convert to unlocked_ioctl
      [media] dsbr100: ensure correct disconnect sequence
      [media] vivi: convert to core priority handling
      [media] ivtv: add missing v4l2_fh_exit
      [media] ivtv: replace ugly casts with a proper container_of
      [media] v4l2: use new flag to enable core priority handling

Hans de Goede (10):
      [media] gspca_sn9c20x: Fix colored borders with ov7660 sensor
      [media] gspca_sn9c20x: Add hflip and vflip controls for the ov7660 sensor
      [media] gspca_sn9c20x: Add LED_REVERSE flag for 0c45:62bb
      [media] gspca_sn9c20x: Make buffers slightly larger for JPEG frames
      [media] gspca_sn9c20x: Add another MSI laptop to the sn9c20x upside down list
      [media] gspca: Add new vicam subdriver
      [media] gspca_cpia1: Don't allow the framerate divisor to go above 2
      [media] staging-usbvideo: remove
      [media] gspca_cpia1: Add support for button
      [media] gspca - sonixb: Update inactive flags to reflect autogain setting

Holger Nelson (1):
      [media] tm6000: Add support for Terratec Grabster AV 150/250 MX

Hyunwoong Kim (5):
      [media] s5p-fimc: fix the value of YUV422 1-plane formats
      [media] s5p-fimc: Configure scaler registers depending on FIMC version
      [media] s5p-fimc: update checking scaling ratio range
      [media] s5p-fimc: Support stop_streaming and job_abort
      [media] s5p-fimc: fix MSCTRL.FIFO_CTRL for performance enhancement

Ian Armstrong (1):
      [media] af9015: enhance RC

Igor M. Liplianin (38):
      [media] Altera FPGA firmware download module
      [media] Altera FPGA based CI driver module
      [media] Support for stv0367 multi-standard demodulator
      [media] xc5000: add support for DVB-C tuning
      [media] Initial commit to support NetUP Dual DVB-T/C CI RF card
      [media] cx23885: implement tuner_bus parameter for cx23885_board structure
      [media] cx23885: implement num_fds_portb, num_fds_portc parameters for cx23885_board structure
      [media] cx23885: disable MSI for NetUP cards, otherwise CI is not working
      [media] cx23885, altera-ci: enable all PID's less than 0x20 in hardware PID filter
      [media] ds3000: fill in demod init function
      [media] ds3000: decrease mpeg clock output
      [media] ds3000: loading firmware in bigger chunks
      [media] ds3000: don't load firmware during demod init
      [media] dw2102: Extend keymap parameter for not used remote
      [media] dw2102: use separate firmwares for Prof 1100, TeVii S630, S660
      [media] dw2102: add support for Geniatech SU3000 USB DVB-S2 card
      [media] dw2102: Add Terratec Cinergy S2 USB HD
      [media] dw2102: Prof 7500: Lock LED implemented
      [media] dw2102: Prof 7500 remote fix
      [media] dw2102: Prof 1100 initialization fix
      [media] dw2102: unnecessary NULL's removed
      [media] dw2102: corrections for TeVii s660 LNB power control
      [media] dw2102: fix TeVii s660 remote control
      [media] dw2102: add support for the TeVii S480 PCIe
      [media] dw2102: Copyright, cards list updated
      [media] ds3000: clean up in tune procedure
      [media] ds3000: remove unnecessary dnxt, dcur structures
      [media] ds3000: add carrier offset calculation
      [media] ds3000: hardware tune algorithm
      [media] cx88: add support for TeVii S464 PCI card
      [media] cx23885, altera-ci: remove operator return <value> in void procedure
      [media] stv0900: speed up DVB-S searching
      [media] ds3000: wrong hardware tune function implemented
      [media] dw2102: X3M TV SPC1400HD added
      [media] dw2102: remove unnecessary delays for i2c transfer for some cards
      [media] dw2102: i2c transfer corrected for some cards
      [media] dw2102: i2c transfer corrected for yet another cards
      [media] dw2102: prof 1100 corrected

Jarod Wilson (9):
      [media] docs: fix typo in lirc_device_interface.xml
      [media] imon: add more panel scancode mappings
      [media] hdpvr: i2c master enhancements
      [media] ir-kbd-i2c: pass device code w/key in hauppauge case
      [media] hdpvr: use same polling interval as other OS
      [media] lirc: silence some compile warnings
      [media] lirc_zilog: error out if buffer read bytes != chunk size
      [media] mceusb: topseed 0x0011 needs gen3 init for tx to work
      [media] rc: interim support for 32-bit NEC-ish scancodes

Jean-François Moine (34):
      [media] gspca - sonixj: Move the avg lum computation to a separate function
      [media] gspca - sonixj: Better scanning of isochronous packets
      [media] gspca - sonixj: Have the same JPEG quality for encoding and decoding
      [media] gspca - sonixj: Update the JPEG quality for best image transfer
      [media] gspca - sonixj: Fix start sequence of sensor mt9v111
      [media] gspca - sonixj: Adjust autogain for sensor mt9v111
      [media] gspca - sonixj: Simplify GPIO setting when audio present
      [media] gspca - sonixj: Same init for all bridges but the sn9c102p
      [media] gspca - sonixj: Set both pins for infrared of mt9v111 webcams
      [media] gspca - sonixj, zc3xx: Let some bandwidth for audio when USB 1.1
      [media] gspca - ov534: Use the new control mechanism
      [media] gspca - ov534: Add the webcam 06f8:3002 and sensor ov767x
      [media] gspca - ov534: Add saturation control for ov767x
      [media] gspca - sonixj: The pin S_PWR_DN is inverted for sensor mi0360
      [media] gspca - ov519: Add the sensor ov2610ae
      [media] gspca - ov519: Add the 800x600 resolution for sensors ov2610/2610ae
      [media] gspca - zc3xx: Remove double definition
      [media] gspca - zc3xx: Cleanup source
      [media] gspca: New file autogain_functions.h
      [media] gspca - sonixb: Use the new control mechanism
      [media] gspca - sonixb: Clenup source
      [media] gspca - jeilinj / stv06xx: Fix some warnings
      [media] gspca - ov519: Add exposure and autogain controls for ov2610/2610ae
      [media] gspca - main: Cleanup source
      [media] gspca - nw80x: New subdriver for Divio based webcams
      [media] gspca - nw80x: Cleanup source
      [media] gspca - nw80x: The webcam dsb-c110 is the same as the twinkle
      [media] gspca - nw80x: Do some initialization at probe time
      [media] gspca - nw80x: Fix the gain, exposure and autogain
      [media] gspca - nw80x: Check the bridge from the webcam type
      [media] gspca - nw80x: Fix some image resolutions
      [media] gspca - nw80x: Get the sensor ID when bridge et31x110
      [media] gspca - nw80x: Fix exposure for some webcams
      [media] gspca - zc3xx: Add exposure control for sensor hv7131r

Jesper Juhl (2):
      [media] TTUSB DVB: ttusb_boot_dsp() needs to release_firmware() or it leaks memory
      [media] Zarlink zl10036 DVB-S: Fix mem leak in zl10036_attach

Jiri Slaby (1):
      [media] V4L: videobuf, don't use dma addr as physical

Juan J. Garcia de Soria (2):
      [media] rc: New rc-based ite-cir driver for several ITE CIRs
      [media] lirc: remove staging lirc_it87 and lirc_ite8709 drivers

Justin P. Mattock (2):
      [media] drivers:media:cx23418.h remove one to many l's in the word
      [media] drivers:media:cx231xx.h remove one to many l's in the word

Kamil Debski (1):
      [media] v4l: Documentation for the NV12MT format

Laurent Pinchart (40):
      [media] v4l: videobuf2: Typo fix
      [media] v4l: Share code between video_usercopy and video_ioctl2
      [media] v4l: subdev: Don't require core operations
      [media] v4l: subdev: Add device node support
      [media] v4l: subdev: Uninline the v4l2_subdev_init function
      [media] v4l: subdev: Control ioctls support
      [media] media: Media device node support
      [media] media: Media device
      [media] media: Entities, pads and links
      [media] media: Entity use count
      [media] media: Media device information query
      [media] media: Entities, pads and links enumeration
      [media] media: Links setup
      [media] media: Pipelines and media streams
      [media] v4l: Add a media_device pointer to the v4l2_device structure
      [media] v4l: Make video_device inherit from media_entity
      [media] v4l: Make v4l2_subdev inherit from media_entity
      [media] v4l: Move the media/v4l2-mediabus.h header to include/linux
      [media] v4l: Replace enums with fixed-sized fields in public structure
      [media] v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
      [media] v4l: Group media bus pixel codes by types and sort them alphabetically
      [media] v4l: subdev: Add new file operations
      [media] v4l: v4l2_subdev pad-level operations
      [media] v4l: v4l2_subdev userspace format API - documentation binary files
      [media] v4l: v4l2_subdev userspace format API
      [media] v4l: v4l2_subdev userspace frame interval API
      [media] v4l: Add subdev sensor g_skip_frames operation
      [media] v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
      [media] v4l: Add remaining RAW10 patterns w DPCM pixel code variants
      [media] v4l: Add missing 12 bits bayer media bus formats
      [media] v4l: Add 12 bits bayer pixel formats
      [media] omap3: Add function to register omap3isp platform device structure
      [media] v4l: subdev: Generic ioctl support
      [media] omap3isp: Video devices and buffers queue
      [media] omap3isp: CCP2/CSI2 receivers
      [media] omap3isp: CCDC, preview engine and resizer
      [media] omap3isp: Kconfig and Makefile
      [media] omap3isp: Add set performance callback in isp platform data
      [media] media: Pick a free ioctls range
      [media] uvcvideo: Fix descriptor parsing for video output devices

Lawrence Rust (1):
      [media] Add proper audio support for Nova-S Plus with wm8775 ADC

Lukas Max Fisch (1):
      [media] Technisat AirStar TeleStick 2

Malcolm Priestley (6):
      [media] dvb_pll: DVB-S incorrect tune settings for dw2102/dm1105/cx88/opera1
      [media] v180 - DM04/QQBOX added support for BS2F7HZ0194 versions
      [media] DM04 LME2510(C) Sharp BS2F7HZ0194 Firmware Information
      [media] DM04/QQBOX Update V1.76 - use 32 bit remote decoding
      [media] Change to 32 bit and add other remote controls for lme2510
      [media] STV0288 added full frontend status

Manjunatha Halli (7):
      [media] drivers:media:radio: wl128x: FM Driver common header file
      [media] drivers:media:radio: wl128x: FM Driver V4L2 sources
      [media] drivers:media:radio: wl128x: FM Driver Common sources
      [media] drivers:media:radio: wl128x: FM driver RX sources
      [media] drivers:media:radio: wl128x: FM driver TX sources
      [media] drivers:media:radio: wl128x: Kconfig & Makefile for wl128x driver
      [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver

Marek Szyprowski (7):
      [media] v4l: videobuf2: add generic memory handling routines
      [media] v4l: videobuf2: add read() and write() emulator
      [media] v4l: mem2mem: port to videobuf2
      [media] v4l: mem2mem: port m2m_testdev to vb2
      [media] v4l2: vb2: fix queue reallocation and REQBUFS(0) case
      [media] v4l2: vb2: one more fix for REQBUFS()
      [media] v4l2: vb2: simplify __vb2_queue_free function

Mathias Krause (1):
      [media] V4L: omap1_camera: fix use after free

Matti Aaltonen (3):
      [media] MFD: WL1273 FM Radio: MFD driver for the FM radio
      [media] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver
      [media] ASoC: WL1273 FM radio: Access I2C IO functions through pointers

Mauro Carvalho Chehab (59):
      [media] technisat-usb2: Don't use a deprecated call
      [media] vb2 core: Fix a few printk warnings
      [media] dib7000p: Fix 4-byte wrong alignments for some case statements
      [media] dib8000: Fix some wrong alignments
      [media] Move CI cxd2099 driver to staging
      [media] ngene: Fix compilation when cxd2099 is not enabled
      [media] tuner-simple: add support for Tena TNF5337 MFD
      [media] saa7134: Properly report when a board doesn't have eeprom
      [media] add support for Encore FM3
      [media] technisat-usb2: CodingStyle cleanups
      [media] cx231xx: Simplify interface checking logic at probe
      [media] cx231xx: Use a generic check for TUNER_XC5000
      [media] cx231xx: Use parameters to describe some board variants
      [media] cx231xx: Allow some boards to not use I2C port 3
      [media] cx231xx: Add support for PV Xcapture USB
      [media] cx88: use unlocked_ioctl for cx88-video.
      [media] cx88: Don't allow opening a device while it is not ready
      [media] tuner-core: Remove V4L1/V4L2 API switch
      [media] tuner-core: remove the legacy is_stereo() call
      [media] tuner-core: move some messages to the proper place
      [media] tuner-core: Reorganize the functions internally
      [media] tuner-core: Some cleanups at check_mode/set_mode
      [media] tuner-core: Better implement standby mode
      [media] tuner-core: do the right thing for suspend/resume
      [media] tuner-core: CodingStyle cleanups
      [media] tuner-core: Don't use a static var for xc5000_cfg
      [media] tuner-core: dead code removal
      [media] tuner-core: Fix a few comments on it
      [media] Remove the remaining usages for T_STANDBY
      [media] tuner-core: remove usage of DIGITAL_TV
      [media] tuner-core: Improve function documentation
      [media] tuner-core: Rearrange some functions to better document
      [media] tuner-core: Don't touch at standby during tuner_lookup
      [media] tuner: Remove remaining usages of T_DIGITAL_TV
      [media] tvp5150: device detection should be done only once
      [media] em28xx: Fix return value for s_ctrl
      [media] em28xx: properly handle subdev controls
      matrox: Remove legacy VIDIOC_*_OLD ioctls
      [media] videodev2.h.xml: Update to reflect videodev2.h changes
      [media] DocBook: Document the removal of the old VIDIOC_*_OLD ioctls
      [media] DocBook/v4l2.xml: Update version of the spec
      [media] several drivers: Fix a few gcc 4.6 warnings
      [media] cpia2: Fix some gcc 4.6 warnings when debug is disabled
      [media] drivers/media/rc/Kconfig: use tabs, instead of spaces
      [media] ite-cir: Fix some CodingStyle issues
      [media] rc/keymaps: use KEY_CAMERA for snapshots
      [media] rc/keymaps: Use KEY_VIDEO for Video Source
      [media] rc/keymaps: Fix most KEY_PROG[n] keycodes
      [media] rc/keymaps: Use KEY_LEFTMETA were pertinent
      [media] dw2102: Use multimedia keys instead of an app-specific mapping
      [media] opera1: Use multimedia keys instead of an app-specific mapping
      [media] a800: Fix a few wrong IR key assignments
      [media] rc-winfast: Fix the keycode tables
      [media] rc-rc5-hauppauge-new: Add the old control to the table
      [media] rc-rc5-hauppauge-new: Add support for the old Black RC
      [media] rc-rc5-hauppauge-new: Fix Hauppauge Grey mapping
      [media] rc/keymaps: Rename Hauppauge table as rc-hauppauge
      [media] remove the old RC_MAP_HAUPPAUGE_NEW RC map
      [media] rc/keymaps: Remove the obsolete rc-rc5-tv keymap

Mike Isely (7):
      [media] pvrusb2: Handle change of mode before handling change of video standard
      [media] pvrusb2: Minor cosmetic code tweak
      [media] pvrusb2: Fix a few missing default control values, for cropping
      [media] pvrusb2: Minor VBI tweak to help potential CC support
      [media] pvrusb2: Use sysfs_attr_init() where appropriate
      [media] pvrusb2: Implement support for Terratec Grabster AV400
      [media] pvrusb2: Remove dead code

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

Patrice Chotard (1):
      [media] gspca - main: Add endpoint direction test in alt_xfer

Patrick Boettcher (3):
      [media] stv090x: added function to control GPIOs from the outside
      [media] stv090x: add tei-field to config-structure
      [media] technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver

Paul Cassella (3):
      [media] Documentation: README.ivtv: Remove note that ivtvfb is not yet in the kernel
      [media] ivtv: udma: handle get_user_pages() returning fewer pages than we asked for
      [media] ivtv: yuv: handle get_user_pages() -errno returns

Pawel Osciak (16):
      [media] v4l: Add multi-planar API definitions to the V4L2 API
      [media] v4l: Add multi-planar ioctl handling code
      [media] v4l: Add compat functions for the multi-planar API
      [media] v4l: add videobuf2 Video for Linux 2 driver framework
      [media] v4l: videobuf2: add vmalloc allocator
      [media] v4l: videobuf2: add DMA coherent allocator
      [media] Fix mmap() example in the V4L2 API DocBook
      [media] Add multi-planar API documentation
      [media] v4l: vivi: port to videobuf2
      [media] Remove compatibility layer from multi-planar API documentation
      [media] Make 2.6.39 not 2.6.38 the version when Multi-planar API was added
      [media] Update Pawel Osciak's e-mail address
      [media] vb2: vb2_poll() fix return values for file I/O mode
      [media] vb2: Handle return value from start_streaming callback
      [media] sh_mobile_ceu_camera: Do not call vb2's mem_ops directly
      [media] videobuf2-dma-contig: make cookie() return a pointer to dma_addr_t

Peter Huewe (2):
      [media] video/cx231xx: Fix sparse warning: Using plain integer as NULL pointer
      [media] video/saa7164: Fix sparse warning: Using plain integer as NULL pointer

Qing Xu (2):
      [media] V4L: add enum_mbus_fsizes video operation
      [media] V4L: soc-camera: add enum-frame-size ioctl

Ralph Metzler (3):
      [media] ngene: CXD2099AR Common Interface driver
      [media] ngene: Shutdown workaround
      [media] ngene: Add net device

Randy Dunlap (1):
      [media] media/radio/wl1273: fix build errors

Sakari Ailus (4):
      [media] v4l: subdev: Events support
      [media] media: Entity graph traversal
      [media] omap3isp: OMAP3 ISP core
      [media] omap3isp: Add documentation

Sergio Aguirre (3):
      [media] omap3: Remove unusued ISP CBUFF resource
      [media] omap2: Fix camera resources for multiomap
      [media] v4l: soc-camera: Store negotiated buffer settings

Servaas Vandenberghe (1):
      [media] pvrusb2: width and height maximum values

Stanimir Varbanov (1):
      [media] v4l: Create v4l2 subdev file handle structure

Stefan Richter (1):
      [media] firedtv: drop obsolete backend abstraction

Stefan Ringel (1):
      [media] tm6000: relabeling any registers

Stephan Lachowsky (1):
      [media] uvcvideo: Fix uvc_fixup_video_ctrl() format search

Steven Rostedt (1):
      [media] saa7134: Fix strange kconfig dependency on RC_CORE

Sungchun Kang (2):
      [media] s5p-fimc: fimc_stop_capture bug fix
      [media] s5p-fimc: fix ISR and buffer handling for fimc-capture

Sylwester Nawrocki (20):
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
      [media] s5p-fimc: Prevent oops when i2c adapter is not available
      [media] s5p-fimc: Prevent hanging on device close and fix the locking
      [media] s5p-fimc: Allow defining number of sensors at runtime
      [media] s5p-fimc: Add a platform data entry for MIPI-CSI data alignment
      [media] s5p-fimc: Use dynamic debug
      [media] s5p-fimc: Fix G_FMT ioctl handler

Tejun Heo (1):
      [media] radio-wl1273: remove unused wl1273_device->work

Thomas Weber (1):
      [media] omap24xxcam: Fix compilation

Tuukka Toivonen (1):
      [media] ARM: OMAP3: Update Camera ISP definitions for OMAP3630

Vadim Solomin (1):
      [media] saa7134-input: key up events not sent after suspend/resume

Vasiliy Kulikov (1):
      [media] video: sn9c102: world-wirtable sysfs files

Xiaochen Wang (1):
      [media] pvrusb2: check kmalloc return value

iceberg (1):
      [media] double mutex lock in drivers/media/radio/si470x/radio-si470x-

 Documentation/ABI/testing/sysfs-bus-media          |    6 +
 Documentation/DocBook/Makefile                     |    5 +-
 Documentation/DocBook/media-entities.tmpl          |   59 +
 Documentation/DocBook/media.tmpl                   |    3 +
 Documentation/DocBook/v4l/bayer.pdf                |  Bin 0 -> 12116 bytes
 Documentation/DocBook/v4l/bayer.png                |  Bin 0 -> 9725 bytes
 Documentation/DocBook/v4l/common.xml               |    2 +
 Documentation/DocBook/v4l/compat.xml               |   26 +-
 Documentation/DocBook/v4l/dev-capture.xml          |   13 +-
 Documentation/DocBook/v4l/dev-output.xml           |   13 +-
 Documentation/DocBook/v4l/dev-subdev.xml           |  313 ++
 Documentation/DocBook/v4l/func-mmap.xml            |   10 +-
 Documentation/DocBook/v4l/func-munmap.xml          |    3 +-
 Documentation/DocBook/v4l/io.xml                   |  283 ++-
 .../DocBook/v4l/lirc_device_interface.xml          |    2 +-
 Documentation/DocBook/v4l/media-controller.xml     |   89 +
 Documentation/DocBook/v4l/media-func-close.xml     |   59 +
 Documentation/DocBook/v4l/media-func-ioctl.xml     |  116 +
 Documentation/DocBook/v4l/media-func-open.xml      |   94 +
 .../DocBook/v4l/media-ioc-device-info.xml          |  133 +
 .../DocBook/v4l/media-ioc-enum-entities.xml        |  308 ++
 Documentation/DocBook/v4l/media-ioc-enum-links.xml |  207 ++
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |   93 +
 Documentation/DocBook/v4l/nv12mt.gif               |  Bin 0 -> 2108 bytes
 Documentation/DocBook/v4l/nv12mt_example.gif       |  Bin 0 -> 6858 bytes
 Documentation/DocBook/v4l/pipeline.pdf             |  Bin 0 -> 20276 bytes
 Documentation/DocBook/v4l/pipeline.png             |  Bin 0 -> 12130 bytes
 Documentation/DocBook/v4l/pixfmt-nv12m.xml         |  154 +
 Documentation/DocBook/v4l/pixfmt-nv12mt.xml        |   74 +
 Documentation/DocBook/v4l/pixfmt-srggb12.xml       |   90 +
 Documentation/DocBook/v4l/pixfmt-yuv420m.xml       |  162 +
 Documentation/DocBook/v4l/pixfmt.xml               |  119 +-
 Documentation/DocBook/v4l/planar-apis.xml          |   62 +
 Documentation/DocBook/v4l/subdev-formats.xml       | 2467 +++++++++++++
 Documentation/DocBook/v4l/v4l2.xml                 |   30 +-
 Documentation/DocBook/v4l/videodev2.h.xml          |  141 +-
 Documentation/DocBook/v4l/vidioc-enum-fmt.xml      |    2 +
 Documentation/DocBook/v4l/vidioc-g-fmt.xml         |   15 +-
 Documentation/DocBook/v4l/vidioc-qbuf.xml          |   24 +-
 Documentation/DocBook/v4l/vidioc-querybuf.xml      |   14 +-
 Documentation/DocBook/v4l/vidioc-querycap.xml      |   18 +-
 Documentation/DocBook/v4l/vidioc-streamon.xml      |    9 +
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |  152 +
 .../DocBook/v4l/vidioc-subdev-enum-frame-size.xml  |  154 +
 .../DocBook/v4l/vidioc-subdev-enum-mbus-code.xml   |  119 +
 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml |  155 +
 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml  |  180 +
 .../DocBook/v4l/vidioc-subdev-g-frame-interval.xml |  141 +
 Documentation/dvb/get_dvb_firmware                 |    8 +-
 Documentation/dvb/lmedm04.txt                      |   16 +-
 Documentation/feature-removal-schedule.txt         |   36 -
 Documentation/ioctl/ioctl-number.txt               |    1 +
 Documentation/media-framework.txt                  |  353 ++
 Documentation/video4linux/README.ivtv              |    3 +-
 Documentation/video4linux/gspca.txt                |   10 +
 Documentation/video4linux/omap3isp.txt             |  278 ++
 Documentation/video4linux/v4l2-framework.txt       |  267 ++-
 MAINTAINERS                                        |    6 +
 arch/arm/mach-omap2/devices.c                      |   63 +-
 arch/arm/mach-omap2/devices.h                      |   19 +
 arch/arm/plat-omap/include/plat/omap34xx.h         |   16 +-
 drivers/media/Kconfig                              |   22 +
 drivers/media/Makefile                             |    6 +
 drivers/media/common/tuners/tda9887.c              |    9 +-
 drivers/media/common/tuners/tea5761.c              |   33 +-
 drivers/media/common/tuners/tuner-types.c          |   21 +
 drivers/media/common/tuners/tuner-xc2028.c         |   16 +-
 drivers/media/common/tuners/xc5000.c               |   56 +-
 drivers/media/common/tuners/xc5000.h               |    1 +
 drivers/media/dvb/Kconfig                          |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    1 -
 drivers/media/dvb/dvb-usb/Kconfig                  |    8 +
 drivers/media/dvb/dvb-usb/Makefile                 |    3 +
 drivers/media/dvb/dvb-usb/a800.c                   |    8 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |   67 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |    1 +
 drivers/media/dvb/dvb-usb/dib0700.h                |    2 +
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   47 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        | 1381 +++++++-
 drivers/media/dvb/dvb-usb/digitv.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    7 +
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 +
 drivers/media/dvb/dvb-usb/dw2102.c                 |  590 +++-
 drivers/media/dvb/dvb-usb/lmedm04.c                |  235 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   33 +-
 drivers/media/dvb/dvb-usb/technisat-usb2.c         |  807 +++++
 drivers/media/dvb/firewire/Kconfig                 |    8 +-
 drivers/media/dvb/firewire/Makefile                |    5 +-
 drivers/media/dvb/firewire/firedtv-1394.c          |  300 --
 drivers/media/dvb/firewire/firedtv-avc.c           |   15 +-
 drivers/media/dvb/firewire/firedtv-dvb.c           |  135 +-
 drivers/media/dvb/firewire/firedtv-fe.c            |    8 +-
 drivers/media/dvb/firewire/firedtv-fw.c            |  146 +-
 drivers/media/dvb/firewire/firedtv.h               |   45 +-
 drivers/media/dvb/frontends/Kconfig                |   15 +
 drivers/media/dvb/frontends/Makefile               |    2 +
 drivers/media/dvb/frontends/af9013.c               |   55 +-
 drivers/media/dvb/frontends/dib0090.c              | 1583 +++++++--
 drivers/media/dvb/frontends/dib0090.h              |   31 +
 drivers/media/dvb/frontends/dib7000p.c             | 1945 ++++++++---
 drivers/media/dvb/frontends/dib7000p.h             |   96 +-
 drivers/media/dvb/frontends/dib8000.c              |  821 +++--
 drivers/media/dvb/frontends/dib8000.h              |   20 +
 drivers/media/dvb/frontends/dib9000.c              | 2351 +++++++++++++
 drivers/media/dvb/frontends/dib9000.h              |  131 +
 drivers/media/dvb/frontends/dibx000_common.c       |  279 ++-
 drivers/media/dvb/frontends/dibx000_common.h       |  152 +-
 drivers/media/dvb/frontends/ds3000.c               |  645 ++--
 drivers/media/dvb/frontends/ds3000.h               |    3 +
 drivers/media/dvb/frontends/dvb-pll.c              |   79 +-
 drivers/media/dvb/frontends/stv0288.c              |    7 +-
 drivers/media/dvb/frontends/stv0367.c              | 3459 +++++++++++++++++++
 drivers/media/dvb/frontends/stv0367.h              |   66 +
 drivers/media/dvb/frontends/stv0367_priv.h         |  212 ++
 drivers/media/dvb/frontends/stv0367_regs.h         | 3614 ++++++++++++++++++++
 drivers/media/dvb/frontends/stv0900.h              |    2 +
 drivers/media/dvb/frontends/stv0900_core.c         |   27 +-
 drivers/media/dvb/frontends/stv090x.c              |  295 ++-
 drivers/media/dvb/frontends/stv090x.h              |   16 +
 drivers/media/dvb/frontends/stv090x_reg.h          |   16 +-
 drivers/media/dvb/frontends/zl10036.c              |   10 +-
 drivers/media/dvb/ngene/Makefile                   |    3 +
 drivers/media/dvb/ngene/ngene-cards.c              |  179 +-
 drivers/media/dvb/ngene/ngene-core.c               |  236 +-
 drivers/media/dvb/ngene/ngene-dvb.c                |   71 +-
 drivers/media/dvb/ngene/ngene.h                    |   24 +
 drivers/media/dvb/siano/sms-cards.c                |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   15 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |    1 +
 drivers/media/media-device.c                       |  382 +++
 drivers/media/media-devnode.c                      |  320 ++
 drivers/media/media-entity.c                       |  536 +++
 drivers/media/radio/Kconfig                        |    4 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/dsbr100.c                      |  128 +-
 drivers/media/radio/radio-si4713.c                 |    3 +-
 drivers/media/radio/radio-wl1273.c                 |  365 +--
 drivers/media/radio/si470x/radio-si470x-common.c   |    1 -
 drivers/media/radio/wl128x/Kconfig                 |   17 +
 drivers/media/radio/wl128x/Makefile                |    6 +
 drivers/media/radio/wl128x/fmdrv.h                 |  244 ++
 drivers/media/radio/wl128x/fmdrv_common.c          | 1677 +++++++++
 drivers/media/radio/wl128x/fmdrv_common.h          |  402 +++
 drivers/media/radio/wl128x/fmdrv_rx.c              |  847 +++++
 drivers/media/radio/wl128x/fmdrv_rx.h              |   59 +
 drivers/media/radio/wl128x/fmdrv_tx.c              |  425 +++
 drivers/media/radio/wl128x/fmdrv_tx.h              |   37 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |  580 ++++
 drivers/media/radio/wl128x/fmdrv_v4l2.h            |   33 +
 drivers/media/rc/Kconfig                           |   35 +-
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/imon.c                            |   11 +-
 drivers/media/rc/ir-nec-decoder.c                  |   10 +-
 drivers/media/rc/ite-cir.c                         | 1736 ++++++++++
 drivers/media/rc/ite-cir.h                         |  481 +++
 drivers/media/rc/keymaps/Makefile                  |    6 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |    6 +-
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |    4 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |    2 +-
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |    2 +-
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |    2 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |    2 +-
 drivers/media/rc/keymaps/rc-behold.c               |    2 +-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |    3 +-
 drivers/media/rc/keymaps/rc-cinergy.c              |    2 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |    2 +-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |    4 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |    2 +-
 drivers/media/rc/keymaps/rc-flydvb.c               |    4 +-
 drivers/media/rc/keymaps/rc-hauppauge-new.c        |  100 -
 drivers/media/rc/keymaps/rc-hauppauge.c            |  241 ++
 drivers/media/rc/keymaps/rc-imon-mce.c             |    2 +-
 drivers/media/rc/keymaps/rc-imon-pad.c             |    2 +-
 drivers/media/rc/keymaps/rc-kworld-315u.c          |    2 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |    2 +-
 drivers/media/rc/keymaps/rc-lme2510.c              |   96 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |    2 +-
 drivers/media/rc/keymaps/rc-nebula.c               |    2 +-
 drivers/media/rc/keymaps/rc-norwood.c              |    2 +-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |    2 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |    2 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |    2 +-
 drivers/media/rc/keymaps/rc-pixelview.c            |    2 +-
 drivers/media/rc/keymaps/rc-pv951.c                |    4 +-
 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c    |  141 -
 drivers/media/rc/keymaps/rc-rc5-tv.c               |   81 -
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    2 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |    2 +-
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |   93 +
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |   72 +
 drivers/media/rc/keymaps/rc-winfast.c              |   22 +-
 drivers/media/rc/mceusb.c                          |    4 +-
 drivers/media/video/Kconfig                        |   58 +-
 drivers/media/video/Makefile                       |   12 +-
 drivers/media/video/adv7343.c                      |  167 +-
 drivers/media/video/adv7343_regs.h                 |    8 +-
 drivers/media/video/au0828/au0828-cards.c          |    3 +-
 drivers/media/video/au0828/au0828-dvb.c            |    3 -
 drivers/media/video/au0828/au0828-video.c          |    4 -
 drivers/media/video/bt819.c                        |  129 +-
 drivers/media/video/bt8xx/bttv-cards.c             |    2 +-
 drivers/media/video/bt8xx/bttv-input.c             |    2 -
 drivers/media/video/cpia2/cpia2_core.c             |   34 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |  374 +--
 drivers/media/video/cs5345.c                       |   87 +-
 drivers/media/video/cx18/cx18-av-audio.c           |   92 +-
 drivers/media/video/cx18/cx18-av-core.c            |  175 +-
 drivers/media/video/cx18/cx18-av-core.h            |   12 +-
 drivers/media/video/cx18/cx18-controls.c           |  285 +--
 drivers/media/video/cx18/cx18-controls.h           |    7 +-
 drivers/media/video/cx18/cx18-driver.c             |   31 +-
 drivers/media/video/cx18/cx18-driver.h             |   16 +-
 drivers/media/video/cx18/cx18-fileops.c            |   52 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx18/cx18-ioctl.c              |  152 +-
 drivers/media/video/cx18/cx18-mailbox.c            |    5 +-
 drivers/media/video/cx18/cx18-mailbox.h            |    5 -
 drivers/media/video/cx18/cx18-streams.c            |   17 +-
 drivers/media/video/cx18/cx23418.h                 |    2 +-
 drivers/media/video/cx231xx/cx231xx-417.c          |    4 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |   14 +-
 drivers/media/video/cx231xx/cx231xx-cards.c        |  246 +-
 drivers/media/video/cx231xx/cx231xx-core.c         |   16 +-
 drivers/media/video/cx231xx/cx231xx-i2c.c          |   31 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |   20 +-
 drivers/media/video/cx231xx/cx231xx.h              |    7 +-
 drivers/media/video/cx23885/Kconfig                |   12 +-
 drivers/media/video/cx23885/Makefile               |    1 +
 drivers/media/video/cx23885/altera-ci.c            |  838 +++++
 drivers/media/video/cx23885/altera-ci.h            |  100 +
 drivers/media/video/cx23885/cx23885-cards.c        |  110 +-
 drivers/media/video/cx23885/cx23885-core.c         |   37 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |  175 +-
 drivers/media/video/cx23885/cx23885-input.c        |    2 +-
 drivers/media/video/cx23885/cx23885-reg.h          |    1 +
 drivers/media/video/cx23885/cx23885-video.c        |    7 +-
 drivers/media/video/cx23885/cx23885.h              |    7 +-
 drivers/media/video/cx88/cx88-alsa.c               |  118 +-
 drivers/media/video/cx88/cx88-cards.c              |   24 +-
 drivers/media/video/cx88/cx88-dvb.c                |   23 +
 drivers/media/video/cx88/cx88-input.c              |    5 +-
 drivers/media/video/cx88/cx88-tvaudio.c            |    8 +-
 drivers/media/video/cx88/cx88-video.c              |   78 +-
 drivers/media/video/cx88/cx88.h                    |   14 +-
 drivers/media/video/davinci/vpfe_capture.c         |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   10 +-
 drivers/media/video/em28xx/em28xx-video.c          |   33 +-
 drivers/media/video/gspca/Kconfig                  |   19 +
 drivers/media/video/gspca/Makefile                 |    4 +
 drivers/media/video/gspca/autogain_functions.h     |  179 +
 drivers/media/video/gspca/cpia1.c                  |   37 +-
 drivers/media/video/gspca/gspca.c                  |   16 +-
 drivers/media/video/gspca/jeilinj.c                |    2 -
 drivers/media/video/gspca/nw80x.c                  | 2145 ++++++++++++
 drivers/media/video/gspca/ov519.c                  |  208 +-
 drivers/media/video/gspca/ov534.c                  |  980 ++++---
 drivers/media/video/gspca/sn9c20x.c                |   40 +-
 drivers/media/video/gspca/sonixb.c                 |  306 +--
 drivers/media/video/gspca/sonixj.c                 |  353 ++-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |    2 -
 drivers/media/video/gspca/vicam.c                  |  381 ++
 drivers/media/video/gspca/zc3xx-reg.h              |    2 -
 drivers/media/video/gspca/zc3xx.c                  |  128 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c              |   72 +-
 drivers/media/video/ir-kbd-i2c.c                   |   18 +-
 drivers/media/video/ivtv/ivtv-driver.h             |    2 -
 drivers/media/video/ivtv/ivtv-fileops.c            |    3 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    5 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |  159 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    1 +
 drivers/media/video/ivtv/ivtv-udma.c               |    7 +-
 drivers/media/video/ivtv/ivtv-vbi.c                |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c                |   52 +-
 drivers/media/video/mem2mem_testdev.c              |  231 +-
 drivers/media/video/meye.c                         |    3 +-
 drivers/media/video/mt9m001.c                      |    2 +-
 drivers/media/video/mt9v022.c                      |    4 +-
 drivers/media/video/mx3_camera.c                   |  415 ++--
 drivers/media/video/mxb.c                          |    3 +-
 drivers/media/video/noon010pc30.c                  |  792 +++++
 drivers/media/video/omap1_camera.c                 |   66 +-
 drivers/media/video/omap24xxcam.c                  |    1 +
 drivers/media/video/omap3isp/Makefile              |   13 +
 drivers/media/video/omap3isp/cfa_coef_table.h      |   61 +
 drivers/media/video/omap3isp/gamma_table.h         |   90 +
 drivers/media/video/omap3isp/isp.c                 | 2220 ++++++++++++
 drivers/media/video/omap3isp/isp.h                 |  431 +++
 drivers/media/video/omap3isp/ispccdc.c             | 2268 ++++++++++++
 drivers/media/video/omap3isp/ispccdc.h             |  219 ++
 drivers/media/video/omap3isp/ispccp2.c             | 1173 +++++++
 drivers/media/video/omap3isp/ispccp2.h             |   98 +
 drivers/media/video/omap3isp/ispcsi2.c             | 1317 +++++++
 drivers/media/video/omap3isp/ispcsi2.h             |  166 +
 drivers/media/video/omap3isp/ispcsiphy.c           |  247 ++
 drivers/media/video/omap3isp/ispcsiphy.h           |   74 +
 drivers/media/video/omap3isp/isph3a.h              |  117 +
 drivers/media/video/omap3isp/isph3a_aewb.c         |  374 ++
 drivers/media/video/omap3isp/isph3a_af.c           |  429 +++
 drivers/media/video/omap3isp/isphist.c             |  520 +++
 drivers/media/video/omap3isp/isphist.h             |   40 +
 drivers/media/video/omap3isp/isppreview.c          | 2113 ++++++++++++
 drivers/media/video/omap3isp/isppreview.h          |  214 ++
 drivers/media/video/omap3isp/ispqueue.c            | 1153 +++++++
 drivers/media/video/omap3isp/ispqueue.h            |  187 +
 drivers/media/video/omap3isp/ispreg.h              | 1589 +++++++++
 drivers/media/video/omap3isp/ispresizer.c          | 1693 +++++++++
 drivers/media/video/omap3isp/ispresizer.h          |  147 +
 drivers/media/video/omap3isp/ispstat.c             | 1092 ++++++
 drivers/media/video/omap3isp/ispstat.h             |  169 +
 drivers/media/video/omap3isp/ispvideo.c            | 1255 +++++++
 drivers/media/video/omap3isp/ispvideo.h            |  202 ++
 drivers/media/video/omap3isp/luma_enhance_table.h  |   42 +
 drivers/media/video/omap3isp/noise_filter_table.h  |   30 +
 drivers/media/video/ov6650.c                       |   10 +-
 drivers/media/video/ov9740.c                       | 1009 ++++++
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c  |   18 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |   24 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   84 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |    9 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    2 -
 drivers/media/video/pwc/pwc-if.c                   |   38 +-
 drivers/media/video/pwc/pwc-v4l.c                  | 1033 +++---
 drivers/media/video/pwc/pwc.h                      |    3 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |  602 ++--
 drivers/media/video/s5p-fimc/fimc-core.c           | 1019 +++---
 drivers/media/video/s5p-fimc/fimc-core.h           |  180 +-
 drivers/media/video/s5p-fimc/fimc-reg.c            |  205 +-
 drivers/media/video/s5p-fimc/regs-fimc.h           |   29 +-
 drivers/media/video/saa7110.c                      |  115 +-
 drivers/media/video/saa7134/Kconfig                |    1 +
 drivers/media/video/saa7134/saa7134-cards.c        |   43 +-
 drivers/media/video/saa7134/saa7134-core.c         |   35 +-
 drivers/media/video/saa7134/saa7134-empress.c      |    4 +
 drivers/media/video/saa7134/saa7134-input.c        |   52 +-
 drivers/media/video/saa7134/saa7134.h              |    1 +
 drivers/media/video/saa7164/saa7164-api.c          |   10 +-
 drivers/media/video/saa7164/saa7164-buffer.c       |   16 +-
 drivers/media/video/saa7164/saa7164-bus.c          |    8 +-
 drivers/media/video/saa7164/saa7164-cmd.c          |   10 +-
 drivers/media/video/saa7164/saa7164-core.c         |    8 +-
 drivers/media/video/saa7164/saa7164-dvb.c          |    4 +-
 drivers/media/video/saa7164/saa7164-encoder.c      |    8 +-
 drivers/media/video/saa7164/saa7164-fw.c           |    2 +-
 drivers/media/video/saa7164/saa7164-vbi.c          |    8 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  274 +-
 drivers/media/video/sh_mobile_csi2.c               |    6 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |    6 +-
 drivers/media/video/soc_camera.c                   |  156 +-
 drivers/media/video/soc_mediabus.c                 |   16 +-
 drivers/media/video/tlg2300/pd-video.c             |    4 +-
 drivers/media/video/tlv320aic23b.c                 |   74 +-
 drivers/media/video/tuner-core.c                   | 1205 ++++---
 drivers/media/video/tvp514x.c                      |  236 +-
 drivers/media/video/tvp5150.c                      |  199 +-
 drivers/media/video/tvp7002.c                      |  117 +-
 drivers/media/video/uvc/uvc_driver.c               |    8 +
 drivers/media/video/uvc/uvc_video.c                |   14 +-
 drivers/media/video/v4l2-common.c                  |   64 -
 drivers/media/video/v4l2-compat-ioctl32.c          |  244 ++-
 drivers/media/video/v4l2-ctrls.c                   |    2 +
 drivers/media/video/v4l2-dev.c                     |  152 +-
 drivers/media/video/v4l2-device.c                  |  101 +-
 drivers/media/video/v4l2-fh.c                      |   47 +
 drivers/media/video/v4l2-ioctl.c                   |  669 +++-
 drivers/media/video/v4l2-mem2mem.c                 |  236 +-
 drivers/media/video/v4l2-subdev.c                  |  332 ++
 drivers/media/video/via-camera.c                   |  147 +-
 drivers/media/video/videobuf-dma-contig.c          |    2 +-
 drivers/media/video/videobuf2-core.c               | 1819 ++++++++++
 drivers/media/video/videobuf2-dma-contig.c         |  185 +
 drivers/media/video/videobuf2-dma-sg.c             |  294 ++
 drivers/media/video/videobuf2-memops.c             |  235 ++
 drivers/media/video/videobuf2-vmalloc.c            |  132 +
 drivers/media/video/vivi.c                         |  579 ++--
 drivers/media/video/vpx3220.c                      |  137 +-
 drivers/media/video/wm8775.c                       |  126 +-
 drivers/mfd/Kconfig                                |    2 +-
 drivers/mfd/wl1273-core.c                          |  149 +-
 drivers/staging/Kconfig                            |    8 +-
 drivers/staging/Makefile                           |    5 +-
 drivers/staging/altera-stapl/Kconfig               |    8 +
 drivers/staging/altera-stapl/Makefile              |    3 +
 drivers/staging/altera-stapl/altera-comp.c         |  142 +
 drivers/staging/altera-stapl/altera-exprt.h        |   33 +
 drivers/staging/altera-stapl/altera-jtag.c         | 1020 ++++++
 drivers/staging/altera-stapl/altera-jtag.h         |  113 +
 drivers/staging/altera-stapl/altera-lpt.c          |   70 +
 drivers/staging/altera-stapl/altera.c              | 2527 ++++++++++++++
 drivers/staging/cx25821/Kconfig                    |    1 -
 drivers/staging/cx25821/cx25821-alsa.c             |    2 +
 drivers/staging/cx25821/cx25821-core.c             |   16 +-
 drivers/staging/cx25821/cx25821-video.c            |    9 +-
 drivers/staging/cx25821/cx25821.h                  |    3 +-
 drivers/staging/cxd2099/Kconfig                    |   11 +
 drivers/staging/cxd2099/Makefile                   |    5 +
 drivers/staging/cxd2099/TODO                       |   12 +
 drivers/staging/cxd2099/cxd2099.c                  |  574 ++++
 drivers/staging/cxd2099/cxd2099.h                  |   41 +
 drivers/staging/dabusb/Kconfig                     |   14 -
 drivers/staging/dabusb/Makefile                    |    2 -
 drivers/staging/dabusb/TODO                        |    5 -
 drivers/staging/dabusb/dabusb.c                    |  914 -----
 drivers/staging/dabusb/dabusb.h                    |   85 -
 drivers/staging/easycap/easycap_ioctl.c            |    5 -
 drivers/staging/lirc/Kconfig                       |   12 -
 drivers/staging/lirc/Makefile                      |    2 -
 drivers/staging/lirc/TODO.lirc_zilog               |   51 +-
 drivers/staging/lirc/lirc_imon.c                   |    2 +-
 drivers/staging/lirc/lirc_it87.c                   | 1027 ------
 drivers/staging/lirc/lirc_it87.h                   |  116 -
 drivers/staging/lirc/lirc_ite8709.c                |  542 ---
 drivers/staging/lirc/lirc_sasem.c                  |    2 +-
 drivers/staging/lirc/lirc_zilog.c                  |  814 +++--
 drivers/staging/se401/Kconfig                      |   13 -
 drivers/staging/se401/Makefile                     |    1 -
 drivers/staging/se401/TODO                         |    5 -
 drivers/staging/se401/se401.c                      | 1492 --------
 drivers/staging/se401/se401.h                      |  236 --
 drivers/staging/se401/videodev.h                   |  318 --
 drivers/staging/tm6000/tm6000-alsa.c               |   13 +-
 drivers/staging/tm6000/tm6000-cards.c              |  102 +-
 drivers/staging/tm6000/tm6000-core.c               |  298 ++-
 drivers/staging/tm6000/tm6000-regs.h               |   63 +-
 drivers/staging/tm6000/tm6000-stds.c               |   35 +-
 drivers/staging/tm6000/tm6000-video.c              |  344 ++-
 drivers/staging/tm6000/tm6000.h                    |   25 +-
 drivers/staging/usbvideo/Kconfig                   |   15 -
 drivers/staging/usbvideo/Makefile                  |    2 -
 drivers/staging/usbvideo/TODO                      |    5 -
 drivers/staging/usbvideo/usbvideo.c                | 2230 ------------
 drivers/staging/usbvideo/usbvideo.h                |  395 ---
 drivers/staging/usbvideo/vicam.c                   |  952 ------
 drivers/staging/usbvideo/videodev.h                |  318 --
 drivers/video/matrox/matroxfb_base.c               |    3 -
 include/linux/Kbuild                               |    4 +
 include/linux/media.h                              |  132 +
 include/linux/mfd/wl1273-core.h                    |    2 +
 include/linux/omap3isp.h                           |  646 ++++
 include/linux/v4l2-mediabus.h                      |  108 +
 include/linux/v4l2-subdev.h                        |  141 +
 include/linux/videodev2.h                          |  146 +-
 include/media/media-device.h                       |   95 +
 include/media/media-devnode.h                      |   97 +
 include/media/media-entity.h                       |  151 +
 include/media/noon010pc30.h                        |   28 +
 include/media/rc-map.h                             |    6 +-
 include/media/{s3c_fimc.h => s5p_fimc.h}           |   27 +-
 include/media/soc_camera.h                         |   24 +-
 include/media/soc_mediabus.h                       |    4 +-
 include/media/tuner.h                              |   16 +-
 include/media/v4l2-chip-ident.h                    |    4 +
 include/media/v4l2-common.h                        |   15 -
 include/media/v4l2-dev.h                           |   46 +-
 include/media/v4l2-device.h                        |   24 +
 include/media/v4l2-fh.h                            |   29 +
 include/media/v4l2-ioctl.h                         |   18 +-
 include/media/v4l2-mediabus.h                      |   61 +-
 include/media/v4l2-mem2mem.h                       |   58 +-
 include/media/v4l2-subdev.h                        |  113 +-
 include/media/videobuf2-core.h                     |  380 ++
 include/media/videobuf2-dma-contig.h               |   32 +
 include/media/videobuf2-dma-sg.h                   |   32 +
 include/media/videobuf2-memops.h                   |   45 +
 include/media/videobuf2-vmalloc.h                  |   20 +
 include/media/wm8775.h                             |    9 +
 include/staging/altera.h                           |   49 +
 sound/soc/codecs/Kconfig                           |    2 +-
 sound/soc/codecs/wl1273.c                          |   11 +-
 470 files changed, 77845 insertions(+), 19362 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-media
 create mode 100644 Documentation/DocBook/v4l/bayer.pdf
 create mode 100644 Documentation/DocBook/v4l/bayer.png
 create mode 100644 Documentation/DocBook/v4l/dev-subdev.xml
 create mode 100644 Documentation/DocBook/v4l/media-controller.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-close.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-ioctl.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-open.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-device-info.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-entities.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-links.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-setup-link.xml
 create mode 100644 Documentation/DocBook/v4l/nv12mt.gif
 create mode 100644 Documentation/DocBook/v4l/nv12mt_example.gif
 create mode 100644 Documentation/DocBook/v4l/pipeline.pdf
 create mode 100644 Documentation/DocBook/v4l/pipeline.png
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12m.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12mt.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb12.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuv420m.xml
 create mode 100644 Documentation/DocBook/v4l/planar-apis.xml
 create mode 100644 Documentation/DocBook/v4l/subdev-formats.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml
 create mode 100644 Documentation/media-framework.txt
 create mode 100644 Documentation/video4linux/omap3isp.txt
 create mode 100644 arch/arm/mach-omap2/devices.h
 create mode 100644 drivers/media/dvb/dvb-usb/technisat-usb2.c
 delete mode 100644 drivers/media/dvb/firewire/firedtv-1394.c
 create mode 100644 drivers/media/dvb/frontends/dib9000.c
 create mode 100644 drivers/media/dvb/frontends/dib9000.h
 create mode 100644 drivers/media/dvb/frontends/stv0367.c
 create mode 100644 drivers/media/dvb/frontends/stv0367.h
 create mode 100644 drivers/media/dvb/frontends/stv0367_priv.h
 create mode 100644 drivers/media/dvb/frontends/stv0367_regs.h
 create mode 100644 drivers/media/media-device.c
 create mode 100644 drivers/media/media-devnode.c
 create mode 100644 drivers/media/media-entity.c
 create mode 100644 drivers/media/radio/wl128x/Kconfig
 create mode 100644 drivers/media/radio/wl128x/Makefile
 create mode 100644 drivers/media/radio/wl128x/fmdrv.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_common.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_rx.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_tx.h
 create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.c
 create mode 100644 drivers/media/radio/wl128x/fmdrv_v4l2.h
 create mode 100644 drivers/media/rc/ite-cir.c
 create mode 100644 drivers/media/rc/ite-cir.h
 delete mode 100644 drivers/media/rc/keymaps/rc-hauppauge-new.c
 create mode 100644 drivers/media/rc/keymaps/rc-hauppauge.c
 delete mode 100644 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
 delete mode 100644 drivers/media/rc/keymaps/rc-rc5-tv.c
 create mode 100644 drivers/media/rc/keymaps/rc-technisat-usb2.c
 create mode 100644 drivers/media/rc/keymaps/rc-terratec-slim-2.c
 create mode 100644 drivers/media/video/cx23885/altera-ci.c
 create mode 100644 drivers/media/video/cx23885/altera-ci.h
 create mode 100644 drivers/media/video/gspca/autogain_functions.h
 create mode 100644 drivers/media/video/gspca/nw80x.c
 create mode 100644 drivers/media/video/gspca/vicam.c
 create mode 100644 drivers/media/video/noon010pc30.c
 create mode 100644 drivers/media/video/omap3isp/Makefile
 create mode 100644 drivers/media/video/omap3isp/cfa_coef_table.h
 create mode 100644 drivers/media/video/omap3isp/gamma_table.h
 create mode 100644 drivers/media/video/omap3isp/isp.c
 create mode 100644 drivers/media/video/omap3isp/isp.h
 create mode 100644 drivers/media/video/omap3isp/ispccdc.c
 create mode 100644 drivers/media/video/omap3isp/ispccdc.h
 create mode 100644 drivers/media/video/omap3isp/ispccp2.c
 create mode 100644 drivers/media/video/omap3isp/ispccp2.h
 create mode 100644 drivers/media/video/omap3isp/ispcsi2.c
 create mode 100644 drivers/media/video/omap3isp/ispcsi2.h
 create mode 100644 drivers/media/video/omap3isp/ispcsiphy.c
 create mode 100644 drivers/media/video/omap3isp/ispcsiphy.h
 create mode 100644 drivers/media/video/omap3isp/isph3a.h
 create mode 100644 drivers/media/video/omap3isp/isph3a_aewb.c
 create mode 100644 drivers/media/video/omap3isp/isph3a_af.c
 create mode 100644 drivers/media/video/omap3isp/isphist.c
 create mode 100644 drivers/media/video/omap3isp/isphist.h
 create mode 100644 drivers/media/video/omap3isp/isppreview.c
 create mode 100644 drivers/media/video/omap3isp/isppreview.h
 create mode 100644 drivers/media/video/omap3isp/ispqueue.c
 create mode 100644 drivers/media/video/omap3isp/ispqueue.h
 create mode 100644 drivers/media/video/omap3isp/ispreg.h
 create mode 100644 drivers/media/video/omap3isp/ispresizer.c
 create mode 100644 drivers/media/video/omap3isp/ispresizer.h
 create mode 100644 drivers/media/video/omap3isp/ispstat.c
 create mode 100644 drivers/media/video/omap3isp/ispstat.h
 create mode 100644 drivers/media/video/omap3isp/ispvideo.c
 create mode 100644 drivers/media/video/omap3isp/ispvideo.h
 create mode 100644 drivers/media/video/omap3isp/luma_enhance_table.h
 create mode 100644 drivers/media/video/omap3isp/noise_filter_table.h
 create mode 100644 drivers/media/video/ov9740.c
 create mode 100644 drivers/media/video/v4l2-subdev.c
 create mode 100644 drivers/media/video/videobuf2-core.c
 create mode 100644 drivers/media/video/videobuf2-dma-contig.c
 create mode 100644 drivers/media/video/videobuf2-dma-sg.c
 create mode 100644 drivers/media/video/videobuf2-memops.c
 create mode 100644 drivers/media/video/videobuf2-vmalloc.c
 create mode 100644 drivers/staging/altera-stapl/Kconfig
 create mode 100644 drivers/staging/altera-stapl/Makefile
 create mode 100644 drivers/staging/altera-stapl/altera-comp.c
 create mode 100644 drivers/staging/altera-stapl/altera-exprt.h
 create mode 100644 drivers/staging/altera-stapl/altera-jtag.c
 create mode 100644 drivers/staging/altera-stapl/altera-jtag.h
 create mode 100644 drivers/staging/altera-stapl/altera-lpt.c
 create mode 100644 drivers/staging/altera-stapl/altera.c
 create mode 100644 drivers/staging/cxd2099/Kconfig
 create mode 100644 drivers/staging/cxd2099/Makefile
 create mode 100644 drivers/staging/cxd2099/TODO
 create mode 100644 drivers/staging/cxd2099/cxd2099.c
 create mode 100644 drivers/staging/cxd2099/cxd2099.h
 delete mode 100644 drivers/staging/dabusb/Kconfig
 delete mode 100644 drivers/staging/dabusb/Makefile
 delete mode 100644 drivers/staging/dabusb/TODO
 delete mode 100644 drivers/staging/dabusb/dabusb.c
 delete mode 100644 drivers/staging/dabusb/dabusb.h
 delete mode 100644 drivers/staging/lirc/lirc_it87.c
 delete mode 100644 drivers/staging/lirc/lirc_it87.h
 delete mode 100644 drivers/staging/lirc/lirc_ite8709.c
 delete mode 100644 drivers/staging/se401/Kconfig
 delete mode 100644 drivers/staging/se401/Makefile
 delete mode 100644 drivers/staging/se401/TODO
 delete mode 100644 drivers/staging/se401/se401.c
 delete mode 100644 drivers/staging/se401/se401.h
 delete mode 100644 drivers/staging/se401/videodev.h
 delete mode 100644 drivers/staging/usbvideo/Kconfig
 delete mode 100644 drivers/staging/usbvideo/Makefile
 delete mode 100644 drivers/staging/usbvideo/TODO
 delete mode 100644 drivers/staging/usbvideo/usbvideo.c
 delete mode 100644 drivers/staging/usbvideo/usbvideo.h
 delete mode 100644 drivers/staging/usbvideo/vicam.c
 delete mode 100644 drivers/staging/usbvideo/videodev.h
 create mode 100644 include/linux/media.h
 create mode 100644 include/linux/omap3isp.h
 create mode 100644 include/linux/v4l2-mediabus.h
 create mode 100644 include/linux/v4l2-subdev.h
 create mode 100644 include/media/media-device.h
 create mode 100644 include/media/media-devnode.h
 create mode 100644 include/media/media-entity.h
 create mode 100644 include/media/noon010pc30.h
 rename include/media/{s3c_fimc.h => s5p_fimc.h} (69%)
 create mode 100644 include/media/videobuf2-core.h
 create mode 100644 include/media/videobuf2-dma-contig.h
 create mode 100644 include/media/videobuf2-dma-sg.h
 create mode 100644 include/media/videobuf2-memops.h
 create mode 100644 include/media/videobuf2-vmalloc.h
 create mode 100644 include/staging/altera.h

