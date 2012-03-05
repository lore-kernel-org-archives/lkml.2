Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2CEQYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:24:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60951 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2CEQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:24:34 -0500
Date: Mon, 5 Mar 2012 08:23:51 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ff2a6617c2acd6a8dc468c90ab8708a6ad112bb0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1329986784-4916-6-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-6-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Add missing newline on error message
Git-Commit-ID: ff2a6617c2acd6a8dc468c90ab8708a6ad112bb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 08:24:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff2a6617c2acd6a8dc468c90ab8708a6ad112bb0
Gitweb:     http://git.kernel.org/tip/ff2a6617c2acd6a8dc468c90ab8708a6ad112bb0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Feb 2012 17:46:24 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Mar 2012 10:15:50 -0300

perf annotate: Add missing newline on error message

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
 1 files changed, 1 insertions(+), 1 deletions(-)

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
