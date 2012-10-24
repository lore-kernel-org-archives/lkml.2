Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422717Ab2JXVyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:54:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:40915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161252Ab2JXVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:50:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/12] perf tools: Remove noise in python version feature test
Date: Wed, 24 Oct 2012 19:50:13 -0200
Message-Id: <1351115423-9025-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now that the feature tests honours the V=1 make verbosity switch, add a
return to the main() routine in the python version test, to avoid this
distraction:

CHK python version
<stdin>: In function 'main':
<stdin>:5: warning: control reaches end of non-void function

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-999no5yxlc2oqo9xjeez5zmv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-tests.mak |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 3ef5ec9..f5ac774 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -121,7 +121,10 @@ define SOURCE_PYTHON_VERSION
 #if PY_VERSION_HEX >= 0x03000000
 	#error
 #endif
-int main(void){}
+int main(void)
+{
+	return 0;
+}
 endef
 define SOURCE_PYTHON_EMBED
 #include <Python.h>
-- 
1.7.9.2.358.g22243

