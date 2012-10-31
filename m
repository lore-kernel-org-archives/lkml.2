Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965762Ab2JaOtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:49:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43647 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965713Ab2JaOtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        David Ahern <dsahern@gmail.com>, Irina Tirdea <irina.tirdea@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] perf tools: Add info about cross compiling for Android ARM
Date: Wed, 31 Oct 2012 12:48:59 -0200
Message-Id: <1351694943-7188-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351694943-7188-1-git-send-email-acme@infradead.org>
References: <1351694943-7188-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <js1304@gmail.com>

Without defining ARCH=arm, building perf for Android ARM will fail,
because it needs architecture specific files.

So add related relevant information to the android documentation.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1351518066-4791-1-git-send-email-js1304@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/android.txt |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/android.txt b/tools/perf/Documentation/android.txt
index a39dbbb..8484c3a 100644
--- a/tools/perf/Documentation/android.txt
+++ b/tools/perf/Documentation/android.txt
@@ -48,7 +48,10 @@ For x86:
 II. Compile perf for Android
 ------------------------------------------------
 You need to run make with the NDK toolchain and sysroot defined above:
-  make CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
+For arm:
+  make ARCH=arm CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
+For x86:
+  make ARCH=x86 CROSS_COMPILE=${NDK_TOOLCHAIN} CFLAGS="--sysroot=${NDK_SYSROOT}"
 
 III. Install perf
 -----------------------------------------------
-- 
1.7.9.2.358.g22243

