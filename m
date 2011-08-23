Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1HWDI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:08:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:41250 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab1HWDIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:08:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,267,1312182000"; 
   d="scan'208";a="43018483"
Subject: [PATCH V2] printk: add ignore_loglevel as module parameter.
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 23 Aug 2011 11:07:59 +0800
Message-ID: <1314068879.1749.10.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are enabling some power features on medfield. To test suspend-2-RAM
conveniently, we need turn on/off ignore_loglevel frequently without rebooting.

Below patch adds a module parameter, so users could change it by:
/sys/module/printk/parameters/ignore_loglevel

Thanks Andrew and Young. I added document info and module param desc.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 kernel/printk.c                     |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 74446e0..8cf3431 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -954,6 +954,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ignore_loglevel	[KNL]
 			Ignore loglevel setting - this will print /all/
 			kernel messages to the console. Useful for debugging.
+			We also add it as printk module parameter, so users
+			could change it dynamically, usually by
+			/sys/module/printk/parameters/ignore_loglevel.
 
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
diff --git a/kernel/printk.c b/kernel/printk.c
index b9ef93a..a6936a9 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -532,6 +532,9 @@ static int __init ignore_loglevel_setup(char *str)
 }
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
+module_param_named(ignore_loglevel, ignore_loglevel, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
+	"print all kernel messages to the console.");
 
 /*
  * Write out chars from start to end - 1 inclusive
-- 
1.7.1



