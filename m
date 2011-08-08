Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1HHPyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:54:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40589 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1HHPxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:53:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Zhu Yanhai <zhu.yanhai@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Zhu Yanhai <gaoyang.zyh@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf lock: Dropping unsupported ':r' modifier
Date: Mon,  8 Aug 2011 12:52:54 -0300
Message-Id: <1312818776-19530-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312818776-19530-1-git-send-email-acme@infradead.org>
References: <1312818776-19530-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhu Yanhai <zhu.yanhai@gmail.com>

Looks to me like the :r modifier is not supported anymore, so remove it
from the list of events. Without this fix 'perf lock record' doesn't
work.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1312035232-9534-1-git-send-email-gaoyang.zyh@taobao.com
Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 9ac05aa..899080a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -942,10 +942,10 @@ static const char *record_args[] = {
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-	"-e", "lock:lock_acquire:r",
-	"-e", "lock:lock_acquired:r",
-	"-e", "lock:lock_contended:r",
-	"-e", "lock:lock_release:r",
+	"-e", "lock:lock_acquire",
+	"-e", "lock:lock_acquired",
+	"-e", "lock:lock_contended",
+	"-e", "lock:lock_release",
 };
 
 static int __cmd_record(int argc, const char **argv)
-- 
1.6.2.5

