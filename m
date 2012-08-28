Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2H1WHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:07:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2H1WHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:07:15 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:06:55 +0300
Message-ID: <CANg8OWLr0H4H3AKit-vtjoOG4+G8tjk2zYKF1c2S4rWb=s+v6g@mail.gmail.com>
Subject: [PATCH 13/13] perf tools: replace mkostemp with mkstemp
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

mkostemp is only available in glibc. This leads to compile
error in Android, since bionic is derived from BSD.

Replacing mkostemp with mkstemp. mkstemp is available on
both glibc and bionic.

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

-    fd = mkostemp(templ, O_CREAT|O_WRONLY|O_TRUNC);
+    fd = mkstemp(templ);

     buf = malloc(size);
     if (!buf) {
--
1.7.9.5
