Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2AIH0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:26:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2AIH0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:26:31 -0500
Date: Sun, 8 Jan 2012 23:26:09 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-1b22859d4320d472a7a51ff4a43f62b0578469de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325957132-10600-5-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-5-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kmem: Fix a memory leak
Git-Commit-ID: 1b22859d4320d472a7a51ff4a43f62b0578469de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 23:26:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b22859d4320d472a7a51ff4a43f62b0578469de
Gitweb:     http://git.kernel.org/tip/1b22859d4320d472a7a51ff4a43f62b0578469de
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 8 Jan 2012 02:25:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 8 Jan 2012 13:27:54 -0200

perf kmem: Fix a memory leak

The 'str' should be freed when sort_dimension__add() failed too.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-5-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7a9b5c5..39104c0 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -647,6 +647,7 @@ static int setup_sorting(struct list_head *sort_list, const char *arg)
 			break;
 		if (sort_dimension__add(tok, sort_list) < 0) {
 			error("Unknown --sort key: '%s'", tok);
+			free(str);
 			return -1;
 		}
 	}
