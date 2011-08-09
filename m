Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab1HIDKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 23:10:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:48053 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab1HIDJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 23:09:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,341,1309762800"; 
   d="scan'208";a="39461309"
Subject: [PATCH ] printk: add module parameter console_suspend_enabled to
 control console_suspend_enabled
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 09 Aug 2011 11:09:04 +0800
Message-ID: <1312859345.1743.9.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are enabling some power features on medfield. To test suspend-2-RAM
conveniently, we need turn on/off console_suspend_enabled frequently.

Below patch adds a module parameter, so users could change it by:
/sys/module/printk/parameters/console_suspend_enabled

Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>

---
 kernel/printk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 37dff34..ce00f1b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1106,6 +1106,8 @@ static int __init console_suspend_disable(char *str)
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
+module_param_named(console_suspend_enabled, console_suspend_enabled,
+		bool, S_IRUGO | S_IWUSR);
 
 /**
  * suspend_console - suspend the console subsystem
-- 
1.7.1




