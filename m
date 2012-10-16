Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2JPLs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:48:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:28304 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab2JPLsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:48:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="156713392"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jason Baron <jbaron@redhat.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCHv3 1/6] lib/string: introduce helper to get base file name from given path
Date: Tue, 16 Oct 2012 14:48:08 +0300
Message-Id: <1350388094-18805-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places in the kernel that use functionality like basename(3)
with an exception: in case of '/foo/bar/' we expect to get an empty string.
Let's do it common helper for them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/string.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 6301258..ac889c5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -143,4 +143,15 @@ static inline bool strstarts(const char *str, const char *prefix)
 
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
 #endif /* _LINUX_STRING_H_ */
-- 
1.7.10.4

