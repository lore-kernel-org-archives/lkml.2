Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2ATBE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:04:26 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64062 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2ATBEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:04:24 -0500
X-AuditID: 9c93016f-b7c20ae000005067-4f-4f18bd53022b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf: Don't call release_callchain_buffers if alloc fails
Date: Fri, 20 Jan 2012 10:12:45 +0900
Message-Id: <1327021966-27688-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9.rc1.dirty
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When alloc_callchain_buffers() fails, it frees all of
entries before return. In addition, calling the
release_callchain_buffers() will cause a NULL pointer
dereference since callchain_cpu_entries is not set.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/events/callchain.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 057e24b665cf..6581a040f399 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -115,8 +115,6 @@ int get_callchain_buffers(void)
 	}
 
 	err = alloc_callchain_buffers();
-	if (err)
-		release_callchain_buffers();
 exit:
 	mutex_unlock(&callchain_mutex);
 
-- 
1.7.9.rc1.dirty

