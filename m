Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2HCOEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:04:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2HCOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:01:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/18] perf target: Fix check on buffer size
Date: Fri,  3 Aug 2012 11:00:55 -0300
Message-Id: <1344002470-5965-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It was a mistake just replace assert to BUG_ON since its condition
should be negated. Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1343267410-7758-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/target.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3f59c49..051eaa6 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -110,7 +110,7 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 	int idx;
 	const char *msg;
 
-	BUG_ON(buflen > 0);
+	BUG_ON(buflen == 0);
 
 	if (errnum >= 0) {
 		const char *err = strerror_r(errnum, buf, buflen);
-- 
1.7.1

