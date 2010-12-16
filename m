Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0LPLiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 06:38:09 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:40476 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab0LPLiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:38:07 -0500
Message-ID: <4D09F9E2.6060900@euromail.se>
Date: Thu, 16 Dec 2010 12:37:06 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] input: mt updates for 2.6.38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTC8y-0000ur-7q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PTC8y-0000ur-7q 08d17220ad4edeeb52cf5b3381fcb9f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next

to re-receive input-mt updates for 2.6.38.

As a one-time measure, the tree has been rewound all the way to 2.6.37-rc1, to
keep our trees at a common checkpoint. Hereafter, the branch will be kept stable
and synchronized at a common checkpoint.

Content-wise, the filename change has been folded into the first commit. The
finger-count report and the trkid documentation have been folded into the commit
where they are introduced. Furthermore, MT_TOOL_ENVELOPE has been dropped
completely, and is going to be replaced by an input device quirk. The overall
documentation changes have been held back for another respin. Lastly, another
device patch has been added to hid-egalax.

Thanks,
Henrik

Dmitry Torokhov (1):
      Input: include MT library as source for kerneldoc

Henrik Rydberg (12):
      input: mt: Break out slots handling
      input: mt: Collect slots initialization code
      input: mt: Move tracking and pointer emulation to input-mt
      input: mt: Add hovering distance axis
      hid: egalax: Setup input device manually
      hid: egalax: Correct for device resolution report error
      hid: egalax: Report zero as minimum pressure
      hid: egalax: Add event filtering
      hid: egalax: Convert to MT slots
      hid: egalax: Add support for Wetab
      hid: egalax: Document the new devices in Kconfig
      MAINTAINERS: Update input-mt entry

Richard Nauber (1):
      hid: egalax: Add support for Samsung NB30 netbook

 Documentation/DocBook/device-drivers.tmpl    |    4 +
 Documentation/input/multi-touch-protocol.txt |    9 ++-
 MAINTAINERS                                  |    2 +
 drivers/hid/Kconfig                          |    3 +-
 drivers/hid/hid-3m-pct.c                     |   36 +-----
 drivers/hid/hid-core.c                       |    2 +
 drivers/hid/hid-egalax.c                     |  129 ++++++++-----------
 drivers/hid/hid-ids.h                        |    2 +
 drivers/input/Makefile                       |    2 +-
 drivers/input/input-mt.c                     |  170 ++++++++++++++++++++++++++
 drivers/input/input.c                        |   48 +-------
 drivers/input/misc/uinput.c                  |    4 +-
 drivers/input/tablet/wacom_wac.c             |   26 +---
 drivers/input/tablet/wacom_wac.h             |    4 -
 drivers/input/touchscreen/wacom_w8001.c      |   25 +---
 include/linux/input.h                        |   22 +---
 include/linux/input/mt.h                     |   57 +++++++++
 17 files changed, 329 insertions(+), 216 deletions(-)
 create mode 100644 drivers/input/input-mt.c
 create mode 100644 include/linux/input/mt.h
