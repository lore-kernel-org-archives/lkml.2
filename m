Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1DHJ5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:57:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48291 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1DHJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:57:51 -0400
From: pavan_savoy@ti.com
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: pavan_savoy@sify.com, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/3] shared transport robustness fixes
Date: Fri,  8 Apr 2011 04:57:41 -0500
Message-Id: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Texas Instruments' WiLink connectivity chipset's Bluetooth, FM and GPS
wireless technologies are interfaced over single UART, which is enabled
by the TI-ST line discipline driver.

The following patches are updates and few fixes found during robustness testing
of the driver.
1. The patch handles the delayed tty receive_buf function called by the TTY layer.
2. Removes the dependency on rfkill for build from Kconfig
3. Fix for the skipping the change remote baud rate command.


Pavan Savoy (2):
  drivers:misc:ti-st: handle delayed tty receive
  drivers:misc:ti-st: remove rfkill dependency

Victor Goldenshtein (1):
  drivers:misc:ti-st: fix skip remote baud logic

 drivers/misc/ti-st/Kconfig   |    1 -
 drivers/misc/ti-st/st_core.c |   23 +++++++++++++----------
 drivers/misc/ti-st/st_kim.c  |    6 ++++--
 include/linux/ti_wilink_st.h |    3 ++-
 4 files changed, 19 insertions(+), 14 deletions(-)

