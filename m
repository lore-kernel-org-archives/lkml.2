Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1G2Rbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1G2Rbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:31:41 -0400
Message-ID: <4E32EE71.4030908@redhat.com>
Date: Fri, 29 Jul 2011 14:31:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.0] media updates for v3.1
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For the usual updates for drivers/media. This series have a two contextual
merge conflicts with current tip, already solved at -next.

Among other things, it contains:
	- V4L2 core improvements to better handle video controls;
	- several new embedded drivers for TI DaVinci, Marvel CCIC,
	  Samsung Exynos4 and TI Omap;
	- new drivers: xc4000, drxk, ddbridge, tda18271c2dd, adp1653,
	  se401 and ov5642;
	- Docbook updates for both DVB and V4L2 API;
	- The Docbook build are now smarter: it auto-generates some index
	  files and creates some cross-references, helping to detect 
	  documentation gaps between the spec and the code.
	- Don't return -EINVAL to mean that an ioctl is not available;
	- Several driver additions;
	- em28xx now exports the internal AC97 mixers to userspace;
	- major rework at pwc driver, fixing several bugs on it.
	- usual bug fixes, driver improvements, and new board additions.

Thanks!
Mauro

-

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Abylay Ospan (3):
      [media] NetUP Dual DVB-T/C CI RF: load firmware according card revision
      [media] Don't OOPS if videobuf_dvb_get_frontend return NULL
      [media] NetUP Dual DVB-T/C CI RF: force card hardware revision by module param

Adam M. Dutko (1):
      [media] TM6000: alsa: Clean up kernel coding style errors

Alexey Khoroshilov (1):
      [media] radio-si470x: fix memory leak in si470x_usb_driver_probe()

Amber Jain (5):
      [media] V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
      [media] OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
      [media] V4L2: OMAP: VOUT: isr handling extended for DPI and HDMI interface
      [media] V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in qbuf and dqbuf
      [media] V4l2: OMAP: VOUT: Minor Cleanup, removing the unnecessary code

Andre Bartke (1):
      [media] drivers/media/video: fix memory leak of snd_cx18_init()

Andreas Oberritter (1):
      [media] DVB: dvb_frontend: fix dtv_property_dump for DTV_DVBT2_PLP_ID

Andrew Chew (6):
      [media] V4L: ov9740: Cleanup hex casing inconsistencies
      [media] V4L: ov9740: Correct print in ov9740_reg_rmw()
      [media] V4L: ov9740: Fixed some settings
      [media] V4L: ov9740: Remove hardcoded resolution regs
      [media] V4L: ov9740: Reorder video and core ops
      [media] V4L: ov9740: Add suspend/resume

Andy Walls (1):
      [media] cx23885: Add IR Rx support for HVR-1270 boards

Antti Palosaari (14):
      [media] anysee: add support for Anysee E7 PTC
      [media] anysee: add support for Anysee E7 PS2
      [media] anysee: style issues, comments, etc
      [media] cxd2820r: malloc buffers instead of stack
      [media] cxd2820r: fix bitfields
      [media] em28xx: EM28174 remote support
      [media] em28xx: add remote for PCTV nanoStick T2 290e
      [media] em28xx: correct PCTV nanoStick T2 290e device name
      [media] cxd2820r: correct missing error checks
      [media] af9015: map remote for MSI DIGIVOX Duo
      [media] af9015: small optimization
      [media] af9015: add more I2C msg checks
      [media] af9015: remove old FW based IR polling code
      [media] af9015: remove 2nd I2C-adapter

Archit Taneja (3):
      [media] OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
      [media] OMAP_VOUT: CLEANUP: Make rotation related helper functions more descriptive
      [media] OMAP_VOUT: Create separate file for VRFB related API's

Bastian Hecht (1):
      [media] V4L: initial driver for ov5642 CMOS sensor

Bjørn Mork (2):
      [media] V4L1 API has been moved into "legacy" on the linuxtv.org site
      [media] DVB API: Mention the dvbM device

Carlos Corbacho (1):
      [media] Make Compro VideoMate Vista T750F actually work

Dan Carpenter (4):
      [media] saa7164: poll mask set incorrectly
      [media] rc: double unlock in rc_register_device()
      [media] rc/redrat3: dereferencing null pointer
      [media] DVB: dvb_frontend: off by one in dtv_property_dump()

David Härdeman (2):
      [media] rc-core: fix winbond-cir issues
      [media] rc-core: lirc use unsigned int

Davide Ferri (1):
      [media] dib0700: add initial code for PCTV 340e by Davide Ferri

Devin Heitmueller (27):
      [media] dib0700: add USB id for PCTV 340eSE
      [media] dib0700: properly setup GPIOs for PCTV 340e
      [media] dib0700: successfully connect to xc4000 over i2c for PCTV 340e
      [media] dib0700: add a sleep before attempting to detect dib7000p
      [media] dib7000p: setup dev.parent for i2c master built into 7000p
      [media] xc4000: pull in firmware management code from xc3028
      [media] xc4000: cut over to using xc5000 version for loading i2c sequences
      [media] xc4000: properly set type for init1 firmware
      [media] xc4000: remove XREG_BUSY code only supported in xc5000
      [media] xc4000: remove xc5000 firmware loading routine
      [media] xc4000: add code to do standard and scode firmware loading
      [media] xc4000: continued cleanup of the firmware loading routine
      [media] xc4000: use if_khz provided in xc4000_config
      [media] xc4000: setup dib7000p AGC config for PCTV 340e
      [media] xc4000: handle dib0700 broken i2c stretching
      [media] dib0700: fixup PLL config for PCTV 340e
      [media] xc4000: get rid of hard-coded 8MHz firmware config
      [media] dib0700: make PCTV 340e work!
      [media] xc4000: turn off debug logging by default
      [media] xc4000: rename firmware image filename
      [media] xc4000: cleanup dmesg logging
      [media] dib0700: remove notes from bringup of PCTV 340e
      [media] cx88: properly maintain decoder config when using MPEG encoder
      [media] Fix regression introduced which broke the Hauppauge USBLive 2
      [media] cx231xx: Fix power ramping issue
      [media] cx231xx: Provide signal lock status in G_INPUT
      [media] au8522: set signal field to 100% when signal present

Emilio David Diaus Lopez (1):
      [media] af9015: add support for Sveon STV22 [1b80:e401]

Greg Dietsche (1):
      [media] dvb: remove unnecessary code

Guennadi Liakhovetski (20):
      [media] media: DVB_NET must depend on DVB_CORE
      [media] V4L: mx3_camera: remove redundant calculations
      [media] V4L: pxa_camera: remove redundant calculations
      [media] V4L: pxa-camera: try to force progressive video format
      [media] V4L: pxa-camera: switch to using subdev .s_power() core operation
      [media] V4L: mx2_camera: .try_fmt shouldn't fail
      [media] V4L: sh_mobile_ceu_camera: remove redundant calculations
      [media] V4L: tw9910: remove bogus ENUMINPUT implementation
      [media] V4L: soc-camera: MIPI flags are not sensor flags
      [media] V4L: mt9m111: propagate higher level abstraction down in functions
      [media] V4L: mt9m111: switch to v4l2-subdev .s_power() method
      [media] V4L: soc-camera: remove several now unused soc-camera client operations
      [media] V4L: pxa-camera: switch to using standard PM hooks
      [media] V4L: soc-camera: remove now unused soc-camera specific PM hooks
      [media] V4L: soc-camera: group struct field initialisations together
      [media] V4L: add media bus configuration subdev operations
      [media] V4L: sh_mobile_csi2: switch away from using the soc-camera bus notifier
      [media] V4L: soc-camera: un-export the soc-camera bus
      [media] V4L: soc-camera: remove soc-camera bus and devices on it
      [media] V4L: sh_mobile_ceu_camera: fix Oops when USERPTR mapping fails

Hans Petter Selasky (7):
      [media] Fix compile warning: Dereferencing type-punned pointer will break strict-aliasing rules
      [media] Make DVB NET configurable in the kernel
      [media] itd1000: Don't reuse core macro names
      [media] cx24113: Don't reuse core macro names
      [media] Correct error code from -ENOMEM to -EINVAL.
      [media] Remove unused definitions which can cause conflict with definitions in usb/ch9.h
      [media] Correct and add some parameter descriptions

Hans Verkuil (39):
      [media] v4l2-ctrls: introduce call_op define
      [media] v4l2-ctrls: simplify error_idx handling
      [media] v4l2-ctrls: drivers should be able to ignore the READ_ONLY flag
      [media] v4l2-ioctl: add ctrl_handler to v4l2_fh
      [media] v4l2-subdev: implement per-filehandle control handlers
      [media] v4l2-ctrls: fix and improve volatile control handling
      [media] v4l2-controls.txt: update to latest v4l2-ctrl.c changes
      [media] v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
      [media] Documentation: Improve cluster documentation and document the new autoclusters
      [media] vivi: add autogain/gain support to test the autocluster functionality
      [media] v4l2-ctrls: add v4l2_fh pointer to the set control functions
      [media] v4l2-ctrls: add control events
      [media] v4l2-ctrls: simplify event subscription
      [media] V4L2 spec: document control events
      [media] vivi: support control events
      [media] ivtv: add control event support
      [media] v4l2-compat-ioctl32: add VIDIOC_DQEVENT support
      [media] v4l2-ctrls: make manual_mode_value 8 bits and check against control range
      [media] v4l2-events/fh: merge v4l2_events into v4l2_fh
      [media] v4l2-ctrls/event: remove struct v4l2_ctrl_fh, instead use v4l2_subscribed_event
      [media] v4l2-event/ctrls/fh: allocate events per fh and per type instead of just per-fh
      [media] v4l2-event: add optional merge and replace callbacks
      [media] v4l2-ctrls: don't initially set CH_VALUE for write-only controls
      [media] v4l2-ctrls: improve discovery of controls of the same cluster
      [media] v4l2-ctrls: split try_or_set_ext_ctrls()
      [media] v4l2-ctrls: v4l2_ctrl_handler_setup code simplification
      [media] v4l2-framework.txt: updated v4l2_fh_init documentation
      [media] v4l2-framework.txt: update v4l2_event section
      [media] DocBook: update V4L Event Interface section
      [media] v4l2-ctrls/v4l2-events: small coding style cleanups
      [media] v4l2-event.h: add overview documentation to the header
      [media] v4l2-ctrls.c: add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK
      [media] v4l2-ctrls.c: copy-and-paste error: user_to_new -> new_to_user
      [media] v4l2-ctrls: always send an event if a control changed implicitly
      [media] DocBook: fix typo: vl42_plane_pix_format -> v4l2_plane_pix_format
      [media] vivi: Fix sleep-in-atomic-context
      [media] v4l2-ctrls: add new bitmask control type
      [media] vivi: add bitmask test control
      [media] DocBook: document V4L2_CTRL_TYPE_BITMASK

Hans de Goede (21):
      [media] videodev2.h Add SE401 compressed RGB format
      [media] gspca: reset image_len to 0 on LAST_PACKET when discarding frame
      [media] gspca: Add new se401 camera driver
      [media] gspca_sunplus: Fix streaming on logitech quicksmart 420
      [media] gspca: s/strncpy/strlcpy/
      [media] pwc: Remove a bunch of bogus sanity checks / don't return EFAULT wrongly
      [media] pwc: remove __cplusplus guards from private header
      [media] pwc: Replace private buffer management code with videobuf2
      [media] pwc: Fix non CodingStyle compliant 3 space indent in pwc.h
      [media] pwc: Get rid of error_status and unplugged variables
      [media] pwc: Remove some unused PWC_INT_PIPE left overs
      [media] pwc: Make power-saving a per device option
      [media] pwc: Move various initialization to driver load and / or stream start
      [media] pwc: Allow multiple opens
      [media] pwc: properly allocate dma-able memory for ISO buffers
      [media] pwc: Replace control code with v4l2-ctrls framework
      [media] pwc: Allow dqbuf / read to complete while waiting for controls
      [media] pwc: Add v4l2 controls for pan/tilt on Logitech QuickCam Orbit/Sphere
      [media] pwc: Add a bunch of pwc custom API to feature-removal-schedule.txt
      [media] pwc: Enable power-management by default on tested models
      [media] pwc: clean-up header files

Istvan Varga (19):
      [media] xc4000: code cleanup
      [media] xc4000: updated standards table
      [media] xc4000: added support for 7 MHz DVB-T
      [media] xc4000: added mutex
      [media] xc4000: fixed frequency error
      [media] xc4000: added firmware_name parameter
      [media] xc4000: simplified seek_firmware()
      [media] xc4000: simplified load_scode
      [media] xc4000: check_firmware() cleanup
      [media] xc4000: added card_type
      [media] xc4000: implemented power management
      [media] xc4000: firmware initialization
      [media] xc4000: debug message improvements
      [media] xc4000: setting registers
      [media] xc4000: added audio_std module parameter
      [media] xc4000: implemented analog TV and radio
      [media] xc4000: xc_tune_channel() cleanup
      [media] xc4000: removed redundant tuner reset
      [media] xc4000: detect also xc4100

Jarod Wilson (5):
      [media] rc-rc6-mce: minor keymap updates
      [media] rc-core support for Microsoft IR keyboard/mouse
      [media] redrat3: sending extra trailing space was useless
      [media] redrat3: cap duration in the right place
      [media] redrat3: improve compat with lirc userspace decode

Jean Delvare (1):
      [media] tea5764: Fix module parameter permissions

Jean-François Moine (4):
      [media] gspca - ov519: New sensor ov9600 with bridge ovfx2
      [media] v4l: Documentation about the JPGL pixel format
      [media] gspca - ov519: Fix sensor detection problems
      [media] gspca - ov519: Fix a LED inversion

Jesper Juhl (2):
      [media] drivers/media: static should be at beginning of declaration
      [media] media, Micronas dvb-t: Fix mem leaks, don't needlessly zero mem, fix spelling

Jiri Slaby (1):
      [media] DVB: dvb-net, make the kconfig text helpful

Joe Perches (1):
      [media] media: Convert vmalloc/memset to vzalloc

Johannes Obermaier (3):
      [media] mt9v011: Fixed incorrect value for the first valid column
      [media] mt9v011: Added exposure for mt9v011
      [media] mt9v011: Fixed gain calculation

Jonathan Corbet (21):
      [media] marvell-cam: Move cafe-ccic into its own directory
      [media] marvell-cam: Separate out the Marvell camera core
      [media] marvell-cam: Pass sensor parameters from the platform
      [media] marvell-cam: Remove the "untested" comment
      [media] marvell-cam: Move Cafe-specific register definitions to cafe-driver.c
      [media] marvell-cam: Right-shift i2c slave ID's in the cafe driver
      [media] marvell-cam: Allocate the i2c adapter in the platform driver
      [media] marvell-cam: Basic working MMP camera driver
      [media] marvell-cam: convert to videobuf2
      [media] marvell-cam: include file cleanup
      [media] marvell-cam: no need to initialize the DMA buffers
      [media] marvell-cam: Don't spam the logs on frame loss
      [media] marvell-cam: implement contiguous DMA operation
      [media] marvell-cam: Working s/g DMA
      [media] marvell-cam: use S/G DMA by default
      [media] marvell-cam: delete struct mcam_sio_buffer
      [media] marvell-cam: core code reorganization
      [media] marvell-cam: remove {min,max}_buffers parameters
      [media] marvell-cam: power down mmp camera on registration failure
      [media] marvell-cam: Allow selection of supported buffer modes
      [media] marvell-cam: clean up a couple of unused cam structure fields

Josh Wu (1):
      [media] V4L: at91: add Atmel Image Sensor Interface (ISI) support

Juergen Lock (1):
      [media] af9015: setup rc keytable for LC-Power LC-USB-DVBT

Julia Lawall (2):
      [media] drivers/media/video: add missing kfree
      [media] drivers/media/video/cx231xx/cx231xx-cards.c: add missing kfree

Justin P. Mattock (1):
      [media] frontends/s5h1420: Change: clock_settting to clock_setting

Kalle Jokiniemi (2):
      [media] OMAP3: ISP: Add regulator control for omap34xx
      [media] OMAP3: RX-51: define vdds_csib regulator supply

Kamil Debski (4):
      [media] v4l: add fourcc definitions for compressed formats
      [media] v4l: add control definitions for codec devices
      [media] v4l2-ctrl: add codec controls support to the control framework
      [media] MFC: Add MFC 5.1 V4L2 driver

Kirill Smelkov (1):
      [media] uvcvideo: Add FIX_BANDWIDTH quirk to HP Webcam on HP Mini 5103 netbook

Laurent Pinchart (2):
      [media] omap3isp: Support configurable HS/VS polarities
      [media] v4l: mt9v032: Fix Bayer pattern

Manjunath Hadli (6):
      [media] davinci vpbe: V4L2 display driver for DM644X SoC
      [media] davinci vpbe: VPBE display driver
      [media] davinci vpbe: OSD(On Screen Display) block
      [media] davinci vpbe: VENC( Video Encoder) implementation
      [media] davinci vpbe: Build infrastructure for VPBE driver
      [media] davinci vpbe: Readme text for Dm6446 vpbe

Manoel Pinheiro (1):
      [media] dvb-usb.h function rc5_scan

Mauro Carvalho Chehab (127):
      [media] DocBook: Add rules to auto-generate some media docbook
      [media] DocBook: Move all media docbook stuff into its own directory
      [media] em28xx: use the proper prefix for board names
      [media] Update several cardlists
      dvb_net: Simplify the code if DVB NET is not defined
      [media] xc4000: Fix a few bad whitespaces on it
      [media] xc4000: make checkpatch.pl happy
      [media] DocBook/Makefile: add references for several dvb structures
      [media] DocBook/frontend.xml: Better document fe_type_t
      [media] DocBook/frontend.xml: Link DVB S2API parameters
      [media] DocBook/frontend.xml: Correlate dvb delivery systems
      [media] DocBook/frontend.xml: add references for some missing info
      [media] DocBook/frontend.xml: Better describe the frontend parameters
      [media] DocBook/dvbproperty.xml: Document the remaining S2API parameters
      [media] DocBook/dvbproperty.xml: Use links for all parameters
      [media] DocBook/dvbproperty.xml: Reorganize the parameters
      [media] DocBook/frontend.xml: Recomend the usage of the new API
      [media] DocBook/dvbproperty.xml: Document the terrestrial delivery systems
      [media] DocBook: Finish synchronizing the frontend API
      [media] DocBook/dvbproperty.xml: Add Cable standards
      [media] DocBook/dvbproperty.xml: Add ATSC standard
      [media] DocBook/dvbproperty.xml: Add Satellite standards
      [media] DocBook/dvbproperty.xml: Better name the ISDB-T layers
      [media] DocBook: Add the other DVB API header files
      [media] DocBook/audio.xml: match section ID's with the reference links
      [media] DocBook/audio.xml: synchronize attribute changes
      [media] DocBook: Document AUDIO_CONTINUE ioctl
      [media] dvb/audio.h: Remove definition for AUDIO_GET_PTS
      [media] Docbook/ca.xml: match section ID's with the reference links
      [media] DocBook/ca.xml: Describe structure ca_pid
      [media] DocBook/demux.xml: Fix section references with dmx.h.xml
      [media] DocBook/demux.xml: Add the remaining data structures to the API spec
      [media] DocBook/net.xml: Synchronize Network data structure
      [media] DocBook/Makefile: Remove osd.h header
      [media] DocBook/video.xml: Fix section references with video.h.xml
      [media] DocBook/video.xml: Document the remaining data structures
      Revert "[media] dvb/audio.h: Remove definition for AUDIO_GET_PTS"
      [media] DocBook: Don't be noisy at make cleanmediadocs
      [media] DocBook: Use base64 for gif/png files
      [media] em28xx: Don't initialize a var if won't be using it
      [media] em28xx: Fix a wrong enum at the ac97 control tables
      [media] em28xx: Allow to compile it without RC/input support
      [media] em28xx-alsa: add mixer support for AC97 volume controls
      [media] em28xx-audio: add support for mute controls
      [media] em28xx-audio: volumes are inverted
      [media] em28xx-audio: add debug info for the volume control
      [media] em28xx-audio: Properly report failures to start stream
      [media] em28xx-audio: Some Alsa API fixes
      [media] em28xx: Add support for devices with a separate audio interface
      [media] em28xx: Mark Kworld 305 as validated
      [media] DocBook/v4l: Remove references to the old V4L1 compat layer
      [media] v4l2-ioctl: Add a default value for kernel version
      [media] drxd, siano: Remove unused include linux/version.h
      [media] Stop using linux/version.h on most video drivers
      [media] pwc: Use the default version for VIDIOC_QUERYCAP
      [media] ivtv,cx18: Use default version control for VIDIOC_QUERYCAP
      [media] et61x251: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
      [media] pvrusb2: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
      [media] sn9c102: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
      [media] uvcvideo: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
      [media] gspca: don't include linux/version.h
      [media] Stop using linux/version.h on the remaining video drivers
      [media] radio: Use the subsystem version control for VIDIOC_QUERYCAP
      [media] DocBook/v4l: Document the new system-wide version behavior
      [media] DocBook: Add a chapter to describe media errors
      [media] DocBook: Use the generic ioctl error codes for all V4L ioctl's
      [media] DocBook: Use the generic error code page also for MC API
      [media] DocBook/media-ioc-setup-link.xml: Remove EBUSY
      [media] DocBook: Remove V4L generic error description for ioctl()
      [media] DocBook: Add an error code session for LIRC interface
      [media] DocBook: Add return error codes to LIRC ioctl session
      [media] siano: bad parameter is -EINVAL and not -EFAULT
      [media] nxt6000: i2c bus error should return -EIO
      [media] DVB: Point to the generic error chapter
      [media] DocBook/audio.xml: Remove generic errors
      [media] DocBook/demux.xml: Remove generic errors
      [media] dvb-bt8xx: Don't return -EFAULT when a device is not found
      [media] DocBook/dvb: Use generic descriptions for the frontend API
      [media] DocBook/dvb: Use generic descriptions for the video API
      [media] v4l2 core: return -ENOTTY if an ioctl doesn't exist
      [media] return -ENOTTY for unsupported ioctl's at legacy drivers
      [media] v4l2-ctrls: Fix a merge conflict
      [media] drxd/drxk: Don't export MulDiv32 symbol
      [media] drxk: Remove the CHK_ERROR macro
      [media] tda18271c2dd: Remove the CHK_ERROR macro
      [media] drxk: Return -EINVAL if an invalid bandwidth is used
      [media] drxk: fix warning: ‘status’ may be used uninitialized in this function
      cxd2099: Remove the CHK_ERROR macro
      [media] ddbridge: Avoid duplicated symbol definition
      [media] ddbridge: use linux/io.h, instead of asm/io.h
      [media] drxk: add drxk prefix to the errors
      [media] tda18271c2dd: add tda18271c2dd prefix to the errors
      [media] drxk: Add debug printk's
      [media] drxk: remove _0 from read/write routines
      [media] drxk: Move I2C address into a config structure
      [media] drxk: Convert an #ifdef logic as a new config parameter
      [media] drxk: Avoid OOPSes if firmware is corrupted
      [media] drxk: Print an error if firmware is not loaded
      [media] Add initial support for Terratec H5
      [media] drxk: Add a parameter for the microcode name
      [media] em28xx-i2c: Add a read after I2C write
      [media] drxk: Allow to disable I2C Bridge control switch
      [media] drxk: Proper handle/propagate the error codes
      [media] drxk: change mode before calling the set mode routines
      [media] drxk: Fix the antenna switch logic
      [media] drxk: Print detected configuration
      [media] drxk: Improves the UIO handling
      [media] drxk: Fix driver removal
      [media] drxk: Simplify the DVB-C set mode logic
      [media] drxk: Improve the scu_command error message
      [media] drxk: Add a fallback method for QAM parameter setting
      [media] em28xx: Change firmware name for Terratec H5 DRX-K
      [media] drxk: remove a now unused variable
      [media] dvb: don't cause missing symbols for drxk/tda18271c2dd
      [media] tda18271c2dd.h: Don't add the same symbol twice
      tda18271c2dd: Fix compilation when module is not selected
      [media] tm6000: remove a check for NO_PCM_LOCK
      Revert "[media] DVB: dvb_frontend: off by one in dtv_property_dump()"
      [media] em28xx: Add other Terratec H5 USB ID's
      [media] Remove the double symbol increment hack from drxk_hard
      [media] drxk: Fix a bug at some switches that broke DVB-T
      [media] drxk: Remove goto/break after return
      [media] drxk: Fix error return code during drxk init
      [media] drxk: Fix read debug message
      [media] drxk: Fix the logic that selects between DVB-C annex A and C
      [media] tda18271c2dd: Fix saw filter configuration for DVB-C @6MHz
      [media] em28xx: Fix DVB-C maxsize for em2884

Michael Grzeschik (2):
      [media] V4L: mt9m111: fix missing return value check mt9m111_reg_clear
      [media] V4L: mt9m111: rewrite set_pixfmt

Newson Edouard (1):
      [media] videobuf_pages_to_sg: sglist[0] length problem

Oliver Endriss (16):
      [media] tda18271c2dd: Lots of coding-style fixes
      [media] DRX-K: Shrink size of drxk_map.h
      [media] DRX-K: Tons of coding-style fixes
      [media] DRX-K, TDA18271c2: Add build support
      [media] get_dvb_firmware: Get DRX-K firmware for Digital Devices DVB-CT cards
      [media] ngene: Codingstyle fixes
      [media] ngene: Fix return code if no demux was found
      [media] ngene: Fix name of Digital Devices PCIe/miniPCIe
      [media] ngene: Support DuoFlex CT attached to CineS2 and SaTiX-S2
      [media] cxd2099: Codingstyle fixes
      [media] ngene: Update for latest cxd2099
      [media] ngene: Strip dummy packets inserted by the driver
      [media] ddbridge: Codingstyle fixes
      [media] ddbridge: Allow compiling of the driver
      [media] cxd2099: Fix compilation of ngene/ddbridge for DVB_CXD2099=n
      [media] cxd2099: Update Kconfig description (ddbridge support)

Ondrej Zary (4):
      [media] tea575x: convert to control framework
      [media] radio-sf16fmr2: convert to generic TEA575x interface
      [media] tea575x: allow multiple opens
      [media] tea575x: remove useless input ioctls

Peter Moon (1):
      [media] cx231xx: Add support for Hauppauge WinTV USB2-FM

Ralph Metzler (5):
      [media] tda18271c2dd: Initial check-in
      [media] DRX-K: Initial check-in
      [media] ngene: Support Digital Devices DuoFlex CT
      [media] cxd2099: Update to latest version
      [media] ddbridge: Initial check-in

Richard RÃƒÆ’Ã‚Â¶jfors (1):
      [media] radio-timb: Simplified platform data

Sakari Ailus (5):
      [media] v4l: Document EACCES in VIDIOC_[GS]_CTRL and VIDIOC_{G, S, TRY}_EXT_CTRLS
      [media] v4l: Add a class and a set of controls for flash devices
      [media] v4l: Add flash control documentation
      [media] adp1653: Add driver for LED flash controller
      [media] v4l: Document V4L2 control endianness as machine endianness

Sensoray Linux Development (1):
      [media] s2255drv: firmware version update, vendor request change

Sergei Shtylyov (1):
      [media] bt8xx: use pci_dev->subsystem_{vendor|device}

Stefan Richter (1):
      [media] firedtv: change some -EFAULT returns to more fitting error codes

Stephan Lachowsky (1):
      [media] uvcvideo: Fix control mapping for devices with multiple chains

Stephen Rothwell (2):
      [media] ov5642: include module.h for its facilities
      [media] ir-mce_kbd-decoder: include module.h for its facilities

Sylwester Nawrocki (1):
      [media] v4l: Fix minor typos in the documentation

Tejun Heo (2):
      [media] cx23885: restore flushes of cx23885_dev work items
      [media] dvb-usb/technisat-usb2: don't use flush_scheduled_work()

Tomasz Stanislawski (6):
      [media] v4l: add g_tvnorms_output callback to V4L2 subdev
      [media] v4l: add g_dv_preset callback to V4L2 subdev
      [media] v4l: add g_std_output callback to V4L2 subdev
      [media] v4l: s5p-tv: add drivers for HDMI on Samsung S5P platform
      [media] v4l: s5p-tv: add SDO driver for Samsung S5P platform
      [media] v4l: s5p-tv: add TV Mixer driver for Samsung S5P platform

Uwe Kleine-König (1):
      [media] V4L/videobuf2-memops: use pr_debug for debug messages

istvan_v@mailbox.hu (11):
      [media] xc4000: code cleanup
      [media] dvb-usb/Kconfig: auto-select XC4000 tuner for dib0700
      [media] xc4000: check firmware version
      [media] xc4000: removed card_type
      [media] cx88: added XC4000 tuner callback and DVB attach functions
      [media] cx88: added support for Leadtek WinFast DTV2000 H Plus
      [media] cx88: added support for Leadtek WinFast DTV1800 H with XC4000 tuner
      [media] cx88: replaced duplicated code with function call
      [media] cx23885: added support for card 107d:6f39
      [media] cx88: implemented sharpness control
      [media] cx88: implemented luma notch filter control

 Documentation/DocBook/.gitignore                   |    5 +-
 Documentation/DocBook/Makefile                     |   31 +-
 Documentation/DocBook/dvb/dvbproperty.xml          |  590 --
 Documentation/DocBook/dvb/dvbstb.png               |  Bin 22655 -> 0 bytes
 Documentation/DocBook/dvb/frontend.h.xml           |  428 --
 Documentation/DocBook/dvb/net.xml                  |   12 -
 Documentation/DocBook/media-entities.tmpl          |  464 --
 Documentation/DocBook/media-indices.tmpl           |   89 -
 Documentation/DocBook/media/Makefile               |  386 ++
 Documentation/DocBook/media/bayer.png.b64          |  171 +
 Documentation/DocBook/media/crop.gif.b64           |  105 +
 Documentation/DocBook/{ => media}/dvb/.gitignore   |    0
 Documentation/DocBook/{ => media}/dvb/audio.xml    |  488 +--
 Documentation/DocBook/{ => media}/dvb/ca.xml       |  112 +-
 Documentation/DocBook/{ => media}/dvb/demux.xml    |  327 +-
 Documentation/DocBook/{ => media}/dvb/dvbapi.xml   |   20 +
 Documentation/DocBook/media/dvb/dvbproperty.xml    |  859 +++
 Documentation/DocBook/{ => media}/dvb/dvbstb.pdf   |  Bin 1881 -> 1881 bytes
 Documentation/DocBook/{ => media}/dvb/examples.xml |    0
 Documentation/DocBook/{ => media}/dvb/frontend.xml |  776 +--
 Documentation/DocBook/{ => media}/dvb/intro.xml    |   23 +-
 Documentation/DocBook/{ => media}/dvb/kdapi.xml    |    0
 Documentation/DocBook/media/dvb/net.xml            |   29 +
 Documentation/DocBook/{ => media}/dvb/video.xml    |  638 +--
 Documentation/DocBook/media/dvbstb.png.b64         |  398 ++
 Documentation/DocBook/media/fieldseq_bt.gif.b64    |  447 ++
 Documentation/DocBook/media/fieldseq_tb.gif.b64    |  445 ++
 Documentation/DocBook/media/nv12mt.gif.b64         |   37 +
 Documentation/DocBook/media/nv12mt_example.gif.b64 |  121 +
 Documentation/DocBook/media/pipeline.png.b64       |  213 +
 Documentation/DocBook/{ => media}/v4l/.gitignore   |    0
 Documentation/DocBook/{ => media}/v4l/biblio.xml   |    0
 .../DocBook/{ => media}/v4l/capture.c.xml          |    0
 Documentation/DocBook/{ => media}/v4l/common.xml   |   10 +-
 Documentation/DocBook/{ => media}/v4l/compat.xml   |   30 +-
 Documentation/DocBook/media/v4l/controls.xml       | 3366 ++++++++++
 Documentation/DocBook/{ => media}/v4l/crop.pdf     |  Bin 5846 -> 5846 bytes
 .../DocBook/{ => media}/v4l/dev-capture.xml        |    0
 .../DocBook/{ => media}/v4l/dev-codec.xml          |    0
 .../DocBook/{ => media}/v4l/dev-effect.xml         |    0
 Documentation/DocBook/media/v4l/dev-event.xml      |   51 +
 Documentation/DocBook/{ => media}/v4l/dev-osd.xml  |    0
 .../DocBook/{ => media}/v4l/dev-output.xml         |    0
 .../DocBook/{ => media}/v4l/dev-overlay.xml        |    0
 .../DocBook/{ => media}/v4l/dev-radio.xml          |    0
 .../DocBook/{ => media}/v4l/dev-raw-vbi.xml        |    0
 Documentation/DocBook/{ => media}/v4l/dev-rds.xml  |    0
 .../DocBook/{ => media}/v4l/dev-sliced-vbi.xml     |    0
 .../DocBook/{ => media}/v4l/dev-subdev.xml         |    0
 .../DocBook/{ => media}/v4l/dev-teletext.xml       |    0
 Documentation/DocBook/{ => media}/v4l/driver.xml   |    0
 .../DocBook/{ => media}/v4l/fdl-appendix.xml       |    0
 .../DocBook/{ => media}/v4l/fieldseq_bt.pdf        |  Bin 9185 -> 9185 bytes
 .../DocBook/{ => media}/v4l/fieldseq_tb.pdf        |  Bin 9173 -> 9173 bytes
 .../DocBook/{ => media}/v4l/func-close.xml         |    0
 Documentation/DocBook/media/v4l/func-ioctl.xml     |   79 +
 .../DocBook/{ => media}/v4l/func-mmap.xml          |    0
 .../DocBook/{ => media}/v4l/func-munmap.xml        |    0
 .../DocBook/{ => media}/v4l/func-open.xml          |    0
 .../DocBook/{ => media}/v4l/func-poll.xml          |    0
 .../DocBook/{ => media}/v4l/func-read.xml          |    0
 .../DocBook/{ => media}/v4l/func-select.xml        |    0
 .../DocBook/{ => media}/v4l/func-write.xml         |    0
 Documentation/DocBook/media/v4l/gen-errors.xml     |   78 +
 Documentation/DocBook/{ => media}/v4l/io.xml       |    0
 .../DocBook/{ => media}/v4l/keytable.c.xml         |    0
 Documentation/DocBook/{ => media}/v4l/libv4l.xml   |    0
 .../{ => media}/v4l/lirc_device_interface.xml      |    4 +-
 .../DocBook/{ => media}/v4l/media-controller.xml   |    0
 .../DocBook/{ => media}/v4l/media-func-close.xml   |    0
 .../DocBook/media/v4l/media-func-ioctl.xml         |   73 +
 .../DocBook/{ => media}/v4l/media-func-open.xml    |    0
 .../{ => media}/v4l/media-ioc-device-info.xml      |    3 +-
 .../{ => media}/v4l/media-ioc-enum-entities.xml    |    0
 .../{ => media}/v4l/media-ioc-enum-links.xml       |    2 +-
 .../{ => media}/v4l/media-ioc-setup-link.xml       |    9 -
 Documentation/DocBook/{ => media}/v4l/pipeline.pdf |  Bin 20276 -> 20276 bytes
 .../DocBook/{ => media}/v4l/pixfmt-grey.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-m420.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-nv12.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-nv12m.xml       |    0
 .../DocBook/{ => media}/v4l/pixfmt-nv12mt.xml      |    0
 .../DocBook/{ => media}/v4l/pixfmt-nv16.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-packed-rgb.xml  |    0
 .../DocBook/{ => media}/v4l/pixfmt-packed-yuv.xml  |    0
 .../DocBook/{ => media}/v4l/pixfmt-sbggr16.xml     |    0
 .../DocBook/{ => media}/v4l/pixfmt-sbggr8.xml      |    0
 .../DocBook/{ => media}/v4l/pixfmt-sgbrg8.xml      |    0
 .../DocBook/{ => media}/v4l/pixfmt-sgrbg8.xml      |    0
 .../DocBook/{ => media}/v4l/pixfmt-srggb10.xml     |    0
 .../DocBook/{ => media}/v4l/pixfmt-srggb12.xml     |    0
 .../DocBook/{ => media}/v4l/pixfmt-srggb8.xml      |    0
 .../DocBook/{ => media}/v4l/pixfmt-uyvy.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-vyuy.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-y10.xml         |    0
 .../DocBook/{ => media}/v4l/pixfmt-y10b.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-y12.xml         |    0
 .../DocBook/{ => media}/v4l/pixfmt-y16.xml         |    0
 .../DocBook/{ => media}/v4l/pixfmt-y41p.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-yuv410.xml      |    0
 .../DocBook/{ => media}/v4l/pixfmt-yuv411p.xml     |    0
 .../DocBook/{ => media}/v4l/pixfmt-yuv420.xml      |    0
 .../DocBook/{ => media}/v4l/pixfmt-yuv420m.xml     |    0
 .../DocBook/{ => media}/v4l/pixfmt-yuv422p.xml     |    0
 .../DocBook/{ => media}/v4l/pixfmt-yuyv.xml        |    0
 .../DocBook/{ => media}/v4l/pixfmt-yvyu.xml        |    0
 Documentation/DocBook/{ => media}/v4l/pixfmt.xml   |   60 +-
 .../DocBook/{ => media}/v4l/planar-apis.xml        |    0
 .../DocBook/{ => media}/v4l/remote_controllers.xml |    0
 .../DocBook/{ => media}/v4l/subdev-formats.xml     |    5 +-
 Documentation/DocBook/{ => media}/v4l/v4l2.xml     |   13 +-
 .../DocBook/{ => media}/v4l/v4l2grab.c.xml         |    0
 Documentation/DocBook/{ => media}/v4l/vbi_525.pdf  |  Bin 3395 -> 3395 bytes
 Documentation/DocBook/{ => media}/v4l/vbi_625.pdf  |  Bin 3683 -> 3683 bytes
 .../DocBook/{ => media}/v4l/vbi_hsync.pdf          |  Bin 7405 -> 7405 bytes
 .../DocBook/{ => media}/v4l/vidioc-cropcap.xml     |   13 +-
 .../{ => media}/v4l/vidioc-dbg-g-chip-ident.xml    |   11 +-
 .../{ => media}/v4l/vidioc-dbg-g-register.xml      |   17 -
 .../DocBook/{ => media}/v4l/vidioc-dqevent.xml     |   27 +-
 .../DocBook/{ => media}/v4l/vidioc-encoder-cmd.xml |   11 +-
 .../{ => media}/v4l/vidioc-enum-dv-presets.xml     |    0
 .../DocBook/{ => media}/v4l/vidioc-enum-fmt.xml    |    0
 .../{ => media}/v4l/vidioc-enum-frameintervals.xml |   11 -
 .../{ => media}/v4l/vidioc-enum-framesizes.xml     |   11 -
 .../DocBook/{ => media}/v4l/vidioc-enumaudio.xml   |   12 +-
 .../{ => media}/v4l/vidioc-enumaudioout.xml        |   12 +-
 .../DocBook/{ => media}/v4l/vidioc-enuminput.xml   |    0
 .../DocBook/{ => media}/v4l/vidioc-enumoutput.xml  |    0
 .../DocBook/{ => media}/v4l/vidioc-enumstd.xml     |    0
 .../DocBook/{ => media}/v4l/vidioc-g-audio.xml     |   18 +-
 .../DocBook/{ => media}/v4l/vidioc-g-audioout.xml  |   18 +-
 .../DocBook/{ => media}/v4l/vidioc-g-crop.xml      |   17 -
 .../DocBook/{ => media}/v4l/vidioc-g-ctrl.xml      |    7 +
 .../DocBook/{ => media}/v4l/vidioc-g-dv-preset.xml |   12 +-
 .../{ => media}/v4l/vidioc-g-dv-timings.xml        |   11 +-
 .../DocBook/{ => media}/v4l/vidioc-g-enc-index.xml |   17 -
 .../DocBook/{ => media}/v4l/vidioc-g-ext-ctrls.xml |   14 +
 .../DocBook/{ => media}/v4l/vidioc-g-fbuf.xml      |   19 +-
 .../DocBook/{ => media}/v4l/vidioc-g-fmt.xml       |   20 +-
 .../DocBook/{ => media}/v4l/vidioc-g-frequency.xml |    0
 .../DocBook/{ => media}/v4l/vidioc-g-input.xml     |   19 +-
 .../DocBook/{ => media}/v4l/vidioc-g-jpegcomp.xml  |   17 -
 .../DocBook/{ => media}/v4l/vidioc-g-modulator.xml |    0
 .../DocBook/{ => media}/v4l/vidioc-g-output.xml    |   18 +-
 .../DocBook/{ => media}/v4l/vidioc-g-parm.xml      |   17 -
 .../DocBook/{ => media}/v4l/vidioc-g-priority.xml  |    3 +-
 .../{ => media}/v4l/vidioc-g-sliced-vbi-cap.xml    |   11 +-
 .../DocBook/{ => media}/v4l/vidioc-g-std.xml       |    9 +-
 .../DocBook/{ => media}/v4l/vidioc-g-tuner.xml     |    0
 .../DocBook/{ => media}/v4l/vidioc-log-status.xml  |   17 -
 .../DocBook/{ => media}/v4l/vidioc-overlay.xml     |   11 +-
 .../DocBook/{ => media}/v4l/vidioc-qbuf.xml        |   17 -
 .../{ => media}/v4l/vidioc-query-dv-preset.xml     |   22 -
 .../DocBook/{ => media}/v4l/vidioc-querybuf.xml    |    0
 .../DocBook/{ => media}/v4l/vidioc-querycap.xml    |   34 +-
 .../DocBook/{ => media}/v4l/vidioc-queryctrl.xml   |   12 +-
 .../DocBook/{ => media}/v4l/vidioc-querystd.xml    |   23 -
 .../DocBook/{ => media}/v4l/vidioc-reqbufs.xml     |   16 -
 .../{ => media}/v4l/vidioc-s-hw-freq-seek.xml      |    0
 .../DocBook/{ => media}/v4l/vidioc-streamon.xml    |   14 +-
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |    0
 .../v4l/vidioc-subdev-enum-frame-size.xml          |    0
 .../v4l/vidioc-subdev-enum-mbus-code.xml           |    0
 .../{ => media}/v4l/vidioc-subdev-g-crop.xml       |    0
 .../{ => media}/v4l/vidioc-subdev-g-fmt.xml        |    3 +
 .../v4l/vidioc-subdev-g-frame-interval.xml         |    0
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  297 +
 Documentation/DocBook/media/vbi_525.gif.b64        |   84 +
 Documentation/DocBook/media/vbi_625.gif.b64        |   90 +
 Documentation/DocBook/media/vbi_hsync.gif.b64      |   43 +
 .../DocBook/{media.tmpl => media_api.tmpl}         |    8 +-
 Documentation/DocBook/v4l/bayer.pdf                |  Bin 12116 -> 0 bytes
 Documentation/DocBook/v4l/bayer.png                |  Bin 9725 -> 0 bytes
 Documentation/DocBook/v4l/controls.xml             | 2103 -------
 Documentation/DocBook/v4l/crop.gif                 |  Bin 5967 -> 0 bytes
 Documentation/DocBook/v4l/dev-event.xml            |   31 -
 Documentation/DocBook/v4l/fieldseq_bt.gif          |  Bin 25430 -> 0 bytes
 Documentation/DocBook/v4l/fieldseq_tb.gif          |  Bin 25323 -> 0 bytes
 Documentation/DocBook/v4l/func-ioctl.xml           |  145 -
 Documentation/DocBook/v4l/media-func-ioctl.xml     |  116 -
 Documentation/DocBook/v4l/nv12mt.gif               |  Bin 2108 -> 0 bytes
 Documentation/DocBook/v4l/nv12mt_example.gif       |  Bin 6858 -> 0 bytes
 Documentation/DocBook/v4l/pipeline.png             |  Bin 12130 -> 0 bytes
 Documentation/DocBook/v4l/vbi_525.gif              |  Bin 4741 -> 0 bytes
 Documentation/DocBook/v4l/vbi_625.gif              |  Bin 5095 -> 0 bytes
 Documentation/DocBook/v4l/vbi_hsync.gif            |  Bin 2400 -> 0 bytes
 Documentation/DocBook/v4l/videodev2.h.xml          | 1946 ------
 .../DocBook/v4l/vidioc-subscribe-event.xml         |  133 -
 Documentation/dvb/get_dvb_firmware                 |   33 +-
 Documentation/feature-removal-schedule.txt         |   35 +
 Documentation/media-framework.txt                  |    2 +-
 Documentation/video4linux/API.html                 |    2 +-
 Documentation/video4linux/CARDLIST.cx23885         |    2 +
 Documentation/video4linux/CARDLIST.cx88            |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    2 +
 Documentation/video4linux/CARDLIST.saa7134         |    4 +
 Documentation/video4linux/CARDLIST.tuner           |    2 +
 Documentation/video4linux/CARDLIST.usbvision       |    2 +
 Documentation/video4linux/README.davinci-vpbe      |   93 +
 Documentation/video4linux/v4l2-controls.txt        |   69 +-
 Documentation/video4linux/v4l2-framework.txt       |   59 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    5 +
 arch/arm/mach-shmobile/board-ap4evb.c              |   12 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   13 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   15 +-
 drivers/media/Kconfig                              |   14 +-
 drivers/media/common/tuners/Kconfig                |   10 +
 drivers/media/common/tuners/Makefile               |    1 +
 drivers/media/common/tuners/tuner-types.c          |    4 +
 drivers/media/common/tuners/xc4000.c               | 1691 +++++
 drivers/media/common/tuners/xc4000.h               |   67 +
 drivers/media/dvb/Kconfig                          |    4 +
 drivers/media/dvb/Makefile                         |    3 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    4 +-
 drivers/media/dvb/ddbridge/Kconfig                 |   18 +
 drivers/media/dvb/ddbridge/Makefile                |   14 +
 drivers/media/dvb/ddbridge/ddbridge-core.c         | 1719 ++++++
 drivers/media/dvb/ddbridge/ddbridge-regs.h         |  151 +
 drivers/media/dvb/ddbridge/ddbridge.h              |  187 +
 drivers/media/dvb/dvb-core/Makefile                |    4 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    3 +-
 drivers/media/dvb/dvb-core/dvb_net.h               |   21 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    1 +
 drivers/media/dvb/dvb-usb/af9015.c                 |  135 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |    1 -
 drivers/media/dvb/dvb-usb/anysee.c                 |   69 +-
 drivers/media/dvb/dvb-usb/anysee.h                 |   16 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  188 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    3 +
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk.h                 |    3 -
 drivers/media/dvb/dvb-usb/technisat-usb2.c         |    4 +-
 drivers/media/dvb/dvb-usb/vp7045.h                 |    3 -
 drivers/media/dvb/firewire/firedtv-avc.c           |    2 +-
 drivers/media/dvb/firewire/firedtv-ci.c            |   34 +-
 drivers/media/dvb/frontends/Kconfig                |   21 +
 drivers/media/dvb/frontends/Makefile               |    3 +
 drivers/media/dvb/frontends/au8522_decoder.c       |    2 +-
 drivers/media/dvb/frontends/cx24113.c              |   20 +-
 drivers/media/dvb/frontends/cx24116.c              |    6 +-
 drivers/media/dvb/frontends/cxd2820r.h             |    4 +-
 drivers/media/dvb/frontends/cxd2820r_core.c        |   22 +-
 drivers/media/dvb/frontends/cxd2820r_priv.h        |    4 +-
 drivers/media/dvb/frontends/dib7000p.c             |    5 +
 drivers/media/dvb/frontends/drxd_hard.c            |    9 +-
 drivers/media/dvb/frontends/drxk.h                 |   47 +
 drivers/media/dvb/frontends/drxk_hard.c            | 6454 ++++++++++++++++++++
 drivers/media/dvb/frontends/drxk_hard.h            |  348 ++
 drivers/media/dvb/frontends/drxk_map.h             |  449 ++
 drivers/media/dvb/frontends/itd1000.c              |   25 +-
 drivers/media/dvb/frontends/nxt6000.c              |    2 +-
 drivers/media/dvb/frontends/s5h1420.c              |   12 +-
 drivers/media/dvb/frontends/tda18271c2dd.c         | 1251 ++++
 drivers/media/dvb/frontends/tda18271c2dd.h         |   16 +
 drivers/media/dvb/frontends/tda18271c2dd_maps.h    |  814 +++
 drivers/media/dvb/ngene/Kconfig                    |    2 +
 drivers/media/dvb/ngene/ngene-cards.c              |  182 +-
 drivers/media/dvb/ngene/ngene-core.c               |   26 +-
 drivers/media/dvb/ngene/ngene-dvb.c                |   46 +-
 drivers/media/dvb/ngene/ngene.h                    |    7 +-
 drivers/media/dvb/siano/smscoreapi.c               |    2 +-
 drivers/media/dvb/siano/smscoreapi.h               |    1 -
 drivers/media/radio/dsbr100.c                      |    7 +-
 drivers/media/radio/radio-aimslab.c                |    5 +-
 drivers/media/radio/radio-aztech.c                 |    5 +-
 drivers/media/radio/radio-cadet.c                  |    5 +-
 drivers/media/radio/radio-gemtek.c                 |    7 +-
 drivers/media/radio/radio-maxiradio.c              |   10 +-
 drivers/media/radio/radio-mr800.c                  |    6 +-
 drivers/media/radio/radio-rtrack2.c                |    5 +-
 drivers/media/radio/radio-sf16fmi.c                |    5 +-
 drivers/media/radio/radio-sf16fmr2.c               |  531 +--
 drivers/media/radio/radio-tea5764.c                |    8 +-
 drivers/media/radio/radio-terratec.c               |    5 +-
 drivers/media/radio/radio-timb.c                   |    3 +-
 drivers/media/radio/radio-trust.c                  |    5 +-
 drivers/media/radio/radio-typhoon.c                |    9 +-
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/radio-zoltrix.c                |    5 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    4 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    6 +-
 drivers/media/radio/si470x/radio-si470x.h          |    1 -
 drivers/media/radio/wl128x/fmdrv.h                 |    5 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    3 +-
 drivers/media/rc/Kconfig                           |   11 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ene_ir.c                          |    4 +-
 drivers/media/rc/ene_ir.h                          |    2 +-
 drivers/media/rc/ir-lirc-codec.c                   |   15 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |  449 ++
 drivers/media/rc/ir-raw.c                          |    1 +
 drivers/media/rc/ite-cir.c                         |    5 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    3 +-
 drivers/media/rc/mceusb.c                          |   10 +-
 drivers/media/rc/nuvoton-cir.c                     |   12 +-
 drivers/media/rc/rc-core-priv.h                    |   18 +
 drivers/media/rc/rc-loopback.c                     |   13 +-
 drivers/media/rc/rc-main.c                         |    4 +-
 drivers/media/rc/redrat3.c                         |   63 +-
 drivers/media/rc/winbond-cir.c                     |   28 +-
 drivers/media/video/Kconfig                        |   44 +-
 drivers/media/video/Makefile                       |    8 +-
 drivers/media/video/adp1653.c                      |  491 ++
 drivers/media/video/arv.c                          |    5 +-
 drivers/media/video/atmel-isi.c                    | 1048 ++++
 drivers/media/video/au0828/au0828-core.c           |    1 +
 drivers/media/video/au0828/au0828-video.c          |    5 -
 drivers/media/video/bt8xx/bttv-cards.c             |    7 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   14 +-
 drivers/media/video/bt8xx/bttvp.h                  |    3 -
 drivers/media/video/bw-qcam.c                      |    4 +-
 drivers/media/video/c-qcam.c                       |    4 +-
 drivers/media/video/cafe_ccic-regs.h               |  166 -
 drivers/media/video/cafe_ccic.c                    | 2267 -------
 drivers/media/video/cpia2/cpia2.h                  |    5 -
 drivers/media/video/cpia2/cpia2_v4l.c              |   12 +-
 drivers/media/video/cx18/cx18-alsa-main.c          |    1 +
 drivers/media/video/cx18/cx18-driver.h             |    1 -
 drivers/media/video/cx18/cx18-ioctl.c              |    1 -
 drivers/media/video/cx18/cx18-version.h            |    8 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |    4 +
 drivers/media/video/cx231xx/cx231xx-cards.c        |   78 +
 drivers/media/video/cx231xx/cx231xx-core.c         |    4 +
 drivers/media/video/cx231xx/cx231xx-video.c        |   29 +-
 drivers/media/video/cx231xx/cx231xx.h              |    5 +-
 drivers/media/video/cx23885/altera-ci.c            |    1 -
 drivers/media/video/cx23885/cx23885-417.c          |    1 -
 drivers/media/video/cx23885/cx23885-cards.c        |   70 +-
 drivers/media/video/cx23885/cx23885-core.c         |   13 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |   23 +-
 drivers/media/video/cx23885/cx23885-input.c        |    6 +
 drivers/media/video/cx23885/cx23885-video.c        |    1 -
 drivers/media/video/cx23885/cx23885.h              |    4 +-
 drivers/media/video/cx88/cx88-alsa.c               |   19 +-
 drivers/media/video/cx88/cx88-blackbird.c          |   20 +-
 drivers/media/video/cx88/cx88-cards.c              |  150 +-
 drivers/media/video/cx88/cx88-core.c               |   11 +-
 drivers/media/video/cx88/cx88-dvb.c                |   77 +-
 drivers/media/video/cx88/cx88-input.c              |    4 +
 drivers/media/video/cx88/cx88-mpeg.c               |   35 +-
 drivers/media/video/cx88/cx88-video.c              |   65 +-
 drivers/media/video/cx88/cx88.h                    |    7 +-
 drivers/media/video/davinci/Kconfig                |   23 +
 drivers/media/video/davinci/Makefile               |    2 +
 drivers/media/video/davinci/vpbe.c                 |  864 +++
 drivers/media/video/davinci/vpbe_display.c         | 1860 ++++++
 drivers/media/video/davinci/vpbe_osd.c             | 1231 ++++
 drivers/media/video/davinci/vpbe_osd_regs.h        |  364 ++
 drivers/media/video/davinci/vpbe_venc.c            |  566 ++
 drivers/media/video/davinci/vpbe_venc_regs.h       |  177 +
 drivers/media/video/davinci/vpif_capture.c         |    9 +-
 drivers/media/video/davinci/vpif_capture.h         |    7 +-
 drivers/media/video/davinci/vpif_display.c         |    9 +-
 drivers/media/video/davinci/vpif_display.h         |    8 +-
 drivers/media/video/em28xx/Kconfig                 |   12 +-
 drivers/media/video/em28xx/Makefile                |    6 +-
 drivers/media/video/em28xx/em28xx-audio.c          |  251 +-
 drivers/media/video/em28xx/em28xx-cards.c          |  159 +-
 drivers/media/video/em28xx/em28xx-core.c           |   84 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |  126 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |   17 +-
 drivers/media/video/em28xx/em28xx-input.c          |    1 +
 drivers/media/video/em28xx/em28xx-reg.h            |    1 +
 drivers/media/video/em28xx/em28xx-video.c          |   14 +-
 drivers/media/video/em28xx/em28xx.h                |   24 +-
 drivers/media/video/et61x251/et61x251.h            |    1 -
 drivers/media/video/et61x251/et61x251_core.c       |   16 +-
 drivers/media/video/fsl-viu.c                      |   10 +-
 drivers/media/video/gspca/Kconfig                  |   10 +
 drivers/media/video/gspca/Makefile                 |    2 +
 drivers/media/video/gspca/gl860/gl860.h            |    1 -
 drivers/media/video/gspca/gspca.c                  |   23 +-
 drivers/media/video/gspca/ov519.c                  |  115 +-
 drivers/media/video/gspca/se401.c                  |  774 +++
 drivers/media/video/gspca/se401.h                  |   90 +
 drivers/media/video/gspca/sunplus.c                |    3 -
 drivers/media/video/gspca/t613.c                   |    2 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |    1 +
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 -
 drivers/media/video/hdpvr/hdpvr.h                  |    6 -
 drivers/media/video/ivtv/ivtv-driver.h             |    1 -
 drivers/media/video/ivtv/ivtv-fileops.c            |   19 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    5 +-
 drivers/media/video/ivtv/ivtv-version.h            |    7 +-
 drivers/media/video/m5mols/m5mols_capture.c        |    2 -
 drivers/media/video/m5mols/m5mols_core.c           |    1 -
 drivers/media/video/marvell-ccic/Kconfig           |   23 +
 drivers/media/video/marvell-ccic/Makefile          |    6 +
 drivers/media/video/marvell-ccic/cafe-driver.c     |  654 ++
 drivers/media/video/marvell-ccic/mcam-core.c       | 1843 ++++++
 drivers/media/video/marvell-ccic/mcam-core.h       |  323 +
 drivers/media/video/marvell-ccic/mmp-driver.c      |  340 +
 drivers/media/video/mem2mem_testdev.c              |    4 +-
 drivers/media/video/mt9m001.c                      |   14 +-
 drivers/media/video/mt9m111.c                      |  359 +-
 drivers/media/video/mt9t031.c                      |    3 +-
 drivers/media/video/mt9t112.c                      |   10 +-
 drivers/media/video/mt9v011.c                      |   85 +-
 drivers/media/video/mt9v022.c                      |   10 +-
 drivers/media/video/mt9v032.c                      |   20 +-
 drivers/media/video/mx1_camera.c                   |   47 +-
 drivers/media/video/mx2_camera.c                   |   66 +-
 drivers/media/video/mx3_camera.c                   |   71 +-
 drivers/media/video/omap/Kconfig                   |    7 +-
 drivers/media/video/omap/Makefile                  |    1 +
 drivers/media/video/omap/omap_vout.c               |  647 +--
 drivers/media/video/omap/omap_vout_vrfb.c          |  390 ++
 drivers/media/video/omap/omap_vout_vrfb.h          |   40 +
 drivers/media/video/omap/omap_voutdef.h            |   78 +
 drivers/media/video/omap/omap_voutlib.c            |   46 +
 drivers/media/video/omap/omap_voutlib.h            |   12 +-
 drivers/media/video/omap1_camera.c                 |   57 +-
 drivers/media/video/omap24xxcam.c                  |    9 +-
 drivers/media/video/omap3isp/isp.c                 |    1 +
 drivers/media/video/omap3isp/isp.h                 |    6 +
 drivers/media/video/omap3isp/ispccdc.c             |    7 +-
 drivers/media/video/omap3isp/ispccp2.c             |   27 +-
 drivers/media/video/omap3isp/ispccp2.h             |    1 +
 drivers/media/video/omap3isp/ispstat.c             |    3 +-
 drivers/media/video/omap3isp/ispvideo.c            |    1 -
 drivers/media/video/omap3isp/ispvideo.h            |    3 +-
 drivers/media/video/ov2640.c                       |   13 +-
 drivers/media/video/ov5642.c                       | 1012 +++
 drivers/media/video/ov7670.c                       |    3 +-
 drivers/media/video/ov772x.c                       |   10 +-
 drivers/media/video/ov9640.c                       |   13 +-
 drivers/media/video/ov9740.c                       |  556 +-
 drivers/media/video/pms.c                          |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    1 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    9 +-
 drivers/media/video/pwc/Kconfig                    |    1 +
 drivers/media/video/pwc/pwc-ctrl.c                 |  803 +--
 drivers/media/video/pwc/pwc-dec1.c                 |   28 +-
 drivers/media/video/pwc/pwc-dec1.h                 |    8 +-
 drivers/media/video/pwc/pwc-dec23.c                |   22 -
 drivers/media/video/pwc/pwc-dec23.h                |   10 -
 drivers/media/video/pwc/pwc-if.c                   | 1259 ++---
 drivers/media/video/pwc/pwc-ioctl.h                |  323 -
 drivers/media/video/pwc/pwc-kiara.c                |    1 -
 drivers/media/video/pwc/pwc-misc.c                 |    4 -
 drivers/media/video/pwc/pwc-uncompress.c           |   17 +-
 drivers/media/video/pwc/pwc-uncompress.h           |   40 -
 drivers/media/video/pwc/pwc-v4l.c                  | 1257 +++--
 drivers/media/video/pwc/pwc.h                      |  409 +-
 drivers/media/video/pxa_camera.c                   |   92 +-
 drivers/media/video/rj54n1cb0c.c                   |    7 +-
 drivers/media/video/s2255drv.c                     |   35 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |    2 -
 drivers/media/video/s5p-fimc/fimc-core.c           |    3 +-
 drivers/media/video/s5p-mfc/Makefile               |    5 +
 drivers/media/video/s5p-mfc/regs-mfc.h             |  413 ++
 drivers/media/video/s5p-mfc/s5p_mfc.c              | 1274 ++++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c          |  120 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h          |   30 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h       |  572 ++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c         |  343 ++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h         |   29 +
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h        |   48 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          | 1036 ++++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h          |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          | 1829 ++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h          |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c         |   92 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h         |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c          | 1397 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h          |   91 +
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c           |  117 +
 drivers/media/video/s5p-mfc/s5p_mfc_pm.h           |   24 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c          |   47 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h          |   91 +
 drivers/media/video/s5p-tv/Kconfig                 |   76 +
 drivers/media/video/s5p-tv/Makefile                |   17 +
 drivers/media/video/s5p-tv/hdmi_drv.c              | 1042 ++++
 drivers/media/video/s5p-tv/hdmiphy_drv.c           |  188 +
 drivers/media/video/s5p-tv/mixer.h                 |  354 ++
 drivers/media/video/s5p-tv/mixer_drv.c             |  487 ++
 drivers/media/video/s5p-tv/mixer_grp_layer.c       |  185 +
 drivers/media/video/s5p-tv/mixer_reg.c             |  541 ++
 drivers/media/video/s5p-tv/mixer_video.c           | 1006 +++
 drivers/media/video/s5p-tv/mixer_vp_layer.c        |  211 +
 drivers/media/video/s5p-tv/regs-hdmi.h             |  141 +
 drivers/media/video/s5p-tv/regs-mixer.h            |  121 +
 drivers/media/video/s5p-tv/regs-sdo.h              |   63 +
 drivers/media/video/s5p-tv/regs-vp.h               |   88 +
 drivers/media/video/s5p-tv/sdo_drv.c               |  479 ++
 drivers/media/video/saa7115.c                      |    4 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   13 +-
 drivers/media/video/saa7134/saa7134-core.c         |   12 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   25 +
 drivers/media/video/saa7134/saa7134-empress.c      |    1 -
 drivers/media/video/saa7134/saa7134-video.c        |    2 -
 drivers/media/video/saa7134/saa7134.h              |    3 +-
 drivers/media/video/saa7164/saa7164-encoder.c      |    6 +-
 drivers/media/video/saa7164/saa7164-vbi.c          |    6 +-
 drivers/media/video/saa7164/saa7164.h              |    1 -
 drivers/media/video/sh_mobile_ceu_camera.c         |  207 +-
 drivers/media/video/sh_mobile_csi2.c               |  135 +-
 drivers/media/video/sh_vou.c                       |    3 +-
 drivers/media/video/sn9c102/sn9c102.h              |    1 -
 drivers/media/video/sn9c102/sn9c102_core.c         |   16 +-
 drivers/media/video/soc_camera.c                   |  281 +-
 drivers/media/video/soc_camera_platform.c          |   10 +-
 drivers/media/video/sr030pc30.c                    |    7 +-
 drivers/media/video/tda7432.c                      |    5 +-
 drivers/media/video/timblogiw.c                    |    1 -
 drivers/media/video/tlg2300/pd-common.h            |    1 -
 drivers/media/video/tlg2300/pd-main.c              |    1 +
 drivers/media/video/tlg2300/pd-radio.c             |    2 -
 drivers/media/video/tuner-core.c                   |   18 +
 drivers/media/video/tw9910.c                       |   21 +-
 drivers/media/video/usbvision/usbvision-video.c    |   12 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |    4 +-
 drivers/media/video/uvc/uvc_driver.c               |   12 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |    4 +-
 drivers/media/video/uvc/uvcvideo.h                 |    3 +-
 drivers/media/video/v4l2-common.c                  |    3 +
 drivers/media/video/v4l2-compat-ioctl32.c          |   37 +
 drivers/media/video/v4l2-ctrls.c                   |  826 ++-
 drivers/media/video/v4l2-device.c                  |    1 +
 drivers/media/video/v4l2-event.c                   |  282 +-
 drivers/media/video/v4l2-fh.c                      |   23 +-
 drivers/media/video/v4l2-ioctl.c                   |   50 +-
 drivers/media/video/v4l2-subdev.c                  |   31 +-
 drivers/media/video/videobuf-dma-sg.c              |    5 +-
 drivers/media/video/videobuf2-dma-sg.c             |    8 +-
 drivers/media/video/videobuf2-memops.c             |    6 +-
 drivers/media/video/vino.c                         |    5 +-
 drivers/media/video/vivi.c                         |   91 +-
 drivers/media/video/w9966.c                        |    4 +-
 drivers/media/video/zoran/zoran.h                  |    4 -
 drivers/media/video/zoran/zoran_card.c             |    7 +-
 drivers/media/video/zoran/zoran_driver.c           |    3 -
 drivers/media/video/zr364xx.c                      |    6 +-
 drivers/mfd/timberdale.c                           |    8 +-
 drivers/staging/cxd2099/Kconfig                    |   11 +-
 drivers/staging/cxd2099/cxd2099.c                  |  311 +-
 drivers/staging/cxd2099/cxd2099.h                  |   18 +-
 drivers/staging/tm6000/tm6000-alsa.c               |   16 +-
 drivers/usb/gadget/uvc_v4l2.c                      |   22 +-
 include/linux/dvb/audio.h                          |    2 +-
 include/linux/videodev2.h                          |  254 +-
 include/media/adp1653.h                            |  126 +
 include/media/atmel-isi.h                          |  119 +
 include/media/davinci/vpbe.h                       |  184 +
 include/media/davinci/vpbe_display.h               |  147 +
 include/media/davinci/vpbe_osd.h                   |  394 ++
 include/media/davinci/vpbe_types.h                 |   91 +
 include/media/davinci/vpbe_venc.h                  |   45 +
 include/media/mmp-camera.h                         |    9 +
 {drivers/media/video => include/media}/ov7670.h    |    0
 include/media/rc-core.h                            |    2 +-
 include/media/rc-map.h                             |    3 +-
 include/media/sh_mobile_ceu.h                      |   10 +-
 include/media/sh_mobile_csi2.h                     |    8 +-
 include/media/soc_camera.h                         |   44 +-
 include/media/soc_camera_platform.h                |   15 +-
 include/media/timb_radio.h                         |    9 +-
 include/media/tuner.h                              |    2 +
 include/media/v4l2-chip-ident.h                    |    4 +-
 include/media/v4l2-ctrls.h                         |   72 +-
 include/media/v4l2-event.h                         |   84 +-
 include/media/v4l2-fh.h                            |   13 +-
 include/media/v4l2-mediabus.h                      |   63 +
 include/media/v4l2-subdev.h                        |   24 +-
 include/sound/tea575x-tuner.h                      |    8 +-
 kernel/compat.c                                    |    1 +
 sound/i2c/other/tea575x-tuner.c                    |  143 +-
 sound/pci/Kconfig                                  |    4 +-
 568 files changed, 55119 insertions(+), 17091 deletions(-)
 delete mode 100644 Documentation/DocBook/dvb/dvbproperty.xml
 delete mode 100644 Documentation/DocBook/dvb/dvbstb.png
 delete mode 100644 Documentation/DocBook/dvb/frontend.h.xml
 delete mode 100644 Documentation/DocBook/dvb/net.xml
 delete mode 100644 Documentation/DocBook/media-entities.tmpl
 delete mode 100644 Documentation/DocBook/media-indices.tmpl
 create mode 100644 Documentation/DocBook/media/Makefile
 create mode 100644 Documentation/DocBook/media/bayer.png.b64
 create mode 100644 Documentation/DocBook/media/crop.gif.b64
 rename Documentation/DocBook/{ => media}/dvb/.gitignore (100%)
 rename Documentation/DocBook/{ => media}/dvb/audio.xml (79%)
 rename Documentation/DocBook/{ => media}/dvb/ca.xml (67%)
 rename Documentation/DocBook/{ => media}/dvb/demux.xml (84%)
 rename Documentation/DocBook/{ => media}/dvb/dvbapi.xml (85%)
 create mode 100644 Documentation/DocBook/media/dvb/dvbproperty.xml
 rename Documentation/DocBook/{ => media}/dvb/dvbstb.pdf (100%)
 rename Documentation/DocBook/{ => media}/dvb/examples.xml (100%)
 rename Documentation/DocBook/{ => media}/dvb/frontend.xml (75%)
 rename Documentation/DocBook/{ => media}/dvb/intro.xml (92%)
 rename Documentation/DocBook/{ => media}/dvb/kdapi.xml (100%)
 create mode 100644 Documentation/DocBook/media/dvb/net.xml
 rename Documentation/DocBook/{ => media}/dvb/video.xml (81%)
 create mode 100644 Documentation/DocBook/media/dvbstb.png.b64
 create mode 100644 Documentation/DocBook/media/fieldseq_bt.gif.b64
 create mode 100644 Documentation/DocBook/media/fieldseq_tb.gif.b64
 create mode 100644 Documentation/DocBook/media/nv12mt.gif.b64
 create mode 100644 Documentation/DocBook/media/nv12mt_example.gif.b64
 create mode 100644 Documentation/DocBook/media/pipeline.png.b64
 rename Documentation/DocBook/{ => media}/v4l/.gitignore (100%)
 rename Documentation/DocBook/{ => media}/v4l/biblio.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/capture.c.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/common.xml (99%)
 rename Documentation/DocBook/{ => media}/v4l/compat.xml (99%)
 create mode 100644 Documentation/DocBook/media/v4l/controls.xml
 rename Documentation/DocBook/{ => media}/v4l/crop.pdf (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-capture.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-codec.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-effect.xml (100%)
 create mode 100644 Documentation/DocBook/media/v4l/dev-event.xml
 rename Documentation/DocBook/{ => media}/v4l/dev-osd.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-output.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-overlay.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-radio.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-raw-vbi.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-rds.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-sliced-vbi.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-subdev.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/dev-teletext.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/driver.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/fdl-appendix.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/fieldseq_bt.pdf (100%)
 rename Documentation/DocBook/{ => media}/v4l/fieldseq_tb.pdf (100%)
 rename Documentation/DocBook/{ => media}/v4l/func-close.xml (100%)
 create mode 100644 Documentation/DocBook/media/v4l/func-ioctl.xml
 rename Documentation/DocBook/{ => media}/v4l/func-mmap.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/func-munmap.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/func-open.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/func-poll.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/func-read.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/func-select.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/func-write.xml (100%)
 create mode 100644 Documentation/DocBook/media/v4l/gen-errors.xml
 rename Documentation/DocBook/{ => media}/v4l/io.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/keytable.c.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/libv4l.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/lirc_device_interface.xml (99%)
 rename Documentation/DocBook/{ => media}/v4l/media-controller.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/media-func-close.xml (100%)
 create mode 100644 Documentation/DocBook/media/v4l/media-func-ioctl.xml
 rename Documentation/DocBook/{ => media}/v4l/media-func-open.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/media-ioc-device-info.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/media-ioc-enum-entities.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/media-ioc-enum-links.xml (98%)
 rename Documentation/DocBook/{ => media}/v4l/media-ioc-setup-link.xml (87%)
 rename Documentation/DocBook/{ => media}/v4l/pipeline.pdf (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-grey.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-m420.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-nv12.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-nv12m.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-nv12mt.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-nv16.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-packed-rgb.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-packed-yuv.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-sbggr16.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-sbggr8.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-sgbrg8.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-sgrbg8.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-srggb10.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-srggb12.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-srggb8.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-uyvy.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-vyuy.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-y10.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-y10b.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-y12.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-y16.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-y41p.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-yuv410.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-yuv411p.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-yuv420.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-yuv420m.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-yuv422p.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-yuyv.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt-yvyu.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/pixfmt.xml (94%)
 rename Documentation/DocBook/{ => media}/v4l/planar-apis.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/remote_controllers.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/subdev-formats.xml (99%)
 rename Documentation/DocBook/{ => media}/v4l/v4l2.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/v4l2grab.c.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vbi_525.pdf (100%)
 rename Documentation/DocBook/{ => media}/v4l/vbi_625.pdf (100%)
 rename Documentation/DocBook/{ => media}/v4l/vbi_hsync.pdf (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-cropcap.xml (95%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-dbg-g-chip-ident.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-dbg-g-register.xml (94%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-dqevent.xml (84%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-encoder-cmd.xml (96%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enum-dv-presets.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enum-fmt.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enum-frameintervals.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enum-framesizes.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enumaudio.xml (89%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enumaudioout.xml (90%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enuminput.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enumoutput.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-enumstd.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-audio.xml (93%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-audioout.xml (92%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-crop.xml (93%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-ctrl.xml (94%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-dv-preset.xml (96%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-dv-timings.xml (98%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-enc-index.xml (95%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-ext-ctrls.xml (95%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-fbuf.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-fmt.xml (93%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-frequency.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-input.xml (85%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-jpegcomp.xml (93%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-modulator.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-output.xml (87%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-parm.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-priority.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-sliced-vbi-cap.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-std.xml (90%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-g-tuner.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-log-status.xml (80%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-overlay.xml (90%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-qbuf.xml (95%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-query-dv-preset.xml (79%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-querybuf.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-querycap.xml (93%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-queryctrl.xml (97%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-querystd.xml (78%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-reqbufs.xml (92%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-s-hw-freq-seek.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-streamon.xml (92%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-subdev-enum-frame-interval.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-subdev-enum-frame-size.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-subdev-enum-mbus-code.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-subdev-g-crop.xml (100%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-subdev-g-fmt.xml (99%)
 rename Documentation/DocBook/{ => media}/v4l/vidioc-subdev-g-frame-interval.xml (100%)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
 create mode 100644 Documentation/DocBook/media/vbi_525.gif.b64
 create mode 100644 Documentation/DocBook/media/vbi_625.gif.b64
 create mode 100644 Documentation/DocBook/media/vbi_hsync.gif.b64
 rename Documentation/DocBook/{media.tmpl => media_api.tmpl} (89%)
 delete mode 100644 Documentation/DocBook/v4l/bayer.pdf
 delete mode 100644 Documentation/DocBook/v4l/bayer.png
 delete mode 100644 Documentation/DocBook/v4l/controls.xml
 delete mode 100644 Documentation/DocBook/v4l/crop.gif
 delete mode 100644 Documentation/DocBook/v4l/dev-event.xml
 delete mode 100644 Documentation/DocBook/v4l/fieldseq_bt.gif
 delete mode 100644 Documentation/DocBook/v4l/fieldseq_tb.gif
 delete mode 100644 Documentation/DocBook/v4l/func-ioctl.xml
 delete mode 100644 Documentation/DocBook/v4l/media-func-ioctl.xml
 delete mode 100644 Documentation/DocBook/v4l/nv12mt.gif
 delete mode 100644 Documentation/DocBook/v4l/nv12mt_example.gif
 delete mode 100644 Documentation/DocBook/v4l/pipeline.png
 delete mode 100644 Documentation/DocBook/v4l/vbi_525.gif
 delete mode 100644 Documentation/DocBook/v4l/vbi_625.gif
 delete mode 100644 Documentation/DocBook/v4l/vbi_hsync.gif
 delete mode 100644 Documentation/DocBook/v4l/videodev2.h.xml
 delete mode 100644 Documentation/DocBook/v4l/vidioc-subscribe-event.xml
 mode change 100644 => 100755 Documentation/dvb/get_dvb_firmware
 create mode 100644 Documentation/video4linux/README.davinci-vpbe
 create mode 100644 drivers/media/common/tuners/xc4000.c
 create mode 100644 drivers/media/common/tuners/xc4000.h
 create mode 100644 drivers/media/dvb/ddbridge/Kconfig
 create mode 100644 drivers/media/dvb/ddbridge/Makefile
 create mode 100644 drivers/media/dvb/ddbridge/ddbridge-core.c
 create mode 100644 drivers/media/dvb/ddbridge/ddbridge-regs.h
 create mode 100644 drivers/media/dvb/ddbridge/ddbridge.h
 create mode 100644 drivers/media/dvb/frontends/drxk.h
 create mode 100644 drivers/media/dvb/frontends/drxk_hard.c
 create mode 100644 drivers/media/dvb/frontends/drxk_hard.h
 create mode 100644 drivers/media/dvb/frontends/drxk_map.h
 create mode 100644 drivers/media/dvb/frontends/tda18271c2dd.c
 create mode 100644 drivers/media/dvb/frontends/tda18271c2dd.h
 create mode 100644 drivers/media/dvb/frontends/tda18271c2dd_maps.h
 create mode 100644 drivers/media/rc/ir-mce_kbd-decoder.c
 create mode 100644 drivers/media/video/adp1653.c
 create mode 100644 drivers/media/video/atmel-isi.c
 delete mode 100644 drivers/media/video/cafe_ccic-regs.h
 delete mode 100644 drivers/media/video/cafe_ccic.c
 create mode 100644 drivers/media/video/davinci/vpbe.c
 create mode 100644 drivers/media/video/davinci/vpbe_display.c
 create mode 100644 drivers/media/video/davinci/vpbe_osd.c
 create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
 create mode 100644 drivers/media/video/davinci/vpbe_venc.c
 create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
 create mode 100644 drivers/media/video/gspca/se401.c
 create mode 100644 drivers/media/video/gspca/se401.h
 create mode 100644 drivers/media/video/marvell-ccic/Kconfig
 create mode 100644 drivers/media/video/marvell-ccic/Makefile
 create mode 100644 drivers/media/video/marvell-ccic/cafe-driver.c
 create mode 100644 drivers/media/video/marvell-ccic/mcam-core.c
 create mode 100644 drivers/media/video/marvell-ccic/mcam-core.h
 create mode 100644 drivers/media/video/marvell-ccic/mmp-driver.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h
 create mode 100644 drivers/media/video/ov5642.c
 delete mode 100644 drivers/media/video/pwc/pwc-ioctl.h
 delete mode 100644 drivers/media/video/pwc/pwc-uncompress.h
 create mode 100644 drivers/media/video/s5p-mfc/Makefile
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h
 create mode 100644 drivers/media/video/s5p-tv/Kconfig
 create mode 100644 drivers/media/video/s5p-tv/Makefile
 create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer.h
 create mode 100644 drivers/media/video/s5p-tv/mixer_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_grp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_reg.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_video.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_vp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/regs-mixer.h
 create mode 100644 drivers/media/video/s5p-tv/regs-sdo.h
 create mode 100644 drivers/media/video/s5p-tv/regs-vp.h
 create mode 100644 drivers/media/video/s5p-tv/sdo_drv.c
 create mode 100644 include/media/adp1653.h
 create mode 100644 include/media/atmel-isi.h
 create mode 100644 include/media/davinci/vpbe.h
 create mode 100644 include/media/davinci/vpbe_display.h
 create mode 100644 include/media/davinci/vpbe_osd.h
 create mode 100644 include/media/davinci/vpbe_types.h
 create mode 100644 include/media/davinci/vpbe_venc.h
 create mode 100644 include/media/mmp-camera.h
 rename {drivers/media/video => include/media}/ov7670.h (100%)

