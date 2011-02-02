Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1BBLA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:00:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55076 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1BBLAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:00:55 -0500
From: pavan_savoy@ti.com
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/7] TI ST patches for new requirements
Date: Wed,  2 Feb 2011 05:00:41 -0600
Message-Id: <1296644448-29667-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg,

The following 7 patches are some major updates that has been going on
in the Texas Instrument's shared transport driver.
These contain few new requirements and some cleanup patches.

The major 2 changes are the first 2 patches.

1. The change from protocol based registration to packet/channel based
registration has been conceptually ACKed by Gustavo (Bluetooth Maintainer).
With this TI-ST now no longer refers to bluetooth headers which was a concern
previously.

2. The 2nd major change is from rfkill based communication to normal sysfs
entry based communication.
This has been conceptually ACKed by Samuel Ortiz (MFD Maintainer).
Previously when the line discipline driver wanted the UART to be opened
and ldisc to be installed, it ab-used the rfkill device node to notify the
user-space daemon, Now it notifies using simpler sysfs entries & making use
of sysfs_notify.
This also allows the UART specifics to be shared with user-space.

Other patches include fixing left over error codes, correcting few dbug logs,
fixes for bugs found during stress testing, firmware change & cleanup.

Pavan Savoy (7):
  drivers:misc: ti-st: register with channel IDs
  drivers:misc: ti-st: move from rfkill to sysfs
  drivers:misc: ti-st: fix error codes
  drivers:misc: ti-st: set right debug levels for logs
  drivers:misc: ti-st: firmware download optimization
  drivers:misc: ti-st: fix hci-ll on wake_ind collision
  drivers:misc: ti-st: remove multiple gpio handling

 drivers/misc/ti-st/st_core.c |  413 +++++++++++++----------------------
 drivers/misc/ti-st/st_kim.c  |  491 +++++++++++++++++++++---------------------
 drivers/misc/ti-st/st_ll.c   |   10 +-
 include/linux/ti_wilink_st.h |   76 +++++---
 4 files changed, 446 insertions(+), 544 deletions(-)

