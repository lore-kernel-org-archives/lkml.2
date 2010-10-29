Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab0J2PQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:16:59 -0400
Received: from bender.cm4all.net ([87.106.27.49]:60164 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964Ab0J2PQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:16:57 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 11:16:57 EDT
Subject: [PATCH] u64_stats_sync.h: move "inline" before the return type
To: linux-kernel@vger.kernel.org
From: Max Kellermann <mk@cm4all.com>
Date: Fri, 29 Oct 2010 17:08:33 +0200
Message-ID: <20101029150833.20666.70754.stgit@rabbit.intern.cm-ag>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the option -Wextra, gcc emits warnings like this one:

 include/linux/u64_stats_sync.h:70: warning: 'inline' is not at beginning of declaration

While this is legal according to the C standard, it would be more
readable to have all modifiers before the return type.
---
 include/linux/u64_stats_sync.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index fa261a0..8da8c4e 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -67,21 +67,21 @@ struct u64_stats_sync {
 #endif
 };
 
-static void inline u64_stats_update_begin(struct u64_stats_sync *syncp)
+static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	write_seqcount_begin(&syncp->seq);
 #endif
 }
 
-static void inline u64_stats_update_end(struct u64_stats_sync *syncp)
+static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	write_seqcount_end(&syncp->seq);
 #endif
 }
 
-static unsigned int inline u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
+static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	return read_seqcount_begin(&syncp->seq);
@@ -93,7 +93,7 @@ static unsigned int inline u64_stats_fetch_begin(const struct u64_stats_sync *sy
 #endif
 }
 
-static bool inline u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
+static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
@@ -112,7 +112,7 @@ static bool inline u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
  * - UP 32bit must disable BH.
  * - 64bit have no problem atomically reading u64 values, irq safe.
  */
-static unsigned int inline u64_stats_fetch_begin_bh(const struct u64_stats_sync *syncp)
+static inline unsigned int u64_stats_fetch_begin_bh(const struct u64_stats_sync *syncp)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	return read_seqcount_begin(&syncp->seq);
@@ -124,7 +124,7 @@ static unsigned int inline u64_stats_fetch_begin_bh(const struct u64_stats_sync
 #endif
 }
 
-static bool inline u64_stats_fetch_retry_bh(const struct u64_stats_sync *syncp,
+static inline bool u64_stats_fetch_retry_bh(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)

