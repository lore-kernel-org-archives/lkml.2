Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab0KYENU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:13:20 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:60638 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0KYENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:13:19 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: tom.leiming@gmail.com, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 1/3] perf: Correct final kernel map guesses
Date: Thu, 25 Nov 2010 15:12:53 +1100
Message-Id: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

If a 32bit userspace perf is running on a 64bit kernel, the end of the
final map in the kernel would incorrectly be set to 2^32-1 rather than
2^64-1.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/event.c  |    2 +-
 tools/perf/util/symbol.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bc47446..4283417 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -392,7 +392,7 @@ static void event_set_kernel_mmap_len(struct map **maps, event_t *self)
 	 * a zero sized synthesized MMAP event for the kernel.
 	 */
 	if (maps[MAP__FUNCTION]->end == 0)
-		maps[MAP__FUNCTION]->end = ~0UL;
+		maps[MAP__FUNCTION]->end = ~0ULL;
 }
 
 static int event__process_kernel_mmap(event_t *self,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0500895..a348906 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -121,7 +121,7 @@ static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
 	 * We still haven't the actual symbols, so guess the
 	 * last map final address.
 	 */
-	curr->end = ~0UL;
+	curr->end = ~0ULL;
 }
 
 static void map_groups__fixup_end(struct map_groups *self)
-- 
1.7.2.3

