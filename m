Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0GBIRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:17:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:58364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640Ab0GBIQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:16:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,525,1272870000"; 
   d="scan'208";a="532503476"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       hpa@zytor.com, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 4/5] Revert "Input: fixup X86_MRST selects"
Date: Fri,  2 Jul 2010 16:35:15 +0800
Message-Id: <1278059716-7147-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278059716-7147-1-git-send-email-feng.tang@intel.com>
References: <1278059716-7147-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

This reverts commit 0b28bac5aef7bd1ab213723df031e61db9ff151a.

After adding x86_platform's detection for i8042 controller, we
don't need the force dependency on !X86_MRST any more

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/input/keyboard/Kconfig |    2 +-
 drivers/input/serio/Kconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 917eec3..3525f53 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -69,7 +69,7 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86 || X86_MRST
+	tristate "AT keyboard" if EMBEDDED || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 256b9e9..3bfe8fa 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,7 @@ config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !X86_MRST
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
-- 
1.7.0.4

