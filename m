Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2H1WWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:22:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51328 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2H1WWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:22:37 -0400
X-Greylist: delayed 1375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2012 18:22:37 EDT
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:22:16 +0300
Message-ID: <CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com>
Subject: [PATCH 11/13] perf tools: replace mempcpy with memcpy
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mempcpy is not supported by bionic in Android
and will lead to compilation errors.

Replacing mempcpy with memcpy so it will work in Android.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 051eaa6..065528b 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -117,8 +117,8 @@ int perf_target__strerror(struct perf_target
*target, int errnum,

 		if (err != buf) {
 			size_t len = strlen(err);
-			char *c = mempcpy(buf, err, min(buflen - 1, len));
-			*c = '\0';
+			memcpy(buf, err, min(buflen - 1, len));
+			*(buf + min(buflen - 1, len)) = '\0';
 		}

 		return 0;
-- 
1.7.9.5
