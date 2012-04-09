Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2DICyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:54:41 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53136 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2DICyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:38 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-b7-4f824f6c6df5
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] trace-cmd: Add NO_PYTHON option for Makefile
Date: Mon,  9 Apr 2012 11:54:28 +0900
Message-Id: <1333940074-19052-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If someone do not want to build python plugins, [s]he can
define the option to disable python support:

  $ make NO_PYTHON=1

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index edf3402..54dbba4 100644
--- a/Makefile
+++ b/Makefile
@@ -76,6 +76,7 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
+ifndef NO_PYTHON
 PYTHON		:= ctracecmd.so
 PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
 
@@ -86,6 +87,7 @@ ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
 	PYTHON_SO_INSTALL := ctracecmd.install
 	PYTHON_PY_INSTALL := event-viewer.install tracecmd.install tracecmdgui.install
 endif
+endif # NO_PYTHON
 
 # $(call test-build, snippet, ret) -> ret if snippet compiles
 #                                  -> empty otherwise
-- 
1.7.7.6

