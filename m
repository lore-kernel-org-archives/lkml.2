Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2IQRWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:22:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57932 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab2IQRSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/18] perf archive: Remove -f from the rm command
Date: Mon, 17 Sep 2012 14:18:04 -0300
Message-Id: <1347902292-14536-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

In Android, rm does not support the -f parameter.

Remove -f from rm and make sure rm does not fail even if the files to be
removed are not found.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347574063-22521-4-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-archive.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index 95b6f8b..da94179 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -24,7 +24,7 @@ NOBUILDID=0000000000000000000000000000000000000000
 perf buildid-list -i $PERF_DATA --with-hits | grep -v "^$NOBUILDID " > $BUILDIDS
 if [ ! -s $BUILDIDS ] ; then
 	echo "perf archive: no build-ids found"
-	rm -f $BUILDIDS
+	rm $BUILDIDS || true
 	exit 1
 fi
 
@@ -40,7 +40,7 @@ while read build_id ; do
 done
 
 tar cfj $PERF_DATA.tar.bz2 -C $PERF_BUILDID_DIR -T $MANIFEST
-rm -f $MANIFEST $BUILDIDS
+rm $MANIFEST $BUILDIDS || true
 echo -e "Now please run:\n"
 echo -e "$ tar xvf $PERF_DATA.tar.bz2 -C ~/.debug\n"
 echo "wherever you need to run 'perf report' on."
-- 
1.7.1

