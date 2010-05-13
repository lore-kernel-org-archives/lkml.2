Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0EMRXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:23:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54309 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab0EMRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :mime-version:content-type:content-transfer-encoding;
        b=VJnZCRZzX37Q492abPJEXYvGn0OPmuXD6aWhDEVXu4upaDsT+w1ceInSUNuOqL9Ewd
         WJulUdnETfKZRG04hQzGzk6kxZBSIjr0eUxMYiLfhKi8iC1n8zys8sIOlDdqqqSYUEEx
         erksTHsmnhwCXgVVMGD6O6VM6aPX9Cy5x5r80=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Fix hists__browse no-newt case
Date: Thu, 13 May 2010 19:22:58 +0200
Message-Id: <1273771378-8577-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.2.3

