Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2GZBzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 21:55:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57185 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2GZBzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 21:55:51 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-31-5010a3a5aa78
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [PATCH] perf target: Fix check on buffer size
Date: Thu, 26 Jul 2012 10:50:10 +0900
Message-Id: <1343267410-7758-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <87lii75p9c.fsf@sejong.aot.lge.com>
References: <87lii75p9c.fsf@sejong.aot.lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It was a mistake just replace assert to BUG_ON since its condition
should be negated. Fix it.

Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3f59c496e64c..051eaa68095e 100644
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
1.7.10.4

