Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2FTRDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:03:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab2FTRDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:03:15 -0400
Date: Wed, 20 Jun 2012 10:01:43 -0700
From: tip-bot for Samuel Liao <samuelliao@tencent.com>
Message-ID: <tip-c0a58fb2bdf033df433cad9009c7dac4c6b872b0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        davidshan@tencent.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        samuelliao@tencent.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, davidshan@tencent.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, samuelliao@tencent.com,
        tglx@linutronix.de
In-Reply-To: <4FCD95D3.90209@gmail.com>
References: <4FCD95D3.90209@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Check null of sym pointer before using it
Git-Commit-ID: c0a58fb2bdf033df433cad9009c7dac4c6b872b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 10:01:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0a58fb2bdf033df433cad9009c7dac4c6b872b0
Gitweb:     http://git.kernel.org/tip/c0a58fb2bdf033df433cad9009c7dac4c6b872b0
Author:     Samuel Liao <samuelliao@tencent.com>
AuthorDate: Tue, 5 Jun 2012 13:14:59 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 14:30:26 -0300

perf annotate: Check null of sym pointer before using it

Sym may be NULL, and that will cause perf to crash.

Signed-off-by: Shan Wei <davidshan@tencent.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FCD95D3.90209@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 34b1c46..67a2703 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -814,7 +814,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 {
 	struct disasm_line *pos, *n;
 	struct annotation *notes;
-	const size_t size = symbol__size(sym);
+	size_t size;
 	struct map_symbol ms = {
 		.map = map,
 		.sym = sym,
@@ -834,6 +834,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	if (sym == NULL)
 		return -1;
 
+	size = symbol__size(sym);
+
 	if (map->dso->annotate_warned)
 		return -1;
 
