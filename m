Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0DZO0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:26:47 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:50695 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0DZO0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:26:46 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Tom Zanussi <tzanussi@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] perf: Fix libdw-dev package name in error message
Date: Mon, 26 Apr 2010 15:27:03 +0100
Message-Id: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The headers required for DWARF support are provided by the libdw-dev
package in Debian-based distros.  This patch corrects the elfutils-dev
package name to libdw-dev in the Makefile error message when libdw.h is
not found.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
I don't think any distro has an elfutils-dev package but the name was chosen because of the usual RedHat/Debian -devel/-dev convention.

 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bc0f670..66c525b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -505,7 +505,7 @@ else
 endif
 
 ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
+	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/libdw-dev);
 	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
 else
 	BASIC_CFLAGS += -I/usr/include/elfutils
-- 
1.7.0

