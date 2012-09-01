Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2IATmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:42:36 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:51467 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab2IATmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:42:06 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnFPAAlkQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngn0jGIECChoBiCO6NxSSHAObR40R
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="184931504"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3 v3 00/20] Input and HID updates for 3.7
Date: Sat,  1 Sep 2012 21:46:55 +0200
Message-Id: <1346528835-363-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, Jiri,

Here is the third version of the patchset for 3.7. I think we are
getting close. Changes in short:

Patch 2: Folded the size estimate removal into this patch, since the
other estimates are still needed for MT-A devices.

Patch 5: Reworked to handle SYN_MT events the 'old' way.
Patch 10: Reworked to allow for a proper device-to-slot mapping.
Patch 15: Remove the old size estimate when converting to MT-B.

Patch 18: New patch, carefully perform finalization per input device.
Patch 19: Shortened version of touch state removal.

Patch 20: New patch, fixing a long-standing bug for devices capable of
more than ten touches.

Several bugs removed, thanks to everyone involved in finding
those. The set has been more thoroughly tested, but still needs
further scrutiny from Benjamin.

Thanks,
Henrik

Henrik Rydberg (20):
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
  Input: bcm5974 - only setup button urb for TYPE1 devices
  Input: bcm5974 - Preparatory renames
  Input: bcm5974 - Drop pressure and width emulation
  Input: bcm5974 - Drop the logical dimensions
  Input: bcm5974 - Convert to MT-B
  HID: Only dump input if someone is listening
  HID: Add an input configured notification callback
  HID: hid-multitouch: Simplify setup and frame synchronization
  HID: hid-multitouch: Remove the redundant touch state
  HID: hid-multitouch: Add missing contact count detection

 drivers/hid/hid-core.c                   |   3 +-
 drivers/hid/hid-input.c                  |  11 +-
 drivers/hid/hid-magicmouse.c             |   2 +-
 drivers/hid/hid-multitouch.c             | 157 ++++++---------
 drivers/input/evdev.c                    |  78 +++++---
 drivers/input/input-mt.c                 | 294 +++++++++++++++++++++++++---
 drivers/input/input.c                    | 245 ++++++++++++++++--------
 drivers/input/misc/uinput.c              |   2 +-
 drivers/input/mouse/alps.c               |   2 +-
 drivers/input/mouse/bcm5974.c            | 317 ++++++++++++-------------------
 drivers/input/mouse/elantech.c           |   4 +-
 drivers/input/mouse/sentelic.c           |   2 +-
 drivers/input/mouse/synaptics.c          |   4 +-
 drivers/input/tablet/wacom_wac.c         |   6 +-
 drivers/input/touchscreen/atmel_mxt_ts.c |   2 +-
 drivers/input/touchscreen/cyttsp_core.c  |   2 +-
 drivers/input/touchscreen/edt-ft5x06.c   |   2 +-
 drivers/input/touchscreen/egalax_ts.c    |   2 +-
 drivers/input/touchscreen/ili210x.c      |   2 +-
 drivers/input/touchscreen/mms114.c       |   2 +-
 drivers/input/touchscreen/penmount.c     |   2 +-
 drivers/input/touchscreen/wacom_w8001.c  |   2 +-
 include/linux/hid.h                      |   3 +
 include/linux/input.h                    |  33 +++-
 include/linux/input/mt.h                 |  55 +++++-
 25 files changed, 778 insertions(+), 456 deletions(-)

-- 
1.7.12

