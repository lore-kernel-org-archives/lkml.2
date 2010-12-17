Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0LQNQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:16:46 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47269 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0LQNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:16:45 -0500
X-AuditID: b753bd60-a7da7ba000003e7d-48-4d0b62baf891
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  1/4] [BUGFIX]perf: Fix lazy wildcard matching
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Dec 2010 22:12:00 +0900
Message-ID: <20101217131200.24123.8202.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix lazy wildcard matching to ignore space after
wild card.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/util/string.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 0409fc7..8fc0bd3 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -259,7 +259,7 @@ static bool __match_glob(const char *str, const char *pat, bool ignore_space)
 		if (!*pat)	/* Tail wild card matches all */
 			return true;
 		while (*str)
-			if (strglobmatch(str++, pat))
+			if (__match_glob(str++, pat, ignore_space))
 				return true;
 	}
 	return !*str && !*pat;

