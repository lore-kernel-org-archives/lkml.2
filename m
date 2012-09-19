Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2ISPTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:19:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2ISPTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:19:49 -0400
Date: Wed, 19 Sep 2012 08:19:29 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-73eb422c10aa2a4afc1100d1bd54974ed72ad373@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347574063-22521-4-git-send-email-irina.tirdea@intel.com>
References: <1347574063-22521-4-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf archive: Remove -f from the rm command
Git-Commit-ID: 73eb422c10aa2a4afc1100d1bd54974ed72ad373
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:19:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73eb422c10aa2a4afc1100d1bd54974ed72ad373
Gitweb:     http://git.kernel.org/tip/73eb422c10aa2a4afc1100d1bd54974ed72ad373
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Fri, 14 Sep 2012 01:07:42 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:10:27 -0300

perf archive: Remove -f from the rm command

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
