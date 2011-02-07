Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1BGPAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:00:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:39124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1BGPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 9/9] perf annotate: Fix build error
Date: Mon,  7 Feb 2011 13:00:12 -0200
Message-Id: <1297090812-10782-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>

A small fix for when NO_NEWT_SUPPORT is defined.

Add a missing "struct" to the function prototype.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20110207143218.GA31197@kryptos.osrc.amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b1253aa..bc08b36 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -82,7 +82,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 int max_lines);
 
 #ifdef NO_NEWT_SUPPORT
-static inline int symbol__tui_annotate(symbol *sym __used,
+static inline int symbol__tui_annotate(struct symbol *sym __used,
 				       struct map *map __used, int evidx __used)
 {
 	return 0;
-- 
1.6.2.5

