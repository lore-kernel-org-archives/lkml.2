Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2CEP4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:56:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:53822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2CEPzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:55:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/7] perf annotate: Add missing newline on error message
Date: Mon,  5 Mar 2012 12:55:32 -0300
Message-Id: <1330962932-1796-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1330962932-1796-1-git-send-email-acme@infradead.org>
References: <1330962932-1796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If perf.data couldn't find vmlinux image for the given build-id,
it would print error message. However it lacked a newline at the
end, so the output looked like below:

 $ perf annotate --stdio
 No vmlinux file with build id 63b554b2e90f14a4bced200008865e757d3e8b36
 was found in the path.

 Please use:

   perf buildid-cache -av vmlinux

 or:

   --vmlinux vmlinux Percent |   Source code & Disassembly of a.out
 ------------------------------------------------
          :
          :
          :
          :      Disassembly of section .text:
          :
          :      00000000004004f4 <foo>:
     0.00 :        4004f4:       push   %rbp
     0.00 :        4004f5:       mov    %rsp,%rbp
     0.00 :        4004f8:       movl   $0x0,-0x4(%rbp)
     0.00 :        4004ff:       jmp    400517 <foo+0x23>
    14.70 :        400501:       mov    0x200b28(%rip),%rax        # 601030 <count>
     0.02 :        400508:       add    $0x1,%rax
     0.01 :        40050c:       mov    %rax,0x200b1d(%rip)        # 601030 <count>
     0.01 :        400513:       addl   $0x1,-0x4(%rbp)
    13.92 :        400517:       cmpl   $0x98967f,-0x4(%rbp)
    71.33 :        40051e:       jle    400501 <foo+0xd>
     0.00 :        400520:       leaveq
     0.00 :        400521:       retq

Fix it by adding a newline at the end of the message. It doesn't affect
the tui output AFAICS. New output will look like this:

 ...
 or:

   --vmlinux vmlinux
  Percent |   Source code & Disassembly of a.out
 ------------------------------------------------
          :
          :
          :
          :      Disassembly of section .text:
 ...

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329986784-4916-6-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 011ed26..e5a462f 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -315,7 +315,7 @@ fallback:
 		       "Please use:\n\n"
 		       "  perf buildid-cache -av vmlinux\n\n"
 		       "or:\n\n"
-		       "  --vmlinux vmlinux",
+		       "  --vmlinux vmlinux\n",
 		       sym->name, build_id_msg ?: "");
 		goto out_free_filename;
 	}
-- 
1.7.9.2.358.g22243

