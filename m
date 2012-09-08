Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab2IHAsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:48:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52347 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab2IHAqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:46:50 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 06/12] perf tools: fix missing winsize definition
Date: Sat,  8 Sep 2012 03:43:18 +0300
Message-Id: <1347065004-15306-7-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

In Android, struct winsize is not defined in the headers already included in
help.c. This leads to a compile error.

Including termios.h fixes the compilation error since it defines struct winsize.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/help.c |    1 +
 tools/perf/util/top.h  |    1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6f2975a..4fa764d 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -3,6 +3,7 @@
 #include "exec_cmd.h"
 #include "levenshtein.h"
 #include "help.h"
+#include <termios.h>
 
 void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
 {
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 33347ca..86ff1b1 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -5,6 +5,7 @@
 #include "types.h"
 #include <stddef.h>
 #include <stdbool.h>
+#include <termios.h>
 
 struct perf_evlist;
 struct perf_evsel;
-- 
1.7.9.5

