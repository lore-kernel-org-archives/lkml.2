Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab2IMWKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:10:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60022 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab2IMWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:10:30 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 4/4] perf archive: make f the last parameter for tar
Date: Fri, 14 Sep 2012 01:07:43 +0300
Message-Id: <1347574063-22521-5-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

On some systems, tar needs to specify the name of the archive immediately
after the -f parameter.

Change the order of the parameters so tar can run properly.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/perf-archive.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.7.9.5

