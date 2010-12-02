Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0LBCCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:02:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:19649 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0LBCCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:02:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="863371753"
Subject: [patch 1/3]make readmostly section correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
        sam@ravnborg.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 10:02:21 +0800
Message-ID: <1291255341.12777.115.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readmostly section should end at cache line aligned address, otherwise the last
several data might share cachline with other data and make the readmostly data
still have cache bounce.
For example, in ia64, secpath_cachep is the last readmostly data, and it shares
cacheline with init_uts_ns.
a000000100e80480 d secpath_cachep
a000000100e80488 D init_uts_ns

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 include/asm-generic/vmlinux.lds.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.orig/include/asm-generic/vmlinux.lds.h	2010-12-01 16:49:48.000000000 +0800
+++ linux/include/asm-generic/vmlinux.lds.h	2010-12-02 09:22:32.000000000 +0800
@@ -192,7 +192,8 @@
 
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
-	*(.data..read_mostly)
+	*(.data..read_mostly)						\
+	. = ALIGN(align);
 
 #define CACHELINE_ALIGNED_DATA(align)					\
 	. = ALIGN(align);						\


