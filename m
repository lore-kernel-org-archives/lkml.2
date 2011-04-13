Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1DMIGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:06:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:29683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757209Ab1DMIFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="678407383"
Message-Id: <20110413080517.384129355@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 15:57:16 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, tj@kernel.org,
        eric.dumazet@gmail.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 1/4] percpu_counter: change return value and add comments
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-positive.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the percpu_counter_*_positive() API SMP and UP aren't consistent. Add comments
to explain it.
Also if count < 0, returns 0 instead of 1 for *read_positive().

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 include/linux/percpu_counter.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-13 13:10:13.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-13 13:21:21.000000000 +0800
@@ -75,7 +75,7 @@ static inline s64 percpu_counter_read_po
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
 		return ret;
-	return 1;
+	return 0;
 }
 
 static inline int percpu_counter_initialized(struct percpu_counter *fbc)
@@ -135,6 +135,10 @@ static inline s64 percpu_counter_read(st
 
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
+	/*
+	 * percpu_counter is intended to track positive number. In UP case, the
+	 * number should never be negative.
+	 */
 	return fbc->count;
 }
 

