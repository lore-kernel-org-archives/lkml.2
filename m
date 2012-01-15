Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2AONmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:42:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab2AONmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:42:02 -0500
Message-ID: <4F12D7A0.7030804@redhat.com>
Date: Sun, 15 Jan 2012 11:41:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.3-rc1] media updates
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the latest updates at the media tree.	

This series include:
	- DVB: a major cleanup at the frontends and tuners. Basically, the
DVB API up to version 3 and drivers were written focused on supporting only 
the 3 initial DTV european standards (DVB-S, DVB-C, DVB-T), plus the american 
standard (ATSC and DVB-C Annex B). While the userspace API for other standards
like DVB-S2, DVB-T2, ISDB and CMDB were added in 2008 (DVB API version 5),
internally, the DVB core used to work with the legacy API, with has issues
when dealing with the new standards. A patch series of 200+ patches converted
the internal API to work directly with the new digital TV properties, instead
of using the DVBv3 emulated one. The DVBv3 handling is now confined to the DVB
core only, removing several memory copies to/from the legacy structures and
the new DVBv5 internal structures;

	- DVB: added a new DVBv5 property to allow enumerating the supported
Digital TV delivery systems (DVB-C, DVB-S, DVB-S2, etc...), needed for devices
that support multiple delivery systems;

	- Both drxk and cxd2820 chips can support DVB-T and DVB-C. Instead
of reporting them as two separate frontend devices, use the new DVB property
to report what they support, and create just one frontend for each physical
device;

	- DVB: Now, the core properly returns -EINVAL if a DVBv5 call is
requesting to set the frontend into an unsupported delivery system.

	- V4L: Addition of the Selection API, required to better control the
input/output frame view and cropping;

	- RC: New infrared decoder for Sanyo protocol;

	- New devices: mt2063 tuner, hdic CMDB driver, as3645a flash controller,
Samsung s5p 2D accelerator driver, s5p jpeg decoder driver, HD29L2 DMB-TH 
demodulator driver;

	- As usual, several driver improvements, new board additions and
fixes.

Thanks!
Mauro.

PS.: 

1) This time, there are three merges from the upstream tree. I usually
remove such merges when sending patches upstream by rebasing the tree I'm
about to send, in order to have a clean patch history, but this time doing 
it would generate too much troubles, as the v4l-dvb tree were partially 
merged at the arm tree.

2) This patch contains one patch that didn't reach linux-next yet:
	[media] revert patch: HDIC HD29L2 DMB-TH USB2.0 reference design driver

Basically, one driver for a non-existent hardware were added by mistake.
This is a template driver for no real hardware, made to help someone that
could be using the HDIC demod for the Chinese standard DMB-TH somewhere.
The developer that wrote it forgot to remove it during the patches submission.
As this is just complete driver removal, it shouldn't cause any merge
conflicts. Anyway, it should be at tomorrow's -next.

Latest commit at the branch: 
126400033940afb658123517a2e80eb68259fbd7 [media] revert patch: HDIC HD29L2 DMB-TH USB2.0 reference design driver
The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Aivar Päkk (1):
      [media] KWorld 355U and 380U support

Alexey Fisher (2):
      [media] uvcvideo: Add debugfs support
      [media] uvcvideo: Extract video stream statistics

Alfredo Jesús Delaiti (1):
      [media] cx23885: add support for Mygica X8507

Andreas Oberritter (2):
      [media] em28xx: Add Terratec Cinergy HTC Stick
      [media] DVB: dvb_frontend: fix delayed thread exit

Andrew Vincer (1):
      [media] rc: Fix input deadlock and transmit error in redrat3 driver

Andrzej Pietrasiewicz (2):
      [media] media: vb2: vmalloc-based allocator user pointer handling
      [media] Exynos4 JPEG codec v4l2 driver

Antti Palosaari (26):
      [media] tda18212: add DVB-T2 support
      [media] anysee: add support for Anysee E7 T2C
      [media] anysee: I2C gate control DNOD44CDH086A tuner module
      [media] anysee: CI/CAM support
      [media] anysee: add control message debugs
      [media] anysee: fix style issues
      [media] tda18218: implement .get_if_frequency()
      [media] af9013: use .get_if_frequency() when possible
      [media] mt2060: implement .get_if_frequency()
      [media] qt1010: implement .get_if_frequency()
      [media] tda18212: implement .get_if_frequency()
      [media] tda18212: round IF frequency to close hardware value
      [media] cxd2820r: switch to .get_if_frequency()
      [media] cxd2820r: check bandwidth earlier for DVB-T/T2
      [media] ce6230: remove experimental from Kconfig
      [media] ce168: remove experimental from Kconfig
      [media] af9015: limit I2C access to keep FW happy
      [media] af9013: rewrite whole driver
      [media] mxl5007t: bugfix DVB-T 7 MHz and 8 MHz bandwidth
      [media] HDIC HD29L2 DMB-TH demodulator driver
      [media] HDIC HD29L2 DMB-TH USB2.0 reference design driver
      [media] hd29l2: synch for latest DVB core changes
      [media] hd29l2: add debug for used IF frequency
      [media] dvb-core: define general callback value for demodulator
      [media] hd29l2: fix review findings
      [media] revert patch: HDIC HD29L2 DMB-TH USB2.0 reference design driver

Archit Taneja (5):
      [media] OMAP_VOUT: Fix check in reqbuf for buf_size allocation
      [media] OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr
      [media] OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
      [media] OMAP_VOUT: Add support for DSI panels
      [media] OMAP_VOUT: Increase MAX_DISPLAYS to a larger value

Axel Lin (2):
      [media] media/radio/tef6862: fix checking return value of i2c_master_send
      [media] convert drivers/media/* to use module_platform_driver()

Ben Hutchings (5):
      [media] staging: lirc_serial: Fix init/exit order
      [media] staging: lirc_serial: Free resources on failure paths of lirc_serial_probe()
      [media] staging: lirc_serial: Fix deadlock on resume failure
      [media] staging: lirc_serial: Fix bogus error codes
      [media] staging: lirc_serial: Do not assume error codes returned by request_irq()

Christian Gmeiner (1):
      [media] Make use of media bus pixel codes in adv7170 driver

Clemens Ladisch (1):
      [media] media: fix truncated entity specification

Dan Carpenter (11):
      [media] V4L: mt9t112: use after free in mt9t112_probe()
      [media] av7110: wrong limiter in av7110_start_feed()
      [media] radio: NUL terminate a user string
      [media] staging/media: lirc_imon: add a __user annotation
      [media] saa7164: fix endian conversion in saa7164_bus_set()
      [media] tm6000: using an uninitialized variable in debug code
      [media] Staging: dt3155v4l: update to newer API
      [media] Staging: dt3155v4l: probe() always fails
      [media] af9013: change & to &&
      [media] saa7134: use correct array offset
      [media] V4L/DVB: v4l2-ioctl: integer overflow in video_usercopy()

Daniel Drake (1):
      [media] via-camera: disable RGB mode

David Fries (1):
      [media] cx88-dvb avoid dangling core->gate_ctrl pointer

Dmitri Belimov (1):
      [media] FM1216ME_MK3 AUX byte for FM mode

Don Kramer (1):
      [media] [resend] em28xx: Add Plextor ConvertX PX-AV100U to em28xx-cards.c

Eddi De Pieri (2):
      [media] em28xx: initial support for HAUPPAUGE HVR-930C again
      [media] get_dvb_firmware: add support for HVR-930C firmware

Fabio Estevam (4):
      [media] drivers: media: tuners: Fix dependency for MEDIA_TUNER_TEA5761
      [media] drivers: media: radio: Fix dependencies for RADIO_WL128X
      [media] drivers: video: cx231xx: Fix dependency for VIDEO_CX231XX_DVB
      [media] drivers: media: au0828: Fix dependency for VIDEO_AU0828

Gareth Williams (2):
      [media] Add AC97 8384:7650 for some versions of EMP202
      [media] Added USB Id & configuration array for Honestech Vidbox NW03

Gianluca Gennari (3):
      [media] staging: as102: Add support for Sky Italia Digital Key based on the same chip
      [media] af9013: Fix typo in get_frontend() function
      [media] xc3028: fix center frequency calculation for DTV78 firmware

Guennadi Liakhovetski (5):
      [media] V4L: cosmetic clean up
      [media] soc-camera: remove redundant parameter from .set_bus_param()
      [media] mt9m111: cleanly separate register contexts
      [media] mt9m111: power down most circuits when suspended
      [media] mt9m111: properly implement .s_crop and .s_fmt(), reset on STREAMON

Hans Verkuil (18):
      [media] solo6x10: rename jpeg.h to solo6x10-jpeg.h
      [media] solo6x10: fix broken Makefile
      [media] V4L menu: move USB drivers section to the top
      [media] V4L menu: move ISA and parport drivers into their own submenu
      [media] V4L menu: remove the EXPERIMENTAL tag from vino and c-qcam
      [media] V4L menu: move all platform drivers to the bottom of the menu
      [media] V4L menu: remove duplicate USB dependency
      [media] V4L menu: reorganize the radio menu
      [media] V4L menu: move all PCI(e) devices to their own submenu
      [media] cx88: fix menu level for the VP-3054 module
      [media] V4L menu: add submenu for platform devices
      [media] ir-sanyo-decoder.c doesn't compile
      [media] board-dm646x-evm.c: wrong register used in setup_vpif_input_channel_mode
      [media] V4L spec: fix typo and missing CAP_RDS documentation
      [media] V4L2 Spec: clarify usage of V4L2_FBUF_FLAG_PRIMARY
      [media] v4l2 framework doc: clarify locking
      [media] V4L2 spec: fix the description of V4L2_FBUF_CAP_SRC_CHROMAKEY
      [media] vpif_capture.c: v4l2_device_register() is called too late in vpif_probe()

Hans de Goede (27):
      [media] gspca: Fix bulk mode cameras no longer working (regression fix)
      [media] gspca_pac207: Raise max exposure + various autogain setting tweaks
      [media] gscpa_vicam: Fix oops if unplugged while streaming
      [media] gspca - main: rename build_ep_tb to build_isoc_ep_tb
      [media] gspca - main: Correct use of interval in bandwidth calculation
      [media] gspca - main: Take numerator into account in fps calculations
      [media] gspca: Check dev->actconfig rather than dev->config
      [media] gspca - main: Avoid clobbering all bandwidth when mic in webcam
      [media] gspca - main: isoc mode devices are never low speed
      [media] gspca: Add a need_max_bandwidth flag to sd_desc
      [media] gscpa - sn9c20x: Add sd_isoc_init ensuring enough bw when i420 fmt
      [media] gspca_sonixb: Fix exposure control min/max value for coarse expo sensors
      [media] gspca_pac7302: Add usb-id for 145f:013c
      [media] gscpa_ov519: Fix the bandwidth calc for enabling compression
      [media] gscpa_t613: Add support for the camera button
      [media] pwc: Use v4l2-device and v4l2-fh
      [media] pwc: Properly mark device_hint as unused in all probe error paths
      [media] pwc: Make auto white balance speed and delay available as v4l2 controls
      [media] pwc: Rework locking
      [media] pwc: Read new preset values when changing awb control to a preset
      [media] pwc: Remove driver specific sysfs interface
      [media] pwc: Remove driver specific use of pixfmt.priv in the pwc driver
      [media] pwc: Remove dead snapshot code
      [media] pwc: Remove driver specific ioctls
      [media] pwc: Remove software emulation of arbritary resolutions
      [media] pwc: Get rid of compression module parameter
      [media] pwc: Properly fill all fields on try_fmt

Haogang Chen (1):
      [media] uvcvideo: Fix integer overflow in uvc_ioctl_ctrl_map()

HeungJun Kim (4):
      [media] m5mols: Extend the busy wait helper
      [media] m5mols: Improve the interrupt handling routines
      [media] m5mols: Add support for the system initialization interrupt
      [media] m5mols: Optimize the capture set up sequence

Heungjun Kim (1):
      [media] MAINTAINERS: Add m5mols driver maintainers

Holger Nelson (2):
      [media] em28xx: Add Terratec Cinergy HTC USB XS to em28xx-cards.c
      [media] em28xx: Reworked probe code to get rid of some hacks

Istvan Varga (1):
      [media] Add support for two Leadtek Winfast TV 2000XP types

Janusz Krzysztofik (1):
      [media] V4L: omap1_camera: fix missing <linux/module.h> include

Javier Martin (3):
      [media] i.MX27 camera: add support for YUV420 format
      [media] media i.MX27 camera: Fix field_count handling
      [media] media: tvp5150: Add mbus_fmt callbacks

Javier Martinez Canillas (1):
      [media] tvp5150: replace video standard "magic" numbers

Jean Delvare (2):
      [media] usbvision: Drop broken 10-bit I2C address support
      [media] video: Drop undue references to i2c-algo-bit

Jean-François Moine (7):
      [media] gspca: Remove the useless variable 'reverse_alts'
      [media] gspca: Remove the useless variable 'nbalt'
      [media] gspca - sonixj: Bad sensor mode at start time
      [media] gspca - sonixj: Change color control for sensor po2030n
      [media] gspca - topro: Lower the frame rate in 640x480 for the tp6800
      [media] gspca - zc3xx: Bad initialization of zc305/gc0303
      [media] gspca - main: Change the bandwidth estimation of isochronous transfer

Jonathan Cameron (1):
      [media] v4l: use i2c_smbus_read_word_swapped

Jonathan Corbet (1):
      [media] marvell-cam: Make suspend/resume work on MMP2

Jonathan Nieder (15):
      [media] dw2102: use symbolic names for dw2102_table indices
      [media] DVB: dvb_net_init: return -errno on error
      [media] videobuf-dvb: avoid spurious ENOMEM when CONFIG_DVB_NET=n
      [media] dvb-bt8xx: use goto based exception handling
      [media] ttusb-budget: use goto for exception handling
      [media] flexcop: handle errors from dvb_net_init
      [media] dvb-bt8xx: handle errors from dvb_net_init
      [media] dm1105: handle errors from dvb_net_init
      [media] dvb-usb: handle errors from dvb_net_init
      [media] firedtv: handle errors from dvb_net_init
      [media] flexcop: CodingStyle fix: don't use "if ((ret = foo()) < 0)"
      [media] dvb-bt8xx: use dprintk for debug statements
      [media] dvb-bt8xx: convert printks to pr_err()
      [media] dm1105: release dvbnet on frontend attachment failure
      [media] af9005, af9015: use symbolic names for USB id table indices

Jose Alberto Reguero (2):
      [media] TT CT-3650 i2c fix
      [media] gspca - ov534_9: New sensor ov5621 and webcam 05a9:1550

Josh Boyer (1):
      [media] ttusb2: Don't use stack variables for DMA

Josh Wu (1):
      [media] atmel-isi: add code to enable/disable ISI_MCK clock

Julia Lawall (4):
      [media] drivers/media/video/atmel-isi.c: eliminate a null pointer dereference
      [media] drivers/media/video/davinci/vpbe_display.c: eliminate a null pointer dereference
      [media] drivers/media/video/davinci/vpbe.c: introduce missing kfree
      [media] drivers/staging/media/as102/as102_usb_drv.c: shift position of allocation code

Kamil Debski (2):
      [media] v4l: add G2D driver for s5p device family
      [media] s5p-g2d: remove two unused variables from the G2D driver

Laurent Pinchart (18):
      [media] v4l: mt9p031/mt9t001: Use i2c_smbus_{read|write}_word_swapped()
      [media] uvcvideo: Move fields from uvc_buffer::buf to uvc_buffer
      [media] uvcvideo: Use videobuf2-vmalloc
      [media] uvcvideo: Handle uvc_init_video() failure in uvc_video_enable()
      [media] uvcvideo: Remove duplicate definitions of UVC_STREAM_* macros
      [media] uvcvideo: Add support for LogiLink Wireless Webcam
      [media] uvcvideo: Make uvc_commit_video() static
      [media] uvcvideo: Don't skip erroneous payloads
      [media] uvcvideo: Ignore GET_RES error for XU controls
      [media] uvcvideo: Extract timestamp-related statistics
      [media] uvcvideo: Add UVC timestamps support
      [media] omap3isp: preview: Rename max output sizes defines
      [media] omap3isp: ccdc: Fix crash in HS/VS interrupt handler
      [media] omap3isp: Clarify the clk_pol field in platform data
      [media] v4l: Add over-current and indicator flash fault bits
      [media] as3645a: Add driver for LED flash controller
      [media] omap3isp: video: Don't WARN() on unknown pixel formats
      [media] omap3isp: Mark next captured frame as faulty when an SBL overflow occurs

Lei Wen (1):
      [media] soc-camera: change order of removing device

Leonid V. Fedorenchik (36):
      [media] cx25821-alsa.c: Line up comments
      [media] cx25821-alsa.c: Add braces to else clause
      [media] cx25821-alsa.c: Fix indent
      [media] cx25821-alsa.c: Change line endings
      [media] cx25821-audio-upstream.c: Fix indent
      [media] cx25821-audio-upstream.c: Move operators
      [media] cx25821-audio-upstream.c: Change line endings
      [media] cx25821-audio.h: Line up defines
      [media] cx25821-audio.h: Fix multiline defines
      [media] cx25821-cards.c: Fix indent
      [media] cx25821-core.c: Delete empty line
      [media] cx25821-core.c: Fix indent
      [media] cx25821-core.c: Change line endings
      [media] cx25821-i2c.c: Change line endings
      [media] cx25821-medusa-defines.h: Fix typo
      [media] cx25821-medusa-defines.h: Line up defines
      [media] cx25821-medusa-reg.h: Line up defines
      [media] cx25821-medusa-video.c: Fix comment
      [media] cx25821-medusa-video.c: Move operators
      [media] cx25821-medusa-video.c: Change line endings
      [media] cx25821-video-upstream-ch2.c: Line up comments
      [media] cx25821-video-upstream-ch2.c: Fix indent
      [media] cx25821-video-upsstream-ch2.c: Move operators
      [media] cx25821-video-upstream-ch2.c: Remove braces
      [media] cx25821-video-upstream-ch2.c: Change line endings
      [media] cx25821-video-upstream.c: Remove braces
      [media] cx25821-video-upstream.c: Fix indent
      [media] cx25821-video-upstream.c: Change line endings
      [media] cx25821-video.c: Delete empty line
      [media] cx25821-video.c: Change spaces
      [media] cx25821-video.c: Fix assignment
      [media] cx25821-video.c: Fix definitions
      [media] cx25821-video.c: Move operators
      [media] cx25821-video.c: Fix indent
      [media] cx25821-video.c: Change line endings
      [media] cx25821.h: Line up defines

Malcolm Priestley (24):
      [media] it913x Support it9135 Verions 2 chip
      [media] it913x ver 1.09 support for USB 1 devices (IT9135)
      [media] it913x-fe ver 1.10 correct SNR reading from frontend
      [media] Support for Sveon STV22 (IT9137)
      [media] it913x: endpoint size changes
      [media] it913x-fe: more user and debugging info
      [media] it913x: support for different tuner regs
      [media] it913x: support for NEC extended keys
      [media] dvb-usb/it913x: multi firmware loader
      [media] it9135:  add support for IT9135 9005 devices
      [media] dvb_get_firmware: updates for it913x
      [media] it913x add retry to USB bulk endpoints and IO
      [media] it913x: multiple devices on system. Copy ite_config to priv area
      [media] [BUG] Re: add support for IT9135 9005 devices
      [media] it913x stop dual frontend attach in warm state with single devices
      [media] it913x add support for IT9135 9006 devices
      [media] lmedm04 DM04/QQBOX ver 1.91 turn pid filter off by caps option only
      [media] it913x ver 1.18 Turn pid filter off by caps option only
      [media] [BUG] it913x ver 1.20. PID filter problems
      [media] [BUG] it913x ver 1.21 Fixed for issue with 9006 and warm boot
      [media] it913x ver 1.22 corrections to Tuner IDs
      [media] it913x-fe ver 1.13 add BER and UNC monitoring
      [media] it913x changed firmware loader for chip version 2 types
      [media] [BUG] it913x-fe fix typo error making SNR levels unstable

Manjunath Hadli (3):
      [media] davinci vpbe: add dm365 VPBE display driver changes
      [media] davinci vpbe: add dm365 and dm355 specific OSD changes
      [media] davinci vpbe: add VENC block changes to enable dm365 and dm355

Manu Abraham (8):
      [media] DVB: Query DVB frontend delivery capabilities
      [media] DVB: Docbook update for DTV_ENUM_DELSYS
      [media] STB0899: Query DVB frontend delivery capabilities
      [media] STV090x: Query DVB frontend delivery capabilities
      [media] STV0900: Query DVB frontend delivery capabilities
      [media] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C
      [media] CXD2820r: Query DVB frontend delivery capabilities
      [media] PCTV290E: Attach a single frontend

Marek Szyprowski (4):
      [media] media: vb2: fix queueing of userptr buffers with null buffer pointer
      [media] media: vb2: fix potential deadlock in mmap vs. get_userptr handling
      [media] media: vb2: remove plane argument from call_memop and cleanup mempriv usage
      [media] media: vb2: review mem_priv usage and fix potential bugs

Mario Ceresa (1):
      [media] Added model Sveon STV40

Matthieu CASTET (2):
      [media] tm6000: improve loading speed on hauppauge 900H
      [media] tm6000: dvb doesn't work on usb1.1

Mauro Carvalho Chehab (267):
      [media] Update some CARDLIST's
      [media] dvb: Allow select between DVB-C Annex A and Annex C
      [media] Properly implement ITU-T J.88 Annex C support
      [media] em28xx: Fix some Terratec entries (H5 and XS)
      [media] xc5000: Add support for get_if_frequency
      [media] em28xx: Fix CodingStyle issues introduced by changeset 82e7dbb
      [media] em28xx: Add IR support for em2884
      [media] em28xx: Add IR support for HVR-930C
      [media] ir-nec-decoder: Report what bit failed at debug msg
      [media] rc: Add support for decoding Sanyo protocol
      Merge tag 'v3.2-rc2' into staging/for_v3.3
      [media] em28xx: Fix a few warnings due to HVR-930C addition
      [media] firedtv-avc: Fix compilation warnings
      [media] tm6000: Add a few missing bits to alsa
      [media] tm6000: Fix tm6010 audio standard selection
      [media] tm6000: Warning cleanup
      [media] tm6000: Fix IR register names
      [media] tuner-xc2028: Better report signal strength
      [media] tm6000: add IR support for HVR-900H
      [media] tm6000: rewrite IR support
      [media] tm6000: Allow auto-detecting tm6000 devices
      [media] tm6000: Use a 16 scancode bitmask for IR
      [media] tm6000: automatically load alsa and dvb modules
      [media] tm6000: fix OOPS at tm6000_ir_int_stop() and tm6000_ir_int_start()
      [media] xc5000: Remove the global mutex lock at xc5000 firmware init
      [media] xc5000,tda18271c2dd: Fix bandwidth calculus
      [media] xc5000: Add support for 7MHz bandwidth for DVB-C/DVB-T
      [media] drxk: Switch the delivery system on FE_SET_PROPERTY
      [media] tm6000: Fix a warning at tm6000_ir_int_start()
      [media] budget-ci: Fix Hauppauge RC-5 IR support
      [media] Update documentation to reflect DVB-C Annex A/C support
      [media] Remove Annex A/C selection via roll-off factor
      [media] drx-k: report the supported delivery systems
      [media] tda10023: Don't use a magic numbers for QAM modulation
      [media] tda10023: add support for DVB-C Annex C
      [media] tda10021: Don't use a magic numbers for QAM modulation
      [media] tda10021: Add support for DVB-C Annex C
      Merge tag 'v3.2-rc7' into staging/for_v3.3
      [media] tda18271c2dd: fix support for DVB-C
      [media] videobuf2-core: fix a warning at vb2
      [media] update Documentation/video4linux/CARDLIST.*
      [media] dvb: replace SYS_DVBC_ANNEX_AC by the right delsys
      [media] dvb_core: estimate bw for all non-terrestial systems
      [media] qt1010: remove fake implementaion of get_bandwidth()
      [media] mt2060: remove fake implementaion of get_bandwidth()
      [media] mt2031: remove fake implementaion of get_bandwidth()
      [media] mc44s803: use DVBv5 parameters on set_params()
      [media] max2165: use DVBv5 parameters on set_params()
      [media] mt2266: use DVBv5 parameters for set_params()
      [media] mxl5005s: use DVBv5 parameters on set_params()
      [media] mxl5005s: fix: don't discard bandwidth changes
      [media] mxl5007t: use DVBv5 parameters on set_params()
      [media] tda18218: use DVBv5 parameters on set_params()
      [media] tda18271: add support for QAM 7 MHz map
      [media] tda18271-fe: use DVBv5 parameters on set_params()
      [media] tda827x: use DVBv5 parameters on set_params()
      [media] tuner-xc2028: use DVBv5 parameters on set_params()
      [media] xc4000: use DVBv5 parameters on set_params()
      [media] cx24113: use DVBv5 parameters on set_params()
      [media] zl10039: use DVBv5 parameters on set_params()
      [media] av7110: use DVBv5 parameters on set_params()
      [media] budget-ci: use DVBv5 parameters on set_params()
      [media] budget-patch: use DVBv5 parameters on set_params()
      [media] saa7134: use DVBv5 parameters on set_params()
      [media] cx88: use DVBv5 parameters on set_params()
      [media] tua6100: use DVBv5 parameters on set_params()
      [media] itd1000: use DVBv5 parameters on set_params()
      [media] bsbe1, bsru6, tdh1: use DVBv5 parameters on set_params()
      [media] ix2505v: use DVBv5 parameters on set_params()
      [media] stb6000: use DVBv5 parameters on set_params()
      [media] tda826x: use DVBv5 parameters on set_params()
      [media] mxl111sf-tuner: use DVBv5 parameters on set_params()
      [media] mantis_vp1033: use DVBv5 parameters on set_params()
      [media] mantis_vp2033: use DVBv5 parameters on set_params()
      [media] mantis_vp2040: use DVBv5 parameters on set_params()
      [media] pluto2: use DVBv5 parameters on set_params()
      [media] dvb-ttusb-budget: use DVBv5 parameters on set_params()
      [media] tuner-simple: use DVBv5 parameters on set_params()
      [media] dvb-bt8xx: use DVBv5 parameters on set_params()
      [media] dvb-pll: use DVBv5 parameters on set_params()
      [media] zl10036: use DVBv5 parameters on set_params()
      [media] dib0070: Remove unused dvb_frontend_parameters
      [media] cxusb: use DVBv5 parameters on set_params()
      [media] dib0700_devices: use DVBv5 parameters on set_params()
      [media] budget-av: use DVBv5 parameters on set_params()
      [media] budget: use DVBv5 parameters on set_params()
      [media] dvb: remove dvb_frontend_parameters from calc_regs()
      [media] tuners: remove dvb_frontend_parameters from set_params()
      [media] dvb-core: allow demods to specify the supported delsys
      [media] Rename set_frontend fops to set_frontend_legacy
      [media] dvb-core: add support for a DVBv5 get_frontend() callback
      [media] atbm8830: convert set_fontend to new way and fix delivery system
      [media] au8522_dig: convert set_fontend to use DVBv5 parameters
      [media] bcm3510: convert set_fontend to use DVBv5 parameters
      [media] cx22700: convert set_fontend to use DVBv5 parameters
      [media] cx22702: convert set_fontend to use DVBv5 parameters
      [media] cx24110: convert set_fontend to use DVBv5 parameters
      [media] cx24116: report delivery system and cleanups
      [media] cx23123: remove an unused argument from cx24123_pll_writereg()
      [media] av7110: convert set_fontend to use DVBv5 parameters
      [media] cx23123: convert set_fontend to use DVBv5 parameters
      [media] dibx000: convert set_fontend to use DVBv5 parameters
      [media] dib9000: remove unused parameters
      [media] cx24113: cleanup: remove unused init
      [media] dib9000: Get rid of the remaining DVBv3 legacy stuff
      [media] dib3000mb: convert set_fontend to use DVBv5 parameters
      [media] dib8000: Remove the old DVBv3 struct from it and add delsys
      [media] dib9000: get rid of unused dvb_frontend_parameters
      [media] zl10353: convert set_fontend to use DVBv5 parameters
      [media] em28xx-dvb: don't initialize drx-d non-used fields with zero
      [media] drxd: convert set_fontend to use DVBv5 parameters
      [media] drxk: convert set_fontend to use DVBv5 parameters
      [media] ds3000: convert set_fontend to use DVBv5 parameters
      [media] dvb_dummy_fe: convert set_fontend to use DVBv5 parameters
      [media] ec100: convert set_fontend to use DVBv5 parameters
      [media] it913x-fe: convert set_fontend to use DVBv5 parameters
      [media] l64781: convert set_fontend to use DVBv5 parameters
      [media] lgs8gl5: convert set_fontend to use DVBv5 parameters
      [media] lgdt330x: convert set_fontend to use DVBv5 parameters
      [media] lgdt3305: convert set_fontend to use DVBv5 parameters
      [media] lgs8gxx: convert set_fontend to use DVBv5 parameters
      [media] vez1x93: convert set_fontend to use DVBv5 parameters
      [media] mb86a16: Add delivery system type at fe struct
      [media] mb86a20s: convert set_fontend to use DVBv5 parameters
      [media] mt352: convert set_fontend to use DVBv5 parameters
      [media] nxt6000: convert set_fontend to use DVBv5 parameters
      [media] s5h1432: convert set_fontend to use DVBv5 parameters
      [media] sp8870: convert set_fontend to use DVBv5 parameters
      [media] sp887x: convert set_fontend to use DVBv5 parameters
      [media] stv0367: convert set_fontend to use DVBv5 parameters
      [media] tda10048: convert set_fontend to use DVBv5 parameters
      [media] tda1004x: convert set_fontend to use DVBv5 parameters
      [media] s921: convert set_fontend to use DVBv5 parameters
      [media] mt312: convert set_fontend to use DVBv5 parameters
      [media] s5h1420: convert set_fontend to use DVBv5 parameters
      [media] si21xx: convert set_fontend to use DVBv5 parameters
      [media] stb0899: convert get_frontend to the new struct
      [media] stb6100: use get_frontend, instead of get_frontend_legacy()
      [media] stv0288: convert set_fontend to use DVBv5 parameters
      [media] stv0297: convert set_fontend to use DVBv5 parameters
      [media] stv0299: convert set_fontend to use DVBv5 parameters
      [media] stv900: convert set_fontend to use DVBv5 parameters
      [media] stv090x: use .delsys property, instead of get_property()
      [media] tda10021: convert set_fontend to use DVBv5 parameters
      [media] tda10023: convert set_fontend to use DVBv5 parameters
      [media] tda10071: convert set_fontend to use DVBv5 parameters
      [media] tda10086: convert set_fontend to use DVBv5 parameters
      [media] nxt200x: convert set_fontend to use DVBv5 parameters
      [media] or51132: convert set_fontend to use DVBv5 parameters
      [media] or51211: convert set_fontend to use DVBv5 parameters
      [media] s5h1409: convert set_fontend to use DVBv5 parameters
      [media] s55h1411: convert set_fontend to use DVBv5 parameters
      [media] tda8083: convert set_fontend to use DVBv5 parameters
      [media] vez1820: convert set_fontend to use DVBv5 parameters
      [media] staging/as102: convert set_fontend to use DVBv5 parameters
      [media] dst: convert set_fontend to use DVBv5 parameters
      [media] af9005-fe: convert set_fontend to use DVBv5 parameters
      [media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters
      [media] dtt200u-fe: convert set_fontend to use DVBv5 parameters
      [media] friio-fe: convert set_fontend to use DVBv5 parameters
      [media] gp8psk-fe: convert set_fontend to use DVBv5 parameters
      [media] mxl111sf-demod: convert set_fontend to use DVBv5 parameters
      [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
      [media] vp7045-fe: convert set_fontend to use DVBv5 parameters
      [media] firedtv: convert set_fontend to use DVBv5 parameters
      [media] siano: convert set_fontend to use DVBv5 parameters
      [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
      [media] tlg2300: convert set_fontend to use DVBv5 parameters
      [media] cxd2820: convert get|set_fontend to use DVBv5 parameters
      [media] af9013: convert get|set_fontend to use DVBv5 parameters
      [media] af9015: convert set_fontend to use DVBv5 parameters
      [media] dvb-core: remove get|set_frontend_legacy
      [media] dvb: simplify get_tune_settings() struct
      [media] dvb-core: Don't pass DVBv3 parameters on tune() fops
      [media] dvb: don't pass a DVBv3 parameter for search() fops
      [media] dvb: remove the track() fops
      [media] dvb-core: don't use fe_bandwidth_t on driver
      [media] dvb: don't use DVBv3 bandwidth macros
      [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
      [media] dvb-core: be sure that drivers won't use DVBv3 internally
      [media] s921: Properly report the delivery system
      [media] dvb_frontend: Fix inversion breakage due to DVBv5 conversion
      [media] dvb: don't require a parameter for get_frontend
      [media] dvb: Add ops.delsys to the remaining frontends
      stv0297: Fix delivery system
      [media] dvb: remove the extra parameter on get_frontend
      [media] fs/compat_ioctl: it needs to see the DVBv3 compat stuff
      [media] stb6100: Properly retrieve symbol rate
      [media] saa7134: fix IR handling for HVR-1110
      [media] dvb: Initialize all cache values
      [media] dvb_frontend: Handle all possible DVBv3 values for bandwidth
      [media] dvb: move dvb_set_frontend logic into a separate routine
      [media] dvb_frontend: Don't use ops->info.type anymore
      [media] dvb_frontend: Fix DVBv3 emulation
      [media] dvb-core: Fix ISDB-T defaults
      [media] dvb: get rid of fepriv->parameters_in
      [media] dvb: deprecate the usage of ops->info.type
      [media] dvb: Remove ops->info.type from frontends
      [media] add driver for mt2063
      [media] mt2063: CodingStyle fixes
      [media] mt2063: Fix some Coding styles at mt2063.h
      [media] mt2063: Move code from mt2063_cfg.h
      [media] mt2063: Fix the driver to make it compile
      [media] mt2063: Use standard Linux types, instead of redefining them
      [media] mt2063: Remove most of the #if's
      [media] mt2063: Re-define functions as static
      [media] mt2063: Remove unused stuff
      [media] mt2063: get rid of compilation warnings
      [media] mt2063: Move data structures to the driver
      [media] mt2063: Remove internal version checks
      [media] mt2063: Use Unix standard error handling
      [media] mt2063: Remove unused data structures
      [media] mt2063: Merge the two state structures into one
      [media] mt2063: Use state for the state structure
      [media] mt2063: Remove the code for more than one adjacent mt2063 tuners
      [media] mt2063: Rewrite read/write logic at the driver
      [media] mt2063: Simplify some functions
      [media] mt2063: Simplify device init logic
      [media] mt2063: Don't violate the DVB API
      [media] mt2063: Use linux default max function
      [media] mt2063: Remove several unused parameters
      [media] mt2063: simplify lockstatus logic
      [media] mt2063: Simplify mt2063_setTune logic
      [media] mt2063: Rework on the publicly-exported functions
      [media] mt2063: Remove setParm/getParm abstraction layer
      [media] mt2063: Reorder the code to avoid function prototypes
      [media] mt2063: Cleanup some function prototypes
      [media] mt2063: make checkpatch.pl happy
      [media] mt2063: Fix analog/digital set params logic
      [media] mt2063: Fix comments
      [media] mt2063: Rearrange the delivery system functions
      [media] mt2063: Properly document the author of the original driver
      [media] mt2063: Convert it to the DVBv5 way for set_params()
      [media] mt2063: Add some debug printk's
      [media] mt2063: Rewrite tuning logic
      [media] mt2063: Remove two unused temporary vars
      [media] mt2063: don't crash if device is not initialized
      [media] mt2063: Print a message about the detected mt2063 type
      [media] mt2063: Fix i2c read message
      [media] mt2063: print the detected version
      [media] mt2063: add some useful info for the dvb callback calls
      [media] mt2063: Add support for get_if_frequency()
      [media] mt2063: Add it to the building system
      [media] drxk: Improve a few debug messages
      [media] drxk: Add support for parallel mode and prints mpeg mode
      [media] Don't test for ops->info.type inside drivers
      [media] cx25840: Fix compilation for i386 architecture
      [media] dvb_frontend: regression fix: add a missing inc inside the loop
      [media] dvb_frontend: Update the dynamic info->type
      [media] dvb_frontend: improve documentation on set_delivery_system()
      [media] drxk: remove ops.info.frequency_stepsize from DVB-C
      [media] drxk: create only one frontend for both DVB-C and DVB-T
      [media] drxk_hard: fix locking issues when changing the delsys
      Merge tag 'v3.2' into staging/for_v3.3
      [media] dvb-bt8xx: Fix a printk statement
      [media] drxk_hard: Remove dead code
      [media] dvb: remove bogus modulation check
      [media] dvb_ca_en50221: fix compilation breakage
      [media] cx231xx-input: stop polling if the device got removed.
      [media] mb86a20s: implement get_frontend()
      [media] cx231xx: Fix unregister logic
      [media] cx231xx: cx231xx_devused is racy
      [media] cx231xx: fix device disconnect checks
      [media] tda18271-fe: Fix support for ISDB-T
      [media] [PATCH] don't reset the delivery system on DTV_CLEAR
      mb86a20s: Group registers into the same line
      mb86a20s: Add a few more register settings at the init seq

Michael Krufky (9):
      [media] au8522: Calculate signal strength shown as percentage from SNR up to 35dB
      [media] s5h1409: Calculate signal strength shown as percentage from SNR up to 35dB
      [media] s5h1411: Calculate signal strength shown as percentage from SNR up to 35dB
      [media] mxl111sf: add mxl111sf_tuner_get_if_frequency
      [media] mxl5007t: add mxl5007t_get_if_frequency
      [media] tda18271: add tda18271_get_if_frequency
      [media] mxl111sf: absorb size_of_priv into *_STREAMING_CONFIG macros
      [media] lgdt330x: fix behavior of read errors in lgdt330x_read_ucblocks
      [media] lgdt330x: warn on errors blasting modulation config to the lgdt3303

Miroslav Slugen (1):
      [media] cx88: Fix radio support for Leadtek DTV2000H J

Olivier Grenie (8):
      [media] dib7000p/dib0090: update the driver
      [media] dib7090: add the reference board TFE7090E
      [media] DiBcom: correct warnings
      [media] DiB8000: improve the tuning and the SNR monitoring
      [media] dib7090: add the reference board TFE7790E
      [media] add the support for DiBcom dib8096P
      [media] dib8096P: add the reference board TFE8096P
      [media] dib9090: limit the I2C speed

Paul Bolle (1):
      [media] Fix typos in VIDEO_CX231XX_DVB Kconfig entry

Pete (1):
      [media] go7007: Fix 2250 urb type

Peter De Schrijver (2):
      [media] bt8xx: add support for Tongwei Video Technology TD-3116
      [media] bt8xx: add support for PCI device ID 0x36c

Piotr Chmura (1):
      [media] staging: as102: Remove comment tags for editors configuration

Samuel Rakitnican (1):
      [media] rc-videomate-m1f.c Rename to match remote controler name

Sascha Sommer (4):
      [media] em28xx: Fix: I2C_CLK write error message checks wrong return code
      [media] em28xx: Do not modify EM28XX_R06_I2C_CLK for em2800
      [media] em28xx: increase maxwidth for em2800
      [media] em28xx: Fix tuner_type for Terratec Cinergy 200 USB

Stas Sergeev (1):
      [media] [saa7134] do not change mute state for capturing audio

Stefan Ringel (7):
      [media] tm6000: remove experimental depends
      [media] tm6000: bugfix at tm6000_set_reg_mask() register setting
      [media] tm6000: bugfix at interrupt reset
      [media] tm6000: bugfix at bulk transfer
      [media] tm6000: bugfix data check
      [media] mt2063: fix get_if_frequency call
      [media] cx23885: add Terratec Cinergy T PCIe dual

Steven Toth (12):
      [media] cx25840 / cx23885: Fixing audio/volume regression
      [media] cx23885: Cleanup MPEG encoder GPIO handling
      [media] cx23885: Ensure the MPEG encoder height is configured from the norm
      [media] cx23885: Configure the MPEG encoder early to avoid jerky video
      [media] cx25840: Add a flag to enable the CX23888 DIF to be enabled or not
      [media] cx23885: Hauppauge HVR1850 Analog driver support
      [media] cx23885: Control cleanup on the MPEG Encoder
      [media] cx23885: Bugfix /sys/class/video4linux/videoX/name truncation
      [media] cx25840: Hauppauge HVR1850 Analog driver support
      [media] cx25840: Added g_std support to the video decoder driver
      [media] cx25840: Add support for g_input_status
      [media] cx23885: Query the CX25840 during enum_input for status

Sylwester Nawrocki (27):
      [media] staging: as102: Remove unnecessary typedefs
      [media] staging: as102: Remove leftovers of the SPI bus driver
      [media] staging: as102: Make the driver select CONFIG_FW_LOADER
      [media] staging: as102: Replace pragma(pack) with attribute __packed
      [media] staging: as102: Fix the dvb device registration error path
      [media] staging: as102: Whitespace and indentation cleanup
      [media] staging: as102: Replace printk(KERN_<LEVEL> witk pr_<level>
      [media] staging: as102: Remove linkage specifiers for C++
      [media] staging: as102: Use linux/uaccess.h instead of asm/uaccess.h
      [media] staging: as102: Move variable declarations to the header
      [media] staging: as102: Define device name string pointers constant
      [media] staging: as102: Eliminate as10x_handle_t alias
      [media] staging: as102: Add missing function argument
      [media] Remove unneeded comments from the media API DocBook files
      [media] v4l: Add new alpha component control
      [media] s5p-fimc: Add support for alpha component configuration
      [media] m5mols: Simplify the I2C registers definition
      [media] m5mols: Remove mode_save field from struct m5mols_info
      [media] m5mols: Change the end of frame v4l2_subdev notification id
      [media] m5mols: Don't ignore v4l2_ctrl_handler_setup() return value
      [media] m5mols: Move the control handler initialization to probe()
      [media] m5mols: Do not reset the configured pixel format when unexpected
      [media] m5mols: Change auto exposure control default value to AUTO
      [media] m5mols: Enable v4l subdev device node
      [media] s5p-csis: Enable v4l subdev device node
      [media] s5p-fimc: Prevent lock up caused by incomplete H/W initialization
      [media] v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes

Theodore Kilgore (1):
      [media] gspca: Add jl2005bcd sub driver

Thierry Reding (3):
      [media] tm6000: Fix fast USB access quirk
      [media] tm6000: Fix bad indentation
      [media] tm6000: Fix check for interrupt endpoint

Thomas Meyer (10):
      [media] drxd: Use kmemdup rather than duplicating its implementation
      [media] dw2102: Use kmemdup rather than duplicating its implementation
      [media] v4l: Casting (void *) value returned by kmalloc is useless
      [media] cx25821: Use kmemdup rather than duplicating its implementation
      [media] pwc: Use kmemdup rather than duplicating its implementation
      [media] pvrusb2: Use kcalloc instead of kzalloc to allocate array
      [media] v4l: s5p-tv: Use kcalloc instead of kzalloc to allocate array
      [media] uvcvideo: Use kcalloc instead of kzalloc to allocate array
      [media] v4l2-ctrls: Use kcalloc instead of kzalloc to allocate array
      [media] xc4000: Use kcalloc instead of kzalloc to allocate array

Thomas Petazzoni (5):
      [media] cx231xx: fix crash after load/unload/load of module
      [media] cx231xx: remove useless 'lif' variable in cx231xx_usb_probe()
      [media] cx231xx: simplify argument passing to cx231xx_init_dev()
      [media] cx231xx: use URB_NO_TRANSFER_DMA_MAP on URBs allocated with usb_alloc_urb()
      [media] em28xx: simplify argument passing to em28xx_init_dev()

Tomas Winkler (11):
      [media] easycap: cleanup function usage
      [media] easycap: remove linux/version.h include from easycap_ioctl.c
      [media] easycap: compress initialization tables
      [media] easycap: streamline the code
      [media] easycap: drop initializations to 0 in the probe functions
      [media] easycap: use usb_kill_urb wrapper functions
      [media] easycap: easycap_usb_driver should be static to easycap_main.c
      [media] easycap: remove unused members of struct easycap
      [media] easycap: add easycap prefix to global functions names
      [media] easycap: drop usb_class_driver
      [media] easycap: fix warnings: variable set but not used

Tomasz Stanislawski (7):
      [media] v4l: add support for selection api
      [media] doc: v4l: add binary images for selection API
      [media] doc: v4l: add documentation for selection API
      [media] v4l: emulate old crop API using extended crop/compose API
      [media] v4l: s5p-tv: mixer: add support for selection API
      [media] v4l: s5p-tv: mixer: fix setup of VP scaling
      [media] doc: v4l: selection: choose pixels as units for selection rectangles

Xi Wang (3):
      [media] wl128x: fmdrv_common: fix signedness bugs
      [media] wl128x: fmdrv_rx: fix signedness bugs
      [media] wl128x: fmdrv_tx: fix signedness bugs

lawrence rust (1):
      [media] ir-rc6-decoder: Support RC6-6A variable length data

sensoray-dev (2):
      [media] saa7134: adding Sensoray boards to saa7134 driver
      [media] bttv: adding Sensoray 611 board to driver

tvboxspy (1):
      [media] it913x-fe ver 1.09 amend adc table entries

 Documentation/DocBook/media/constraints.png.b64    |   59 +
 Documentation/DocBook/media/dvb/dvbproperty.xml    |   19 +-
 Documentation/DocBook/media/dvb/frontend.xml       |    8 +-
 Documentation/DocBook/media/selection.png.b64      |  206 ++
 Documentation/DocBook/media/v4l/biblio.xml         |    8 -
 Documentation/DocBook/media/v4l/common.xml         |   10 +-
 Documentation/DocBook/media/v4l/compat.xml         |   30 +-
 Documentation/DocBook/media/v4l/controls.xml       |   43 +-
 Documentation/DocBook/media/v4l/dev-capture.xml    |    8 -
 Documentation/DocBook/media/v4l/dev-codec.xml      |    8 -
 Documentation/DocBook/media/v4l/dev-effect.xml     |    8 -
 Documentation/DocBook/media/v4l/dev-event.xml      |    8 -
 Documentation/DocBook/media/v4l/dev-osd.xml        |    8 -
 Documentation/DocBook/media/v4l/dev-output.xml     |    8 -
 Documentation/DocBook/media/v4l/dev-overlay.xml    |    8 -
 Documentation/DocBook/media/v4l/dev-radio.xml      |    8 -
 Documentation/DocBook/media/v4l/dev-raw-vbi.xml    |    8 -
 Documentation/DocBook/media/v4l/dev-rds.xml        |   16 +-
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml |    9 -
 Documentation/DocBook/media/v4l/dev-teletext.xml   |    8 -
 Documentation/DocBook/media/v4l/driver.xml         |    8 -
 Documentation/DocBook/media/v4l/func-close.xml     |    8 -
 Documentation/DocBook/media/v4l/func-ioctl.xml     |    8 -
 Documentation/DocBook/media/v4l/func-mmap.xml      |    8 -
 Documentation/DocBook/media/v4l/func-munmap.xml    |    8 -
 Documentation/DocBook/media/v4l/func-open.xml      |    8 -
 Documentation/DocBook/media/v4l/func-poll.xml      |    8 -
 Documentation/DocBook/media/v4l/func-read.xml      |    8 -
 Documentation/DocBook/media/v4l/func-select.xml    |    8 -
 Documentation/DocBook/media/v4l/func-write.xml     |    8 -
 Documentation/DocBook/media/v4l/io.xml             |    8 -
 Documentation/DocBook/media/v4l/libv4l.xml         |    7 -
 Documentation/DocBook/media/v4l/pixfmt-grey.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt-m420.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt-nv12.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |    8 -
 Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml  |    8 -
 Documentation/DocBook/media/v4l/pixfmt-nv16.xml    |    8 -
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |   15 +-
 .../DocBook/media/v4l/pixfmt-packed-yuv.xml        |    8 -
 Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml |    8 -
 Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml  |    8 -
 Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml  |    8 -
 Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml  |    8 -
 Documentation/DocBook/media/v4l/pixfmt-uyvy.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt-vyuy.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt-y16.xml     |    8 -
 Documentation/DocBook/media/v4l/pixfmt-y41p.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt-yuv410.xml  |    8 -
 Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml |    8 -
 Documentation/DocBook/media/v4l/pixfmt-yuv420.xml  |    8 -
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |    8 -
 Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml |    8 -
 Documentation/DocBook/media/v4l/pixfmt-yuyv.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt-yvyu.xml    |    8 -
 Documentation/DocBook/media/v4l/pixfmt.xml         |   13 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |  321 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-enum-dv-presets.xml   |    8 -
 .../DocBook/media/v4l/vidioc-enum-fmt.xml          |    8 -
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    8 -
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    8 -
 Documentation/DocBook/media/v4l/vidioc-enumstd.xml |    8 -
 Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml  |    8 -
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 -
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |   14 +-
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    8 -
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |    8 -
 .../DocBook/media/v4l/vidioc-g-priority.xml        |    8 -
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  304 ++
 Documentation/DocBook/media/v4l/vidioc-g-std.xml   |    8 -
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   18 +-
 .../DocBook/media/v4l/vidioc-querybuf.xml          |    8 -
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |    8 -
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    8 -
 Documentation/dvb/get_dvb_firmware                 |   42 +-
 Documentation/feature-removal-schedule.txt         |   35 -
 Documentation/video4linux/CARDLIST.au0828          |    2 +-
 Documentation/video4linux/CARDLIST.bttv            |    3 +-
 Documentation/video4linux/CARDLIST.cx23885         |    3 +
 Documentation/video4linux/CARDLIST.cx88            |    2 +
 Documentation/video4linux/CARDLIST.em28xx          |   10 +-
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/CARDLIST.saa7164         |    2 +
 Documentation/video4linux/gspca.txt                |    2 +
 Documentation/video4linux/v4l2-framework.txt       |   11 +
 MAINTAINERS                                        |    8 +
 drivers/media/common/tuners/Kconfig                |    9 +-
 drivers/media/common/tuners/Makefile               |    1 +
 drivers/media/common/tuners/max2165.c              |   39 +-
 drivers/media/common/tuners/mc44s803.c             |   10 +-
 drivers/media/common/tuners/mt2060.c               |   13 +-
 drivers/media/common/tuners/mt2060_priv.h          |    1 -
 drivers/media/common/tuners/mt2063.c               | 2307 ++++++++++++++
 drivers/media/common/tuners/mt2063.h               |   36 +
 drivers/media/common/tuners/mt2131.c               |   20 +-
 drivers/media/common/tuners/mt2131_priv.h          |    1 -
 drivers/media/common/tuners/mt2266.c               |   25 +-
 drivers/media/common/tuners/mxl5005s.c             |   69 +-
 drivers/media/common/tuners/mxl5007t.c             |   98 +-
 drivers/media/common/tuners/qt1010.c               |   21 +-
 drivers/media/common/tuners/qt1010_priv.h          |    1 -
 drivers/media/common/tuners/tda18212.c             |   72 +-
 drivers/media/common/tuners/tda18212.h             |    4 +
 drivers/media/common/tuners/tda18218.c             |   34 +-
 drivers/media/common/tuners/tda18218_priv.h        |    2 +
 drivers/media/common/tuners/tda18271-fe.c          |   83 +-
 drivers/media/common/tuners/tda18271-maps.c        |    4 +
 drivers/media/common/tuners/tda18271-priv.h        |    2 +
 drivers/media/common/tuners/tda18271.h             |    1 +
 drivers/media/common/tuners/tda827x.c              |   52 +-
 drivers/media/common/tuners/tuner-simple.c         |   68 +-
 drivers/media/common/tuners/tuner-xc2028.c         |  116 +-
 drivers/media/common/tuners/xc4000.c               |  105 +-
 drivers/media/common/tuners/xc5000.c               |  147 +-
 drivers/media/dvb/b2c2/flexcop.c                   |   29 +-
 drivers/media/dvb/bt8xx/dst.c                      |   72 +-
 drivers/media/dvb/bt8xx/dst_common.h               |    2 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |  205 +-
 drivers/media/dvb/ddbridge/ddbridge-core.c         |    2 +-
 drivers/media/dvb/dm1105/dm1105.c                  |    7 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |    4 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |  885 ++++--
 drivers/media/dvb/dvb-core/dvb_frontend.h          |   27 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    4 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    5 +-
 drivers/media/dvb/dvb-usb/af9005-fe.c              |  105 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |   23 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |  492 +++-
 drivers/media/dvb/dvb-usb/af9015.h                 |    6 +
 drivers/media/dvb/dvb-usb/anysee.c                 |  411 +++-
 drivers/media/dvb/dvb-usb/anysee.h                 |    6 +
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c           |   33 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |   11 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  717 +++++-
 drivers/media/dvb/dvb-usb/digitv.c                 |    4 +-
 drivers/media/dvb/dvb-usb/dtt200u-fe.c             |   33 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c            |    8 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    6 +
 drivers/media/dvb/dvb-usb/dw2102.c                 |   93 +-
 drivers/media/dvb/dvb-usb/friio-fe.c               |   29 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c              |   24 +-
 drivers/media/dvb/dvb-usb/it913x.c                 |  336 ++-
 drivers/media/dvb/dvb-usb/lmedm04.c                |    8 +-
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c         |   42 +-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c         |  102 +-
 drivers/media/dvb/dvb-usb/mxl111sf.c               |   16 +-
 drivers/media/dvb/dvb-usb/ttusb2.c                 |   19 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c              |   20 +-
 drivers/media/dvb/dvb-usb/vp7045-fe.c              |   32 +-
 drivers/media/dvb/firewire/firedtv-avc.c           |   98 +-
 drivers/media/dvb/firewire/firedtv-dvb.c           |    5 +-
 drivers/media/dvb/firewire/firedtv-fe.c            |   35 +-
 drivers/media/dvb/firewire/firedtv.h               |    4 +-
 drivers/media/dvb/frontends/Kconfig                |    7 +
 drivers/media/dvb/frontends/Makefile               |    1 +
 drivers/media/dvb/frontends/af9013.c               | 1783 ++++++------
 drivers/media/dvb/frontends/af9013.h               |  113 +-
 drivers/media/dvb/frontends/af9013_priv.h          |   93 +-
 drivers/media/dvb/frontends/atbm8830.c             |   27 +-
 drivers/media/dvb/frontends/au8522_dig.c           |   58 +-
 drivers/media/dvb/frontends/bcm3510.c              |   18 +-
 drivers/media/dvb/frontends/bsbe1.h                |    7 +-
 drivers/media/dvb/frontends/bsru6.h                |    9 +-
 drivers/media/dvb/frontends/cx22700.c              |   51 +-
 drivers/media/dvb/frontends/cx22702.c              |   69 +-
 drivers/media/dvb/frontends/cx24110.c              |   20 +-
 drivers/media/dvb/frontends/cx24113.c              |   10 +-
 drivers/media/dvb/frontends/cx24116.c              |   36 +-
 drivers/media/dvb/frontends/cx24123.c              |   56 +-
 drivers/media/dvb/frontends/cxd2820r.h             |   13 -
 drivers/media/dvb/frontends/cxd2820r_c.c           |   25 +-
 drivers/media/dvb/frontends/cxd2820r_core.c        |  641 ++---
 drivers/media/dvb/frontends/cxd2820r_priv.h        |   23 +-
 drivers/media/dvb/frontends/cxd2820r_t.c           |   63 +-
 drivers/media/dvb/frontends/cxd2820r_t2.c          |   70 +-
 drivers/media/dvb/frontends/dib0070.c              |   10 +-
 drivers/media/dvb/frontends/dib0090.c              |  165 +-
 drivers/media/dvb/frontends/dib0090.h              |   54 +-
 drivers/media/dvb/frontends/dib3000mb.c            |  113 +-
 drivers/media/dvb/frontends/dib3000mb_priv.h       |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c            |  132 +-
 drivers/media/dvb/frontends/dib7000m.c             |  136 +-
 drivers/media/dvb/frontends/dib7000p.c             |  456 ++--
 drivers/media/dvb/frontends/dib7000p.h             |   16 +-
 drivers/media/dvb/frontends/dib8000.c              | 1073 ++++++-
 drivers/media/dvb/frontends/dib8000.h              |   42 +-
 drivers/media/dvb/frontends/dib9000.c              |   36 +-
 drivers/media/dvb/frontends/dibx000_common.h       |   17 +-
 drivers/media/dvb/frontends/drxd.h                 |    2 -
 drivers/media/dvb/frontends/drxd_hard.c            |   62 +-
 drivers/media/dvb/frontends/drxk.h                 |   11 +-
 drivers/media/dvb/frontends/drxk_hard.c            |  314 +-
 drivers/media/dvb/frontends/drxk_hard.h            |    8 +-
 drivers/media/dvb/frontends/ds3000.c               |   36 +-
 drivers/media/dvb/frontends/dvb-pll.c              |   65 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.c         |   18 +-
 drivers/media/dvb/frontends/ec100.c                |   20 +-
 drivers/media/dvb/frontends/hd29l2.c               |  861 ++++++
 drivers/media/dvb/frontends/hd29l2.h               |   66 +
 drivers/media/dvb/frontends/hd29l2_priv.h          |  314 ++
 drivers/media/dvb/frontends/it913x-fe-priv.h       |  806 +++++-
 drivers/media/dvb/frontends/it913x-fe.c            |  289 ++-
 drivers/media/dvb/frontends/it913x-fe.h            |   43 +-
 drivers/media/dvb/frontends/itd1000.c              |    7 +-
 drivers/media/dvb/frontends/ix2505v.c              |    8 +-
 drivers/media/dvb/frontends/l64781.c               |  117 +-
 drivers/media/dvb/frontends/lgdt3305.c             |   98 +-
 drivers/media/dvb/frontends/lgdt330x.c             |   37 +-
 drivers/media/dvb/frontends/lgs8gl5.c              |   29 +-
 drivers/media/dvb/frontends/lgs8gxx.c              |   26 +-
 drivers/media/dvb/frontends/mb86a16.c              |    8 +-
 drivers/media/dvb/frontends/mb86a20s.c             |  546 ++--
 drivers/media/dvb/frontends/mt312.c                |   37 +-
 drivers/media/dvb/frontends/mt352.c                |   65 +-
 drivers/media/dvb/frontends/nxt200x.c              |   17 +-
 drivers/media/dvb/frontends/nxt6000.c              |   32 +-
 drivers/media/dvb/frontends/or51132.c              |   52 +-
 drivers/media/dvb/frontends/or51211.c              |   13 +-
 drivers/media/dvb/frontends/s5h1409.c              |   48 +-
 drivers/media/dvb/frontends/s5h1411.c              |   48 +-
 drivers/media/dvb/frontends/s5h1420.c              |   71 +-
 drivers/media/dvb/frontends/s5h1432.c              |   36 +-
 drivers/media/dvb/frontends/s921.c                 |   23 +-
 drivers/media/dvb/frontends/si21xx.c               |   20 +-
 drivers/media/dvb/frontends/sp8870.c               |   29 +-
 drivers/media/dvb/frontends/sp887x.c               |   50 +-
 drivers/media/dvb/frontends/stb0899_drv.c          |   37 +-
 drivers/media/dvb/frontends/stb6000.c              |    8 +-
 drivers/media/dvb/frontends/stb6100.c              |    6 +-
 drivers/media/dvb/frontends/stv0288.c              |   17 +-
 drivers/media/dvb/frontends/stv0297.c              |   37 +-
 drivers/media/dvb/frontends/stv0299.c              |   32 +-
 drivers/media/dvb/frontends/stv0367.c              |  156 +-
 drivers/media/dvb/frontends/stv0900_core.c         |   37 +-
 drivers/media/dvb/frontends/stv090x.c              |   13 +-
 drivers/media/dvb/frontends/stv6110.c              |    3 +-
 drivers/media/dvb/frontends/tda10021.c             |  111 +-
 drivers/media/dvb/frontends/tda10023.c             |  103 +-
 drivers/media/dvb/frontends/tda10048.c             |   83 +-
 drivers/media/dvb/frontends/tda1004x.c             |  111 +-
 drivers/media/dvb/frontends/tda10071.c             |    8 +-
 drivers/media/dvb/frontends/tda10086.c             |   62 +-
 drivers/media/dvb/frontends/tda18271c2dd.c         |   52 +-
 drivers/media/dvb/frontends/tda8083.c              |   19 +-
 drivers/media/dvb/frontends/tda826x.c              |    7 +-
 drivers/media/dvb/frontends/tdhd1.h                |   11 +-
 drivers/media/dvb/frontends/tua6100.c              |   31 +-
 drivers/media/dvb/frontends/ves1820.c              |   23 +-
 drivers/media/dvb/frontends/ves1x93.c              |   23 +-
 drivers/media/dvb/frontends/zl10036.c              |   10 +-
 drivers/media/dvb/frontends/zl10039.c              |   10 +-
 drivers/media/dvb/frontends/zl10353.c              |  116 +-
 drivers/media/dvb/mantis/mantis_vp1033.c           |    8 +-
 drivers/media/dvb/mantis/mantis_vp2033.c           |    9 +-
 drivers/media/dvb/mantis/mantis_vp2040.c           |    9 +-
 drivers/media/dvb/ngene/ngene-cards.c              |    2 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    6 +-
 drivers/media/dvb/pt1/va1j5jf8007s.c               |    6 +-
 drivers/media/dvb/pt1/va1j5jf8007t.c               |    6 +-
 drivers/media/dvb/siano/smsdvb.c                   |   33 +-
 drivers/media/dvb/ttpci/av7110.c                   |  102 +-
 drivers/media/dvb/ttpci/av7110.h                   |    3 +-
 drivers/media/dvb/ttpci/budget-av.c                |   50 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   51 +-
 drivers/media/dvb/ttpci/budget-patch.c             |   27 +-
 drivers/media/dvb/ttpci/budget.c                   |   68 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |  102 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c           |   14 +-
 drivers/media/media-device.c                       |    3 +-
 drivers/media/radio/Kconfig                        |  297 +-
 drivers/media/radio/radio-si4713.c                 |   15 +-
 drivers/media/radio/radio-timb.c                   |   15 +-
 drivers/media/radio/radio-wl1273.c                 |   17 +-
 drivers/media/radio/tef6862.c                      |    8 +-
 drivers/media/radio/wl128x/Kconfig                 |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   58 +-
 drivers/media/radio/wl128x/fmdrv_common.h          |   28 +-
 drivers/media/radio/wl128x/fmdrv_rx.c              |   84 +-
 drivers/media/radio/wl128x/fmdrv_rx.h              |   50 +-
 drivers/media/radio/wl128x/fmdrv_tx.c              |   61 +-
 drivers/media/radio/wl128x/fmdrv_tx.h              |   20 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    1 +
 drivers/media/rc/Kconfig                           |   10 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ir-nec-decoder.c                  |    4 +-
 drivers/media/rc/ir-raw.c                          |    1 +
 drivers/media/rc/ir-rc6-decoder.c                  |   67 +-
 drivers/media/rc/ir-sanyo-decoder.c                |  205 ++
 drivers/media/rc/keymaps/rc-hauppauge.c            |   51 +
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |   24 +-
 drivers/media/rc/rc-core-priv.h                    |   12 +
 drivers/media/rc/rc-main.c                         |    1 +
 drivers/media/rc/redrat3.c                         |   52 +-
 drivers/media/video/Kconfig                        |  427 ++--
 drivers/media/video/Makefile                       |    4 +
 drivers/media/video/adv7170.c                      |   62 +
 drivers/media/video/as3645a.c                      |  904 ++++++
 drivers/media/video/atmel-isi.c                    |   35 +-
 drivers/media/video/au0828/Kconfig                 |    1 +
 drivers/media/video/au0828/au0828-i2c.c            |    2 +-
 drivers/media/video/bt8xx/bt848.h                  |    5 +-
 drivers/media/video/bt8xx/bttv-cards.c             |   58 +-
 drivers/media/video/bt8xx/bttv-driver.c            |    1 +
 drivers/media/video/bt8xx/bttv-i2c.c               |    2 +-
 drivers/media/video/bt8xx/bttv.h                   |    3 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx18/cx18-i2c.h                |    2 +-
 drivers/media/video/cx231xx/Kconfig                |    6 +-
 drivers/media/video/cx231xx/cx231xx-audio.c        |   24 +-
 drivers/media/video/cx231xx/cx231xx-cards.c        |   86 +-
 drivers/media/video/cx231xx/cx231xx-core.c         |    7 +-
 drivers/media/video/cx231xx/cx231xx-dvb.c          |    4 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |   11 +-
 drivers/media/video/cx231xx/cx231xx-vbi.c          |    4 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |   14 +-
 drivers/media/video/cx231xx/cx231xx.h              |    2 +-
 drivers/media/video/cx23885/cx23885-417.c          |  141 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   75 +-
 drivers/media/video/cx23885/cx23885-core.c         |   24 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |  108 +-
 drivers/media/video/cx23885/cx23885-i2c.c          |    2 +-
 drivers/media/video/cx23885/cx23885-video.c        |  175 +-
 drivers/media/video/cx23885/cx23885.h              |   14 +
 drivers/media/video/cx25821/cx25821-alsa.c         |   73 +-
 .../media/video/cx25821/cx25821-audio-upstream.c   |  113 +-
 drivers/media/video/cx25821/cx25821-audio.h        |   39 +-
 drivers/media/video/cx25821/cx25821-cards.c        |    2 +-
 drivers/media/video/cx25821/cx25821-core.c         |   57 +-
 drivers/media/video/cx25821/cx25821-i2c.c          |   12 +-
 .../media/video/cx25821/cx25821-medusa-defines.h   |    6 +-
 drivers/media/video/cx25821/cx25821-medusa-reg.h   |  518 ++--
 drivers/media/video/cx25821/cx25821-medusa-video.c |  410 +--
 .../video/cx25821/cx25821-video-upstream-ch2.c     |  138 +-
 .../media/video/cx25821/cx25821-video-upstream.c   |  156 +-
 drivers/media/video/cx25821/cx25821-video.c        |  145 +-
 drivers/media/video/cx25821/cx25821.h              |    4 +-
 drivers/media/video/cx25840/cx25840-audio.c        |   10 +-
 drivers/media/video/cx25840/cx25840-core.c         | 3241 +++++++++++++++++++-
 drivers/media/video/cx88/Kconfig                   |   10 +-
 drivers/media/video/cx88/cx88-cards.c              |   94 +-
 drivers/media/video/cx88/cx88-dvb.c                |   30 +-
 drivers/media/video/cx88/cx88-i2c.c                |    2 +-
 drivers/media/video/cx88/cx88-input.c              |    4 +
 drivers/media/video/cx88/cx88.h                    |    2 +
 drivers/media/video/davinci/dm355_ccdc.c           |   13 +-
 drivers/media/video/davinci/dm644x_ccdc.c          |   13 +-
 drivers/media/video/davinci/isif.c                 |   13 +-
 drivers/media/video/davinci/vpbe.c                 |   76 +-
 drivers/media/video/davinci/vpbe_display.c         |   43 +-
 drivers/media/video/davinci/vpbe_osd.c             |  491 +++-
 drivers/media/video/davinci/vpbe_venc.c            |  223 ++-
 drivers/media/video/davinci/vpfe_capture.c         |   18 +-
 drivers/media/video/davinci/vpif_capture.c         |   14 +-
 drivers/media/video/em28xx/em28xx-audio.c          |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c          |  256 +-
 drivers/media/video/em28xx/em28xx-core.c           |   61 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |  190 +-
 drivers/media/video/em28xx/em28xx-input.c          |    7 +-
 drivers/media/video/em28xx/em28xx-reg.h            |    5 +
 drivers/media/video/em28xx/em28xx-video.c          |   14 +-
 drivers/media/video/em28xx/em28xx.h                |    8 +-
 drivers/media/video/fsl-viu.c                      |   13 +-
 drivers/media/video/gspca/Kconfig                  |   10 +
 drivers/media/video/gspca/Makefile                 |    2 +
 drivers/media/video/gspca/benq.c                   |    7 +-
 drivers/media/video/gspca/gl860/gl860.c            |    1 -
 drivers/media/video/gspca/gspca.c                  |   73 +-
 drivers/media/video/gspca/gspca.h                  |    5 +-
 drivers/media/video/gspca/jl2005bcd.c              |  554 ++++
 drivers/media/video/gspca/konica.c                 |    3 -
 drivers/media/video/gspca/mars.c                   |    1 -
 drivers/media/video/gspca/nw80x.c                  |    2 +-
 drivers/media/video/gspca/ov519.c                  |    5 +-
 drivers/media/video/gspca/ov534_9.c                |  141 +-
 drivers/media/video/gspca/pac207.c                 |   10 +-
 drivers/media/video/gspca/pac7302.c                |    1 +
 drivers/media/video/gspca/se401.c                  |   10 +-
 drivers/media/video/gspca/sn9c20x.c                |   38 +
 drivers/media/video/gspca/sonixb.c                 |   15 +-
 drivers/media/video/gspca/sonixj.c                 |   18 +-
 drivers/media/video/gspca/spca561.c                |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |    4 +-
 drivers/media/video/gspca/t613.c                   |   25 +
 drivers/media/video/gspca/topro.c                  |    2 +-
 drivers/media/video/gspca/vicam.c                  |    3 +-
 drivers/media/video/gspca/xirlink_cit.c            |    6 +-
 drivers/media/video/gspca/zc3xx.c                  |  117 +-
 drivers/media/video/ir-kbd-i2c.c                   |   25 +-
 drivers/media/video/ivtv/ivtv-i2c.h                |    2 +-
 drivers/media/video/m5mols/m5mols.h                |   46 +-
 drivers/media/video/m5mols/m5mols_capture.c        |   83 +-
 drivers/media/video/m5mols/m5mols_core.c           |  288 +-
 drivers/media/video/m5mols/m5mols_reg.h            |  247 +-
 drivers/media/video/marvell-ccic/mcam-core.c       |   36 +-
 drivers/media/video/marvell-ccic/mmp-driver.c      |   35 +
 drivers/media/video/mt9m001.c                      |    5 +-
 drivers/media/video/mt9m111.c                      |  380 ++--
 drivers/media/video/mt9p031.c                      |    5 +-
 drivers/media/video/mt9t001.c                      |    5 +-
 drivers/media/video/mt9t031.c                      |    5 +-
 drivers/media/video/mt9v022.c                      |    5 +-
 drivers/media/video/mt9v032.c                      |    8 +-
 drivers/media/video/mx1_camera.c                   |    2 +-
 drivers/media/video/mx2_camera.c                   |  299 ++-
 drivers/media/video/mx3_camera.c                   |   17 +-
 drivers/media/video/omap/omap_vout.c               |  187 +-
 drivers/media/video/omap/omap_voutdef.h            |    2 +-
 drivers/media/video/omap1_camera.c                 |   16 +-
 drivers/media/video/omap24xxcam.c                  |   19 +-
 drivers/media/video/omap3isp/isp.c                 |   72 +-
 drivers/media/video/omap3isp/ispccdc.c             |   14 +-
 drivers/media/video/omap3isp/ispccdc.h             |    2 -
 drivers/media/video/omap3isp/ispccp2.c             |   22 +-
 drivers/media/video/omap3isp/ispccp2.h             |    3 +-
 drivers/media/video/omap3isp/ispcsi2.c             |   18 +-
 drivers/media/video/omap3isp/ispcsi2.h             |    2 +-
 drivers/media/video/omap3isp/isppreview.c          |   25 +-
 drivers/media/video/omap3isp/isppreview.h          |    2 -
 drivers/media/video/omap3isp/ispresizer.c          |    7 +-
 drivers/media/video/omap3isp/ispresizer.h          |    1 -
 drivers/media/video/omap3isp/ispvideo.c            |   27 +-
 drivers/media/video/omap3isp/ispvideo.h            |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    5 +-
 drivers/media/video/pwc/pwc-ctrl.c                 |  726 +----
 drivers/media/video/pwc/pwc-dec23.c                |  288 +--
 drivers/media/video/pwc/pwc-dec23.h                |    5 +-
 drivers/media/video/pwc/pwc-if.c                   |  297 +--
 drivers/media/video/pwc/pwc-kiara.h                |    2 +-
 drivers/media/video/pwc/pwc-misc.c                 |   87 +-
 drivers/media/video/pwc/pwc-timon.h                |    2 +-
 drivers/media/video/pwc/pwc-uncompress.c           |   46 +-
 drivers/media/video/pwc/pwc-v4l.c                  |  258 +-
 drivers/media/video/pwc/pwc.h                      |   66 +-
 drivers/media/video/pxa_camera.c                   |   17 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |   11 +
 drivers/media/video/s5p-fimc/fimc-core.c           |  134 +-
 drivers/media/video/s5p-fimc/fimc-core.h           |   30 +-
 drivers/media/video/s5p-fimc/fimc-reg.c            |   53 +-
 drivers/media/video/s5p-fimc/mipi-csis.c           |   22 +
 drivers/media/video/s5p-fimc/mipi-csis.h           |    3 +
 drivers/media/video/s5p-fimc/regs-fimc.h           |    5 +
 drivers/media/video/s5p-g2d/Makefile               |    3 +
 drivers/media/video/s5p-g2d/g2d-hw.c               |  104 +
 drivers/media/video/s5p-g2d/g2d-regs.h             |  115 +
 drivers/media/video/s5p-g2d/g2d.c                  |  810 +++++
 drivers/media/video/s5p-g2d/g2d.h                  |   83 +
 drivers/media/video/s5p-jpeg/Makefile              |    2 +
 drivers/media/video/s5p-jpeg/jpeg-core.c           | 1481 +++++++++
 drivers/media/video/s5p-jpeg/jpeg-core.h           |  143 +
 drivers/media/video/s5p-jpeg/jpeg-hw.h             |  353 +++
 drivers/media/video/s5p-jpeg/jpeg-regs.h           |  170 +
 drivers/media/video/s5p-mfc/s5p_mfc.c              |   22 +-
 drivers/media/video/s5p-tv/hdmi_drv.c              |   30 +-
 drivers/media/video/s5p-tv/mixer.h                 |   14 +-
 drivers/media/video/s5p-tv/mixer_grp_layer.c       |  157 +-
 drivers/media/video/s5p-tv/mixer_video.c           |  342 ++-
 drivers/media/video/s5p-tv/mixer_vp_layer.c        |  108 +-
 drivers/media/video/s5p-tv/sdo_drv.c               |   22 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   33 +
 drivers/media/video/saa7134/saa7134-core.c         |    1 -
 drivers/media/video/saa7134/saa7134-dvb.c          |   33 +-
 drivers/media/video/saa7134/saa7134-input.c        |   23 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c      |   65 +-
 drivers/media/video/saa7134/saa7134-video.c        |    2 +
 drivers/media/video/saa7134/saa7134.h              |    2 +
 drivers/media/video/saa7164/saa7164-bus.c          |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   11 +-
 drivers/media/video/sh_mobile_csi2.c               |   13 +-
 drivers/media/video/soc_camera.c                   |    4 +-
 drivers/media/video/soc_camera_platform.c          |   13 +-
 drivers/media/video/stk-webcam.c                   |    4 +-
 drivers/media/video/timblogiw.c                    |   15 +-
 drivers/media/video/tlg2300/pd-common.h            |    2 +-
 drivers/media/video/tlg2300/pd-dvb.c               |   22 +-
 drivers/media/video/tm6000/Kconfig                 |    6 +-
 drivers/media/video/tm6000/tm6000-alsa.c           |   21 +-
 drivers/media/video/tm6000/tm6000-cards.c          |   35 +
 drivers/media/video/tm6000/tm6000-core.c           |   86 +-
 drivers/media/video/tm6000/tm6000-dvb.c            |   21 +-
 drivers/media/video/tm6000/tm6000-i2c.c            |    8 +-
 drivers/media/video/tm6000/tm6000-input.c          |  407 ++--
 drivers/media/video/tm6000/tm6000-regs.h           |   14 +-
 drivers/media/video/tm6000/tm6000-stds.c           |   89 +-
 drivers/media/video/tm6000/tm6000-video.c          |   21 +-
 drivers/media/video/tm6000/tm6000.h                |    3 +
 drivers/media/video/tuner-core.c                   |    1 +
 drivers/media/video/tvp5150.c                      |   81 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |   46 +-
 drivers/media/video/uvc/Kconfig                    |    1 +
 drivers/media/video/uvc/Makefile                   |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |   19 +-
 drivers/media/video/uvc/uvc_debugfs.c              |  136 +
 drivers/media/video/uvc/uvc_driver.c               |   30 +-
 drivers/media/video/uvc/uvc_isight.c               |   10 +-
 drivers/media/video/uvc/uvc_queue.c                |  564 +---
 drivers/media/video/uvc/uvc_v4l2.c                 |   29 +-
 drivers/media/video/uvc/uvc_video.c                |  625 ++++-
 drivers/media/video/uvc/uvcvideo.h                 |  128 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    2 +
 drivers/media/video/v4l2-ctrls.c                   |    5 +-
 drivers/media/video/v4l2-dev.c                     |   14 +-
 drivers/media/video/v4l2-device.c                  |    4 +-
 drivers/media/video/v4l2-ioctl.c                   |  120 +-
 drivers/media/video/v4l2-subdev.c                  |    4 +
 drivers/media/video/via-camera.c                   |   22 +-
 drivers/media/video/videobuf-dvb.c                 |    7 +-
 drivers/media/video/videobuf2-core.c               |  118 +-
 drivers/media/video/videobuf2-dma-sg.c             |    3 +-
 drivers/media/video/videobuf2-memops.c             |   28 +-
 drivers/media/video/videobuf2-vmalloc.c            |   90 +-
 drivers/media/video/vino.c                         |    2 +-
 drivers/staging/media/as102/Kconfig                |    1 +
 drivers/staging/media/as102/Makefile               |    2 +-
 drivers/staging/media/as102/as102_drv.c            |  126 +-
 drivers/staging/media/as102/as102_drv.h            |   59 +-
 drivers/staging/media/as102/as102_fe.c             |   81 +-
 drivers/staging/media/as102/as102_fw.c             |   44 +-
 drivers/staging/media/as102/as102_fw.h             |   10 +-
 drivers/staging/media/as102/as102_usb_drv.c        |   48 +-
 drivers/staging/media/as102/as102_usb_drv.h        |    6 +-
 drivers/staging/media/as102/as10x_cmd.c            |  143 +-
 drivers/staging/media/as102/as10x_cmd.h            |  895 +++---
 drivers/staging/media/as102/as10x_cmd_cfg.c        |   66 +-
 drivers/staging/media/as102/as10x_cmd_stream.c     |   56 +-
 drivers/staging/media/as102/as10x_handle.h         |   26 +-
 drivers/staging/media/as102/as10x_types.h          |  250 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |   17 +-
 drivers/staging/media/easycap/easycap.h            |   93 +-
 drivers/staging/media/easycap/easycap_ioctl.c      |   60 +-
 drivers/staging/media/easycap/easycap_low.c        |  273 +--
 drivers/staging/media/easycap/easycap_main.c       |  379 +--
 drivers/staging/media/easycap/easycap_settings.c   |    2 +-
 drivers/staging/media/easycap/easycap_sound.c      |  340 +--
 drivers/staging/media/go7007/go7007-usb.c          |    8 +-
 drivers/staging/media/lirc/lirc_imon.c             |    4 +-
 drivers/staging/media/lirc/lirc_serial.c           |  113 +-
 drivers/staging/media/solo6x10/Makefile            |    2 +-
 .../media/solo6x10/{jpeg.h => solo6x10-jpeg.h}     |    0
 drivers/staging/media/solo6x10/v4l2-enc.c          |    2 +-
 fs/compat_ioctl.c                                  |    1 +
 include/linux/dvb/frontend.h                       |   19 +-
 include/linux/dvb/version.h                        |    2 +-
 include/linux/videodev2.h                          |   56 +-
 include/media/as3645a.h                            |   71 +
 include/media/atmel-isi.h                          |    4 +-
 include/media/cx25840.h                            |    1 +
 include/media/davinci/vpbe.h                       |   16 +
 include/media/davinci/vpbe_venc.h                  |    4 +
 include/media/media-entity.h                       |    2 +-
 include/media/omap3isp.h                           |    2 +-
 include/media/pwc-ioctl.h                          |  323 --
 include/media/rc-map.h                             |   10 +-
 include/media/soc_camera.h                         |    2 +-
 include/media/v4l2-ioctl.h                         |    4 +
 555 files changed, 31396 insertions(+), 14462 deletions(-)
 create mode 100644 Documentation/DocBook/media/constraints.png.b64
 create mode 100644 Documentation/DocBook/media/selection.png.b64
 create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml
 create mode 100644 drivers/media/common/tuners/mt2063.c
 create mode 100644 drivers/media/common/tuners/mt2063.h
 create mode 100644 drivers/media/dvb/frontends/hd29l2.c
 create mode 100644 drivers/media/dvb/frontends/hd29l2.h
 create mode 100644 drivers/media/dvb/frontends/hd29l2_priv.h
 create mode 100644 drivers/media/rc/ir-sanyo-decoder.c
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 drivers/media/video/gspca/jl2005bcd.c
 create mode 100644 drivers/media/video/s5p-g2d/Makefile
 create mode 100644 drivers/media/video/s5p-g2d/g2d-hw.c
 create mode 100644 drivers/media/video/s5p-g2d/g2d-regs.h
 create mode 100644 drivers/media/video/s5p-g2d/g2d.c
 create mode 100644 drivers/media/video/s5p-g2d/g2d.h
 create mode 100644 drivers/media/video/s5p-jpeg/Makefile
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.c
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-regs.h
 create mode 100644 drivers/media/video/uvc/uvc_debugfs.c
 rename drivers/staging/media/solo6x10/{jpeg.h => solo6x10-jpeg.h} (100%)
 create mode 100644 include/media/as3645a.h
 delete mode 100644 include/media/pwc-ioctl.h



