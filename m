Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0LVLdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:33:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:49465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0LVLdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:33:20 -0500
Date: Wed, 22 Dec 2010 11:32:37 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101217131200.24123.8202.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101217131200.24123.8202.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix lazy wildcard matching
Message-ID: <tip-ea187cfbb9a3de73e7bd7b7125ae345d92d4384b@git.kernel.org>
Git-Commit-ID: ea187cfbb9a3de73e7bd7b7125ae345d92d4384b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:32:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea187cfbb9a3de73e7bd7b7125ae345d92d4384b
Gitweb:     http://git.kernel.org/tip/ea187cfbb9a3de73e7bd7b7125ae345d92d4384b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 17 Dec 2010 22:12:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 19:15:42 -0200

perf tools: Fix lazy wildcard matching

Fix lazy wildcard matching to ignore space after wild card.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20101217131200.24123.8202.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
