Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab1HWDFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:05:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:60222 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab1HWDF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:05:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="41170840"
Subject: [PATCH V2] printk:add console_suspend module parameter
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 23 Aug 2011 11:04:32 +0800
Message-ID: <1314068672.1749.6.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are enabling some power features on medfield. To test suspend-2-RAM
conveniently, we need turn on/off console_suspend_enabled frequently.

Below patch adds a module parameter, so users could change it by:
/sys/module/printk/parameters/console_suspend

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>

---

 Documentation/kernel-parameters.txt |    5 +++++
 kernel/printk.c                     |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 614d038..74446e0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1642,6 +1642,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			debugging driver suspend/resume hooks).  This may
 			not work reliably with all consoles, but is known
 			to work with serial and VGA consoles.
+			To facilitate more flexible debugging, we also add
+			console_suspend, a printk module parameter to control
+			it. Users could use console_suspend (usually
+			/sys/module/printk/parameters/console_suspend) to
+			turn on/off it dynamically.
 
 	noaliencache	[MM, NUMA, SLAB] Disables the allocation of alien
 			caches in the slab allocator.  Saves per-node memory,
diff --git a/kernel/printk.c b/kernel/printk.c
index 836a2ae..b9ef93a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1108,6 +1108,10 @@ static int __init console_suspend_disable(char *str)
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
+module_param_named(console_suspend, console_suspend_enabled,
+		bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(console_suspend, "suspend console during suspend"
+	" and hibernate operations");
 
 /**
  * suspend_console - suspend the console subsystem
-- 
1.7.1



