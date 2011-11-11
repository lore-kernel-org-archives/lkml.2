Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1KKPzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:55:09 -0500
Received: from prod-mail-xrelay04.akamai.com ([96.6.114.79]:47078 "EHLO
	prod-mail-xrelay04.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932248Ab1KKPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:55:01 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Nov 2011 10:55:01 EST
From: Josh Hunt <johunt@akamai.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix implicit declaration of getline in util/probe-finder.c
Date: Fri, 11 Nov 2011 09:48:47 -0600
Message-Id: <1321026527-28251-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my older build machine I get the following failure:

CC util/probe-finder.o
cc1: warnings being treated as errors
util/probe-finder.c: In function 'find_lazy_match_lines':
util/probe-finder.c:864: warning: implicit declaration of function 'getline'
util/probe-finder.c:864: warning: nested extern declaration of 'getline'
make: *** [util/probe-finder.o] Error 1

This is a similar problem to the one resolved with git commit: 69e3f52d.
As with that fix I'm using util.h to provide the necessary inclusions as well
as handling _GNU_SOURCE.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 tools/perf/util/probe-finder.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..0f33926 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -19,24 +19,14 @@
  *
  */
 
+#include "util.h"
 #include <sys/utsname.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <stdio.h>
-#include <unistd.h>
 #include <getopt.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdarg.h>
-#include <ctype.h>
 #include <dwarf-regs.h>
 
 #include <linux/bitops.h>
 #include "event.h"
 #include "debug.h"
-#include "util.h"
 #include "symbol.h"
 #include "probe-finder.h"
 
-- 
1.7.0.4

