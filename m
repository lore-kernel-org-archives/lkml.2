Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1GXRdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:33:36 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:30243 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab1GXRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:33:29 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Subject: [PATCH] x86, olpc: Fix dependency on POWER_SUPPLY
Message-Id: <20110724173321.747BC9D401C@zog.reactivated.net>
Date: Sun, 24 Jul 2011 18:33:21 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=oewl8nJhCRAA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=HvDL60SoF23dlzwWE2MA:9 a=vHti6KwBZ3s7r8pesGYA:7 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Randy Dunlap, CONFIG_POWER_SUPPLY=m caused a compile error:

arch/x86/built-in.o: In function `battery_status_changed':
olpc-xo15-sci.c:(.text+0x3acdd): undefined reference to `power_supply_get_by_name'
olpc-xo15-sci.c:(.text+0x3ad04): undefined reference to `power_supply_changed'

The SCI drivers, as bool, require POWER_SUPPLY to be builtin. Use
select to make that a hard requirement and avoid this build failure.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8af5ba8..b198c01 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2089,7 +2089,8 @@ config OLPC_XO1_RTC
 
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
-	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
+	depends on OLPC && OLPC_XO1_PM
+	select POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
 	---help---
@@ -2103,7 +2104,8 @@ config OLPC_XO1_SCI
 
 config OLPC_XO15_SCI
 	bool "OLPC XO-1.5 SCI extras"
-	depends on OLPC && ACPI && POWER_SUPPLY
+	depends on OLPC && ACPI
+	select POWER_SUPPLY
 	---help---
 	  Add support for SCI-based features of the OLPC XO-1.5 laptop:
 	   - EC-driven system wakeups
-- 
1.7.6

