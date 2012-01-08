Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2AHPKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:10:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51499 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab2AHPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:10:39 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Fix compile error on x86_64 Ubuntu
Date: Mon,  9 Jan 2012 00:10:30 +0900
Message-Id: <1326035430-7621-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <20120108150012.GA7570@elte.hu>
References: <20120108150012.GA7570@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ctype.h is not needed here and it breaks build on some system
(at least 64bit Ubuntu 10.04) like below. Just get rid of it.

    CC util/trace-event-info.o
cc1: warnings being treated as errors
util/trace-event-info.c: In function ‘record_file’:
util/trace-event-info.c:192: error: implicit declaration of function ‘pwrite’
util/trace-event-info.c:192: error: nested extern declaration of ‘pwrite’
make: *** [util/trace-event-info.o] Error 1

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/util/trace-event-info.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index ac6830d8292b..fc22cf5c605f 100644
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
1.7.8.2

