Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2LFAQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:16:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2LFAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:16:19 -0500
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
Subject: [PATCH v5 0/3] Cypress PS/2 Trackpad driver
Date: Wed,  5 Dec 2012 16:16:13 -0800
Message-Id: <1354752976-27257-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver, submitted on behalf of Cypress Semiconductor Corporation and
additional contributors, provides support for the Cypress PS/2 Trackpad.

This [PATCH v5] version differs from my previous submitted version[3]:

  Patch #1 (cmdbuf to 8 bytes) and #3 (link in driver) are unchanged.
  Patch #4 (simulated multitouch) has been dropped. 

  Patch #2 (main driver) changes:

  - fixed cypress_reconnect/suspend/resume (don't let pkt_size get clobbered)

  as recommended by Henrik Rydberg:

  - removed all the CYTP_RELATIVE_SUPPORT code.
  - removed debug-only vscroll/hscroll code.
  - renamed "vital_stat{ist}ics" to "tp_metrics".
  - fixed cypress_set_input_params x/y sanity check.
  - clarified cypress_parse_packet contact_cnt palm-detection check.
  - clarified cypress_ps2_ext_cmd comment.
  - dropped separate #define CTYP_MAX_CONTACTS.

Known problems:  None.

 -Kamal Mostafa <kamal@canonical.com>

[0] PATCH v1: http://www.spinics.net/lists/linux-input/msg23690.html
[1] PATCH v2: http://www.spinics.net/lists/linux-input/msg23718.html
[2] PATCH v3: http://www.spinics.net/lists/linux-input/msg23943.html
[3] PATCH v4: http://www.spinics.net/lists/linux-input/msg24047.html


Dudley Du (2):
  input: Cypress PS/2 Trackpad psmouse driver
  input: Cypress PS/2 Trackpad link into psmouse-base

Kamal Mostafa (1):
  input: increase struct ps2dev cmdbuf[] to 8 bytes

 drivers/input/mouse/Kconfig        |   10 +
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/cypress_ps2.c  |  740 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cypress_ps2.h  |  216 +++++++++++
 drivers/input/mouse/psmouse-base.c |   32 ++
 drivers/input/mouse/psmouse.h      |    1 +
 include/linux/libps2.h             |    2 +-
 7 files changed, 1001 insertions(+), 1 deletion(-)
 create mode 100644 drivers/input/mouse/cypress_ps2.c
 create mode 100644 drivers/input/mouse/cypress_ps2.h

-- 
1.7.10.4

