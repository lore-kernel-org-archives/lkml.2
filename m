Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423363Ab2KNTNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:13:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46350 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423196Ab2KNTNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:13:02 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sjenning@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de
Cc: fschmaus@gmail.com, andor.daam@googlemail.com, ilendir@googlemail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/11] zcache: Allow to compile if ZCACHE_DEBUG and !DEBUG_FS
Date: Wed, 14 Nov 2012 14:12:17 -0500
Message-Id: <1352920339-10183-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
References: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is defined.

Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/ramster/debug.h |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ramster/debug.h b/drivers/staging/ramster/debug.h
index 35af06d..b412b90 100644
--- a/drivers/staging/ramster/debug.h
+++ b/drivers/staging/ramster/debug.h
@@ -174,7 +174,6 @@ static inline void inc_zcache_evicted_eph_pageframes(void) { zcache_evicted_eph_
 static inline void inc_zcache_eph_nonactive_puts_ignored(void) { zcache_eph_nonactive_puts_ignored ++; };
 static inline void inc_zcache_pers_nonactive_puts_ignored(void) { zcache_pers_nonactive_puts_ignored ++; };
 
-int zcache_debugfs_init(void);
 #else
 static inline void inc_zcache_obj_count(void) { };
 static inline void dec_zcache_obj_count(void) { };
@@ -198,10 +197,6 @@ static inline unsigned long curr_pageframes_count(void)
 {
 	return 0;
 };
-static inline int zcache_debugfs_init(void)
-{
-	return 0;
-};
 static inline void inc_zcache_flush_total(void) { };
 static inline void inc_zcache_flush_found(void) { };
 static inline void inc_zcache_flobj_total(void) { };
@@ -223,3 +218,12 @@ static inline void inc_zcache_evicted_eph_pageframes(void) { };
 static inline void inc_zcache_eph_nonactive_puts_ignored(void) { };
 static inline void inc_zcache_pers_nonactive_puts_ignored(void) { };
 #endif
+
+#ifdef CONFIG_DEBUG_FS
+int zcache_debugfs_init(void);
+#else
+static inline int zcache_debugfs_init(void)
+{
+	return 0;
+};
+#endif
-- 
1.7.7.6

