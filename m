Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2K2V6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:58:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K2V6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:58:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Dudley Du <dudl@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH v3 0/4] Cypress PS/2 Trackpad driver
Date: Thu, 29 Nov 2012 13:57:57 -0800
Message-Id: <1354226281-3476-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver, submitted on behalf of Cypress Semiconductor Corporation and
additional contributors, provides support for the Cypress PS/2 Trackpad.

This [PATCH v3] version differs from my previous submitted version[1]:

  Patch #1 (cmdbuf to 8 bytes) and #3 (link in driver) are unchanged.

  Patch #2 (main driver), as recommended by Henrik Rydberg[2]:
  - use input_mt_assign_slots; drop cypress_cal_finger_id.
  - enable 2-finger-only SEMI_MT; drop cypress_simulate_fingers.
  - various code clean-ups.

  Henrik, does patch #2 appear to properly use assign_slots and SEMI_MT as
  you intended?  This SEMI_MT method does work (with 2 finger support only),
  but I'm not clear why we wouldn't want to handle >2 fingers also, so ...

  Patch #4 (new) reintroduces simulated multitouch for up to 5 fingers
  (#if CYPRESS_SIMULATE_MT), disabling SEMI_MT again.

  If that functionality (support for >2 fingers) can be acheived in some
  better way, please advise.


Remaining known problems (assistance or advice appreciated):

  - Multitouch >2 fingers does not work after rmmod/insmod, and stops
    working after suspend/resume.  Restarting X fixes it in both cases.

  - cypress_reconnect() never actually works, so I disabled it; just let
    psmouse re-init the driver instead, which works and is what was ending
    up happenning anyway.


 -Kamal Mostafa <kamal@canonical.com>

[0] PATCH v1: http://www.spinics.net/lists/linux-input/msg23690.html
[1] PATCH v2: http://www.spinics.net/lists/linux-input/msg23718.html
[2] Henrik's review: http://www.spinics.net/lists/linux-input/msg23747.html



Cypress Semiconductor Corporation (2):
  input: Cypress PS/2 Trackpad psmouse driver
  input: Cypress PS/2 Trackpad link into psmouse-base

Kamal Mostafa (2):
  input: increase struct ps2dev cmdbuf[] to 8 bytes
  input: Cypress PS/2 Trackpad simulated multitouch

 drivers/input/mouse/Kconfig        |   10 +
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/cypress_ps2.c  |  846 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cypress_ps2.h  |  231 ++++++++++
 drivers/input/mouse/psmouse-base.c |   32 ++
 drivers/input/mouse/psmouse.h      |    1 +
 include/linux/libps2.h             |    2 +-
 7 files changed, 1122 insertions(+), 1 deletion(-)
 create mode 100644 drivers/input/mouse/cypress_ps2.c
 create mode 100644 drivers/input/mouse/cypress_ps2.h

-- 
1.7.10.4

