Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0HBUWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab0HBUWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:22:16 -0400
Message-ID: <4C5728D8.4040902@redhat.com>
Date: Mon, 02 Aug 2010 17:21:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100720 Red Hat/3.1.1-1.el6 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.36] V4L/DVB updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.35

This is the LIRC pull request ;) After years of being maintained out-of-tree and being
merged on almost all distros, it is finally ready for its addition upstream.
The core got converted to work together with the Remote Controller subsystem, and one
driver got ported to it, on this series (there are more to come on a next pull request).
The drivers that are still waiting to be ported were at drivers/staging.

It also removes several V4L1 drivers that were replaced by gspca.

The net balance is that this series is removing 31665 lines, and adding "only" 27791 lines. 
So, lots of cleanups.

The rest of this series are the usual improvements at V4L, DVB and RC (remote controllers),
including a port of two DVB drivers to use the new RC core, and a few new drivers.

---

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.35

Abylay Ospan (1):
      V4L/DVB: Fix kernel Oops when number of NetUP Dual DVB-S2-CI cards more than DVB_MAX_ADAPTERS limit

Amerigo Wang (6):
      V4L/DVB: Remove usbvideo quickcam_messenger driver
      V4L/DVB: Remove obsolete ov511 driver
      V4L/DVB: Remove obsolete w9968cf v4l1 driver
      V4L/DVB: Remove obsolete ovcamchip sensor framework
      V4L/DVB: Remove obsolete stv680 v4l1 driver
      V4L/DVB: Remove obsolete zc0301 v4l driver

Anatolij Gustschin (2):
      V4L/DVB: v4l: Add MPC5121e VIU video capture driver
      V4L/DVB: v4l2-dev: fix memory leak

Andrew Morton (1):
      V4L/DVB: "dib3000mc: reduce large stack usage" fix

Andy Walls (3):
      V4L/DVB: ivtv: Increment driver version due to firmware loading changes
      V4L/DVB: cx23885: Convert from struct card_ir to struct cx23885_ir_input for IR Rx
      V4L/DVB: cx23885: Convert cx23885-input to use new in kernel IR pulse decoders

Antti Palosaari (7):
      V4L/DVB: af9013: add support for firmware 5.1.0.0
      V4L/DVB: get_dvb_firmware: update af9015
      V4L/DVB: af9015: support for AverMedia AVerTV Volar M (A815Mac)
      V4L/DVB: af9013: program tuner before demodulator
      V4L/DVB: af9013: af9013_read_status() refactoring
      V4L/DVB: af9013: output fw version as four digit long
      V4L/DVB: af9013: fix comments

Arnd Bergmann (1):
      V4L/DVB: lirc: use unlocked_ioctl

Ben Hutchings (2):
      V4L/DVB: mantis: Select correct frontends
      V4L/DVB: lgs8gxx: remove firmware for lgs8g75

Christian Dietrich (1):
      V4L/DVB: drivers/media/video: Remove dead CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE

Christoph Egger (1):
      V4L/DVB: remove obsolete conditionalizing on DVB_DIBCOM_DEBUG

Dan Carpenter (7):
      V4L/DVB: dvb-usb-init.c: white space changes in dvb-usb-init
      V4L/DVB: remove unneeded null check in anysee_probe()
      V4L/DVB: cpia_usb: remove unneeded variable
      V4L/DVB: media/radio: fix copy_to_user to user handling
      V4L/DVB: dvb_ca_en50221: return -EFAULT on copy_to_user errors
      V4L/DVB: media/IR: testing the wrong variable
      V4L/DVB: au0828: move dereference below sanity checks

Daniel Mack (2):
      V4L/DVB: drivers/media/dvb/dvb-usb/dib0700: fix return values
      V4L/DVB: drivers/media/dvb/dvb-usb/dib0700: CodingStyle fixes

David HÃ¤rdeman (4):
      V4L/DVB: ir-core: convert mantis to not use ir-functions.c
      V4L/DVB: ir-core: convert em28xx to not use ir-functions.c
      V4L/DVB: ir-core: centralize sysfs raw decoder enabling/disabling
      V4L/DVB: ir-core: move decoding state to ir_raw_event_ctrl

David Härdeman (2):
      V4L/DVB: ir-core: partially convert cx88 to not use ir-functions.c
      V4L/DVB: ir-core: partially convert ir-kbd-i2c.c to not use ir-functions.c

Dean Anderson (1):
      V4L/DVB: s2255drv: cleanup of device structure

Devin Heitmueller (2):
      V4L/DVB: Add closed captioning support for the HVR-950q
      V4L/DVB: Fix case where fields were not at the correct start location

Dmitri Belimov (2):
      V4L/DVB: tm6000: Fix Video decoder initialization
      V4L/DVB: xc5000, rework xc_write_reg

Guennadi Liakhovetski (9):
      V4L/DVB: sh_mobile_ceu_camera: fix debugging message
      V4L/DVB: V4L2: fix sh_vou.c compile breakage: #include <slab.h>
      V4L/DVB: mediabus: fix ambiguous pixel code names
      V4L/DVB: V4L2: mediabus: add 12-bit Bayer and YUV420 pixel formats
      V4L/DVB: V4L2: soc-camera: export soc-camera bus type for notifications
      V4L/DVB: V4L2: soc-camera: add a MIPI CSI-2 driver for SH-Mobile platforms
      V4L/DVB: V4L2: sh_mobile_camera_ceu: add support for CSI2
      V4L/DVB: V4L2: sh_vou: VOU does support the full PAL resolution too
      V4L/DVB: rj54n1cb0c: fix a comment in the driver

Guillaume Audirac (4):
      V4L/DVB: tda10048: fix the uncomplete function tda10048_read_ber
      V4L/DVB: tda10048: fix bitmask for the transmission mode
      V4L/DVB: tda10048: clear the uncorrected packet registers when saturated
      V4L/DVB: dvb_frontend: fix typos in comments and one function

Hans de Goede (6):
      V4L/DVB: gspca_ovfx2: drop first frames in stream if not synced
      V4L/DVB: gspca_tv8532: remove a whole bunch of unnecessary register writes
      V4L/DVB: gspca_tv8532: add gain control
      V4L/DVB: gspca_tv8532: rename brightness control to exposure
      V4L/DVB: gspca_ov519: Don't report a saturation control for 7670 sensors
      V4L/DVB: uvcvideo: Make button controls work properly

Ian Armstrong (2):
      V4L/DVB: ivtv: Add firmare monitoring and debug mode to ignore firmware problems
      V4L/DVB: ivtv: Automatic firmware reload

Jarod Wilson (38):
      V4L/DVB: IR: let all protocol decoders have a go at raw data
      V4L/DVB: IR: only initially registers protocol that matches loaded keymap
      V4L/DVB: IR: add RC6 keymap for Windows Media Center Ed. remotes
      V4L/DVB: IR: add mceusb IR receiver driver
      V4L/DVB: dvb: add lgdt3304 support to lgdt3305 driver
      V4L/DVB: IR/imon: use the proper ir-core device unregister function
      V4L/DVB: IR/mceusb: use the proper ir-core device unregister function
      V4L/DVB: IR/mceusb: misc cleanups and init fixes
      V4L/DVB: IR/mceusb: kill pinnacle-device-specific nonsense
      V4L/DVB: IR: add tx callbacks to ir-core
      V4L/DVB: IR/mceusb: add tx callback functions and wire up
      V4L/DVB: IR: add lirc device interface
      V4L/DVB: IR: add ir-core to lirc userspace decoder bridge driver
      V4L/DVB: IR TX: incoming IR buffer now an int pointer
      V4L/DVB: IR: add empty lirc pseudo-keymap
      V4L/DVB: IR/lirc: add docbook info covering lirc device interface
      V4L/DVB: IR/imon: auto-configure another 0xffdc device variant
      V4L/DVB: IR/mceusb: unify and simplify different gen device init
      V4L/DVB: IR/lirc_dev: fix locking in lirc_dev_fop_read
      V4L/DVB: IR/mceusb: more streamlining of device init
      V4L/DVB: IR/lirc: make lirc userspace and staging modules buildable
      V4L/DVB: IR/lirc: use memdup_user instead of copy_from_user
      V4L/DVB: dvb: add support for kworld 340u and ub435-q to em28xx-dvb
      V4L/DVB: staging/lirc: add lirc_bt829 driver
      V4L/DVB: staging/lirc: add lirc_ene0100 driver
      V4L/DVB: staging/lirc: add lirc_i2c driver
      V4L/DVB: staging/lirc: add lirc_igorplugusb driver
      V4L/DVB: staging/lirc: add lirc_imon driver
      V4L/DVB: staging/lirc: add lirc_ite8709 driver
      V4L/DVB: staging/lirc: add lirc_it87 driver
      V4L/DVB: staging/lirc: add lirc_parallel driver
      V4L/DVB: staging/lirc: add lirc_sasem driver
      V4L/DVB: staging/lirc: add lirc_serial driver
      V4L/DVB: staging/lirc: add lirc_sir driver
      V4L/DVB: staging/lirc: add lirc_streamzap driver
      V4L/DVB: staging/lirc: add lirc_ttusbir driver
      V4L/DVB: staging/lirc: add lirc_zilog driver
      V4L/DVB: staging/lirc: wire up Kconfig and Makefile bits

Jean Delvare (2):
      V4L/DVB: cx88: Move I2C IR initialization
      V4L/DVB: cx88: Let the user disable IR support

Jean-François Moine (34):
      V4L/DVB: gspca - JPEG subdrivers: Don't allocate the JPEG header
      V4L/DVB: gspca - stk014: Change the min and default values of the JPEG quality
      V4L/DVB: gspca - zc3xx: Change the max and default JPEG qualities
      V4L/DVB: gspca - zc3xx: Don't change the registers 7 and 8 for sensor pas202b
      V4L/DVB: gspca - zc3xx: Add back the brightness control
      V4L/DVB: gspca - t613: Cleanup and clarify the source
      V4L/DVB: gspca - t613: Adjust light frequency values per sensor
      V4L/DVB: gspca - t613: Change the gamma table
      V4L/DVB: gspca - t613: Remove the RGB gains setting from sensor_polling
      V4L/DVB: gspca - t613: Simplify the scan of isoc packets
      V4L/DVB: gspca - t613: Change the gain mechanism
      V4L/DVB: gspca - sq930x: New subdriver
      V4L/DVB: gspca - main: Function gspca_dev_probe2 added
      V4L/DVB: gspca - spca1528: New subdriver
      V4L/DVB: gspca: Remove/move useless inclusions of slab.h
      V4L/DVB: gspca - pac7302/11: Bad request value in USB write
      V4L/DVB: gspca - sq930x: Check the USB read errors
      V4L/DVB: gspca - sq930x: New sensor mt9v111
      V4L/DVB: gspca - main: Don't use the PG_Reserved flag for mmapped buffers
      V4L/DVB: gspca - main: Remove V4L1 compatibility
      V4L/DVB: gspca - gl860: Fix a compilation warning
      V4L/DVB: gspca - main: Simplify image building
      V4L/DVB: gspca - main: Possible race condition in queue management
      V4L/DVB: gspca - main: Don't use the frame buffer flags
      V4L/DVB: gspca - vc032x: Add some comments
      V4L/DVB: gspca - vc032x: Stop the USB exchanges on error
      V4L/DVB: gspca - vc032x: Add trace of USB exchanges
      V4L/DVB: gspca - sq930x: Add some comments for sensor mt9v111
      V4L/DVB: gspca - main: Fix a compilation warning
      V4L/DVB: gspca - main: Remove useless audio ioctl's
      V4L/DVB: gspca - main: Adjust and remove some debug messages
      V4L/DVB: gspca - main: Handle the audio device
      V4L/DVB: gspca - sonixj: Do the audio input work for webcams with a microphone
      V4L/DVB: gspca - vc032x: Move the first VC0321 settings to sd_init()

Jiri Slaby (2):
      V4L/DVB: VIDEO: ivtvfb, remove unneeded NULL test
      V4L/DVB: DVB: fix dvr node refcounting

Joe Perches (2):
      V4L/DVB: smscoreapi/w9968cf: drivers/media: Remove unnecesary kmalloc casts
      V4L/DVB: drivers/media: Remove unnecessary casts of private_data

Julia Lawall (8):
      V4L/DVB: drivers/media/video/pvrusb2: Add missing mutex_unlock
      V4L/DVB: drivers/media/video/gspca: Use kmemdup
      V4L/DVB: drivers/media/video/uvc: Use kmemdup
      V4L/DVB: drivers/media/video/tlg2300: Use kmemdup
      V4L/DVB: drivers/media/video/zoran: Use kmemdup
      V4L/DVB: drivers/media: Use memdup_user
      V4L/DVB: drivers/media/dvb/frontends: remove duplicate structure field 	initialization
      V4L/DVB: drivers/video/omap2/displays: add missing mutex_unlock

Justin P. Mattock (1):
      V4L/DVB: tuners:tuner-simple Fix warning: variable 'tun' set but not used

Klaus Schmidinger (1):
      V4L/DVB: Add FE_CAN_TURBO_FEC

Kuninori Morimoto (1):
      V4L/DVB: soc_camera_platform: Add necessary v4l2_subdev_video_ops method

Kusanagi Kouichi (1):
      V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)

Laurent Pinchart (10):
      V4L/DVB: videobuf: Remove the videobuf_sg_dma_map/unmap functions
      V4L/DVB: Remove videobuf_sg_alloc abuse
      V4L/DVB: videobuf: Don't export videobuf_(vmalloc|pages)_to_sg
      V4L/DVB: videobuf: Remove videobuf_mapping start and end fields
      V4L/DVB: videobuf: Rename vmalloc fields to vaddr
      V4L/DVB: uvcvideo: Support menu controls in the control mapping API
      V4L/DVB: uvcvideo: Define control information bits using macros
      V4L/DVB: uvcvideo: Don't use stack-based buffers for USB transfers
      V4L/DVB: uvcvideo: Add support for Manta MM-353 Plako
      V4L/DVB: uvc: Move constants and structures definitions to linux/usb/video.h

Martin Rubli (1):
      V4L/DVB: uvcvideo: Add support for absolute pan/tilt controls

Mauro Carvalho Chehab (41):
      V4L/DVB: tm6000: Avoid OOPS when loading tm6000-alsa module
      V4L/DVB: tm6000-alsa: rework audio buffer allocation/deallocation
      V4L/DVB: tm6000: Use an enum for extension type
      V4L/DVB: tm6000: Add a callback code for buffer fill
      V4L/DVB: tm6000: avoid unknown symbol tm6000_debug
      V4L/DVB: tm6000-alsa: Fix several bugs at the driver initialization code
      V4L/DVB: tm6000-alsa: Implement a routine to store data received from URB
      V4L/DVB: tm6000: Improve set bitrate routines used by alsa
      V4L/DVB: tm6000: audio packet has always 180 bytes
      V4L/DVB: tm6000: Fix copybuf continue logic
      V4L/DVB: tm6000: Be sure that the new buffer is empty
      V4L/DVB: tm6000: Partially revert some copybuf logic
      V4L/DVB: em28xx-input: Don't generate one debug message for every get_key read
      V4L/DVB: ir-core: Remove magic numbers at the sysfs logic
      V4L/DVB: ir-core: Rename sysfs protocols nomenclature to rc-5 and rc-6
      V4L/DVB: ir-core: Add support for disabling all protocols
      V4L/DVB: ir-core: allow specifying multiple protocols at one open/write
      V4L/DVB: DocBook/dvb: Update spec to reflect the current FE capabilities
      V4L/DVB: Increment DVB API version
      V4L/DVB: DocBook/media: Add LIRC DocBook to media.html
      V4L/DVB: cx25821: Make comments C99 compliant
      V4L/DVB: cx25821: Add a kernel level at printk's
      V4L/DVB: cx25821: Fix bad whitespacing
      V4L/DVB: tm6000-input: Make checkpatch.pl happy
      V4L/DVB: xc5000: Fix a few warnings
      V4L/DVB: IR/mceusb: remove unused vars from gen1 init
      V4L/DVB: staging: Add an specific TODO note for lirc_i2c
      V4L/DVB: staging/lirc: CodingStyle cleanups
      V4L/DVB: dvb-usb: get rid of struct dvb_usb_rc_key
      V4L/DVB: dvb-usb: prepare drivers for using rc-core
      V4L/DVB: dvb-usb: add support for rc-core mode
      V4L/DVB: Add a keymap file with dib0700 table
      V4L/DVB: Port dib0700 to rc-core
      V4L/DVB: dib0700: avoid bad repeat
      V4L/DVB: dib0700: break keytable into NEC and RC-5 variants
      V4L/DVB: dib0700: properly implement IR change_protocol
      V4L/DVB: dib0700: Fix RC protocol logic to properly handle NEC/NECx and RC-5
      V4L/DVB: smsusb: enable IR port for Hauppauge WinTV MiniStick
      V4L/DVB: standardize names at rc-dib0700 tables
      V4L/DVB: sms: properly initialize IR phys and IR name
      V4L/DVB: sms: Convert IR support to use the Remote Controller core

Michael Krufky (11):
      V4L/DVB: lgdt3305: remove pointless function, lgdt3304_sleep
      V4L/DVB: lgdt3305: update lgdt3305.h header to match the header in lgdt3305.c
      V4L/DVB: lgdt3305: re-write lgdt3304 ifbw hack in lgdt3305_rfagc_loop with FIXME
      V4L/DVB: lgdt3305: consolidate init functions
      V4L/DVB: lgdt3305: FIXME: verify & document the LGDT3304 registers
      V4L/DVB: lgdt3305: Jarod Wilson gets the credit for LGDT3304 support
      V4L/DVB: lgdt3305: update copyright date and MODULE_VERSION
      V4L/DVB: lgdt3305: enable FE_HAS_SIGNAL hack for the lgdt3304 in QAM mode
      V4L/DVB: tda18271: fix error detection during initialization of first instance
      V4L/DVB: cx23885: add support for new model revisions of the HVR12xx board family
      V4L/DVB: af9005: use generic_bulk_ctrl_endpoint_response

Murali Karicheri (1):
      V4L/DVB: vpif: removing VPIF config variables

Márton Németh (1):
      V4L/DVB: gspca - pac7302: add Genius iSlim 310

Olivier Lorin (6):
      V4L/DVB: gspca - gl860: new driver for MI2020 sensor
      V4L/DVB: gspca - gl860: USB control message delay unification
      V4L/DVB: gspca - gl860: setting changes applied after an EOI
      V4L/DVB: gspca - gl860: use of real resolutions for MI2020 sensor
      V4L/DVB: gspca - gl860: fix for wrong 0V9655 resolution identifier name
      V4L/DVB: gspca - gl860: text alignment

Palash Bandyopadhyay (1):
      V4L/DVB: cx25821: Removed duplicate code and cleaned up

Pawel Osciak (2):
      V4L/DVB: videobuf: rename videobuf_alloc to videobuf_alloc_vb
      V4L/DVB: videobuf: rename videobuf_mmap_free and add sanity checks

Perceval Anichini (1):
      V4L/DVB: hdpvr: Fixes probing function

Randy Dunlap (3):
      V4L/DVB: media/IR: nec-decoder needs to select BITREV
      V4L/DVB: vivi: fix depends again
      V4L/DVB: IR: jvc-decoder needs BITREVERSE

Renzo Dani (1):
      V4L/DVB: Retrieve firmware for az6027

Stefan Ringel (4):
      V4L/DVB: tm6000: rewrite copy_streams
      V4L/DVB: tm6000: rewrite init and fini
      V4L/DVB: tm6000: move dvb into a separate kern module
      V4L/DVB: tm6000: add ir support

Timofey Trofimov (1):
      V4L/DVB: Staging: tm6000: Fix coding style issues

Tobias Lorenz (1):
      V4L/DVB:  si470x: -EINVAL overwritten in si470x_vidioc_s_tuner()

Vadim Catana (1):
      V4L/DVB: TechnoTrend TT-budget T-3000

Vaibhav Hiremath (1):
      V4L/DVB: vpfe_capture: Create separate Kconfig file for davinci devices

 Documentation/DocBook/dvb/dvbapi.xml               |   19 +-
 Documentation/DocBook/dvb/frontend.h.xml           |    1 +
 Documentation/DocBook/dvb/frontend.xml             |   10 +-
 Documentation/DocBook/media-entities.tmpl          |    1 +
 Documentation/DocBook/media.tmpl                   |    8 +-
 .../DocBook/v4l/lirc_device_interface.xml          |  235 +
 Documentation/DocBook/v4l/remote_controllers.xml   |    2 +
 Documentation/dvb/get_dvb_firmware                 |   25 +-
 Documentation/feature-removal-schedule.txt         |   51 -
 Documentation/video4linux/CARDLIST.cx23885         |    6 +-
 Documentation/video4linux/CARDLIST.em28xx          |    1 +
 Documentation/video4linux/CARDLIST.saa7134         |    3 +-
 Documentation/video4linux/gspca.txt                |    8 +
 arch/sh/boards/mach-ap325rxa/setup.c               |    2 +-
 drivers/media/IR/Kconfig                           |   35 +
 drivers/media/IR/Makefile                          |    3 +
 drivers/media/IR/imon.c                            |   11 +-
 drivers/media/IR/ir-core-priv.h                    |   54 +
 drivers/media/IR/ir-jvc-decoder.c                  |  152 +-
 drivers/media/IR/ir-keytable.c                     |    5 +-
 drivers/media/IR/ir-lirc-codec.c                   |  278 +
 drivers/media/IR/ir-nec-decoder.c                  |  151 +-
 drivers/media/IR/ir-raw-event.c                    |  167 +-
 drivers/media/IR/ir-rc5-decoder.c                  |  167 +-
 drivers/media/IR/ir-rc6-decoder.c                  |  153 +-
 drivers/media/IR/ir-sony-decoder.c                 |  155 +-
 drivers/media/IR/ir-sysfs.c                        |  251 +-
 drivers/media/IR/keymaps/Makefile                  |    4 +
 drivers/media/IR/keymaps/rc-dib0700-nec.c          |  124 +
 drivers/media/IR/keymaps/rc-dib0700-rc5.c          |  235 +
 drivers/media/IR/keymaps/rc-lirc.c                 |   41 +
 drivers/media/IR/keymaps/rc-rc6-mce.c              |  105 +
 drivers/media/IR/lirc_dev.c                        |  764 +++
 drivers/media/IR/mceusb.c                          | 1143 ++++
 drivers/media/common/saa7146_fops.c                |    2 +-
 drivers/media/common/saa7146_vbi.c                 |    4 +-
 drivers/media/common/saa7146_video.c               |    4 +-
 drivers/media/common/tuners/tda18271-fe.c          |    8 +-
 drivers/media/common/tuners/tuner-simple.c         |    3 -
 drivers/media/common/tuners/xc5000.c               |   59 +-
 drivers/media/dvb/bt8xx/dst_ca.c                   |    2 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |    2 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |   10 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |   10 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   10 +-
 drivers/media/dvb/dvb-usb/a800.c                   |   12 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c          |    4 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |   71 +-
 drivers/media/dvb/dvb-usb/af9005.h                 |    2 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |   42 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |   18 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |   28 +-
 drivers/media/dvb/dvb-usb/az6027.c                 |   13 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c         |   12 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |  128 +-
 drivers/media/dvb/dvb-usb/dib0700.h                |    1 +
 drivers/media/dvb/dvb-usb/dib0700_core.c           |  266 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  614 +--
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |   40 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c              |   10 +-
 drivers/media/dvb/dvb-usb/dibusb.h                 |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |   20 +-
 drivers/media/dvb/dvb-usb/dtt200u.c                |   42 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb-init.c           |   60 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |  198 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h                |   92 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |   67 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c              |    2 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |   44 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |   14 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   16 +-
 drivers/media/dvb/dvb-usb/vp702x.c                 |   14 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |   14 +-
 drivers/media/dvb/frontends/Kconfig                |    1 +
 drivers/media/dvb/frontends/af9013.c               |   52 +-
 drivers/media/dvb/frontends/af9013.h               |    2 +-
 drivers/media/dvb/frontends/af9013_priv.h          |    8 +-
 drivers/media/dvb/frontends/dib3000mb.c            |    9 +-
 drivers/media/dvb/frontends/dib3000mb_priv.h       |    4 -
 drivers/media/dvb/frontends/dib3000mc.c            |    2 +-
 drivers/media/dvb/frontends/lgdt3305.c             |  267 +-
 drivers/media/dvb/frontends/lgdt3305.h             |   10 +-
 drivers/media/dvb/frontends/lgs8gxx.c              |   50 +-
 drivers/media/dvb/frontends/mb86a16.c              |    1 -
 drivers/media/dvb/frontends/tda10048.c             |   43 +-
 drivers/media/dvb/mantis/Kconfig                   |   14 +-
 drivers/media/dvb/mantis/mantis_input.c            |    5 +-
 drivers/media/dvb/siano/sms-cards.c                |    2 +
 drivers/media/dvb/siano/sms-cards.h                |    2 +-
 drivers/media/dvb/siano/smscoreapi.c               |    4 +-
 drivers/media/dvb/siano/smsir.c                    |  261 +-
 drivers/media/dvb/siano/smsir.h                    |   63 +-
 drivers/media/dvb/siano/smsusb.c                   |    3 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    2 +-
 drivers/media/radio/si4713-i2c.c                   |   12 +-
 drivers/media/video/Kconfig                        |  183 +-
 drivers/media/video/Makefile                       |    9 +-
 drivers/media/video/ak881x.c                       |    6 +-
 drivers/media/video/au0828/Makefile                |    2 +-
 drivers/media/video/au0828/au0828-vbi.c            |  138 +
 drivers/media/video/au0828/au0828-video.c          |  443 ++-
 drivers/media/video/au0828/au0828.h                |   20 +-
 drivers/media/video/bt8xx/bttv-risc.c              |    2 +-
 drivers/media/video/cpia_usb.c                     |    3 -
 drivers/media/video/cx18/cx18-ioctl.c              |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   40 +
 drivers/media/video/cx23885/cx23885-core.c         |   11 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |    2 +-
 drivers/media/video/cx23885/cx23885-input.c        |  317 +-
 drivers/media/video/cx23885/cx23885-ir.c           |    2 +-
 drivers/media/video/cx23885/cx23885.h              |   12 +-
 drivers/media/video/cx88/cx88-alsa.c               |   37 +-
 drivers/media/video/cx88/cx88-cards.c              |    9 +-
 drivers/media/video/cx88/cx88-core.c               |    2 +-
 drivers/media/video/cx88/cx88-i2c.c                |    6 +-
 drivers/media/video/cx88/cx88-input.c              |   46 +-
 drivers/media/video/cx88/cx88.h                    |    1 +
 drivers/media/video/dabusb.c                       |   13 +-
 drivers/media/video/davinci/Kconfig                |   93 +
 drivers/media/video/em28xx/em28xx-cards.c          |   28 +
 drivers/media/video/em28xx/em28xx-dvb.c            |   33 +
 drivers/media/video/em28xx/em28xx-input.c          |   80 +-
 drivers/media/video/em28xx/em28xx-video.c          |    4 +-
 drivers/media/video/em28xx/em28xx.h                |    2 +
 drivers/media/video/fsl-viu.c                      | 1632 ++++++
 drivers/media/video/gspca/Kconfig                  |   18 +
 drivers/media/video/gspca/Makefile                 |    4 +
 drivers/media/video/gspca/conex.c                  |    8 +-
 drivers/media/video/gspca/cpia1.c                  |   19 +-
 drivers/media/video/gspca/gl860/gl860-mi2020.c     |  731 +--
 drivers/media/video/gspca/gl860/gl860-ov9655.c     |    4 +-
 drivers/media/video/gspca/gl860/gl860.c            |   42 +-
 drivers/media/video/gspca/gl860/gl860.h            |   13 +-
 drivers/media/video/gspca/gspca.c                  |  340 +-
 drivers/media/video/gspca/gspca.h                  |   22 +-
 drivers/media/video/gspca/jeilinj.c                |    6 +-
 drivers/media/video/gspca/m5602/m5602_bridge.h     |    1 +
 drivers/media/video/gspca/m5602/m5602_core.c       |   15 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c     |    1 -
 drivers/media/video/gspca/mars.c                   |   13 +-
 drivers/media/video/gspca/ov519.c                  |   28 +-
 drivers/media/video/gspca/ov534.c                  |    7 +-
 drivers/media/video/gspca/pac7302.c                |   31 +-
 drivers/media/video/gspca/pac7311.c                |   29 +-
 drivers/media/video/gspca/sn9c20x.c                |   18 +-
 drivers/media/video/gspca/sonixb.c                 |    8 +-
 drivers/media/video/gspca/sonixj.c                 |   38 +-
 drivers/media/video/gspca/spca1528.c               |  605 ++
 drivers/media/video/gspca/spca500.c                |   13 +-
 drivers/media/video/gspca/sq930x.c                 | 1402 +++++
 drivers/media/video/gspca/stk014.c                 |   17 +-
 drivers/media/video/gspca/stv06xx/stv06xx.h        |    1 +
 drivers/media/video/gspca/sunplus.c                |   13 +-
 drivers/media/video/gspca/t613.c                   |  408 +-
 drivers/media/video/gspca/tv8532.c                 |  227 +-
 drivers/media/video/gspca/vc032x.c                 |  228 +-
 drivers/media/video/gspca/w996Xcf.c                |   16 +-
 drivers/media/video/gspca/zc3xx.c                  |   92 +-
 drivers/media/video/hdpvr/hdpvr-core.c             |    5 +
 drivers/media/video/hdpvr/hdpvr-video.c            |    4 +-
 drivers/media/video/ir-kbd-i2c.c                   |   14 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   14 +
 drivers/media/video/ivtv/ivtv-driver.h             |    4 +
 drivers/media/video/ivtv/ivtv-fileops.c            |   30 +-
 drivers/media/video/ivtv/ivtv-firmware.c           |  122 +
 drivers/media/video/ivtv/ivtv-firmware.h           |    1 +
 drivers/media/video/ivtv/ivtv-mailbox.c            |    8 +
 drivers/media/video/ivtv/ivtv-mailbox.h            |    1 +
 drivers/media/video/ivtv/ivtv-streams.c            |   11 +-
 drivers/media/video/ivtv/ivtv-version.h            |    2 +-
 drivers/media/video/ivtv/ivtvfb.c                  |   45 +-
 drivers/media/video/mem2mem_testdev.c              |    4 +-
 drivers/media/video/mt9m111.c                      |   16 +-
 drivers/media/video/mt9t112.c                      |   12 +-
 drivers/media/video/omap/omap_vout.c               |    8 -
 drivers/media/video/omap24xxcam.c                  |    2 +-
 drivers/media/video/ov511.c                        | 5995 --------------------
 drivers/media/video/ov511.h                        |  573 --
 drivers/media/video/ov772x.c                       |    8 +-
 drivers/media/video/ov9640.c                       |   14 +-
 drivers/media/video/ovcamchip/Makefile             |    4 -
 drivers/media/video/ovcamchip/ov6x20.c             |  414 --
 drivers/media/video/ovcamchip/ov6x30.c             |  373 --
 drivers/media/video/ovcamchip/ov76be.c             |  302 -
 drivers/media/video/ovcamchip/ov7x10.c             |  334 --
 drivers/media/video/ovcamchip/ov7x20.c             |  454 --
 drivers/media/video/ovcamchip/ovcamchip_core.c     |  395 --
 drivers/media/video/ovcamchip/ovcamchip_priv.h     |  101 -
 drivers/media/video/pvrusb2/pvrusb2-ioread.c       |    5 +-
 drivers/media/video/pxa_camera.c                   |   10 +-
 drivers/media/video/rj54n1cb0c.c                   |   10 +-
 drivers/media/video/s2255drv.c                     |  724 ++--
 drivers/media/video/saa7134/saa7134-alsa.c         |   14 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   31 +
 drivers/media/video/saa7134/saa7134-core.c         |    2 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   23 +
 drivers/media/video/saa7134/saa7134.h              |    1 +
 drivers/media/video/sh_mobile_ceu_camera.c         |  149 +-
 drivers/media/video/sh_mobile_csi2.c               |  354 ++
 drivers/media/video/sh_vou.c                       |   65 +-
 drivers/media/video/soc_camera.c                   |    3 +-
 drivers/media/video/soc_camera_platform.c          |   42 +-
 drivers/media/video/soc_mediabus.c                 |    8 +-
 drivers/media/video/stv680.c                       | 1565 -----
 drivers/media/video/stv680.h                       |  227 -
 drivers/media/video/tlg2300/pd-main.c              |    3 +-
 drivers/media/video/tw9910.c                       |    8 +-
 drivers/media/video/usbvideo/Kconfig               |   14 -
 drivers/media/video/usbvideo/Makefile              |    1 -
 drivers/media/video/usbvideo/quickcam_messenger.c  | 1126 ----
 drivers/media/video/usbvideo/quickcam_messenger.h  |  112 -
 drivers/media/video/uvc/uvc_ctrl.c                 |  105 +-
 drivers/media/video/uvc/uvc_driver.c               |   15 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |  103 +-
 drivers/media/video/uvc/uvcvideo.h                 |   45 +-
 drivers/media/video/v4l2-dev.c                     |    6 +-
 drivers/media/video/videobuf-core.c                |   84 +-
 drivers/media/video/videobuf-dma-contig.c          |    6 +-
 drivers/media/video/videobuf-dma-sg.c              |   76 +-
 drivers/media/video/videobuf-vmalloc.c             |   36 +-
 drivers/media/video/w9968cf.c                      | 3620 ------------
 drivers/media/video/w9968cf.h                      |  333 --
 drivers/media/video/w9968cf_decoder.h              |   86 -
 drivers/media/video/w9968cf_vpp.h                  |   40 -
 drivers/media/video/zc0301/Kconfig                 |   15 -
 drivers/media/video/zc0301/Makefile                |    3 -
 drivers/media/video/zc0301/zc0301.h                |  196 -
 drivers/media/video/zc0301/zc0301_core.c           | 2098 -------
 drivers/media/video/zc0301/zc0301_pas202bcb.c      |  362 --
 drivers/media/video/zc0301/zc0301_pb0330.c         |  188 -
 drivers/media/video/zc0301/zc0301_sensor.h         |  107 -
 drivers/media/video/zoran/videocodec.c             |    5 +-
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/cx25821/Makefile                   |   11 +-
 drivers/staging/cx25821/cx25821-alsa.c             |   35 +-
 drivers/staging/cx25821/cx25821-audio-upstream.c   |   38 +-
 drivers/staging/cx25821/cx25821-audio.h            |   13 +-
 drivers/staging/cx25821/cx25821-audups11.c         |  420 --
 drivers/staging/cx25821/cx25821-core.c             |   86 +-
 drivers/staging/cx25821/cx25821-i2c.c              |    3 +
 drivers/staging/cx25821/cx25821-medusa-defines.h   |   15 +-
 drivers/staging/cx25821/cx25821-medusa-reg.h       |   32 +-
 drivers/staging/cx25821/cx25821-medusa-video.c     |   18 +-
 drivers/staging/cx25821/cx25821-medusa-video.h     |    4 +-
 drivers/staging/cx25821/cx25821-reg.h              | 1826 +++---
 drivers/staging/cx25821/cx25821-sram.h             |   50 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   91 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |    2 +-
 drivers/staging/cx25821/cx25821-video-upstream.c   |   72 +-
 drivers/staging/cx25821/cx25821-video-upstream.h   |    2 +-
 drivers/staging/cx25821/cx25821-video.c            |  905 +++-
 drivers/staging/cx25821/cx25821-video.h            |   20 +-
 drivers/staging/cx25821/cx25821-video0.c           |  434 --
 drivers/staging/cx25821/cx25821-video1.c           |  434 --
 drivers/staging/cx25821/cx25821-video2.c           |  436 --
 drivers/staging/cx25821/cx25821-video3.c           |  435 --
 drivers/staging/cx25821/cx25821-video4.c           |  434 --
 drivers/staging/cx25821/cx25821-video5.c           |  434 --
 drivers/staging/cx25821/cx25821-video6.c           |  434 --
 drivers/staging/cx25821/cx25821-video7.c           |  433 --
 drivers/staging/cx25821/cx25821-videoioctl.c       |  480 --
 drivers/staging/cx25821/cx25821-vidups10.c         |  418 --
 drivers/staging/cx25821/cx25821-vidups9.c          |  416 --
 drivers/staging/cx25821/cx25821.h                  |   49 +-
 drivers/staging/lirc/Kconfig                       |  110 +
 drivers/staging/lirc/Makefile                      |   19 +
 drivers/staging/lirc/TODO                          |    8 +
 drivers/staging/lirc/TODO.lirc_i2c                 |    3 +
 drivers/staging/lirc/lirc_bt829.c                  |  383 ++
 drivers/staging/lirc/lirc_ene0100.c                |  646 +++
 drivers/staging/lirc/lirc_ene0100.h                |  169 +
 drivers/staging/lirc/lirc_i2c.c                    |  536 ++
 drivers/staging/lirc/lirc_igorplugusb.c            |  555 ++
 drivers/staging/lirc/lirc_imon.c                   | 1058 ++++
 drivers/staging/lirc/lirc_it87.c                   | 1019 ++++
 drivers/staging/lirc/lirc_it87.h                   |  116 +
 drivers/staging/lirc/lirc_ite8709.c                |  542 ++
 drivers/staging/lirc/lirc_parallel.c               |  705 +++
 drivers/staging/lirc/lirc_parallel.h               |   26 +
 drivers/staging/lirc/lirc_sasem.c                  |  933 +++
 drivers/staging/lirc/lirc_serial.c                 | 1313 +++++
 drivers/staging/lirc/lirc_sir.c                    | 1282 +++++
 drivers/staging/lirc/lirc_streamzap.c              |  821 +++
 drivers/staging/lirc/lirc_ttusbir.c                |  396 ++
 drivers/staging/lirc/lirc_zilog.c                  | 1387 +++++
 drivers/staging/tm6000/Kconfig                     |    4 +-
 drivers/staging/tm6000/Makefile                    |    8 +-
 drivers/staging/tm6000/tm6000-alsa.c               |  263 +-
 drivers/staging/tm6000/tm6000-cards.c              |   58 +-
 drivers/staging/tm6000/tm6000-core.c               |  182 +-
 drivers/staging/tm6000/tm6000-dvb.c                |  173 +-
 drivers/staging/tm6000/tm6000-i2c.c                |   25 +-
 drivers/staging/tm6000/tm6000-input.c              |  364 ++
 drivers/staging/tm6000/tm6000-stds.c               |   36 +-
 drivers/staging/tm6000/tm6000-usb-isoc.h           |    5 +-
 drivers/staging/tm6000/tm6000-video.c              |  337 +-
 drivers/staging/tm6000/tm6000.h                    |   88 +-
 drivers/usb/gadget/f_uvc.c                         |   16 +-
 drivers/usb/gadget/f_uvc.h                         |  352 +--
 drivers/usb/gadget/uvc.h                           |   36 -
 drivers/usb/gadget/webcam.c                        |   24 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |    4 +-
 include/linux/dvb/frontend.h                       |    1 +
 include/linux/dvb/version.h                        |    2 +-
 include/linux/usb/video.h                          |  404 ++
 include/media/ir-core.h                            |    8 +-
 include/media/ir-kbd-i2c.h                         |    2 +-
 include/media/lirc.h                               |  165 +
 include/media/lirc_dev.h                           |  225 +
 include/media/rc-map.h                             |   10 +
 include/media/sh_mobile_ceu.h                      |    3 +
 include/media/sh_mobile_csi2.h                     |   46 +
 include/media/soc_camera.h                         |    3 +
 include/media/v4l2-mediabus.h                      |   13 +-
 include/media/videobuf-core.h                      |    6 +-
 include/media/videobuf-dma-sg.h                    |   39 +-
 include/media/videobuf-vmalloc.h                   |    2 +-
 320 files changed, 27791 insertions(+), 31665 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/lirc_device_interface.xml
 create mode 100644 drivers/media/IR/ir-lirc-codec.c
 create mode 100644 drivers/media/IR/keymaps/rc-dib0700-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-dib0700-rc5.c
 create mode 100644 drivers/media/IR/keymaps/rc-lirc.c
 create mode 100644 drivers/media/IR/keymaps/rc-rc6-mce.c
 create mode 100644 drivers/media/IR/lirc_dev.c
 create mode 100644 drivers/media/IR/mceusb.c
 create mode 100644 drivers/media/video/au0828/au0828-vbi.c
 create mode 100644 drivers/media/video/davinci/Kconfig
 create mode 100644 drivers/media/video/fsl-viu.c
 create mode 100644 drivers/media/video/gspca/spca1528.c
 create mode 100644 drivers/media/video/gspca/sq930x.c
 delete mode 100644 drivers/media/video/ov511.c
 delete mode 100644 drivers/media/video/ov511.h
 delete mode 100644 drivers/media/video/ovcamchip/Makefile
 delete mode 100644 drivers/media/video/ovcamchip/ov6x20.c
 delete mode 100644 drivers/media/video/ovcamchip/ov6x30.c
 delete mode 100644 drivers/media/video/ovcamchip/ov76be.c
 delete mode 100644 drivers/media/video/ovcamchip/ov7x10.c
 delete mode 100644 drivers/media/video/ovcamchip/ov7x20.c
 delete mode 100644 drivers/media/video/ovcamchip/ovcamchip_core.c
 delete mode 100644 drivers/media/video/ovcamchip/ovcamchip_priv.h
 create mode 100644 drivers/media/video/sh_mobile_csi2.c
 delete mode 100644 drivers/media/video/stv680.c
 delete mode 100644 drivers/media/video/stv680.h
 delete mode 100644 drivers/media/video/usbvideo/quickcam_messenger.c
 delete mode 100644 drivers/media/video/usbvideo/quickcam_messenger.h
 delete mode 100644 drivers/media/video/w9968cf.c
 delete mode 100644 drivers/media/video/w9968cf.h
 delete mode 100644 drivers/media/video/w9968cf_decoder.h
 delete mode 100644 drivers/media/video/w9968cf_vpp.h
 delete mode 100644 drivers/media/video/zc0301/Kconfig
 delete mode 100644 drivers/media/video/zc0301/Makefile
 delete mode 100644 drivers/media/video/zc0301/zc0301.h
 delete mode 100644 drivers/media/video/zc0301/zc0301_core.c
 delete mode 100644 drivers/media/video/zc0301/zc0301_pas202bcb.c
 delete mode 100644 drivers/media/video/zc0301/zc0301_pb0330.c
 delete mode 100644 drivers/media/video/zc0301/zc0301_sensor.h
 delete mode 100644 drivers/staging/cx25821/cx25821-audups11.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video0.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video1.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video2.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video3.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video4.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video5.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video6.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video7.c
 delete mode 100644 drivers/staging/cx25821/cx25821-videoioctl.c
 delete mode 100644 drivers/staging/cx25821/cx25821-vidups10.c
 delete mode 100644 drivers/staging/cx25821/cx25821-vidups9.c
 create mode 100644 drivers/staging/lirc/Kconfig
 create mode 100644 drivers/staging/lirc/Makefile
 create mode 100644 drivers/staging/lirc/TODO
 create mode 100644 drivers/staging/lirc/TODO.lirc_i2c
 create mode 100644 drivers/staging/lirc/lirc_bt829.c
 create mode 100644 drivers/staging/lirc/lirc_ene0100.c
 create mode 100644 drivers/staging/lirc/lirc_ene0100.h
 create mode 100644 drivers/staging/lirc/lirc_i2c.c
 create mode 100644 drivers/staging/lirc/lirc_igorplugusb.c
 create mode 100644 drivers/staging/lirc/lirc_imon.c
 create mode 100644 drivers/staging/lirc/lirc_it87.c
 create mode 100644 drivers/staging/lirc/lirc_it87.h
 create mode 100644 drivers/staging/lirc/lirc_ite8709.c
 create mode 100644 drivers/staging/lirc/lirc_parallel.c
 create mode 100644 drivers/staging/lirc/lirc_parallel.h
 create mode 100644 drivers/staging/lirc/lirc_sasem.c
 create mode 100644 drivers/staging/lirc/lirc_serial.c
 create mode 100644 drivers/staging/lirc/lirc_sir.c
 create mode 100644 drivers/staging/lirc/lirc_streamzap.c
 create mode 100644 drivers/staging/lirc/lirc_ttusbir.c
 create mode 100644 drivers/staging/lirc/lirc_zilog.c
 create mode 100644 drivers/staging/tm6000/tm6000-input.c
 create mode 100644 include/media/lirc.h
 create mode 100644 include/media/lirc_dev.h
 create mode 100644 include/media/sh_mobile_csi2.h

