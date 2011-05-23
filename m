Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1EWMd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:33:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:55819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab1EWMdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:33:25 -0400
Date: Mon, 23 May 2011 14:33:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1105231409060.28291@pobox.suse.cz>
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

to receive merge window updates for HID layer.

Benjamin has made quite some progress with unification of all the 
multitouch drivers into hid-multitouch, and added support for a load of 
new devices on top of it.

Apart from that, usual pack of fixes and support for new devices is 
included.
Plus there is a hid-magicmouse regression fix, which was reported and 
figured out too late for -rc, so I will be pushing it to -stable as well.

Thanks.

Alan Ott (2):
      HID: Documentation for hidraw
      HID: Move hiddev.txt to the new Documentation/hid directory

Antonio Ospite (1):
      HID: bt: hidp.h: do not use a tab after a #define

Armando Visconti (1):
      HID: fix a crash in hid_report_raw_event() function.

Austin Zhang (1):
      HID: hid-multitouch: add support for Ilitek dual-touch panel

Benjamin Tissoires (16):
      HID: hid-multitouch: Auto detection of maxcontacts
      HID: hid-multitouch: migrate support for Stantum panels to the unified driver.
      HID: hid-multitouch: migrate Cando dual touch panels to hid-multitouch
      HID: hid-multitouch: refactor initialization of ABS_MT_ORIENTATION
      HID: hid-multitouch: migrate 3M PCT touch screens to hid-multitouch
      HID: hid-multitouch: refactor last_field_index
      HID: hid-multitouch: merge hid-mosart into hid-multitouch
      HID: hid-multitouch: Add support for Lumio panels
      HID: hid-multitouch: add support for Elo TouchSystems 2515 IntelliTouch Plus
      HID: hid-multitouch: add support for ActionStar panels
      HID: hid-multitouch: add support for CVTouch panels
      HID: hid-multitouch: add support for GoodTouch panels
      HID: hid-multitouch: add support for Touch International panels
      HID: hid-multitouch: add support for Unitec panels
      HID: hid-multitouch: class MT_CLS_STANTUM is redundant with MT_CLS_CONFIDENCE
      HID: hid-multitouch: cosmetic changes, sort classes and devices

Bruno Prémont (1):
      HID: picolcd: Avoid compile warning/error triggered by copy_from_user()

Dan Carpenter (1):
      HID: hiddev: fix brace indent

Daniel Mack (1):
      HID: 'name' and 'phys' in 'struct hid_device' can never be NULL

Jarod Wilson (1):
      HID: assorted usage updates from hut 1.12

Jiri Kosina (6):
      HID: hidraw: fix comments
      HID: hidraw: fix samples miscompilation
      HID: add support for barcode scanners from Symbol Technologies
      HID: add support for Sony Navigation Controller
      HID: magicmouse: ignore 'ivalid report id' while switching modes
      HID: hiddev: fix race between hiddev_disconnect and hiddev_release

John Sung (1):
      HID: hid-multitouch: add support for PenMount dual-touch panel

Peter Gundermann (1):
      HID: add support for Logitech G27 wheel

Peter Waechtler (1):
      HID: hiddev: fix error path in hiddev_read when interrupted

Randy Dunlap (1):
      HID: hid-example: fix some build issues

Stefan Achatz (1):
      HID: roccat: fix actual/startup profile sysfs attribute in koneplus

 .../ABI/obsolete/sysfs-driver-hid-roccat-koneplus  |   10 +
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |   19 +-
 Documentation/{usb => hid}/hiddev.txt              |    0
 Documentation/hid/hidraw.txt                       |  119 ++++++++
 drivers/hid/Kconfig                                |   42 +--
 drivers/hid/Makefile                               |    4 -
 drivers/hid/hid-3m-pct.c                           |  305 --------------------
 drivers/hid/hid-cando.c                            |  276 ------------------
 drivers/hid/hid-core.c                             |   15 +
 drivers/hid/hid-ids.h                              |   32 ++
 drivers/hid/hid-input.c                            |   60 ++++-
 drivers/hid/hid-lg.c                               |    2 +
 drivers/hid/hid-lgff.c                             |    3 +
 drivers/hid/hid-magicmouse.c                       |   10 +-
 drivers/hid/hid-mosart.c                           |  296 -------------------
 drivers/hid/hid-multitouch.c                       |  264 ++++++++++++++---
 drivers/hid/hid-picolcd.c                          |    4 +-
 drivers/hid/hid-roccat-koneplus.c                  |   82 +++---
 drivers/hid/hid-roccat-koneplus.h                  |   11 +-
 drivers/hid/hid-sony.c                             |    2 +
 drivers/hid/hid-stantum.c                          |  286 ------------------
 drivers/hid/hidraw.c                               |   30 +--
 drivers/hid/usbhid/hid-quirks.c                    |    2 +
 drivers/hid/usbhid/hiddev.c                        |   34 +--
 net/bluetooth/hidp/hidp.h                          |    2 +-
 samples/Kconfig                                    |    6 +
 samples/Makefile                                   |    2 +-
 samples/hidraw/Makefile                            |   10 +
 samples/hidraw/hid-example.c                       |  178 ++++++++++++
 29 files changed, 755 insertions(+), 1351 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
 rename Documentation/{usb => hid}/hiddev.txt (100%)
 create mode 100644 Documentation/hid/hidraw.txt
 delete mode 100644 drivers/hid/hid-3m-pct.c
 delete mode 100644 drivers/hid/hid-cando.c
 delete mode 100644 drivers/hid/hid-mosart.c
 delete mode 100644 drivers/hid/hid-stantum.c
 create mode 100644 samples/hidraw/Makefile
 create mode 100644 samples/hidraw/hid-example.c
