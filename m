Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab0JWVjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 17:39:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab0JWVjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 17:39:19 -0400
Date: Sat, 23 Oct 2010 23:39:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1010232314400.6879@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the HID subsystem patches below. Mostly adding support for a 
few new multitouch toys, and improving already existing drivers. Plus some 
bugfixes which were not urgent enough for .36.

Thanks!

Alan Ott (2):
      HID: don't Send Feature Reports on Interrupt Endpoint
      HID: trivial formatting fix

Alan Stern (1):
      HID: usbhid: remove unused hiddev_driver

Antonio Ospite (2):
      HID: sony: Apply sixaxis quirks only to sixaxis
      HID: hid-sony: override usbhid_output_raw_report for Sixaxis

Borislav Petkov (1):
      HID: Kconfig: Complete Kconfig prompt names

Chase Douglas (6):
      HID: magicmouse: simplify touch down logic
      HID: magicmouse: remove timestamp logic
      HID: magicmouse: simplify multitouch feature request
      HID: magicmouse: simplify touch data bit manipulation
      HID: magicmouse: enable Magic Trackpad support
      HID: debugfs: wake up reading tasks upon event

Hendrik Iben (1):
      HID: force feedback support for Logitech RumblePad gamepad

Henrik Rydberg (7):
      HID: Add a hid quirk for input sync override
      HID: 3m: Adjust to sequential MT HID protocol
      HID: 3m: Output proper orientation range
      HID: 3m: Convert to MT slots
      HID: 3m: Correct touchscreen emulation
      HID: 3m: Adjust major / minor axes to scale
      HID: magicmouse: Adjust major / minor axes to scale

Jiri Kosina (2):
      HID: uclogic: fix up Kconfig entry
      HID: fix mismerge in hid-lg

Jiri Slaby (1):
      HID: hidraw: fix window in hidraw_release

Lech Perczak (1):
      HID: fix A4Tech RP-649 horizontal scrollwheel

Michael Poole (1):
      HID: magicmouse: Use hid-input parsing rather than bypassing it

Nikolai Kondrashov (13):
      HID: allow resizing and replacing report descriptors
      HID: Add Tablet Pick -> BTN_STYLUS2 mapping
      HID: Add support for UC-Logic WP????U tablets
      HID: add support for two Waltop tablets
      HID: uclogic: fix coding style
      HID: uclogic: add proper support for PF1209
      HID: waltop: fix Media Tablet 10.6 inch scrolling
      HID: waltop: add Media Tablet 14.1 inch support
      HID: waltop: fix Media Tablet 10.6 inch zooming
      HID: waltop: comment on tablet modes
      HID: rdesc parser: remove local item size limit
      HID: waltop: add support for Waltop Slim Tablet 12.1 inch
      HID: add absolute axis resolution calculation

Pascal Auriel - Stantum (1):
      HID: support STmicroelectronics and Sitronix with hid-stantuml driver

Philipp Merkel (1):
      HID: Fix for problems with eGalax/DWAV multi-touch-screen

Rafi Rubin (3):
      HID: ntrig: add documention
      HID: ntrig: a bit of whitespace cleanup
      HID: ntrig: identify firmware version

Rok Mandeljc (1):
      HID: add NOGET quirk for AXIS 295 Video Surveillance Joystick

Simon Wood (1):
      HID: Add support for Logitech Speed Force Wireless gaming wheel

Stefan Achatz (2):
      HID: roccat: add driver for Roccat Pyra mouse
      HID: roccat: Normalized reported profile number for pyra button events.

 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |   98 ++
 Documentation/input/ntrig.txt                      |  126 +++
 drivers/hid/Kconfig                                |   91 ++-
 drivers/hid/Makefile                               |    6 +
 drivers/hid/hid-3m-pct.c                           |  127 ++-
 drivers/hid/hid-a4tech.c                           |    2 +
 drivers/hid/hid-apple.c                            |    7 +-
 drivers/hid/hid-cherry.c                           |    7 +-
 drivers/hid/hid-core.c                             |   23 +-
 drivers/hid/hid-cypress.c                          |    9 +-
 drivers/hid/hid-debug.c                            |    2 +
 drivers/hid/hid-egalax.c                           |   16 +-
 drivers/hid/hid-elecom.c                           |    7 +-
 drivers/hid/hid-ids.h                              |   23 +-
 drivers/hid/hid-input.c                            |   87 ++
 drivers/hid/hid-kye.c                              |    7 +-
 drivers/hid/hid-lg.c                               |   49 +-
 drivers/hid/hid-lg.h                               |    6 +
 drivers/hid/hid-lg2ff.c                            |    4 +-
 drivers/hid/hid-lg4ff.c                            |  136 +++
 drivers/hid/hid-magicmouse.c                       |  325 ++++---
 drivers/hid/hid-microsoft.c                        |    7 +-
 drivers/hid/hid-monterey.c                         |    7 +-
 drivers/hid/hid-ntrig.c                            |   69 ++-
 drivers/hid/hid-ortek.c                            |    7 +-
 drivers/hid/hid-petalynx.c                         |    7 +-
 drivers/hid/hid-prodikeys.c                        |    7 +-
 drivers/hid/hid-roccat-pyra.c                      |  968 +++++++++++++++++
 drivers/hid/hid-roccat-pyra.h                      |  186 ++++
 drivers/hid/hid-samsung.c                          |   20 +-
 drivers/hid/hid-sony.c                             |   56 +-
 drivers/hid/hid-stantum.c                          |    2 +
 drivers/hid/hid-sunplus.c                          |    7 +-
 drivers/hid/hid-uclogic.c                          |  623 +++++++++++
 drivers/hid/hid-waltop.c                           | 1099 ++++++++++++++++++++
 drivers/hid/hid-zydacron.c                         |    7 +-
 drivers/hid/hidraw.c                               |   14 +-
 drivers/hid/usbhid/hid-core.c                      |    9 +-
 drivers/hid/usbhid/hid-quirks.c                    |    6 +-
 drivers/hid/usbhid/hiddev.c                        |   40 -
 include/linux/hid.h                                |    5 +-
 include/linux/hiddev.h                             |    4 -
 42 files changed, 3934 insertions(+), 374 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
 create mode 100644 Documentation/input/ntrig.txt
 create mode 100644 drivers/hid/hid-lg4ff.c
 create mode 100644 drivers/hid/hid-roccat-pyra.c
 create mode 100644 drivers/hid/hid-roccat-pyra.h
 create mode 100644 drivers/hid/hid-uclogic.c
 create mode 100644 drivers/hid/hid-waltop.c
