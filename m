Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab0K1IfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 03:35:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:57108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0K1IfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 03:35:05 -0500
Date: Sun, 28 Nov 2010 08:34:37 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        imunsie@au1.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, imunsie@au1.ibm.com, mingo@elte.hu
In-Reply-To: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Correct final kernel map guesses
Message-ID: <tip-9d1faba5fe410558099f13cfada2eab03186769d@git.kernel.org>
Git-Commit-ID: 9d1faba5fe410558099f13cfada2eab03186769d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Nov 2010 08:34:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d1faba5fe410558099f13cfada2eab03186769d
Gitweb:     http://git.kernel.org/tip/9d1faba5fe410558099f13cfada2eab03186769d
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Thu, 25 Nov 2010 15:12:53 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 27 Nov 2010 01:32:53 -0200

perf symbols: Correct final kernel map guesses

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
