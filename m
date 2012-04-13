Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2DMSUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:20:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2DMSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:20:38 -0400
Date: Fri, 13 Apr 2012 11:19:38 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-a31b7cc083b1d3d15bd475729fc4471685ebc5f6@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung.kim@lge.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, ashay.rane@tacc.utexas.edu, namhyung@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung.kim@lge.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        ashay.rane@tacc.utexas.edu, namhyung@gmail.com,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <87ty0tlv4i.fsf@dasan.aot.lge.com>
References: <87ty0tlv4i.fsf@dasan.aot.lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix a build error
Git-Commit-ID: a31b7cc083b1d3d15bd475729fc4471685ebc5f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:19:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a31b7cc083b1d3d15bd475729fc4471685ebc5f6
Gitweb:     http://git.kernel.org/tip/a31b7cc083b1d3d15bd475729fc4471685ebc5f6
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 11 Apr 2012 17:04:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 17:07:18 -0300

perf annotate: Fix a build error

    CC util/annotate.o
util/annotate.c: In function symbol__annotate:
util/annotate.c:87:16: error: parsed_line may be used uninitialized in this function [-Werror=maybe-uninitialized]
util/annotate.c:211:22: note: parsed_line was declared here
cc1: all warnings being treated as errors
make: *** [util/annotate.o] Error 1
make: *** Waiting for unfinished jobs....

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ashay Rane <ashay.rane@tacc.utexas.edu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/87ty0tlv4i.fsf@dasan.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9fc4126..1e7fd52 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -226,6 +226,7 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		*c = 0;
 
 	line_ip = -1;
+	parsed_line = line;
 
 	/*
 	 * Strip leading spaces:
@@ -255,8 +256,7 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 			offset = -1;
 		else
 			parsed_line = tmp2 + 1;
-	} else
-		parsed_line = line;
+	}
 
 	objdump_line = objdump_line__new(offset, parsed_line, privsize);
 	free(line);
