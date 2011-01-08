Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1AHPaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 10:30:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1AHPaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:30:04 -0500
Date: Sat, 8 Jan 2011 16:29:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1101080132020.26685@pobox.suse.cz>
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

to receive first round of updates for the HID layer. There are quite a few 
new devices supported (MacBook Air3 is probably the most notable one), as 
well as a few random fixes here and there.

The second round, which will be following in a few days, will contain 
first step towards unification of all the HID multitouch support (which is 
currently scattered around into several distinct drivers). The few-day 
delay is caused by (1) dependency on some input changes which are 
currently in-flight your way (2) Benjamin performing some final testing of 
the new unified driver right now.

Thanks.



Alan Ott (1):
      HID: hidraw: add compatibility ioctl() for 32-bit applications.

Benjamin Tissoires (2):
      HID: hid-mosart: ignore buttons report
      HID: hid-mosart: support suspend/resume

Chase Douglas (1):
      HID: magicmouse: Don't report REL_{X,Y} for Magic Trackpad

David Sterba (1):
      HID: picolcd: fix misuse of logical operation in place of bitop

Dennis Kügler (1):
      HID: Add support for Perixx PERIBOARD-707 (Plus)

Dmitry Torokhov (2):
      HID: hid-core - rename hid_blacklist to hid_have_special_driver
      HID: add hid_hw_open/close/power() handlers

Edgar (gimli) Hucek (2):
      HID: add MacBookAir 3,1 and 3,2 support
      input: bcm5974: Add support for MacBookAir3

Florian Fainelli (1):
      HID: replace offsets values with their corresponding BTN_* defines

Ignaz Forster (1):
      HID: Add Force Feedback support for EMS Trio Linker Plus II

Jesper Juhl (1):
      HID: hid-picolcd: Fix memory leak in picolcd_debug_out_report()

Jiri Kosina (4):
      HID: make translation table selection more clear
      HID: prodikeys: make sysfs permissions more strict
      HID: wacom: make sysfs permissions more strict
      HID: roccat: don't use #pragma pack

Joe Perches (5):
      HID: Add and use hid_<level>: dev_<level> equivalents
      HID: Use vzalloc for vmalloc/memset(,0...)
      HID: Remove superfluous __inline__
      HID: Hoist assigns from ifs
      HID: simplify an index check in hid_lookup_collection

Oliver Neukum (1):
      HID: usbhid: base runtime PM on modern API

Stefan Achatz (6):
      sysfs: Introducing binary attributes for struct class
      HID: roccat: use class for char device for sysfs attribute creation
      HID: roccat: declare meaning of pack pragma usage in driver headers
      HID: roccat: reduce number of functions in kone and pyra drivers
      HID: roccat: Add support for Roccat Kone[+] v2
      HID: roccat: Update sysfs attribute doc

Tejun Heo (1):
      HID: hid-picolcd: don't use flush_scheduled_work()

Tracey Dent (2):
      HID: Clean up makefile (-y instead of -objs)
      HID: usbhid: Clean up makefile (-y instead of -objs)

Valentine Barshak (2):
      HID: Fix race between disconnect and hiddev_ioctl
      HID: Consolidate device existence checks in hiddev_ioctl

 .../ABI/testing/sysfs-driver-hid-roccat-kone       |   16 +-
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |  108 +++
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |   18 +-
 drivers/base/core.c                                |   41 +-
 drivers/hid/Kconfig                                |   17 +
 drivers/hid/Makefile                               |   14 +-
 drivers/hid/hid-3m-pct.c                           |    2 +-
 drivers/hid/hid-a4tech.c                           |    6 +-
 drivers/hid/hid-apple.c                            |   63 ++-
 drivers/hid/hid-axff.c                             |   14 +-
 drivers/hid/hid-belkin.c                           |    4 +-
 drivers/hid/hid-cando.c                            |    2 +-
 drivers/hid/hid-cherry.c                           |    3 +-
 drivers/hid/hid-core.c                             |  119 ++-
 drivers/hid/hid-cypress.c                          |    4 +-
 drivers/hid/hid-debug.c                            |    4 +-
 drivers/hid/hid-drff.c                             |   14 +-
 drivers/hid/hid-egalax.c                           |    2 +-
 drivers/hid/hid-elecom.c                           |    3 +-
 drivers/hid/hid-emsff.c                            |  161 ++++
 drivers/hid/hid-gaff.c                             |   13 +-
 drivers/hid/hid-ids.h                              |   11 +
 drivers/hid/hid-input.c                            |   18 +-
 drivers/hid/hid-kye.c                              |    4 +-
 drivers/hid/hid-lg.c                               |   15 +-
 drivers/hid/hid-lg2ff.c                            |    9 +-
 drivers/hid/hid-lg3ff.c                            |    9 +-
 drivers/hid/hid-lg4ff.c                            |    9 +-
 drivers/hid/hid-lgff.c                             |    8 +-
 drivers/hid/hid-magicmouse.c                       |   20 +-
 drivers/hid/hid-microsoft.c                        |    7 +-
 drivers/hid/hid-monterey.c                         |    3 +-
 drivers/hid/hid-mosart.c                           |   22 +-
 drivers/hid/hid-ntrig.c                            |    9 +-
 drivers/hid/hid-ortek.c                            |    3 +-
 drivers/hid/hid-petalynx.c                         |    7 +-
 drivers/hid/hid-picolcd.c                          |   58 +-
 drivers/hid/hid-pl.c                               |   16 +-
 drivers/hid/hid-prodikeys.c                        |   27 +-
 drivers/hid/hid-quanta.c                           |    2 +-
 drivers/hid/hid-roccat-kone.c                      |  404 ++++------
 drivers/hid/hid-roccat-kone.h                      |   19 +-
 drivers/hid/hid-roccat-koneplus.c                  |  837 ++++++++++++++++++++
 drivers/hid/hid-roccat-koneplus.h                  |  224 ++++++
 drivers/hid/hid-roccat-pyra.c                      |  411 +++-------
 drivers/hid/hid-roccat-pyra.h                      |   23 +-
 drivers/hid/hid-roccat.c                           |   53 +-
 drivers/hid/hid-roccat.h                           |    5 +-
 drivers/hid/hid-samsung.c                          |    8 +-
 drivers/hid/hid-sjoy.c                             |   16 +-
 drivers/hid/hid-sony.c                             |   11 +-
 drivers/hid/hid-stantum.c                          |    2 +-
 drivers/hid/hid-sunplus.c                          |    3 +-
 drivers/hid/hid-tmff.c                             |   27 +-
 drivers/hid/hid-topseed.c                          |    1 +
 drivers/hid/hid-wacom.c                            |   28 +-
 drivers/hid/hid-zpff.c                             |   11 +-
 drivers/hid/hid-zydacron.c                         |   11 +-
 drivers/hid/hidraw.c                               |   36 +-
 drivers/hid/usbhid/Makefile                        |    6 +-
 drivers/hid/usbhid/hid-core.c                      |  105 +--
 drivers/hid/usbhid/hid-pidff.c                     |  164 ++--
 drivers/hid/usbhid/hid-quirks.c                    |    2 +-
 drivers/hid/usbhid/hiddev.c                        |  241 +++---
 drivers/hid/usbhid/usbhid.h                        |    1 -
 drivers/hid/usbhid/usbkbd.c                        |   24 +-
 drivers/input/mouse/bcm5974.c                      |   40 +
 include/linux/device.h                             |    1 +
 include/linux/hid.h                                |   75 ++-
 69 files changed, 2464 insertions(+), 1210 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
 create mode 100644 drivers/hid/hid-emsff.c
 create mode 100644 drivers/hid/hid-roccat-koneplus.c
 create mode 100644 drivers/hid/hid-roccat-koneplus.h

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
