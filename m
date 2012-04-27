Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab2D0Ijc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:39:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960Ab2D0Ij3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:39:29 -0400
Date: Fri, 27 Apr 2012 01:39:06 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-hkx848wdbs6n7bcp3ymr9yus@git.kernel.org>
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
  Add visual cues on jump lines
Git-Commit-ID: 51a0d455b5f44cb4680e0a89f99860b669e40d0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:39:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51a0d455b5f44cb4680e0a89f99860b669e40d0f
Gitweb:     http://git.kernel.org/tip/51a0d455b5f44cb4680e0a89f99860b669e40d0f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Apr 2012 15:40:20 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Apr 2012 15:40:20 -0300

perf annotate browser: Add visual cues on jump lines

Using up/down arrows just before the instruction, replacing the actual chars
with approximations to avoid mail encoding snafus:

avtab_search_node
    0.00 |      push   %rbp
    0.00 |      mov    %rsp,%rbp
    0.00 |      callq  mcount
    0.00 |      movzwl 0x6(%rsi),%edx
    0.00 |      and    $0x7fff,%dx
    0.00 |      test   %rdi,%rdi
    0.00 |    v jne    20
    0.00 | 17:  xor    %eax,%eax
    0.00 | 19:  leaveq
    0.00 |      retq
    0.00 |      nopl   0x0(%rax,%rax,1)
    0.00 | 20:  mov    (%rdi),%rax
    0.00 |      test   %rax,%rax
    0.00 |    ^ je     17
    0.00 |      movzwl (%rsi),%ecx
    0.00 |      movzwl 0x2(%rsi),%r9d
    0.00 |      movzwl 0x4(%rsi),%r8d
    0.00 |      movzwl %cx,%esi
    0.00 |      movzwl %r9w,%r10d
    0.00 |      shl    $0x9,%esi
    0.00 |      lea    (%rsi,%r10,4),%esi
    0.00 |      lea    (%r8,%rsi,1),%esi
    0.00 |      and    0x10(%rdi),%si
    0.00 |      movzwl %si,%esi
    0.00 |      mov    (%rax,%rsi,8),%rax
    0.00 |      test   %rax,%rax
    0.00 |    ^ je     19
    0.00 |      nopw   0x0(%rax,%rax,1)
    0.00 | 60:  cmp    %cx,(%rax)
    0.00 |    v jne    7e
    0.00 |      cmp    %r9w,0x2(%rax)
    0.00 |    v jne    7e
    0.00 |      cmp    %r8w,0x4(%rax)
    0.00 |    v jne    79
    0.00 |      test   %dx,0x6(%rax)
    0.00 |    ^ jne    19
    0.00 | 79:  cmp    %r8w,0x4(%rax)
   93.04 | 7e:^ ja     17
    2.53 |      mov    0x10(%rax),%rax
    4.43 |      test   %rax,%rax
    0.00 |    ^ jne    60
    0.00 |      leaveq
    0.00 |      retq

Next low hanging fruit is to use left arrow for retqs, then work on clearling
marking loops.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hkx848wdbs6n7bcp3ymr9yus@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index c2bbfc7..63206ca 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -113,9 +113,20 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		if (change_color)
 			ui_browser__set_color(self, color);
 		if (dl->ins && dl->ins->ops->scnprintf) {
+			if (ins__is_jump(dl->ins)) {
+				bool fwd = dl->ops.target > (u64)dl->offset;
+
+				SLsmg_set_char_set(1);
+				SLsmg_write_char(fwd ? SLSMG_DARROW_CHAR :
+						       SLSMG_UARROW_CHAR);
+				SLsmg_set_char_set(0);
+				SLsmg_write_char(' ');
+			} else {
+				slsmg_write_nstring(" ", 2);
+			}
+
 			dl->ins->ops->scnprintf(dl->ins, bf, sizeof(bf), &dl->ops,
 						!ab->use_offset);
-			slsmg_write_nstring(" ", 2);
 			printed += 2;
 		} else
 			scnprintf(bf, sizeof(bf), "  %-6.6s %s", dl->name, dl->ops.raw);
