Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285Ab2IHAsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:48:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52347 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759918Ab2IHAq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:46:57 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 09/12] perf tools: replace mkostemp with mkstemp
Date: Sat,  8 Sep 2012 03:43:21 +0300
Message-Id: <1347065004-15306-10-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

mkostemp is only available in glibc. This leads to compile error in Android,
since bionic is derived from BSD.

Replacing mkostemp with mkstemp. mkstemp is available on both glibc and bionic.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
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
1.7.9.5

