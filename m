Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2AHPmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:42:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:59595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2AHPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:42:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 9/9] perf tools: Fix compile error on x86_64 Ubuntu
Date: Sun,  8 Jan 2012 13:42:19 -0200
Message-Id: <1326037339-31125-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.GIT
In-Reply-To: <1326037339-31125-1-git-send-email-acme@infradead.org>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The ctype.h include is not needed here and it breaks build on some systems (at
least 64bit Ubuntu 10.04) like below. Just get rid of it.

    CC util/trace-event-info.o
cc1: warnings being treated as errors
util/trace-event-info.c: In function ‘record_file’:
util/trace-event-info.c:192: error: implicit declaration of function ‘pwrite’
util/trace-event-info.c:192: error: nested extern declaration of ‘pwrite’
make: *** [util/trace-event-info.o] Error 1

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1326035430-7621-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index ac6830d..fc22cf5 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -18,7 +18,6 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#include <ctype.h>
 #include "util.h"
 #include <dirent.h>
 #include <mntent.h>
-- 
1.7.8.GIT

