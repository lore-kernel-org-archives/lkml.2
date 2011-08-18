Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1HRTId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:08:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47518 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1HRTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:08:30 -0400
Date: Thu, 18 Aug 2011 20:08:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 57/91] um: take chan_*.h and line.h to
 arch/um/drivers
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7x7-0007rw-PD@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 .../{include/shared/chan_kern.h => drivers/chan.h} |    6 +++---
 arch/um/drivers/chan_kern.c                        |    2 +-
 arch/um/{include/shared => drivers}/chan_user.h    |    0
 arch/um/drivers/line.c                             |    2 +-
 arch/um/{include/shared => drivers}/line.h         |    0
 arch/um/drivers/ssl.c                              |    3 +--
 arch/um/drivers/stdio_console.c                    |    3 +--
 arch/um/os-Linux/skas/process.c                    |    2 +-
 8 files changed, 8 insertions(+), 10 deletions(-)
 rename arch/um/{include/shared/chan_kern.h => drivers/chan.h} (95%)
 rename arch/um/{include/shared => drivers}/chan_user.h (100%)
 rename arch/um/{include/shared => drivers}/line.h (100%)

diff --git a/arch/um/include/shared/chan_kern.h b/arch/um/drivers/chan.h
similarity index 95%
rename from arch/um/include/shared/chan_kern.h
rename to arch/um/drivers/chan.h
index 1e65145..8df0fd9 100644
--- a/arch/um/include/shared/chan_kern.h
+++ b/arch/um/drivers/chan.h
@@ -6,9 +6,9 @@
 #ifndef __CHAN_KERN_H__
 #define __CHAN_KERN_H__
 
-#include "linux/tty.h"
-#include "linux/list.h"
-#include "linux/console.h"
+#include <linux/tty.h>
+#include <linux/list.h>
+#include <linux/console.h>
 #include "chan_user.h"
 #include "line.h"
 
diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index d4191fe..e040683 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -6,7 +6,7 @@
 #include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
-#include "chan_kern.h"
+#include "chan.h"
 #include "os.h"
 
 #ifdef CONFIG_NOCONFIG_CHAN
diff --git a/arch/um/include/shared/chan_user.h b/arch/um/drivers/chan_user.h
similarity index 100%
rename from arch/um/include/shared/chan_user.h
rename to arch/um/drivers/chan_user.h
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 364c8a1..c1cf220 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -7,7 +7,7 @@
 #include "linux/kd.h"
 #include "linux/sched.h"
 #include "linux/slab.h"
-#include "chan_kern.h"
+#include "chan.h"
 #include "irq_kern.h"
 #include "irq_user.h"
 #include "kern_util.h"
diff --git a/arch/um/include/shared/line.h b/arch/um/drivers/line.h
similarity index 100%
rename from arch/um/include/shared/line.h
rename to arch/um/drivers/line.h
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 678e205..9d8c20a 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -12,9 +12,8 @@
 #include "linux/console.h"
 #include "asm/termbits.h"
 #include "asm/irq.h"
-#include "line.h"
 #include "ssl.h"
-#include "chan_kern.h"
+#include "chan.h"
 #include "init.h"
 #include "irq_user.h"
 #include "mconsole_kern.h"
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index 49266f6..088776f 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -20,8 +20,7 @@
 #include "asm/current.h"
 #include "asm/irq.h"
 #include "stdio_console.h"
-#include "line.h"
-#include "chan_kern.h"
+#include "chan.h"
 #include "irq_user.h"
 #include "mconsole_kern.h"
 #include "init.h"
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 3fdac54..ce26053 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -13,7 +13,7 @@
 #include <sys/wait.h>
 #include <asm/unistd.h>
 #include "as-layout.h"
-#include "chan_user.h"
+#include "init.h"
 #include "kern_util.h"
 #include "mem.h"
 #include "os.h"
-- 
1.7.2.5


