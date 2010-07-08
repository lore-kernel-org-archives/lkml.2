Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0GHNzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:55:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36011 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab0GHNzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:55:38 -0400
From: pavan_savoy@ti.com
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/2] drivers:staging:ti-st: Providing contexts
Date: Thu,  8 Jul 2010 08:55:15 -0500
Message-Id: <1278597317-31389-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Alan / Greg,

A small step (hopefully in right direction) to move this driver out of staging, into a right place in mainline.

The patch set has,

* Update TODO to add the requirement to remove global references.
* The 2nd patch addresses the issue by removing the global references.
To achieve this, the platform device being added from the board-XX.c inside arch/XX/ needs to expose a function'st_get_plat_device' which returns a pointer to the platform_device struct.

Now there are 3 contexts in the driver:
1. platform device/driver context - probe/remove, sysfs show/store, and rfkill ops
2. TTY context - tty_open/close/_receive since it is ldisc driver
3. Process context - st_register/_unregister/_write called from the protocol drivers registering to ST upon calling open/close on /dev/radio0, /dev/tigps sort of char devices or hci0 sort of interfaces

In platform device/driver context's dev_set_drvdata/get_drvdata is used. TTY's disc_data in TTY context and for the 3rd context and to combine 1 and 2 - the platform device exposed in board-XX.c will be used.

Pavan Savoy (2):
  drivers:staging:ti-st: Update TODO
  drivers:staging:ti-st: remove global references

 drivers/staging/ti-st/TODO      |    4 ++-
 drivers/staging/ti-st/st.h      |    5 ++-
 drivers/staging/ti-st/st_core.c |    8 ++--
 drivers/staging/ti-st/st_core.h |    2 +
 drivers/staging/ti-st/st_kim.c  |   77 +++++++++++++++++++++++++++------------
 drivers/staging/ti-st/st_kim.h  |    6 ++--
 6 files changed, 68 insertions(+), 34 deletions(-)

