Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab2IFUvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:51:51 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:54826 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2IFUvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:51:49 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Arl1AD0MSVBV5qoUPGdsb2JhbABFhR6FI7AABIEIGQEBAQEeGQ0ngiABAQQBOhwjBQsIAw44FCUKGogdCrtcFIszhS9gA5VZgRWEWo0TgVYj
X-IronPort-AV: E=Sophos;i="4.80,382,1344204000"; 
   d="scan'208";a="110815066"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Sep 2012 22:57:45 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/20] HID: Only dump input if someone is listening
Message-ID: <20120906205745.GA419@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <1346528835-363-17-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1209020927130.20709@pobox.suse.cz>
 <20120902085211.GA604@polaris.bitmath.org>
 <alpine.LNX.2.00.1209031515450.20709@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1209031515450.20709@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Let's wait once Dmitry is finished with the input changes, and I can 
> either take the set through my tree with his Signed-off-by: on the Input 
> patches, or vice-versa.

Ok. Meanwhile, the current set is now in a temporary branch on github,
see below. Given there are no more change requests, I can add the
right SOBs and push it to my next tree for a while, before sending a
proper pull request to either of you.

Thanks,
Henrik

The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://github.com/rydberg/linux.git maybe

for you to fetch changes up to 631ea780695fdc0d1efa91b6714bd85369daab06:

  HID: hid-multitouch: Add Flatfrog support (2012-09-06 22:21:02 +0200)

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
      Input: bcm5974 - only setup button urb for TYPE1 devices
      Input: bcm5974 - Preparatory renames
      Input: bcm5974 - Drop pressure and width emulation
      Input: bcm5974 - Drop the logical dimensions
      Input: bcm5974 - Convert to MT-B
      HID: Add an input configured notification callback
      HID: hid-multitouch: Simplify setup and frame synchronization
      HID: hid-multitouch: Remove the redundant touch state
      HID: hid-multitouch: Fix contact count on 3M panels
      HID: Allow more fields in the hid report
      HID: hid-multitouch: Add Flatfrog support

 drivers/hid/hid-ids.h                    |   3 +
 drivers/hid/hid-input.c                  |  11 +-
 drivers/hid/hid-magicmouse.c             |   2 +-
 drivers/hid/hid-multitouch.c             | 192 +++++++++++++++-----------------
 drivers/input/evdev.c                    |  78 ++++++++-----
 drivers/input/input-mt.c                 | 294 +++++++++++++++++++++++++++++++++++++++++++++----
 drivers/input/input.c                    | 245 +++++++++++++++++++++++++++--------------
 drivers/input/misc/uinput.c              |   2 +-
 drivers/input/mouse/alps.c               |   2 +-
 drivers/input/mouse/bcm5974.c            | 317 ++++++++++++++++++++---------------------------------
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
 include/linux/input.h                    |  33 ++++--
 include/linux/input/mt.h                 |  55 +++++++++-
 25 files changed, 807 insertions(+), 464 deletions(-)
