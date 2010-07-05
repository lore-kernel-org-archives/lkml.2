Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab0GEOod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 10:44:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:60744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0GEOob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 10:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,540,1272870000"; 
   d="scan'208";a="296676688"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       hpa@zytor.com, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Cc: Feng Tang <feng.tang@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 3/5] Revert "Input: do not force selecting i8042 on Moorestown"
Date: Mon,  5 Jul 2010 23:03:20 +0800
Message-Id: <1278342202-10973-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

This reverts commit 685afae02557a178185a4be36f58332976e79f63.

After adding x86_platform's detection for i8042 controller, we
don't need the force dependency on !X86_MRST any more

Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/input/keyboard/Kconfig |    2 +-
 drivers/input/mouse/Kconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 0f9a478..917eec3 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -73,7 +73,7 @@ config KEYBOARD_ATKBD
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index eeb58c1..c714ca2 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -17,7 +17,7 @@ config MOUSE_PS2
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86 && !X86_MRST
+	select SERIO_I8042 if X86
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you have a PS/2 mouse connected to your system. This
-- 
1.7.0.4

