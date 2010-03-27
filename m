Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0C0Rca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 13:32:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab0C0Rc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 13:32:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf tools: Use -o $(BITBUCKET) in one more case
Date: Sat, 27 Mar 2010 14:32:12 -0300
Message-Id: <1269711133-7743-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As described in 1703f2c some gcc versions has issues using /dev/null, so
use the mechanism used elsewhere.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b474641..0d36c8c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -541,7 +541,7 @@ PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
 PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <Python.h>'; echo 'int main(void) { Py_Initialize(); return 0; }') | $(CC) -x c - $(PYTHON_EMBED_CCOPTS) -o /dev/null $(PYTHON_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <Python.h>'; echo 'int main(void) { Py_Initialize(); return 0; }') | $(CC) -x c - $(PYTHON_EMBED_CCOPTS) -o $(BITBUCKET) $(PYTHON_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
 	BASIC_CFLAGS += -DNO_LIBPYTHON
 else
 	ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
-- 
1.6.2.5

