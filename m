Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab2BJAzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:55:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48912 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab2BJAzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:55:15 -0500
X-AuditID: 9c930179-b7cf1ae000000e40-e6-4f346aebfafc
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perf tools: Get rid of ctype.h in symbol.c
Date: Fri, 10 Feb 2012 10:10:17 +0900
Message-Id: <1328836217-9118-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328836217-9118-1-git-send-email-namhyung.kim@lge.com>
References: <1328836217-9118-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ctype.h in symbol.c was needed because of isupper(). However we now
have it in util.h, it can be changed to use our implementation.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fc6e12fe4b44..5dd83c3e2c0c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,4 +1,3 @@
-#include <ctype.h>
 #include <dirent.h>
 #include <errno.h>
 #include <libgen.h>
@@ -12,6 +11,7 @@
 #include <unistd.h>
 #include <inttypes.h>
 #include "build-id.h"
+#include "util.h"
 #include "debug.h"
 #include "symbol.h"
 #include "strlist.h"
-- 
1.7.9

