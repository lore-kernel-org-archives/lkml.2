Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0LBIF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:05:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:47984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0LBIFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:05:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208";a="632307494"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v3 1/4] printk, Add pr_pfx for library functions
Date: Thu,  2 Dec 2010 16:05:02 +0800
Message-Id: <1291277105-31758-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291277105-31758-1-git-send-email-ying.huang@intel.com>
References: <1291277105-31758-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For library functions doing printk, the log level and line prefix
usually need to be specified by the caller. So this patch adds
"pr_pfx" to make the life of these library functions easier.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/printk.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -202,6 +202,13 @@ extern void print_hex_dump_bytes(const c
 #endif
 
 /*
+ * Used by library functions, where log level and line prefix need to
+ * be specifieded by the caller.
+ */
+#define pr_pfx(pfx, fmt, ...) \
+	printk("%s" fmt, pfx, ##__VA_ARGS__)
+
+/*
  * ratelimited messages with local ratelimit_state,
  * no local ratelimit_state used in the !PRINTK case
  */
