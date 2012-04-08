Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2DHWZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:25:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52685 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2DHWZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:25:06 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Ashay Rane <ashay.rane@tacc.utexas.edu>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/8] perf/urgent new features
References: <1333832049-2399-1-git-send-email-acme@infradead.org>
Date: Mon, 09 Apr 2012 07:24:45 +0900
In-Reply-To: <1333832049-2399-1-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Sat, 7 Apr 2012 17:54:01 -0300")
Message-ID: <87ty0tlv4i.fsf@dasan.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

This gave me a build failuire. You might need this also.



>From cacd1950b71bcd28a5d5115c573f2a0578058fcd Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Mon, 9 Apr 2012 07:19:50 +0900
Subject: [PATCH] perf annotate: Fix a build error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

    CC util/annotate.o
util/annotate.c: In function ‘symbol__annotate’:
util/annotate.c:87:16: error: ‘parsed_line’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
util/annotate.c:211:22: note: ‘parsed_line’ was declared here
cc1: all warnings being treated as errors
make: *** [util/annotate.o] Error 1
make: *** Waiting for unfinished jobs....

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/annotate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9fc4126e54db..1e7fd52bd29d 100644
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
1.7.9.3

