Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab2IMWKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:10:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60022 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2IMWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:10:15 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 3/4] perf archive: remove -f from the rm command
Date: Fri, 14 Sep 2012 01:07:42 +0300
Message-Id: <1347574063-22521-4-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

In Android, rm does not support the -f parameter.
Remove -f from rm and make sure rm does not fail even if
the files to be removed are not found.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/perf-archive.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
1.7.9.5

