Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab2DKNH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab2DKNHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:07:55 -0400
Date: Wed, 11 Apr 2012 08:15:29 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] Make panic_on_oops configurable
Message-ID: <20120411121529.GH26688@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several distros set this by default by patching panic_on_oops. It seems
to fit with the BOOTPARAM_{HARD,SOFT}_PANIC options though, so let's add
a Kconfig entry and reduce some more upstream delta.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -27,7 +27,7 @@
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
 
-int panic_on_oops;
+int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
 static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6777153..91858cd 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -228,6 +228,26 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
+config PANIC_ON_OOPS
+	bool "Panic on Oops" if EXPERT
+	default n
+	help
+	  Say Y here to enable the kernel to panic when it oopses. This
+	  has the same effect as setting oops=panic on the kernel command
+	  line.
+
+	  This feature is useful to ensure that the kernel does not do
+	  anything erroneous after an oops which could result in data
+	  corruption or other issues.
+
+	  Say N if unsure.
+
+config PANIC_ON_OOPS_VALUE
+	int
+	range 0 1
+	default 0 if !PANIC_ON_OOPS
+	default 1 if PANIC_ON_OOPS
+
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
