Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568Ab2FEJiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:38:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44664 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761541Ab2FEJiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:38:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: [PATCH 0/5] usb: musb: cleanup
Date: Tue, 5 Jun 2012 15:08:33 +0530
Message-ID: <1338889118-10032-1-git-send-email-kishon@ti.com>
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
* make musb omap glue make use of usb2 phy driver and make twl630
 as a comparator driver.

Patch series depends on
[PATCH v4 0/3] usb: multi-phy support

Performed device mode testing in omap4 panda and omap3 beagle

Kishon Vijay Abraham I (5):
  usb: musb: move work_struct(otg_notifier_work) from core to omap glue
  usb: musb: twl: use mailbox API to send VBUS or ID events
  drivers: usb: musb: move otg specific initializations from twl to
    glue
  usb: musb: omap: use devres API to allocate resources
  drivers: usb: otg: twl: use devres API to allocate resources

 drivers/usb/musb/musb_core.h  |    2 -
 drivers/usb/musb/omap2430.c   |  118 +++++++++++++++++++++++++---------------
 drivers/usb/otg/twl4030-usb.c |   63 ++++++++--------------
 drivers/usb/otg/twl6030-usb.c |   69 ++++++++----------------
 include/linux/usb/musb-omap.h |   30 ++++++++++
 5 files changed, 150 insertions(+), 132 deletions(-)
 create mode 100644 include/linux/usb/musb-omap.h

-- 
1.7.5.4

