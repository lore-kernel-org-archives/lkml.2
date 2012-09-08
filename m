Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627Ab2IHCJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:09:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41336 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329Ab2IHCH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/13] perf tools: Fix build for another rbtree.c change
Date: Fri,  7 Sep 2012 23:07:12 -0300
Message-Id: <1347070032-4161-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Fixes:

../../lib/rbtree.c: In function 'rb_insert_color':
../../lib/rbtree.c:95:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once for each function it appears in
../../lib/rbtree.c: In function '__rb_erase_color':
../../lib/rbtree.c:216:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c: In function 'rb_erase':
../../lib/rbtree.c:368:2: error: unknown type name 'bool'
make: *** [util/rbtree.o] Error 1

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/50406F60.5040707@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/rbtree.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
index 7a243a1..2a030c5 100644
--- a/tools/perf/util/include/linux/rbtree.h
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -1 +1,2 @@
+#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
-- 
1.7.9.2.358.g22243

