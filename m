Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab1BNFzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 00:55:24 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59069 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1BNFzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 00:55:22 -0500
X-AuditID: b753bd60-a454dba0000001d0-45-4d58c3c8633b
X-AuditID: b753bd60-a454dba0000001d0-45-4d58c3c8633b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip ] [BUGFIX] tracing/kprobe: Fix NULL pointer deref check
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Date: Mon, 14 Feb 2011 14:48:07 +0900
Message-ID: <20110214054807.8919.69740.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NULL check for avoiding NULL pointer deref.
This bug has been introduced by
1ff511e35ed87cc2ebade9e678e4a2fe39b6f9c5, which causes
a null pointer dereference bug when kprobe-tracer parses
an argument without type.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
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

