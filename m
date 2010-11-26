Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0KZVrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:47:33 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57350 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0KZVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:47:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf symbols: Correct final kernel map guesses
Date: Fri, 26 Nov 2010 19:47:20 -0200
Message-Id: <1290808041-16535-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290808041-16535-1-git-send-email-acme@infradead.org>
References: <1290808041-16535-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

If a 32bit userspace perf is running on a 64bit kernel, the end of the final
map in the kernel would incorrectly be set to 2^32-1 rather than 2^64-1.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    2 +-
 tools/perf/util/symbol.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index dab9e75..7260db7 100644
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
1.6.2.5

