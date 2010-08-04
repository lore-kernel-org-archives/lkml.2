Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab0HDBsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:48:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52679 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab0HDBsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:48:16 -0400
Message-ID: <4C58C7FF.5060906@cn.fujitsu.com>
Date: Wed, 04 Aug 2010 09:53:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend on
 LOCKUP_DETECTOR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DETECT_SOFTLOCKUP has been removed, so switch the
default value to LOCKUP_DETECTOR.

Also fix the help text of BOOT_PRINTK_DELAY.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 lib/Kconfig.debug |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 596106b..2fb7fa3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -203,7 +203,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
-	default DETECT_SOFTLOCKUP
+	default LOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to detect "hung tasks",
 	  which are bugs that cause the task to be stuck in
@@ -767,7 +767,7 @@ config BOOT_PRINTK_DELAY
 	  system, and then set "lpj=M" before setting "boot_delay=N".
 	  NOTE:  Using this option may adversely affect SMP systems.
 	  I.e., processors other than the first one may not boot up.
-	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
+	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
 config RCU_TORTURE_TEST
-- 
1.6.3

