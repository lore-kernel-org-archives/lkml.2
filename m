Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab2DKVFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:05:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:46006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab2DKVFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>,
        Ashay Rane <ashay.rane@tacc.utexas.edu>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/13] perf annotate: Fix a build error
Date: Wed, 11 Apr 2012 18:05:20 -0300
Message-Id: <1334178325-19148-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.7.9.2.358.g22243

