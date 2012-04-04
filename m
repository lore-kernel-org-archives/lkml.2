Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2DDIpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:45:32 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:33285 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2DDIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:45:31 -0400
Date: Wed, 4 Apr 2012 10:45:27 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] Fix perf build failure on glibc trunk
Message-ID: <20120404084527.GA294@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a system running glibc trunk perf doesn't build:

    CC builtin-sched.o
builtin-sched.c: In function ‘get_cpu_usage_nsec_parent’:
builtin-sched.c:399:16: error: storage size of ‘ru’ isn’t known
builtin-sched.c:403:2: error: implicit declaration of function ‘getrusage’ [-Werror=implicit-function-declaration]
builtin-sched.c:403:2: error: nested extern declaration of ‘getrusage’ [-Werror=nested-externs]
builtin-sched.c:403:18: error: ‘RUSAGE_SELF’ undeclared (first use in this function)
builtin-sched.c:403:18: note: each undeclared identifier is reported only once for each function it appears in
builtin-sched.c:399:16: error: unused variable ‘ru’ [-Werror=unused-variable]
cc1: all warnings being treated as errors

Fix it by including sys/resource.h.
---
 tools/perf/builtin-sched.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index fb8b5f8..1cad3af 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -17,6 +17,7 @@
 #include "util/debug.h"
 
 #include <sys/prctl.h>
+#include <sys/resource.h>
 
 #include <semaphore.h>
 #include <pthread.h>
-- 
Markus
