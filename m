Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0EMUTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:19:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:54760 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab0EMUTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:19:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf hist: Fix hists__browse no-newt case
Date: Thu, 13 May 2010 17:19:21 -0300
Message-Id: <1273781964-29552-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273781964-29552-1-git-send-email-acme@infradead.org>
References: <1273781964-29552-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Fix mistake in a parameter type of the no-newt hists__browse()
version.

Fixes:
	builtin-report.c: In function ‘__cmd_report’:
	builtin-report.c:314: erreur: incompatible type for argument 1 of ‘hists__browse’

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1273771378-8577-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ed9c067..0b4c8df 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -78,7 +78,7 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso);
 void hists__filter_by_thread(struct hists *self, const struct thread *thread);
 
 #ifdef NO_NEWT_SUPPORT
-static inline int hists__browse(struct hists self __used,
+static inline int hists__browse(struct hists *self __used,
 				const char *helpline __used,
 				const char *input_name __used)
 {
-- 
1.6.2.5

