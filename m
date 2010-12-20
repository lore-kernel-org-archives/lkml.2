Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0LTOS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:18:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab0LTOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:18:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u0S/buvVFZYlzfF994XdQdmAmESzykxoGgtcsYT8aGbrobtgs5fDJ1DfVStWig6r70
         xUFIRalR5UQ/wcJQFIgMl5qreBWIX6J9rGtoXuwHKMN7fShn/Ks/Ex7X+Rn4vhuHobGP
         V1gxDXS8xArp19TG3i3c6Yh9f7iW8emvrnOIA=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] perf-probe: Fix line range description since a single file is allowed
Date: Mon, 20 Dec 2010 15:18:03 +0100
Message-Id: <1292854685-8230-5-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

	$ perf-probe -L sched.c

is currently allowed but not documented.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-event.c           |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 62de1b7..562501f 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -117,7 +117,7 @@ LINE SYNTAX
 -----------
 Line range is descripted by following syntax.
 
- "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]"
+ "FUNC[:RLN[+NUM|-RLN2]]|SRC[:ALN[+NUM|-ALN2]]"
 
 FUNC specifies the function name of showing lines. 'RLN' is the start line
 number from function entry line, and 'RLN2' is the end line number. As same as
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3c92b92..8e5f5ff 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -525,15 +525,18 @@ int show_available_vars(struct perf_probe_event *pevs __unused,
 }
 #endif
 
+/*
+ * Stuff 'lr' according to the line range described by 'arg'.
+ * The line range syntax is described by:
+ *
+ *         SRC[:SLN[+NUM|-ELN]]
+ *         FNC[:SLN[+NUM|-ELN]]
+ */
 int parse_line_range_desc(const char *arg, struct line_range *lr)
 {
 	const char *ptr;
 	char *tmp;
-	/*
-	 * <Syntax>
-	 * SRC:SLN[+NUM|-ELN]
-	 * FUNC[:SLN[+NUM|-ELN]]
-	 */
+
 	ptr = strchr(arg, ':');
 	if (ptr) {
 		lr->start = (int)strtoul(ptr + 1, &tmp, 0);
-- 
1.7.3.2

