Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab1DNCHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:07:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:59952 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab1DNCHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:07:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,208,1301900400"; 
   d="scan'208";a="909291250"
Message-Id: <20110414020747.006551352@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 14 Apr 2011 10:04:48 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, cl@linux.com,
        eric.dumazet@gmail.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v3 1/3] percpu_counter: change return value and add comments
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-positive.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the percpu_counter_*_positive() API in UP case doesn't check if return value is
positive. Add comments to explain why we don't.
Also if count < 0, returns 0 instead of 1 for *read_positive().

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 include/linux/percpu_counter.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-13 16:09:22.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-14 08:50:45.000000000 +0800
@@ -75,7 +75,7 @@ static inline s64 percpu_counter_read_po
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
 		return ret;
-	return 1;
+	return 0;
 }
 
 static inline int percpu_counter_initialized(struct percpu_counter *fbc)
@@ -133,6 +133,10 @@ static inline s64 percpu_counter_read(st
 	return fbc->count;
 }
 
+/*
+ * percpu_counter is intended to track positive number. In UP case, the number
+ * should never be negative.
+ */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
 	return fbc->count;

