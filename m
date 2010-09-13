Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0IMTsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:51 -0400
Received: from mail.perches.com ([173.55.12.10]:1930 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0IMTsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:45 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/25] tools/perf/util: Use static const char arrays
Date: Mon, 13 Sep 2010 12:48:03 -0700
Message-Id: <fd8327a360bece26e07f210b8fa5645a5062facc.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 tools/perf/util/ui/setup.c |    3 ++-
 tools/perf/util/ui/util.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index 6620850..9ff3ead 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -34,7 +34,8 @@ void exit_browser(bool wait_for_ok)
 {
 	if (use_browser > 0) {
 		if (wait_for_ok) {
-			char title[] = "Fatal Error", ok[] = "Ok";
+			static const char title[] = "Fatal Error";
+			static const char ok[] = "Ok";
 			newtWinMessage(title, ok, ui_helpline__last_msg);
 		}
 		newtFinished();
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 9706d9d..fe2742e 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -107,6 +107,7 @@ out_destroy_form:
 bool ui__dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
-	char yes[] = "Yes", no[] = "No";
+	static const char yes[] = "Yes";
+	static const char no[] = "No";
 	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
-- 
1.7.3.rc1

