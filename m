Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab2IHAq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:46:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63600 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab2IHAqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:46:52 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 07/12] perf tools: include missing pthread.h header
Date: Sat,  8 Sep 2012 03:43:19 +0300
Message-Id: <1347065004-15306-8-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

pthread variables are used in some files without explicitely including
pthread.h. This leads to compile errors on Android. e.g.: in annotate.h,
error: unknown type name 'pthread_mutex_t'

Including pthread.h explicitely in files that use it to have all definitions
included.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/perf.c          |    1 +
 tools/perf/util/annotate.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index e7840e5..fb8578c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,6 +14,7 @@
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include "util/debugfs.h"
+#include <pthread.h>
 
 const char perf_usage_string[] =
 	"perf [--version] [--help] COMMAND [ARGS]";
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a6d6bc5..62a6e7a 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -7,6 +7,7 @@
 #include "symbol.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include <pthread.h>
 
 struct ins;
 
-- 
1.7.9.5

