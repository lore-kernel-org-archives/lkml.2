Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1CWJni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:43:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1CWJnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:43:35 -0400
Date: Wed, 23 Mar 2011 09:43:16 GMT
From: tip-bot for Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, akihiro.nagai.hw@hitachi.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        akihiro.nagai.hw@hitachi.com, acme@infradead.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110323072939.11638.50173.stgit@localhost6.localdomain6>
References: <20110323072939.11638.50173.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Fix uninitialized 'counter' variable
Message-ID: <tip-ce2d17ca7f85dcade62cd608601a0d52ccdaf0e6@git.kernel.org>
Git-Commit-ID: ce2d17ca7f85dcade62cd608601a0d52ccdaf0e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Mar 2011 09:43:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce2d17ca7f85dcade62cd608601a0d52ccdaf0e6
Gitweb:     http://git.kernel.org/tip/ce2d17ca7f85dcade62cd608601a0d52ccdaf0e6
Author:     Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
AuthorDate: Wed, 23 Mar 2011 16:29:39 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Mar 2011 10:38:32 +0100

perf top: Fix uninitialized 'counter' variable

builtin-top.c has an uninitialized variable.
gcc(version 4.5.1) warns about it and it results in build failure:

 builtin-top.c: In function 'display_thread':
 builtin-top.c:518:9: error: 'counter' may be used uninitialized

This situation can indeed trigger, if the getline() call in
prompt_integer() fails.

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110323072939.11638.50173.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-top.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 70f1075..676b4fb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -515,7 +515,9 @@ static void handle_keypress(struct perf_session *session, int c)
 			break;
 		case 'E':
 			if (top.evlist->nr_entries > 1) {
-				int counter;
+				/* Select 0 as the default event: */
+				int counter = 0;
+
 				fprintf(stderr, "\nAvailable events:");
 
 				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
