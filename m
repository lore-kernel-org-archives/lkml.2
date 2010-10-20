Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0JTSYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:24:20 -0400
Received: from mail.perches.com ([173.55.12.10]:3384 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab0JTSYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:24:19 -0400
Subject: [PATCH] arch/x86/kernel/tboot.c: Standardize pr_fmt
From: Joe Perches <joe@perches.com>
To: Joseph Cihula <joseph.cihula@intel.com>, Shane Wang <shane.wang@intel.com>
Cc: x86 <x86@kernel.org>, tboot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 11:24:17 -0700
Message-ID: <1287599057.1813.229.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the define before any #include and use the more
standard KBUILD_MODNAME.  No change in output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/tboot.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index c2f1b26..b9a0077 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/dma_remapping.h>
 #include <linux/init_task.h>
 #include <linux/spinlock.h>
@@ -51,9 +53,6 @@ EXPORT_SYMBOL(tboot);
 /* timeout for APs (in secs) to enter wait-for-SIPI state during shutdown */
 #define AP_WAIT_TIMEOUT		1
 
-#undef pr_fmt
-#define pr_fmt(fmt)	"tboot: " fmt
-
 static u8 tboot_uuid[16] __initdata = TBOOT_UUID;
 
 void __init tboot_probe(void)


