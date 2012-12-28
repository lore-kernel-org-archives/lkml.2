Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2L1HRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 02:17:02 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48398 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2L1HRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 02:17:00 -0500
X-AuditID: 9c930197-b7c5bae000000e31-87-50dd476ab518
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf symbol: Include elf.h header regardless LIBELF_SUPPORT
Date: Fri, 28 Dec 2012 16:16:49 +0900
Message-Id: <1356679009-32122-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The elf.h header file is used for NO_LIBELF build too so it should be
included anyway.  Also remove duplicated include of the header file in
symbol-*.c.  This patch fixes following build error on NO_LIBELF build:

    CC tests/hists_link.o
tests/hists_link.c: In function ‘setup_fake_machine’:
tests/hists_link.c:132:8: error: ‘STB_GLOBAL’ undeclared (first use in this function)
tests/hists_link.c:132:8: note: each undeclared identifier is reported only once for each function it appears in

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol-elf.c     | 3 ---
 tools/perf/util/symbol-minimal.c | 1 -
 tools/perf/util/symbol.h         | 2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index f63557b59c06..54efcb5659ac 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1,6 +1,3 @@
-#include <libelf.h>
-#include <gelf.h>
-#include <elf.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <errno.h>
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 259f8f2ea9c9..a7390cde63bc 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,6 +1,5 @@
 #include "symbol.h"
 
-#include <elf.h>
 #include <stdio.h>
 #include <fcntl.h>
 #include <string.h>
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ec7b2405c377..d97377ac2f16 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -16,8 +16,8 @@
 #ifdef LIBELF_SUPPORT
 #include <libelf.h>
 #include <gelf.h>
-#include <elf.h>
 #endif
+#include <elf.h>
 
 #include "dso.h"
 
-- 
1.7.11.7

