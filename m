Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2IQRWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:22:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2IQRSb (ORCPT
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
Subject: [PATCH 11/18] perf archive: Make 'f' the last parameter for tar
Date: Mon, 17 Sep 2012 14:18:05 -0300
Message-Id: <1347902292-14536-12-git-send-email-acme@infradead.org>
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

On some systems, tar needs to specify the name of the archive immediately
after the -f parameter.

Change the order of the parameters so tar can run properly.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347574063-22521-5-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-archive.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index da94179..e919306 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -39,7 +39,7 @@ while read build_id ; do
 	echo ${filename#$PERF_BUILDID_LINKDIR} >> $MANIFEST
 done
 
-tar cfj $PERF_DATA.tar.bz2 -C $PERF_BUILDID_DIR -T $MANIFEST
+tar cjf $PERF_DATA.tar.bz2 -C $PERF_BUILDID_DIR -T $MANIFEST
 rm $MANIFEST $BUILDIDS || true
 echo -e "Now please run:\n"
 echo -e "$ tar xvf $PERF_DATA.tar.bz2 -C ~/.debug\n"
-- 
1.7.1

