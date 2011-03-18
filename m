Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1CRNYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:24:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:47273 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab1CRNYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:24:04 -0400
Date: Fri, 18 Mar 2011 14:24:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1103181338330.19969@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive first round of merge window updates for HID subsystem.

There is quite some new hardware support added, both 'standard' HID and 
HID-multitouch ones.
Another thing to mention is finally the merge of hidraw support for proper 
working with FEATURE reports.
And of course assorted small fixes here and there.

Thanks!



Alan Ott (6):
      HID: hidraw: Replace Confusing += Operator with =
      HID: bt: Move hid_add_device() call to after hidp_session() has started.
      HID: bt: Wait for ACK on Sent Reports
      HID: Add Support for Setting and Getting Feature Reports from hidraw
      HID: bt: Add support for hidraw HIDIOCGFEATURE and HIDIOCSFEATURE
      HID: Add HID Report Descriptor to sysfs

Antonio Ospite (2):
      HID: hid-sony.c: Fix sending Output reports to the Sixaxis
      HID: bt hidp: send Output reports using SET_REPORT on the Control channel

Benjamin Tissoires (6):
      HID: hid-multitouch: change default mt_class
      HID: hid-multitouch: Rename MT_CLS_DUAL1 and MT_CLS_DUAL2
      HID: hid-multitouch: add Benjamin Tissoires as module_author
      HID: hid-multitouch: introduce IrTouch Infrared USB device
      HID: kernel oops in out_cleanup in function hidinput_connect
      HID: add IRTOUCH infrared USB to hid_have_special_driver

Chris Schlund (2):
      HID: add support for wireless remote LC Power model RC1000MCE
      HID: hid-lcpower: fix key mapping

Dmitry Torokhov (1):
      HID: ACRUX - activate the device immediately after binding

Henrik Rydberg (3):
      HID: Do not create input devices for feature reports
      HID: hid-magicmouse: Correct touch orientation direction
      HID: hid-multitouch: Send events per slot if CONTACTCOUNT is missing

Herton Ronaldo Krzesinski (1):
      HID: add support for Ortek PKB-1700

Jiri Kosina (4):
      HID: add support for Keytouch IEC 60945
      HID: hid-ortek: remove spurious reference
      HID: add support for Logitech Driving Force Pro wheel
      Merge branches 'dragonrise', 'hidraw-feature', 'multitouch', 'ntrig', 'roccat', 'upstream' and 'upstream-fixes' into for-linus

Nikolai Kondrashov (3):
      HID: rename hid-drff.c to hid-dr.c
      HID: add support for DragonRise PID 0011 gamepad
      HID: update dragonrise Kconfig description

Rafi Rubin (4):
      HID: ntrig don't dereference unclaimed hidinput
      HID: ntrig: apply NO_INIT_REPORTS quirk
      HID: ntrig remove if and drop an indent
      HID: hid-ntrig: init settle and mode check

Richard Nauber (1):
      HID: merge hid-egalax into hid-multitouch

Stefan Achatz (14):
      HID: roccat: Add support for Roccat Arvo keyboard
      HID: roccat: Fix an error message when reading more data from bin attributes
      HID: hidraw: fix hidraw_disconnect()
      HID: roccat: Remove empty function definitions for roccat chardev
      HID: roccat: Use new hid_err macros
      HID: roccat: Introduce module hid-roccat-common
      HID: roccat: Add support for Kova[+] mouse
      HID: roccat: Increase waiting time for Kone[+] to prevent occasional freezes
      HID: roccat: Add ioctl command to retreive report size from chardev
      HID: roccat: Fix NULL pointer dereference when unloading module
      HID: roccat: Fix bug that prevented roccat chardev from removing devices
      HID: roccat: Rename header roccat.h -> hid-roccat.h
      HID: roccat: Add 'Users:' tag to sysfs documentation
      HID: roccat-koneplus: vorrect mode of sysfs attr 'sensor'

Steffen Barszus (1):
      HID: Add teletext/color keys - gyration remote - EU version (GYAR3101CKDE)

Vasiliy Kulikov (1):
      HID: hid-roccat-koneplus: potential NULL dereference

 Documentation/ABI/testing/sysfs-driver-hid         |   10 +
 .../ABI/testing/sysfs-driver-hid-roccat-arvo       |   53 ++
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |    8 +
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |   11 +
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |  100 +++
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |    9 +
 Documentation/ioctl/ioctl-number.txt               |    1 +
 drivers/hid/Kconfig                                |   67 ++-
 drivers/hid/Makefile                               |   10 +-
 drivers/hid/hid-axff.c                             |   31 +-
 drivers/hid/hid-core.c                             |   43 ++-
 drivers/hid/hid-dr.c                               |  312 +++++++++
 drivers/hid/hid-drff.c                             |  197 ------
 drivers/hid/hid-egalax.c                           |  279 --------
 drivers/hid/hid-gyration.c                         |    5 +
 drivers/hid/hid-ids.h                              |   13 +
 drivers/hid/hid-input.c                            |   31 +-
 drivers/hid/hid-keytouch.c                         |   66 ++
 drivers/hid/hid-lcpower.c                          |   70 ++
 drivers/hid/hid-lg.c                               |    2 +
 drivers/hid/hid-magicmouse.c                       |    4 +-
 drivers/hid/hid-multitouch.c                       |   76 ++-
 drivers/hid/hid-ntrig.c                            |  519 ++++++++-------
 drivers/hid/hid-ortek.c                            |    6 +-
 drivers/hid/hid-roccat-arvo.c                      |  450 ++++++++++++
 drivers/hid/hid-roccat-arvo.h                      |   98 +++
 drivers/hid/hid-roccat-common.c                    |   62 ++
 drivers/hid/hid-roccat-common.h                    |   23 +
 drivers/hid/hid-roccat-kone.c                      |  156 ++---
 drivers/hid/hid-roccat-koneplus.c                  |  167 ++---
 drivers/hid/hid-roccat-kovaplus.c                  |  715 ++++++++++++++++++++
 drivers/hid/hid-roccat-kovaplus.h                  |  157 +++++
 drivers/hid/hid-roccat-pyra.c                      |  174 ++----
 drivers/hid/hid-roccat.c                           |   53 ++-
 drivers/hid/hid-sony.c                             |   20 +
 drivers/hid/hidraw.c                               |  112 +++-
 drivers/hid/usbhid/hid-core.c                      |   35 +
 {drivers/hid => include/linux}/hid-roccat.h        |   19 +-
 include/linux/hid.h                                |    5 +-
 include/linux/hidraw.h                             |    3 +
 net/bluetooth/hidp/core.c                          |  197 +++++-
 net/bluetooth/hidp/hidp.h                          |   15 +
 42 files changed, 3235 insertions(+), 1149 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
 create mode 100644 drivers/hid/hid-dr.c
 delete mode 100644 drivers/hid/hid-drff.c
 delete mode 100644 drivers/hid/hid-egalax.c
 create mode 100644 drivers/hid/hid-keytouch.c
 create mode 100644 drivers/hid/hid-lcpower.c
 create mode 100644 drivers/hid/hid-roccat-arvo.c
 create mode 100644 drivers/hid/hid-roccat-arvo.h
 create mode 100644 drivers/hid/hid-roccat-common.c
 create mode 100644 drivers/hid/hid-roccat-common.h
 create mode 100644 drivers/hid/hid-roccat-kovaplus.c
 create mode 100644 drivers/hid/hid-roccat-kovaplus.h
 rename {drivers/hid => include/linux}/hid-roccat.h (52%)
