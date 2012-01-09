Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2AIHZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:25:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2AIHY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:24:59 -0500
Date: Sun, 8 Jan 2012 23:24:38 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-cdce445906852d90efdc773ca7ba460e6e41664d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325957132-10600-3-git-send-email-namhyung@gmail.com>
References: <1325957132-10600-3-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Add error message for EMFILE
Git-Commit-ID: cdce445906852d90efdc773ca7ba460e6e41664d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 23:24:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdce445906852d90efdc773ca7ba460e6e41664d
Gitweb:     http://git.kernel.org/tip/cdce445906852d90efdc773ca7ba460e6e41664d
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 8 Jan 2012 02:25:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 8 Jan 2012 13:26:11 -0200

perf top: Add error message for EMFILE

When a user tries to open so many events, perf_event_open syscall may
fail with EMFILE. Provide advise for that case.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325957132-10600-3-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d89dec9..8f80df8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -888,6 +888,10 @@ try_again:
 				ui__warning("The %s event is not supported.\n",
 					    event_name(counter));
 				goto out_err;
+			} else if (err == EMFILE) {
+				ui__warning("Too many events are opened.\n"
+					    "Try again after reducing the number of events\n");
+				goto out_err;
 			}
 
 			ui__warning("The sys_perf_event_open() syscall "
