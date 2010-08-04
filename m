Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab0HDOeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:34:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105Ab0HDOeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:34:01 -0400
Date: Wed, 4 Aug 2010 16:34:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1008041544500.29919@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive 2.6.36 material for the HID subsystem. We add support for quite 
some new hardware, fix a few random bugs, and finally get rid of BKL in 
hiddev.

Thanks.

Arnd Bergmann (1):
      HID: hiddev: use usb_find_interface, get rid of BKL

Bruno Prémont (4):
      HID: picolcd: fix deferred_io init/cleanup to fb ordering
      HID: picolcd: Add minimal palette required by fbcon on 8bpp
      HID: picolcd: do not reallocate memory on depth change
      HID: picolcd: implement refcounting of framebuffer

Chase Douglas (6):
      HID: magicmouse: scroll on entire surface, not just middle of mouse
      HID: magicmouse: disable and add module param for scroll acceleration
      HID: magicmouse: properly account for scroll movement in state
      HID: magicmouse: add param for scroll speed
      HID: magicmouse: enable horizontal scrolling
      HID: magicmouse: report last touch up

Daniel Mack (3):
      HID: hid-input.c: indentation fixes
      HID: add HID_QUIRK_HIDINPUT_FORCE
      HID: Force input registration for "VEC footpedal"

Forest Bond (1):
      HID: ignore digitizer usage Undefined (0x00)

Jiri Kosina (2):
      HID: fix up Kconfig entry for ACRUX driver
      Revert "HID: add support for the Wacom Intuos 4 wireless"

Julia Lawall (1):
      HID: roccat: introduce missing kfree

Kees Bakker (3):
      HID: hid-ids.h: keep vendor ids in alphabetical order
      HID: hid-ids.h: Whitespace fixup, align using TABs
      HID: Add support for Conceptronic CLLRCMCE

Michael Poole (1):
      HID: magicmouse: Correct parsing of large X and Y motions.

Richard Nauber (1):
      HID: add proper support for Elecom BM084 bluetooth mouse

Sergei Kolzun (1):
      HID: add ACRUX game controller force feedback support

Stefan Achatz (6):
      HID: remove unused variable from hidraw_read
      HID: roccat: remove obsolete comment
      HID: roccat: fix whitespace warning from checkpatch.pl
      HID: roccat: change kone_driver_version to kone_abi_version
      HID: roccat: fix offset errors in bin_attribute read
      HID: roccat: remove obsolete kone_abi_version sysfs attribute

 .../ABI/testing/sysfs-driver-hid-roccat-kone       |   13 --
 drivers/hid/Kconfig                                |   19 ++-
 drivers/hid/Makefile                               |    2 +
 drivers/hid/hid-axff.c                             |  172 +++++++++++++++++
 drivers/hid/hid-core.c                             |    8 +-
 drivers/hid/hid-elecom.c                           |   57 ++++++
 drivers/hid/hid-ids.h                              |   91 +++++----
 drivers/hid/hid-input.c                            |   21 ++-
 drivers/hid/hid-magicmouse.c                       |   96 +++++++---
 drivers/hid/hid-picolcd.c                          |  199 ++++++++++++++++----
 drivers/hid/hid-roccat-kone.c                      |   25 +---
 drivers/hid/hid-roccat-kone.h                      |    2 -
 drivers/hid/hid-roccat.c                           |    9 +-
 drivers/hid/hid-roccat.h                           |    2 +-
 drivers/hid/hid-topseed.c                          |    5 +
 drivers/hid/hid-wacom.c                            |    2 +-
 drivers/hid/hidraw.c                               |    2 -
 drivers/hid/usbhid/hid-quirks.c                    |    2 +
 drivers/hid/usbhid/hiddev.c                        |   54 ++----
 include/linux/hid.h                                |    1 +
 20 files changed, 586 insertions(+), 196 deletions(-)
 create mode 100644 drivers/hid/hid-axff.c
 create mode 100644 drivers/hid/hid-elecom.c

