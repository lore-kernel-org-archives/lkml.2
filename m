Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab2IHCIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:08:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:46408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343Ab2IHCH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/13] perf tools: replace mkostemp with mkstemp
Date: Fri,  7 Sep 2012 23:07:09 -0300
Message-Id: <1347070032-4161-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

The mkostemp function is only available in glibc. This leads to compile
error in Android, since bionic is derived from BSD.

Replacing mkostemp with mkstemp. mkstemp is available on both glibc and
bionic.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-10-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso-test-data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/util/dso-test-data.c
index 541cdc7..c6caede 100644
--- a/tools/perf/util/dso-test-data.c
+++ b/tools/perf/util/dso-test-data.c
@@ -23,7 +23,7 @@ static char *test_file(int size)
 	int fd, i;
 	unsigned char *buf;
 
-	fd = mkostemp(templ, O_CREAT|O_WRONLY|O_TRUNC);
+	fd = mkstemp(templ);
 
 	buf = malloc(size);
 	if (!buf) {
-- 
1.7.9.2.358.g22243

