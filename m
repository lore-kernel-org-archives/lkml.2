Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab2ISS4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:56:11 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:51008 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab2ISS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:56:06 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnSpAN0UWlBV5h1yPGdsb2JhbABFhSGFI7B5AQF/GQEBAQEfGQ0ngmEcIxgRTCUKGogauyAUjFxsgyFgA5VjgRWEW40a
X-IronPort-AV: E=Sophos;i="4.80,450,1344204000"; 
   d="scan'208";a="195712342"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 19 Sep 2012 20:56:05 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Input and HID updates for 3.7
Message-ID: <20120919185605.GA778@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Please pull this tree to receive Input and HID updates for 3.7. The
tree contains input core changes, Acked by Dmitry, which substantially
reduces the irqsoff latency for all input devices. It also contains MT
changes which allows further memory reduction, speedup and hardware
support in the HID Multitouch driver. Lastly, you get the conversion
of the bcm5974 driver to MT-B, which due to the mixed dependency of
the tree fits better here than anywhere else.

Thanks,
Henrik

The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://github.com/rydberg/linux.git for-next

for you to fetch changes up to 51c80b74002f86477d691ed7c8ac479dcfa6271c:

  Input: bcm5974 - Convert to MT-B (2012-09-19 19:50:22 +0200)

----------------------------------------------------------------
Henrik Rydberg (21):
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
      Input: MT - Allow legacy pressure computation
      HID: Add an input configured notification callback
      HID: Allow more fields in the hid report
      HID: hid-multitouch: Simplify setup and frame synchronization
      HID: hid-multitouch: Remove the redundant touch state
      HID: hid-multitouch: Fix contact count on 3M panels
      HID: hid-multitouch: Add Flatfrog support
      Input: bcm5974 - only setup button urb for TYPE1 devices
      Input: bcm5974 - Preparatory renames
      Input: bcm5974 - Drop the logical dimensions
      Input: bcm5974 - Convert to MT-B

 drivers/hid/hid-ids.h                    |   3 +
 drivers/hid/hid-input.c                  |  11 +-
 drivers/hid/hid-magicmouse.c             |   2 +-
 drivers/hid/hid-multitouch.c             | 185 ++++++++--------
 drivers/input/evdev.c                    |  78 ++++---
 drivers/input/input-mt.c                 | 305 ++++++++++++++++++++++++---
 drivers/input/input.c                    | 254 ++++++++++++++--------
 drivers/input/misc/uinput.c              |   2 +-
 drivers/input/mouse/alps.c               |   2 +-
 drivers/input/mouse/bcm5974.c            | 348 ++++++++++++++-----------------
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
 include/linux/hid.h                      |   5 +-
 include/linux/input.h                    |  35 ++--
 include/linux/input/mt.h                 |  57 ++++-
 25 files changed, 850 insertions(+), 469 deletions(-)
