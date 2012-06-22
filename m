Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab2FVMLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:11:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37068 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714Ab2FVMLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:11:12 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: [PATCH v3 0/5] usb: musb: cleanup
Date: Fri, 22 Jun 2012 17:40:50 +0530
Message-ID: <1340367055-19835-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most part of this patch series was obtained by splitting
[RFC PATCH 2/3] usb: musb: omap glue: use omap-usb2 as the phy driver.

TO DO:
* dt adaptation of musb omap glue, twl4030, twl6030.
* Use control module driver API to write to control module registers
 (mailbox and power control of phy)
* send usb2 phy driver
* make musb omap glue use usb2 phy driver and make twl630
 as a comparator driver.

Changes from v2:
* Added a condition in twl4030 to avoid spurious disconnect event
message to the omap glue, on bootup if the cable is not connected.

Changes from v1:
Changed the commit log of *usb: musb: move work_struct(otg_notifier_work)
from core to omap glue* as per Sergei's suggestion.

Patch series depends on
[PATCH v7 0/3] usb: multi-phy support

Developed and Tested on.
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb

commit 2ed9127cff9a255b7671b8d3d938109f68a87961
Author: Mantesh Sarasetti <mantesh@ti.com>
Date:   Fri Jun 1 14:54:30 2012 +0300

    usb: musb: host: Disable MUSB DMA mode incase of DMA channel request failure

Performed device mode testing in omap4 panda and omap3 beagle.

Kishon Vijay Abraham I (5):
  usb: musb: move work_struct(otg_notifier_work) from core to omap glue
  usb: musb: twl: use mailbox API to send VBUS or ID events
  drivers: usb: musb: move otg specific initializations from twl to
    glue
  usb: musb: omap: use devres API to allocate resources
  drivers: usb: otg: twl: use devres API to allocate resources

 drivers/usb/musb/musb_core.h  |    2 -
 drivers/usb/musb/omap2430.c   |  122 +++++++++++++++++++++++++---------------
 drivers/usb/otg/twl4030-usb.c |   67 ++++++++--------------
 drivers/usb/otg/twl6030-usb.c |   69 ++++++++---------------
 include/linux/usb/musb-omap.h |   30 ++++++++++
 5 files changed, 155 insertions(+), 135 deletions(-)
 create mode 100644 include/linux/usb/musb-omap.h

-- 
1.7.5.4

