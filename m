Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1I2WsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60117 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab1I2WsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/16] perf stat: Allow tab as cvs delimiter
Date: Thu, 29 Sep 2011 19:48:04 -0300
Message-Id: <1317336490-19437-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

If option -x '\t' is given, convert '\t' to "\t".  This makes cvs
printing more flexible.

Link: http://lkml.kernel.org/r/1315437244-3788-5-git-send-email-jim.cromie@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 076eda5..0ffbd97 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1198,9 +1198,11 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		}
 	}
 
-	if (csv_sep)
+	if (csv_sep) {
 		csv_output = true;
-	else
+		if (!strcmp(csv_sep, "\\t"))
+			csv_sep = "\t";
+	} else
 		csv_sep = DEFAULT_SEPARATOR;
 
 	/*
-- 
1.6.2.5

