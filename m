Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0JEW4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:56:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50390 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab0JEW4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:56:01 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/4] move TI_ST driver out of staging
Date: Tue,  5 Oct 2010 20:08:33 -0400
Message-Id: <1286323717-2925-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Texas Instrument's WiLink 7 chipset packs wireless technologies like
Bluetooth, FM, GPS and WLAN into a single die.
Among these the Bluetooth, FM Rx/Tx and GPS are interfaced to a apps processor
over a single UART.

This line discipline driver allows various protocol drivers such as Bluetooth
BlueZ driver, FM V4L2 driver and GPS simple character device driver
to communicate with its relevant core in the chip.

The following patches,
1. removes the driver from staging
2. adds the driver to drivers/misc/ directory since it really doesn't
belong anywhere else
3. adds in the Kconfig and Makefile for the driver
4. modifies the drivers/misc/Kconfig and drivers/misc/Makefile for the
driver to be available to be built along with rest of the kernel.

Pavan Savoy (4):
  drivers:staging:ti-st: remove TI_ST from staging
  drivers:misc: ti-st: sources for TI_ST driver
  drivers:misc: ti-st: Kconfig & Makefile for TI_ST
  drivers:misc: modify Kconfig & Makefile for TI_ST

 drivers/misc/Kconfig            |    1 +
 drivers/misc/Makefile           |    1 +
 drivers/misc/ti-st/Kconfig      |   17 +
 drivers/misc/ti-st/Makefile     |    6 +
 drivers/misc/ti-st/st_core.c    | 1031 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/ti-st/st_kim.c     |  798 ++++++++++++++++++++++++++++++
 drivers/misc/ti-st/st_ll.c      |  150 ++++++
 drivers/staging/ti-st/Kconfig   |   11 -
 drivers/staging/ti-st/Makefile  |    2 -
 drivers/staging/ti-st/st_core.c | 1030 --------------------------------------
 drivers/staging/ti-st/st_kim.c  |  797 ------------------------------
 drivers/staging/ti-st/st_ll.c   |  149 ------
 12 files changed, 2004 insertions(+), 1989 deletions(-)
 create mode 100644 drivers/misc/ti-st/Kconfig
 create mode 100644 drivers/misc/ti-st/Makefile
 create mode 100644 drivers/misc/ti-st/st_core.c
 create mode 100644 drivers/misc/ti-st/st_kim.c
 create mode 100644 drivers/misc/ti-st/st_ll.c
 delete mode 100644 drivers/staging/ti-st/st_core.c
 delete mode 100644 drivers/staging/ti-st/st_kim.c
 delete mode 100644 drivers/staging/ti-st/st_ll.c

