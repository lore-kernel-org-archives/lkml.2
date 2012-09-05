Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab2IEXLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:11:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:34328 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759850Ab2IEXJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/17] perf tools: Replace mempcpy with memcpy
Date: Wed,  5 Sep 2012 20:08:56 -0300
Message-Id: <1346886537-11621-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@gmail.com>

mempcpy is not supported by bionic in Android and will lead to
compilation errors.

Replacing mempcpy with memcpy so it will work in Android.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/target.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 051eaa6..065528b 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -117,8 +117,8 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 
 		if (err != buf) {
 			size_t len = strlen(err);
-			char *c = mempcpy(buf, err, min(buflen - 1, len));
-			*c = '\0';
+			memcpy(buf, err, min(buflen - 1, len));
+			*(buf + min(buflen - 1, len)) = '\0';
 		}
 
 		return 0;
-- 
1.7.1

