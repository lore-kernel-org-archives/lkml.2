Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2KTVaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:30:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2KTVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:30:04 -0500
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
Subject: [PATCH v2 0/3] Cypress PS/2 Trackpad driver
Date: Tue, 20 Nov 2012 13:30:07 -0800
Message-Id: <1353447010-4852-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver, submitted on behalf of Cypress Semiconductor Corporation and
additional contributors, provides support for the Cypress PS/2 Trackpad.

This [PATCH v2] version differs from my first submission[0]:

 - Increases the size the of the cmdbuf[] array in struct ps2dev from
   6 to 8 bytes, per Dmitry Torokhov's suggestion.  ** This change has
   not been tested with respect to any other touchpads.  Is it safe? **

 - Removes the special Cypress handling from psmouse-base.c

And it *almost* works properly... Cypress PS/2 Trackpad is recognized and
works fine on boot, but after a suspend-resume multitouch features no longer
work (one and two finger tap works, but three does not).  Restarting X does
fix it, until the next suspend.  The previous version of the driver[0] does
not exhibit that problem.

Help identifying and fixing the suspend-resume issue will be much
appreciated.

 -Kamal Mostafa <kamal@canonical.com>

[0] http://www.spinics.net/lists/linux-input/msg23690.html


Cypress Semiconductor Corporation (2):
  input: Cypress PS/2 Trackpad psmouse driver
  input: Cypress PS/2 Trackpad link into psmouse-base

Kamal Mostafa (1):
  input: increase struct ps2dev cmdbuf[] to 8 bytes

 drivers/input/mouse/Kconfig        |   10 +
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/cypress_ps2.c  |  956 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/cypress_ps2.h  |  220 +++++++++
 drivers/input/mouse/psmouse-base.c |   32 ++
 drivers/input/mouse/psmouse.h      |    1 +
 include/linux/libps2.h             |    2 +-
 7 files changed, 1221 insertions(+), 1 deletion(-)
 create mode 100644 drivers/input/mouse/cypress_ps2.c
 create mode 100644 drivers/input/mouse/cypress_ps2.h

-- 
1.7.10.4

