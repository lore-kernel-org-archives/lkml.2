Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1CWHbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:31:31 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:33713 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1CWHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:31:29 -0400
X-AuditID: b753bd60-9bb52ba000007e19-39-4d89a1499fad
X-AuditID: b753bd60-9bb52ba000007e19-39-4d89a1499fad
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip ] [BUGFIX] perf-top: Fix uninitialized variable
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 23 Mar 2011 16:29:39 +0900
Message-ID: <20110323072939.11638.50173.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

builtin-top.c has an uninitialized valiable.
gcc(version 4.5.1) warns it and results in build failure.

# make
CC builtin-top.o
cc1: warnings being treated as errors
builtin-top.c: In function 'display_thread':
builtin-top.c:518:9: error: 'counter' may be used uninitialized in this function
builtin-top.c:518:9: note: 'counter' was declared here
make: *** [builtin-top.o] Error 1

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/builtin-top.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 70f1075..0e382ff 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -515,7 +515,9 @@ static void handle_keypress(struct perf_session *session, int c)
 			break;
 		case 'E':
 			if (top.evlist->nr_entries > 1) {
-				int counter;
+				/* Select 0 as default event */
+				int counter = 0;
+
 				fprintf(stderr, "\nAvailable events:");
 
 				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)

