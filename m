Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2CUJAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:00:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44697 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2CUI77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:59:59 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] perf tool: fix compile failure with missed 'linux/export.h'
Date: Wed, 21 Mar 2012 16:59:38 +0800
Message-Id: <1332320378-30652-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just fake a export.h under util/include/linux so that perf
can be built successfully.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 tools/perf/Makefile                    |    1 +
 tools/perf/util/include/linux/export.h |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/linux/export.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74fd7f8..ad9d1cb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -250,6 +250,7 @@ LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/module.h
+LIB_H += util/include/linux/export.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
new file mode 100644
index 0000000..841636d
--- /dev/null
+++ b/tools/perf/util/include/linux/export.h
@@ -0,0 +1,6 @@
+#ifndef PERF_LINUX_EXPORT_H
+#define PERF_LINUX_EXPORT_H
+
+#define EXPORT_SYMBOL(name)
+
+#endif
-- 
1.7.9.1

