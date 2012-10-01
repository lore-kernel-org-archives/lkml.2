Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2JANQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:16:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab2JANQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:16:40 -0400
Date: Mon, 1 Oct 2012 15:16:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1210011452020.27440@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID layer.


1) Patchset from Henrik Rydberg which substantially reduces irqsoff 
   latency for all input devices. In addition to that, Henrik reworked 
   multitouch handling in order to reduce runtime memory consumption.

   This patchset touches code in Input subsystem as well. All the changes 
   have been Acked by Dmitry, and we agreed to do it this way due to 
   inter-dependencies between the patchset and subsequent changes in HID 
   subsystem.

2) Rework, clenaups and a lot of fixes to picolcd driver by Bruno Prémont.

3) Core report descriptor handling fix which fixes resume issue on some 
   devices, by Kevin Daughtridge

4) hidraw fixes by Alexey Khoroshilov and Ratan Nalumasu

5) wiimote driver now supports balance board, by David Herrmann.

6) Other smaller fixes and new device id additions all over the place.





Alexey Khoroshilov (1):
      HID: hidraw: improve error handling in hidraw_init()

Andy Shevchenko (1):
      HID: holtekff: use %*ph to dump small buffers

Axel Lin (10):
      HID: hid-lcpower: Use HID_UP_LOGIVENDOR instead of hard coded 0x0ffbc0000
      HID: waltop: Remove waltop_probe() and waltop_remove() functions
      HID: primax: Remove px_probe() and px_remove() functions
      HID: picolcd: fix build error if !CONFIG_DEBUG_FS
      HID: lg: Remove unnecessary casts of void pointers
      HID: lg4ff: Remove unnecessary casts of void pointers
      HID: prodikeys: Remove unnecessary casts of void pointers
      HID: lenovo-tpkbd: Remove unnecessary casts of void pointers
      HID: wacom: Fix wacom_probe error handling
      HID: picolcd_core: Remove setting hdev->claimed before calling hid_hw_start()

Bruno Prémont (15):
      HID: picoLCD: split driver code
      HID: picoLCD: Replace own refcounting with fbdev's
      HID: picoLCD: prevent NULL pointer dereference on unplug
      HID: picoLCD: satify some checkpatch warnings
      HID: picoLCD: Improve unplug handling
      HID: picoLCD: add myself to MAINTAINERS
      HID: picoLCD: prevent NULL pointer dereferences
      HID: picoLCD: rework hid-fbdev interaction
      HID: picoLCD: Add support for CIR
      HID: picoLCD: optimize for inactive debugfs
      HID: picoLCD: fix dumping of IR_DATA report
      HID: picoLCD: use proper device as input_dev parent
      HID: picoLCD: drop version check during probe
      HID: picoLCD: bounds check in dump_buff_as_hex()
      HID: picoLCD: optimize for inactive debugfs

Dan Carpenter (1):
      HID: picoLCD: fix a NULL test in picolcd_raw_cir()

David Dillow (1):
      HID: Add support for Sony PS3 BD Remote Control

David Herrmann (1):
      HID: wiimote: Add Nintendo Balance-Board support

Florian Echtler (2):
      HID: wiimote: Parse calibration data of balance boards
      HID: wiimote: fix weight conversion error for values > 17kg

Geert Uytterhoeven (1):
      HID: picolcd: Add missing #include <linux/uaccess.h>

Henrik Rydberg (23):
      HID: hid-multitouch: Remove misleading null test
      HID: hid-debug: Show rdesc for unclaimed devices
      Input: Break out MT data
      Input: Improve the events-per-packet estimate
      Input: Make sure we follow all EV_KEY events
      Input: Move autorepeat to the event-passing phase
      Input: Send events one packet at a time
      Input: evdev - Add the events() callback
      Input: MT - Add flags to input_mt_init_slots()
      Input: MT - Handle frame synchronization in core
      Input: MT - Add in-kernel tracking
      Input: MT - Get slot by key
      Input: MT - Allow legacy pressure computation
      HID: Add an input configured notification callback
      HID: Allow more fields in the hid report
      HID: hid-multitouch: Simplify setup and frame synchronization
      HID: hid-multitouch: Remove the redundant touch state
      HID: hid-multitouch: Fix contact count on 3M panels
      HID: hid-multitouch: Add Flatfrog support
      Input: bcm5974 - only setup button urb for TYPE1 devices
      Input: bcm5974 - Preparatory renames
      Input: bcm5974 - Drop the logical dimensions
      Input: bcm5974 - Convert to MT-B

Jiri Kosina (3):
      HID: multitouch: add support for Touch Revolution touchscreens
      HID: update hid_have_special_driver[] explanation
      HID: remove Paul Walmsley's copyright from places where it shouldn't be

Josh Triplett (1):
      HID: Remove "default m" from HID_LOGITECH_DJ

Kevin Daughtridge (1):
      HID: keep dev_rdesc unmodified and use it for comparisons

Marek Vasut (2):
      HID: Bump maximum global item tag report size to 128 bytes
      HID: add quirk for Freescale i.MX28 ROM recovery

Michal Malý (4):
      HID: hid-lg4ff: Minor code cleanup to improve readability
      HID: hid-lg4ff: Adjust X axis input value accordingly to selected range.
      HID: hid-lg4ff: Set absolute axes parametes on DFP
      HID: lg4ff: Minor coding style fixes in lg4ff and hid-lg

Nikolai Kondrashov (1):
      HID: uclogic: Add support for UC-Logic TWHA60

Przemo Firszt (2):
      HID: wacom: Use half of brightness for low state
      HID: wacom: OLEDs control over sysfs for Intuos4

Ratan Nalumasu (1):
      HID: hidraw: don't deallocate memory when it is in use

Sachin Kamat (1):
      HID: Fix return values in open_collection()

Scott Liu (1):
      HID: multitouch: Add ELAN production request when resume.

Simon Farnsworth (1):
      HID: Remove duplicate ID for QUANTA 3001 touchscreen

Stefan Achatz (1):
      HID: roccat: conditional blacklisting of Roccat modules

Stephen Rothwell (1):
      HID: picolcd: using vmalloc() requires the include of vmalloc.h

Thierry Reding (1):
      HID: multitouch: Add support for eGalax 0x73f7

Wen-chien Jesse Sung (1):
      HID: ntrig: change default value of logical/physical width/height to 1

Xianhan Yu (1):
      HID: multitouch: add support for GeneralTouch multi-touchscreen

 Documentation/ABI/testing/sysfs-driver-wacom |   13 +
 MAINTAINERS                                  |    6 +
 drivers/hid/Kconfig                          |   22 +-
 drivers/hid/Makefile                         |   21 +
 drivers/hid/hid-a4tech.c                     |    1 -
 drivers/hid/hid-apple.c                      |    1 -
 drivers/hid/hid-aureal.c                     |    1 -
 drivers/hid/hid-belkin.c                     |    1 -
 drivers/hid/hid-cherry.c                     |    1 -
 drivers/hid/hid-core.c                       |   38 +-
 drivers/hid/hid-cypress.c                    |    1 -
 drivers/hid/hid-debug.c                      |   12 +-
 drivers/hid/hid-ezkey.c                      |    1 -
 drivers/hid/hid-gyration.c                   |    1 -
 drivers/hid/hid-holtekff.c                   |    3 +-
 drivers/hid/hid-ids.h                        |   16 +-
 drivers/hid/hid-input.c                      |   11 +-
 drivers/hid/hid-lcpower.c                    |    2 +-
 drivers/hid/hid-lenovo-tpkbd.c               |  147 +--
 drivers/hid/hid-lg.c                         |   20 +-
 drivers/hid/hid-lg.h                         |    4 +
 drivers/hid/hid-lg4ff.c                      |  198 ++-
 drivers/hid/hid-magicmouse.c                 |    2 +-
 drivers/hid/hid-microsoft.c                  |    1 -
 drivers/hid/hid-monterey.c                   |    1 -
 drivers/hid/hid-multitouch.c                 |  252 ++-
 drivers/hid/hid-ntrig.c                      |    8 +-
 drivers/hid/hid-petalynx.c                   |    1 -
 drivers/hid/hid-picolcd.c                    | 2748 --------------------------
 drivers/hid/hid-picolcd.h                    |  309 +++
 drivers/hid/hid-picolcd_backlight.c          |  122 ++
 drivers/hid/hid-picolcd_cir.c                |  152 ++
 drivers/hid/hid-picolcd_core.c               |  689 +++++++
 drivers/hid/hid-picolcd_debugfs.c            |  899 +++++++++
 drivers/hid/hid-picolcd_fb.c                 |  615 ++++++
 drivers/hid/hid-picolcd_lcd.c                |  107 +
 drivers/hid/hid-picolcd_leds.c               |  175 ++
 drivers/hid/hid-primax.c                     |   25 -
 drivers/hid/hid-prodikeys.c                  |   18 +-
 drivers/hid/hid-ps3remote.c                  |  215 ++
 drivers/hid/hid-samsung.c                    |    1 -
 drivers/hid/hid-sony.c                       |    1 -
 drivers/hid/hid-sunplus.c                    |    1 -
 drivers/hid/hid-uclogic.c                    |   98 +
 drivers/hid/hid-wacom.c                      |  170 ++-
 drivers/hid/hid-waltop.c                     |   29 -
 drivers/hid/hid-wiimote-ext.c                |   97 +
 drivers/hid/hidraw.c                         |   84 +-
 drivers/hid/usbhid/hid-core.c                |    6 +-
 drivers/hid/usbhid/hid-quirks.c              |    3 +-
 drivers/input/evdev.c                        |   78 +-
 drivers/input/input-mt.c                     |  305 +++-
 drivers/input/input.c                        |  254 ++-
 drivers/input/misc/uinput.c                  |    2 +-
 drivers/input/mouse/alps.c                   |    2 +-
 drivers/input/mouse/bcm5974.c                |  348 ++--
 drivers/input/mouse/elantech.c               |    4 +-
 drivers/input/mouse/sentelic.c               |    2 +-
 drivers/input/mouse/synaptics.c              |    4 +-
 drivers/input/tablet/wacom_wac.c             |    6 +-
 drivers/input/touchscreen/atmel_mxt_ts.c     |    2 +-
 drivers/input/touchscreen/cyttsp_core.c      |    2 +-
 drivers/input/touchscreen/edt-ft5x06.c       |    2 +-
 drivers/input/touchscreen/egalax_ts.c        |    2 +-
 drivers/input/touchscreen/ili210x.c          |    2 +-
 drivers/input/touchscreen/mms114.c           |    2 +-
 drivers/input/touchscreen/penmount.c         |    2 +-
 drivers/input/touchscreen/wacom_w8001.c      |    2 +-
 include/linux/hid.h                          |    5 +-
 include/linux/input.h                        |   35 +-
 include/linux/input/mt.h                     |   57 +-
 71 files changed, 4900 insertions(+), 3568 deletions(-)
 delete mode 100644 drivers/hid/hid-picolcd.c
 create mode 100644 drivers/hid/hid-picolcd.h
 create mode 100644 drivers/hid/hid-picolcd_backlight.c
 create mode 100644 drivers/hid/hid-picolcd_cir.c
 create mode 100644 drivers/hid/hid-picolcd_core.c
 create mode 100644 drivers/hid/hid-picolcd_debugfs.c
 create mode 100644 drivers/hid/hid-picolcd_fb.c
 create mode 100644 drivers/hid/hid-picolcd_lcd.c
 create mode 100644 drivers/hid/hid-picolcd_leds.c
 create mode 100644 drivers/hid/hid-ps3remote.c

-- 
Jiri Kosina
SUSE Labs
