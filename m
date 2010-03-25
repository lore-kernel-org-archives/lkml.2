Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0CYW7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:59:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:58728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0CYW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:59:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/6] perf newt: Initialize choice variable
Date: Thu, 25 Mar 2010 19:58:56 -0300
Message-Id: <1269557941-15617-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

  cc1: warnings being treated as errors
  util/newt.c: In function ‘perf_session__browse_hists’:
  util/newt.c:442: error: ‘choice’ may be used uninitialized in this function

Note: Ingo, you may want to fold this with:

   [PATCH v2 6/6] perf report: Pass the DSO to 'perf annotate'

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 12572b5..e99bcc8 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -439,7 +439,7 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	while (1) {
 		char annotate[512];
 		const char *options[2];
-		int nr_options = 0, choice;
+		int nr_options = 0, choice = 0;
 
 		newtFormRun(form, &es);
 		if (es.reason == NEWT_EXIT_HOTKEY) {
-- 
1.6.2.5

