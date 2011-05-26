Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab1EZSGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:06:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:56667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1EZSGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:06:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf tools: Fix build on older systems
Date: Thu, 26 May 2011 15:05:34 -0300
Message-Id: <1306433134-31869-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1306433134-31869-1-git-send-email-acme@infradead.org>
References: <1306433134-31869-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Where /usr/include/linux/const.h is not present, e.g. RHEL5.

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-ypcw2mu0w7dl1rrc6ncz3pee@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                   |    2 ++
 tools/perf/util/include/linux/const.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/linux/const.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1455413..032ba63 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -215,11 +215,13 @@ LIB_FILE=$(OUTPUT)libperf.a
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
+LIB_H += ../../include/linux/const.h
 LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
 LIB_H += util/include/linux/compiler.h
+LIB_H += util/include/linux/const.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
diff --git a/tools/perf/util/include/linux/const.h b/tools/perf/util/include/linux/const.h
new file mode 100644
index 0000000..1b476c9
--- /dev/null
+++ b/tools/perf/util/include/linux/const.h
@@ -0,0 +1 @@
+#include "../../../../include/linux/const.h"
-- 
1.6.2.5

