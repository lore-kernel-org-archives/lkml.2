Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2LECYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:24:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58900 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2LECYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:24:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Dudley Du <dudl@cypress.com>, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>, Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH v4 0/4] Cypress PS/2 Trackpad driver
Date: Tue,  4 Dec 2012 18:24:01 -0800
Message-Id: <1354674245-25768-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver, submitted on behalf of Cypress Semiconductor Corporation and
additional contributors, provides support for the Cypress PS/2 Trackpad.

This [PATCH v4] version differs from my previous submitted version[2]:

  Patch #1 (cmdbuf to 8 bytes) and #3 (link in driver) are unchanged.

  Patch #2 (main driver) changes, as recommended by Henrik Rydberg,
  Dmitry Torokhov, and Dudley Du:

  - call input_mt_report_finger_count() directly; drop INPUT_MT_POINTER.
  - #ifdef out all the CYTP_RELATIVE_SUPPORT code.
  - convert CYTP_ macros to functions.
  - propagate error return codes.
  - fixed tp_res_y typo.
  - list Dudley Du <dudl@cypress.com> as the primary author of the driver.
  - additional misc cleanups.

  Patch #4 (selectable simulated multitouch instead of SEMI_MT):

  - this is now #ifdef-disabled by default but needed for (older?) userspace
    X/Unity-desktop which does not support the input_mt_report_finger_count
    events (e.g. BTN_TOOL_TRIPLETAP).


Remaining known problems (assistance or advice appreciated):

  - Patch #4 (simulated multitouch) does not work after rmmod/insmod, and
    stops working after suspend/resume.  Restarting X fixes it in both
    cases.  SEMI_MT appears to work normally in any case (per input-events).

  - cypress_reconnect() doesn't actually work after suspend/resume, but
    psmouse re-inits the driver after _reconnect fails.  Per Dudley Du,
    this routine does work when physically disconnecting the device though
    and its harmless regardless, so I am leaving it in pending further
    investigation.


 -Kamal Mostafa <kamal@canonical.com>

[0] PATCH v1: http://www.spinics.net/lists/linux-input/msg23690.html
[1] PATCH v2: http://www.spinics.net/lists/linux-input/msg23718.html
[2] PATCH v3: http://www.spinics.net/lists/linux-input/msg23943.html



Dudley Du (2):
  input: Cypress PS/2 Trackpad psmouse driver
  input: Cypress PS/2 Trackpad link into psmouse-base

Kamal Mostafa (2):
  input: increase struct ps2dev cmdbuf[] to 8 bytes
  input: Cypress PS/2 Trackpad simulated multitouch (disabled)

 drivers/input/mouse/Kconfig        |   10 +
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/cypress_ps2.c  |  853 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cypress_ps2.h  |  231 ++++++++++
 drivers/input/mouse/psmouse-base.c |   32 ++
 drivers/input/mouse/psmouse.h      |    1 +
 include/linux/libps2.h             |    2 +-
 7 files changed, 1129 insertions(+), 1 deletion(-)
 create mode 100644 drivers/input/mouse/cypress_ps2.c
 create mode 100644 drivers/input/mouse/cypress_ps2.h

-- 
1.7.10.4

