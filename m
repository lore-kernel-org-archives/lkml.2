Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0K1UrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:47:03 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25385 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0K1UrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:47:00 -0500
Date: Sun, 28 Nov 2010 21:39:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: =?ISO-8859-7?Q?=5BPATCH=5D=5Btrivial=5D_Kill_off_a_bunch_of_annoying__warning=3A_=A1inline=A2_is_not_at_beginning_of_declaration?=
Message-ID: <alpine.LNX.2.00.1011282128210.29621@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1764006212-1290976775=:29621"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1764006212-1290976775=:29621
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Hi,

These warnings are spewed during a build of a 'allnoconfig' kernel 
(especially the ones from u64_stats_sync.h show up a lot) when building 
with -Wextra (which I often do)..
They are
  a) annoying
  b) easy to get rid of.
This patch kills them off.

include/linux/u64_stats_sync.h:70:1: warning: ¡inline¢ is not at beginning of declaration
include/linux/u64_stats_sync.h:77:1: warning: ¡inline¢ is not at beginning of declaration
include/linux/u64_stats_sync.h:84:1: warning: ¡inline¢ is not at beginning of declaration
include/linux/u64_stats_sync.h:96:1: warning: ¡inline¢ is not at beginning of declaration
include/linux/u64_stats_sync.h:115:1: warning: ¡inline¢ is not at beginning of declaration
include/linux/u64_stats_sync.h:127:1: warning: ¡inline¢ is not at beginning of declaration
kernel/time.c:241:1: warning: ¡inline¢ is not at beginning of declaration
kernel/time.c:257:1: warning: ¡inline¢ is not at beginning of declaration
kernel/perf_event.c:4513:1: warning: ¡inline¢ is not at beginning of declaration
mm/page_alloc.c:4012:1: warning: ¡inline¢ is not at beginning of declaration


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 include/linux/u64_stats_sync.h |   12 ++++++------
 kernel/perf_event.c            |    2 +-
 kernel/time.c                  |    4 ++--
 mm/page_alloc.c                |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 671f6c8..8126942 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4510,7 +4510,7 @@ int perf_swevent_get_recursion_context(void)
 }
 EXPORT_SYMBOL_GPL(perf_swevent_get_recursion_context);
 
-void inline perf_swevent_put_recursion_context(int rctx)
+inline void perf_swevent_put_recursion_context(int rctx)
 {
 	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
 
diff --git a/kernel/time.c b/kernel/time.c
index ba9b338..3217435 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -238,7 +238,7 @@ EXPORT_SYMBOL(current_fs_time);
  * Avoid unnecessary multiplications/divisions in the
  * two most common HZ cases:
  */
-unsigned int inline jiffies_to_msecs(const unsigned long j)
+inline unsigned int jiffies_to_msecs(const unsigned long j)
 {
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
 	return (MSEC_PER_SEC / HZ) * j;
@@ -254,7 +254,7 @@ unsigned int inline jiffies_to_msecs(const unsigned long j)
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
 
-unsigned int inline jiffies_to_usecs(const unsigned long j)
+inline unsigned int jiffies_to_usecs(const unsigned long j)
 {
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e409270..6bb6660 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4009,7 +4009,7 @@ static void __init setup_usemap(struct pglist_data *pgdat,
 		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
 }
 #else
-static void inline setup_usemap(struct pglist_data *pgdat,
+static inline void setup_usemap(struct pglist_data *pgdat,
 				struct zone *zone, unsigned long zonesize) {}
 #endif /* CONFIG_SPARSEMEM */
 



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1764006212-1290976775=:29621--
