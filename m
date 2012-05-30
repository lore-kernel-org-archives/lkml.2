Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2E3Hse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:48:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35335 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2E3Hsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:48:33 -0400
Date: Wed, 30 May 2012 00:48:05 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-42c59cdab42b8909454e0d434e3977cd3b636fbd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1338003691-3141-1-git-send-email-namhyung@gmail.com>
References: <1338003691-3141-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Silence compiler warning on 32bit build
Git-Commit-ID: 42c59cdab42b8909454e0d434e3977cd3b636fbd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:48:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42c59cdab42b8909454e0d434e3977cd3b636fbd
Gitweb:     http://git.kernel.org/tip/42c59cdab42b8909454e0d434e3977cd3b636fbd
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sat, 26 May 2012 12:41:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 26 May 2012 14:14:58 -0300

tools lib traceevent: Silence compiler warning on 32bit build

The gcc complains about casting a pointer to unsigned long long directly:

    SUBDIR ../lib/traceevent/
  CC FPIC            event-parse.o
  CC FPIC            trace-seq.o
  CC FPIC            parse-filter.o
/home/namhyung/project/linux/tools/lib/traceevent/parse-filter.c: In function ‘get_value’:
/home/namhyung/project/linux/tools/lib/traceevent/parse-filter.c:1588: warning: cast from pointer to integer of different size
  CC FPIC            parse-utils.o
  BUILD STATIC LIB   libtraceevent.a

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1338003691-3141-1-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index e08d21f..dfcfe2c 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1584,7 +1584,7 @@ get_value(struct event_format *event,
 		const char *name;
 
 		name = get_comm(event, record);
-		return (unsigned long long)name;
+		return (unsigned long)name;
 	}
 
 	pevent_read_number_field(field, record->data, &val);
