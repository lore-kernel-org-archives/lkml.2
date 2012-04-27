Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab2D0IgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:36:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab2D0IgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:36:12 -0400
Date: Fri, 27 Apr 2012 01:35:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-mwshob8n12jlsu458ghvheos@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Add missing jump variants
Git-Commit-ID: 3f862fd076275c442dfe295eddb5650a6e0aecd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:35:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f862fd076275c442dfe295eddb5650a6e0aecd4
Gitweb:     http://git.kernel.org/tip/3f862fd076275c442dfe295eddb5650a6e0aecd4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Apr 2012 17:10:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Apr 2012 17:10:12 -0300

perf annotate: Add missing jump variants

Taken from binutils:

[acme@sandy binutils-2.22]$ grep ^j opcodes/i386-opc.tbl | cut -d, -f1 | sort -u

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mwshob8n12jlsu458ghvheos@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d8e2f41..e70cbb4 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -70,11 +70,40 @@ static struct ins instructions[] = {
 	{ .name = "call",  .ops  = &call_ops, },
 	{ .name = "callq", .ops  = &call_ops, },
 	{ .name = "ja",	   .ops  = &jump_ops, },
+	{ .name = "jae",   .ops  = &jump_ops, },
+	{ .name = "jb",	   .ops  = &jump_ops, },
+	{ .name = "jbe",   .ops  = &jump_ops, },
+	{ .name = "jc",	   .ops  = &jump_ops, },
+	{ .name = "jcxz",  .ops  = &jump_ops, },
 	{ .name = "je",	   .ops  = &jump_ops, },
+	{ .name = "jecxz", .ops  = &jump_ops, },
+	{ .name = "jg",	   .ops  = &jump_ops, },
+	{ .name = "jge",   .ops  = &jump_ops, },
+	{ .name = "jl",    .ops  = &jump_ops, },
+	{ .name = "jle",   .ops  = &jump_ops, },
 	{ .name = "jmp",   .ops  = &jump_ops, },
 	{ .name = "jmpq",  .ops  = &jump_ops, },
+	{ .name = "jna",   .ops  = &jump_ops, },
+	{ .name = "jnae",  .ops  = &jump_ops, },
+	{ .name = "jnb",   .ops  = &jump_ops, },
+	{ .name = "jnbe",  .ops  = &jump_ops, },
+	{ .name = "jnc",   .ops  = &jump_ops, },
 	{ .name = "jne",   .ops  = &jump_ops, },
+	{ .name = "jng",   .ops  = &jump_ops, },
+	{ .name = "jnge",  .ops  = &jump_ops, },
+	{ .name = "jnl",   .ops  = &jump_ops, },
+	{ .name = "jnle",  .ops  = &jump_ops, },
+	{ .name = "jno",   .ops  = &jump_ops, },
+	{ .name = "jnp",   .ops  = &jump_ops, },
+	{ .name = "jns",   .ops  = &jump_ops, },
+	{ .name = "jnz",   .ops  = &jump_ops, },
+	{ .name = "jo",	   .ops  = &jump_ops, },
+	{ .name = "jp",	   .ops  = &jump_ops, },
+	{ .name = "jpe",   .ops  = &jump_ops, },
+	{ .name = "jpo",   .ops  = &jump_ops, },
+	{ .name = "jrcxz", .ops  = &jump_ops, },
 	{ .name = "js",	   .ops  = &jump_ops, },
+	{ .name = "jz",	   .ops  = &jump_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
