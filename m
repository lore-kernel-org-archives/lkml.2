Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1BNSIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:08:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:45620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1BNSH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:26 -0500
Date: Mon, 14 Feb 2011 13:52:21 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, acme@ghostprotocols.net, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        peterz@infradead.org, acme@ghostprotocols.net, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110214054807.8919.69740.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110214054807.8919.69740.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobe: Fix NULL pointer deref check
Message-ID: <tip-0de4b34d466bae571b50f41c7296b85248205e35@git.kernel.org>
Git-Commit-ID: 0de4b34d466bae571b50f41c7296b85248205e35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:07:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0de4b34d466bae571b50f41c7296b85248205e35
Gitweb:     http://git.kernel.org/tip/0de4b34d466bae571b50f41c7296b85248205e35
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 14 Feb 2011 14:48:07 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 12:09:53 +0100

tracing/kprobe: Fix NULL pointer deref check

Add NULL check for avoiding NULL pointer deref.
This bug has been introduced by:

  1ff511e35ed8: tracing/kprobes: Add bitfield type

which causes a null pointer dereference bug when kprobe-tracer
parses an argument without type.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110214054807.8919.69740.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ccdc542..8435b43 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -935,7 +935,7 @@ static int parse_probe_arg(char *arg, struct trace_probe *tp,
 	parg->offset = tp->size;
 	tp->size += parg->type->size;
 	ret = __parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
-	if (ret >= 0)
+	if (ret >= 0 && t != NULL)
 		ret = __parse_bitfield_probe_arg(t, parg->type, &parg->fetch);
 	if (ret >= 0) {
 		parg->fetch_size.fn = get_fetch_size_function(parg->type,
