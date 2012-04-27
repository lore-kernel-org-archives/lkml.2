Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab2D0IkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:40:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab2D0IkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:40:20 -0400
Date: Fri, 27 Apr 2012 01:39:56 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-tnpfijuomrntbnl5vr6ibdwa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Add visual cue for retq instruction
Git-Commit-ID: 4ea08b522071c6c34098b7a880aac3551abecd75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:40:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ea08b522071c6c34098b7a880aac3551abecd75
Gitweb:     http://git.kernel.org/tip/4ea08b522071c6c34098b7a880aac3551abecd75
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Apr 2012 15:51:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Apr 2012 15:51:40 -0300

perf annotate browser: Add visual cue for retq instruction

Just use a left arrow prefixing retqs.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tnpfijuomrntbnl5vr6ibdwa@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 63206ca..d0c606e 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -127,11 +127,20 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 			dl->ins->ops->scnprintf(dl->ins, bf, sizeof(bf), &dl->ops,
 						!ab->use_offset);
-			printed += 2;
-		} else
-			scnprintf(bf, sizeof(bf), "  %-6.6s %s", dl->name, dl->ops.raw);
+		} else {
+			if (strcmp(dl->name, "retq")) {
+				slsmg_write_nstring(" ", 2);
+			} else {
+				SLsmg_set_char_set(1);
+				SLsmg_write_char(SLSMG_LARROW_CHAR);
+				SLsmg_set_char_set(0);
+				SLsmg_write_char(' ');
+			}
+
+			scnprintf(bf, sizeof(bf), "%-6.6s %s", dl->name, dl->ops.raw);
+		}
 
-		slsmg_write_nstring(bf, width - 10 - printed);
+		slsmg_write_nstring(bf, width - 12 - printed);
 	}
 
 	if (current_entry)
