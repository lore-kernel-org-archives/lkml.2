Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab0ESM7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:59:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab0ESM7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:59:05 -0400
Date: Wed, 19 May 2010 14:59:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1005191430370.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID subsystem patches queued for 2.6.35 merge window.

We have a lot of new drivers (including some fancy new multitouch stuff), 
plus some fixes and improvements to existing drivers and general subsystem 
infrastructure.


Alan Ott (1):
      HID: hidraw: Use Interrupt Endpoint for OUT Transfers if Available

Alan Stern (1):
      HID: usbhid: enable remote wakeup for keyboards

Antonio Ospite (1):
      HID: hidraw: fix indentation

Bastien Nocera (2):
      HID: add HID_QUIRK_HIDDEV_FORCE and HID_QUIRK_NO_IGNORE
      HID: add support for the Wacom Intuos 4 wireless

Bruno Prémont (12):
      HID: register debugfs entries before adding device
      HID: new driver for PicoLCD device
      HID: add framebuffer support to PicoLCD device
      HID: add backlight support to PicoLCD device
      HID: add lcd support to PicoLCD device
      HID: add GPO (leds) support to PicoLCD device
      HID: add experimental access to PicoLCD device's EEPROM and FLASH
      HID: hid-picolcd depends on LCD_CLASS_DEVICE
      HID: fix picolcd's version parsing
      HID: add suspend/resume hooks for hid drivers
      HID: split picolcd's operation_mode sysfs attribute
      HID: add PM support to PicoLCD device

Don Prince (4):
      HID: Prodikeys PC-MIDI HID Driver
      HID: Zydacron Remote Control driver
      HID: hid-samsung: add support for Creative Desktop Wireless 6000
      HID: hid-samsung: remove redundant key mappings

Jiri Kosina (13):
      HID: output event in debugfs even if hid_get_report() fails
      HID: simplify error handling in hid_input_report()
      HID: fixup Kconfig entry for Roccat Kone
      HID: remove BKL from hidraw
      HID: remove excessive _EMERG messages from hidraw
      HID: update BKL comment in hiddev
      HID: picolcd: fix build failure
      HID: egalax: update slab.h include
      HID: fix support for Wacom Intuos 4 wireless
      HID: fix build failure
      HID: make Prodikeys driver standalone config option
      HID: magicmouse: fix input registration
      HID: add omitted hid-zydacron.c file

Julia Lawall (2):
      HID: Use kmemdup
      HID: picolcd: Eliminate use after free

Lorenzo Castelli (1):
      HID: add mappings for a few keys found on Logitech MX3200

Pete Zaitcev (1):
      HID: non-overlapping zeroing of extra bits

Peter Hutterer (1):
      HID: add multi-input quirk for eGalax Touchcontroller

Przemo Firszt (4):
      HID: expose wacom pen tablet battery through power_supply class
      HID: separate mode switching function for wacom bluetooth driver
      HID: add sysfs speed attribute for wacom bluetooth tablet
      HID: wacom: add ABI doc entry for speed attribute

Rafi Rubin (3):
      HID: ntrig: add sensitivity and responsiveness support
      HID: ntrig: add sysfs access to filter parameters
      HID: ntrig: add filtering module parameters

Stefan Achatz (5):
      HID: add driver for Roccat Kone gaming mouse
      HID: roccat: Correctly mark init and exit functions
      HID: roccat: fix special button support
      HID: roccat: refactor special event handling
      HID: roccat: cleanup preprocessor macros

Stephane Chatty (5):
      HID: add support for the eGalax dual-touch panel
      HID: add support for 3M multitouch 22" display
      HID: added support for the Cando dual touch panel
      HID: fixed missing inits in hid-cando.c
      HID: Support for the 11.6" Cando panel

Tejun Heo (1):
      HID: update gfp/slab.h includes

Wayne Thomas (1):
      HID: add support for BTC Emprex 3009URF III Vista MCE Remote

 Documentation/ABI/testing/sysfs-driver-hid-picolcd |   43 +
 .../ABI/testing/sysfs-driver-hid-prodikeys         |   29 +
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |  111 +
 Documentation/ABI/testing/sysfs-wacom              |   10 +
 drivers/hid/Kconfig                                |  110 +-
 drivers/hid/Makefile                               |    6 +
 drivers/hid/hid-3m-pct.c                           |   31 +-
 drivers/hid/hid-cando.c                            |  272 ++
 drivers/hid/hid-core.c                             |   53 +-
 drivers/hid/hid-egalax.c                           |  281 +++
 drivers/hid/hid-ids.h                              |   25 +
 drivers/hid/hid-lg.c                               |    9 +
 drivers/hid/hid-magicmouse.c                       |    5 +-
 drivers/hid/hid-ntrig.c                            |  526 ++++-
 drivers/hid/hid-picolcd.c                          | 2631 ++++++++++++++++++++
 drivers/hid/hid-prodikeys.c                        |  910 +++++++
 drivers/hid/hid-roccat-kone.c                      |  994 ++++++++
 drivers/hid/hid-roccat-kone.h                      |  224 ++
 drivers/hid/hid-samsung.c                          |   95 +-
 drivers/hid/hid-topseed.c                          |   38 +-
 drivers/hid/hid-wacom.c                            |  229 ++-
 drivers/hid/hid-zydacron.c                         |  237 ++
 drivers/hid/hidraw.c                               |   50 +-
 drivers/hid/usbhid/hid-core.c                      |   73 +-
 drivers/hid/usbhid/hid-quirks.c                    |    1 +
 drivers/hid/usbhid/hiddev.c                        |   19 +-
 drivers/hid/usbhid/usbkbd.c                        |    1 +
 include/linux/hid.h                                |   10 +
 28 files changed, 6894 insertions(+), 129 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-picolcd
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-prodikeys
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
 create mode 100644 Documentation/ABI/testing/sysfs-wacom
 create mode 100644 drivers/hid/hid-cando.c
 create mode 100644 drivers/hid/hid-egalax.c
 create mode 100644 drivers/hid/hid-picolcd.c
 create mode 100644 drivers/hid/hid-prodikeys.c
 create mode 100644 drivers/hid/hid-roccat-kone.c
 create mode 100644 drivers/hid/hid-roccat-kone.h
 create mode 100644 drivers/hid/hid-zydacron.c

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
