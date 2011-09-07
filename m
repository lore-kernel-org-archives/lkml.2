Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab1IGXOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:14:44 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58020 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab1IGXOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:14:30 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 4/5] perf stat: allow tab as cvs delimiter
Date: Wed,  7 Sep 2011 17:14:03 -0600
Message-Id: <1315437244-3788-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315437244-3788-1-git-send-email-jim.cromie@gmail.com>
References: <20110902185857.GE17970@ghostprotocols.net>
 <1315437244-3788-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If option -x '\t' is given, convert '\t' to "\t".
This makes cvs printing more flexible.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 660bed1..b3e6e56 100644
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
1.7.4.4

