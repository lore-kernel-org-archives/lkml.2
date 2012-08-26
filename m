Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2HZMwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:52:36 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:40695 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2HZMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:52:35 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AohZADUbOlBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngn0jGIECChoBiCO7SRSSBQObQI0P
X-IronPort-AV: E=Sophos;i="4.77,830,1336341600"; 
   d="scan'208";a="397048475"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v2 00/20] Input and HID updates for 3.7
Date: Sun, 26 Aug 2012 14:57:18 +0200
Message-Id: <1345985858-445-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, Jiri,

Here is the second version of the patchset for 3.7. Changes in short:

Patch  1: New patch fixing an upcoming problem with ehci scheduling
Patch  3: Improved commit message, explaining the chosen packet size.
Patch  7: Make sure packets always end with a SYN event.
Patch 10: Bugfix and improved commit message.
Patch 19: New patch showing report descriptors for unclaimed devices.
Patch 20: Less is more in the hid-multitouch driver.

That is pretty much it. Please take/comment on the patches you care
about, and I can carry the rest in my tree.

Thanks,
Henrik

Henrik Rydberg (20):
  Input: bcm5974 - only setup button urb for TYPE1 devices
  Input: Break out MT data
  Input: Improve the events-per-packet estimate
  Input: Remove redundant packet estimates
  Input: Make sure we follow all EV_KEY events
  Input: Move autorepeat to the event-passing phase
  Input: Send events one packet at a time
  Input: evdev - Add the events() callback
  Input: MT - Add flags to input_mt_init_slots()
  Input: MT - Handle frame synchronization in core
  Input: MT - Add in-kernel tracking
  Input: MT - Add slot assignment by id
  Input: bcm5974 - Preparatory renames
  Input: bcm5974 - Drop pressure and width emulation
  Input: bcm5974 - Drop the logical dimensions
  Input: bcm5974 - Convert to MT-B
  HID: Only dump input if someone is listening
  HID: Add an input configured notification callback
  HID: hid-debug: Show rdesc for unclaimed devices
  HID: multitouch: Remove the redundant touch state

 drivers/hid/hid-core.c                   |   3 +-
 drivers/hid/hid-debug.c                  |  12 +-
 drivers/hid/hid-input.c                  |  15 +-
 drivers/hid/hid-magicmouse.c             |   4 +-
 drivers/hid/hid-multitouch.c             | 133 +++++--------
 drivers/input/evdev.c                    |  78 +++++---
 drivers/input/input-mt.c                 | 293 +++++++++++++++++++++++++---
 drivers/input/input.c                    | 257 +++++++++++++++----------
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
 include/linux/input.h                    |  35 ++--
 include/linux/input/mt.h                 |  53 +++++-
 26 files changed, 756 insertions(+), 483 deletions(-)

-- 
1.7.12

