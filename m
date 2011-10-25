Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1JYJXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:23:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab1JYJXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:23:22 -0400
Date: Tue, 25 Oct 2011 11:23:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1110251009100.3541@pobox.suse.cz>
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

to receive the following updates to HID subsystem.

Amit Nagal (2):
      HID: hidraw: free list for all error in hidraw_open
      HID: hidraw: open count should not increase if error

Benjamin Tissoires (2):
      HID: add autodetection of multitouch devices
      HID: multitouch: decide if hid-multitouch needs to handle mt devices

Bojan Prtvar (2):
      HID: zydacron: kfree() NULL pointer cleanup
      HID: prodikeys: kfree() NULL pointer cleanup

Dan Carpenter (4):
      HID: hid-lg4ff: silence sparse complaint
      HID: hid-lg4ff: add a kfree() to an error path
      HID: unlock on error path in hid_device_probe()
      HID: hiddev: potential info leak in hiddev_ioctl()

Daniel van Vugt (1):
      HID: hid-magicmouse: Magic Trackpad has 1 button, not 2

David Herrmann (17):
      HID: Fix race condition between driver core and ll-driver
      HID: wiimote: Support rumble device
      HID: wiimote: Add force-feedback support
      HID: wiimote: Add accelerometer input device
      HID: wiimote: Parse accelerometer data
      HID: wiimote: Add IR input device
      HID: wiimote: Parse IR data
      HID: wiimote: Add missing extension DRM handlers
      HID: wiimote: Add register/eeprom memory support
      HID: wiimote: Helper functions for synchronous requests
      HID: wiimote: Add write-register helpers
      HID: wiimote: Add IR initializer
      HID: wiimote: Initialize IR cam on request
      HID: wiimote: Add status request
      HID: wiimote: Read wiimote battery charge level
      HID: wiimote: Add MAINTAINERS entry
      HID: wacom: Set input bits before registration

James Hogan (1):
      HID: hidraw: protect hidraw_disconnect() better

Jeff Brown (3):
      HID: hid-debug: Show application usage for each collection.
      HID: hid-multitouch: Filter collections by application usage.
      HID: hid-multitouch: Add LG Display Multitouch device.

Jiri Kosina (6):
      HID: propagate return value correctly in hid_input_report()
      HID: add MacBookAir4,2 to hid_have_special_driver[]
      HID: make CONFIG_LOGIWHEELS_FF default to CONFIG_LOGITECH_FF
      HID: MacbookAir4,1 and MacbookAir4,2 need entry in hid_mouse_ignore_list[]
      HID: consolidate MacbookAir 4,1 mappings
      HID: primax: remove spurious dependency

Joshua V. Dillon (1):
      HID: add support for MacBookAir4,2 keyboard.

Michal Malý (7):
      HID: lg4ff - Move handling of Logitech wheels to lg4ff driver
      HID: lg4ff - Add support for native mode switching
      HID: lg4ff - Add range setting support and sysfs interface
      HID: lg4ff - Add autocentering command accepted by Formula Force EX
      HID: lg4ff - Fix misleading info in Kconfig
      HID: lg4ff - Document sysfs interface for range setting
      HID: "hid-logitech" driver with Logitech Driving Force GT

Nestor Lopez Casado (2):
      HID: Add full support for Logitech Unifying receivers
      HID: hid-logitech-dj: fix off by one

Nobuhiro Iwamatsu (1):
      HID: Add support MacbookAir 4,1 keyboard

Oliver Neukum (1):
      HID: usbhid: cancel timer for retry synchronously

Sean Young (2):
      IHD: Support force feedback on MP-8866
      HID: Add device IDs for more SJOY adapters

Sergei Kolzun (2):
      HID: ACRUX - fix enabling force feedback support
      HID: ACRUX - handle gamepads with different report layout

Stefan Achatz (5):
      HID: roccat: Fixed false dpi reporting when using osd event
      HID: roccat: Pyra now reports external profile changes via roccat device
      HID: roccat: Kovaplus now reports external profile changes via roccat device
      HID: roccat: cleaned up code for Kone and fixed wrong initialization value
      HID: roccat: Kone now reports external profile changes via roccat device

Stephane Chatty (1):
      HID: hid-multitouch: add support for the IDEACOM 6650 chip

Terry Lambert (1):
      HID: support primax keyboards violating USB HID spec

 .../ABI/testing/sysfs-driver-hid-logitech-lg4ff    |    7 +
 MAINTAINERS                                        |    6 +
 drivers/hid/Kconfig                                |   42 +-
 drivers/hid/Makefile                               |    4 +-
 drivers/hid/hid-apple.c                            |   15 +
 drivers/hid/hid-axff.c                             |   36 +-
 drivers/hid/hid-core.c                             |   79 ++-
 drivers/hid/hid-debug.c                            |    5 +
 drivers/hid/hid-ids.h                              |   21 +
 drivers/hid/hid-input.c                            |   11 +
 drivers/hid/hid-lg.c                               |   29 +-
 drivers/hid/hid-lg.h                               |    4 +-
 drivers/hid/hid-lg4ff.c                            |  403 ++++++++-
 drivers/hid/hid-lgff.c                             |   13 -
 drivers/hid/hid-logitech-dj.c                      |  922 ++++++++++++++++++++
 drivers/hid/hid-logitech-dj.h                      |  123 +++
 drivers/hid/hid-magicmouse.c                       |    7 +
 drivers/hid/hid-multitouch.c                       |   93 ++-
 drivers/hid/hid-primax.c                           |  117 +++
 drivers/hid/hid-prodikeys.c                        |    8 +-
 drivers/hid/hid-roccat-kone.c                      |   63 +-
 drivers/hid/hid-roccat-kovaplus.c                  |   17 +-
 drivers/hid/hid-roccat-pyra.c                      |   23 +-
 drivers/hid/hid-sjoy.c                             |   75 +-
 drivers/hid/hid-wacom.c                            |   81 +-
 drivers/hid/hid-wiimote.c                          |  800 +++++++++++++++++-
 drivers/hid/hid-zydacron.c                         |    4 +-
 drivers/hid/hidraw.c                               |   11 +-
 drivers/hid/usbhid/hid-core.c                      |    2 +-
 drivers/hid/usbhid/hid-quirks.c                    |    2 -
 drivers/hid/usbhid/hiddev.c                        |    2 +
 include/linux/hid.h                                |    3 +
 32 files changed, 2804 insertions(+), 224 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-logitech-lg4ff
 create mode 100644 drivers/hid/hid-logitech-dj.c
 create mode 100644 drivers/hid/hid-logitech-dj.h
 create mode 100644 drivers/hid/hid-primax.c

-- 
Jiri Kosina
SUSE Labs
