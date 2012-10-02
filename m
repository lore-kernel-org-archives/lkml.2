Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2JBPCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:02:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:56482 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2JBPBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:01:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="199635154"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/7] string: introduce helper to get base file name from given path
Date: Tue,  2 Oct 2012 18:00:54 +0300
Message-Id: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places in kernel that use functionality like shell's basename
function. Let's do it common helper for them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 include/linux/string.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index b917881..b09a342 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -147,5 +147,16 @@ static inline bool strstarts(const char *str, const char *prefix)
 
 extern size_t memweight(const void *ptr, size_t bytes);
 
+/**
+ * kbasename - return the last part of a pathname.
+ *
+ * @path: path to extract the filename from.
+ */
+static inline const char *kbasename(const char *path)
+{
+	const char *tail = strrchr(path, '/');
+	return tail ? tail + 1 : path;
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_STRING_H_ */
-- 
1.7.10.4

