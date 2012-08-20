Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2HTEpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:45:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2HTEpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:45:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 1/7] perf: initial infrasructure for kbuild/kconfig
Date: Sun, 19 Aug 2012 22:44:45 -0600
Message-Id: <1345437891-78830-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
References: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need help adapting the build targets from the top level Makefile.

For this RFC series, the commands can be run manually:
$ cd tools/perf
$ ../../scripts/kconfig/conf --allyesconfig  Pconfig
--> generates .config for perf

$ mkdir include/config
$ mkdir include/generated
$ /tmp/kbuild/scripts/kconfig/conf --silentoldconfig Pconfig
--> takes .config and generates include/config/auto.conf and
    include/generated/autoconf.h

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile |    6 +++++-
 tools/perf/Pconfig  |   17 +++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/Pconfig

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 90cfecf..70b4ae9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -5,6 +5,9 @@ all:
 
 include config/utilities.mak
 
+# Read in config
+-include include/config/auto.conf
+
 # Define V to have a more verbose compile.
 #
 # Define O to save output files in a separate directory.
@@ -167,7 +170,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iinclude -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -336,6 +339,7 @@ LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += ui/helpline.h
+LIB_H += include/generated/autoconf.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
new file mode 100644
index 0000000..24c8655
--- /dev/null
+++ b/tools/perf/Pconfig
@@ -0,0 +1,17 @@
+config NEWT
+    bool "Enable newt-based TUI"
+
+config GTK2
+    bool "Enable GTK-based UI"
+
+config LIBUNWIND
+    bool "Enable support for libunwind"
+
+config DEMANGLE
+    bool "Enable support for demangle"
+
+config LIBPERL
+    bool "Enable support for perl scripting engine"
+
+config LIBPYTHON
+    bool "Enable support for python scripting engine"
-- 
1.7.10.1

