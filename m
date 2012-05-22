Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2EVJtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:49:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab2EVJtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:49:41 -0400
Date: Tue, 22 May 2012 11:49:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1205221142570.16396@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID subsystem.

Apart from various driver updates and added support for a number of new 
devices (mostly multitouch ones, but not limited to), there is one change 
that is worth pointing out explicitly: creation of HID device groups and 
proper autoloading of hid-multitouch, implemented by Henrik Rydberg.

Thanks.

Alexey Kaminsky (1):
      HID: apple: Add Apple wireless keyboard 2011 ANSI PID

Benedikt Bergenthal (1):
      HID: hid-apple: fix a tab width style issue

Benjamin Tissoires (1):
      HID: hid-multitouch: fix wrong protocol detection

David Herrmann (1):
      HID: wiimote: Fix IR data parser

David Rientjes (1):
      HID: wacom: fix build breakage without CONFIG_LEDS_CLASS

Havard Skinnemoen (1):
      HID: hiddev: Use vzalloc to allocate hiddev_list

Henrik Rydberg (10):
      HID: hid-hyperv: Do not use hid_parse_report() directly
      HID: hid-logitech: Collect report descriptors before sending
      HID: Handle driver-specific device descriptor in core
      HID: Add device group to modalias
      HID: Scan the device for group info before adding it
      HID: Allow bus wildcard matching
      HID: Create a generic device group
      HID: hid-multitouch: Switch to device groups
      HID: Create a common generic driver
      HID: hid-multitouch: Only match MT interfaces

Jiri Kosina (8):
      HID: tivo: fix support for bluetooth version of tivo Slide
      HID: multitouch: Add support for Baanto touchscreen
      HID: hid-lg4ff: remove unused label in !LEDS_CLASS case
      HID: add Kconfig text to HID_BATTERY_STRENGTH
      HID: hidraw: add proper error handling to raw event reporting
      HID: fix return value of hidraw_report_event() when !CONFIG_HIDRAW
      HID: multitouch: MT interface matching for Baanto
      HID: explain the signed/unsigned handling in hid_add_field()

Jonathan Nieder (1):
      HID: logitech: read all 32 bits of report type bitfield

Josenivaldo Benito Junior (1):
      HID: Aureal Remote Control Device Driver

K. Y. Srinivasan (1):
      HID: hyperv: Set the hid drvdata correctly

Michal Malý (3):
      HID: hid-lg: Allow for custom device-specific properties to be stored in priv drvdata
      HID: lg4ff: Remove sysfs iface before deallocating memory
      HID: lg4ff: Take advantage of private driver data

Nikolai Kondrashov (4):
      HID: hid-input: Add digitizer tilt usage support
      HID: waltop: Add support for Sirius tablet
      HID: uclogic: Add support for UC-Logic TWHL850
      HID: waltop: Extend barrel button fix

Oliver Neukum (1):
      HID: usbhid: fix error handling of not enough bandwidth

Przemo Firszt (11):
      HID: wacom: Remove CONFIG_HID_WACOM_POWER_SUPPLY option
      HID: wacom: Change HID_WACOM option description.
      HID: wacom: Refactor battery/ac reporting for Graphire
      HID: wacom: Add battery/ac reporting for Intuos4 WL
      HID: wacom: Fix HID_WACOM self-dependency
      HID: wacom: Add module description
      HID: wacom: Add tilt reporting for Intuos4 WL
      HID: wacom: Add LED selector control for Wacom Intuos4 WL
      HID: wacom: Move Graphire raport header check.
      HID: wacom: Add speed setting for Intuos4 WL
      HID: wacom: Unify speed setting

Simon Haggett (1):
      HID: usbhid: Check HID report descriptor contents after device reset

Simon Wood (2):
      HID: hid-lg4ff: Add support for G27 LEDs
      HID: hid-lg4ff: Update Comments

srinivas pandruvada (1):
      HID: handle logical min/max signedness properly in parser

 Documentation/ABI/testing/sysfs-driver-wacom |    8 +
 drivers/hid/Kconfig                          |   34 ++-
 drivers/hid/Makefile                         |    3 +
 drivers/hid/hid-apple.c                      |    5 +-
 drivers/hid/hid-aureal.c                     |   54 +++++
 drivers/hid/hid-core.c                       |  316 +++++++++++++++++---------
 drivers/hid/hid-generic.c                    |   53 +++++
 drivers/hid/hid-hyperv.c                     |   15 +-
 drivers/hid/hid-ids.h                        |    8 +
 drivers/hid/hid-input.c                      |   36 ++--
 drivers/hid/hid-lg.c                         |   55 +++--
 drivers/hid/hid-lg.h                         |    5 +
 drivers/hid/hid-lg4ff.c                      |  258 +++++++++++++++++-----
 drivers/hid/hid-logitech-dj.c                |   76 +++----
 drivers/hid/hid-multitouch.c                 |  233 ++++++++++++--------
 drivers/hid/hid-uclogic.c                    |  141 ++++++++++++
 drivers/hid/hid-wacom.c                      |  302 ++++++++++++++++++-------
 drivers/hid/hid-waltop.c                     |  230 ++++++++++++++++---
 drivers/hid/hid-wiimote-core.c               |   16 +-
 drivers/hid/hidraw.c                         |   19 +-
 drivers/hid/usbhid/hid-core.c                |   81 +++++--
 drivers/hid/usbhid/hid-quirks.c              |    1 +
 drivers/hid/usbhid/hiddev.c                  |    9 +-
 drivers/hid/usbhid/usbhid.h                  |    1 +
 include/linux/hid.h                          |   36 ++--
 include/linux/hidraw.h                       |    4 +-
 include/linux/mod_devicetable.h              |    4 +-
 net/bluetooth/hidp/core.c                    |   27 +--
 scripts/mod/file2alias.c                     |    5 +-
 29 files changed, 1468 insertions(+), 567 deletions(-)
 create mode 100644 drivers/hid/hid-aureal.c
 create mode 100644 drivers/hid/hid-generic.c

-- 
Jiri Kosina
SUSE Labs
