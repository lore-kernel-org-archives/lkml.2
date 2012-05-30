Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2E3Ofp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:35:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47415 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2E3Oet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:34:49 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: [RFC PATCH 0/3] usb: musb: add new phy driver
Date: Wed, 30 May 2012 20:04:23 +0530
Message-ID: <1338388466-3565-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a new usb2 phy driver. The device for which is created
by the ocp2scp driver. This also uses control module driver.

This series converts twl6030 as a comparator driver (previously it was
also the phy driver) and makes use of omap-usb2 as the phy driver.

Instead of notification mechanism by power chip to omap glue to pass detection
of any events, an export API has been added in omap glue. Both twl4030 and
twl6030 will call to this API to pass any event. (twl6030 is used in omap4 and
twl4030 is used in omap3).

This series depends on:
*[RFC PATCH 00/11] OMAP System Control Module* patch series
However System Control Module driver has only dt support, so wouldn't
be able to test this patch series. However I'll adapt omap usb2 phy
driver and musb driver for dt and send it asap to the list.

This series also depends on:
*[PATCH v3 0/3] usb: multi-phy support* patch series
*[RFC PATCH 0/5] omap: add ocp2scp as a misc driver* patch series

Compile tested only.

Kishon Vijay Abraham I (3):
  drivers: usb: otg: add a new driver for omap usb2 phy
  usb: musb: omap glue: use omap-usb2 as the phy driver
  arm: omap: phy: remove unused functions from omap-phy-internal.c

 arch/arm/mach-omap2/omap_phy_internal.c |  138 ------------------
 arch/arm/mach-omap2/twl-common.c        |    5 -
 arch/arm/mach-omap2/usb-musb.c          |    3 -
 drivers/usb/musb/musb_core.h            |    1 -
 drivers/usb/musb/omap2430.c             |  150 ++++++++++++++------
 drivers/usb/otg/Kconfig                 |   17 ++-
 drivers/usb/otg/Makefile                |    1 +
 drivers/usb/otg/omap-usb2.c             |  232 +++++++++++++++++++++++++++++++
 drivers/usb/otg/twl4030-usb.c           |   40 ++----
 drivers/usb/otg/twl6030-usb.c           |  172 +++++------------------
 include/linux/usb/musb-omap.h           |   31 ++++
 include/linux/usb/omap_usb.h            |   47 ++++++
 include/linux/usb/phy_companion.h       |   34 +++++
 13 files changed, 514 insertions(+), 357 deletions(-)
 create mode 100644 drivers/usb/otg/omap-usb2.c
 create mode 100644 include/linux/usb/musb-omap.h
 create mode 100644 include/linux/usb/omap_usb.h
 create mode 100644 include/linux/usb/phy_companion.h

-- 
1.7.5.4

