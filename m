Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab1CXTEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:04:50 -0400
Received: from imr3.ericy.com ([198.24.6.13]:49162 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112Ab1CXTEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:04:47 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] mfd: Select MFD_CORE if TPS6105X driver is configured
Date: Thu, 24 Mar 2011 12:12:47 -0700
Message-ID: <1300993967-30987-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS61050/61052 driver uses MFD core code, yet does not specify the
dependency in Kconfig. If it is the only MFD driver configured, compilation
fails with

ERROR: "mfd_add_devices" [drivers/mfd/tps6105x.ko] undefined!
ERROR: "mfd_remove_devices" [drivers/mfd/tps6105x.ko] undefined!

Fix the problem by adding "select MFD_CORE" to the respective Kconfig entry.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index a9a1af4..e986f91 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -133,6 +133,7 @@ config TPS6105X
 	tristate "TPS61050/61052 Boost Converters"
 	depends on I2C
 	select REGULATOR
+	select MFD_CORE
 	select REGULATOR_FIXED_VOLTAGE
 	help
 	  This option enables a driver for the TP61050/TPS61052
-- 
1.7.3.1

