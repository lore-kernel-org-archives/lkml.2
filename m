Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0EQTma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:42:30 -0400
Received: from mga06.intel.com ([134.134.136.21]:25432 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753506Ab0EQTm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,249,1272870000"; 
   d="scan'208";a="518673183"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Cox <alan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] input: do not select i8042 for x86 mid
Date: Mon, 17 May 2010 12:35:16 -0700
Message-Id: <1274124916-23668-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@intel.com>

Moorestown does not have i8042 based keyboard controller, so give
an option to deselect i8042 for non-pc mid

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/input/keyboard/Kconfig |    2 +-
 drivers/input/mouse/Kconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 64c1023..42aa650 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -73,7 +73,7 @@ config KEYBOARD_ATKBD
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86
+	select SERIO_I8042 if X86 && !X86_MRST
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you want to use a standard AT or PS/2 keyboard. Usually
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index c714ca2..eeb58c1 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -17,7 +17,7 @@ config MOUSE_PS2
 	default y
 	select SERIO
 	select SERIO_LIBPS2
-	select SERIO_I8042 if X86
+	select SERIO_I8042 if X86 && !X86_MRST
 	select SERIO_GSCPS2 if GSC
 	help
 	  Say Y here if you have a PS/2 mouse connected to your system. This
-- 
1.6.3.3

