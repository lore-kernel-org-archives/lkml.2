Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0DOHb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:31:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:38266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab0DOHbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:31:49 -0400
Date: Thu, 15 Apr 2010 07:30:59 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100414223935.14630.11954.stgit@localhost6.localdomain6>
References: <20100414223935.14630.11954.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix mis-estimation for shortening filename
Message-ID: <tip-dd259c5db26ccda46409dbf6efc79d5a2b259e38@git.kernel.org>
Git-Commit-ID: dd259c5db26ccda46409dbf6efc79d5a2b259e38
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:31:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd259c5db26ccda46409dbf6efc79d5a2b259e38
Gitweb:     http://git.kernel.org/tip/dd259c5db26ccda46409dbf6efc79d5a2b259e38
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 14 Apr 2010 18:39:35 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:41:14 -0300

perf probe: Fix mis-estimation for shortening filename

Fix mis-estimation size for making a short filename.
Since the buffer size is 32 bytes and there are '@' prefix and
'\0' termination, maximum shorten filename length should be
30. This means, before searching '/', it should be 31 bytes.

LKML-Reference: <20100414223935.14630.11954.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1c4a20a..6d43839 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -806,12 +806,12 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 			goto error;
 	}
 	if (pp->file) {
-		len = strlen(pp->file) - 32;
+		len = strlen(pp->file) - 31;
 		if (len < 0)
 			len = 0;
 		tmp = strchr(pp->file + len, '/');
 		if (!tmp)
-			tmp = pp->file + len - 1;
+			tmp = pp->file + len;
 		ret = e_snprintf(file, 32, "@%s", tmp + 1);
 		if (ret <= 0)
 			goto error;
