Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1I2WsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60121 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1I2WsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/16] perf stat: Suppress printing std-dev when its 0
Date: Thu, 29 Sep 2011 19:48:03 -0300
Message-Id: <1317336490-19437-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

For pretty output only (preserve column for cvs output), dont print
std-deviation when its 0.00.  Do this based upon value, instead of
checking for --no-aggr, since the stats could conceivably be computed
over the runs on each CPU, and theres no reason to preclude that.

Link: http://lkml.kernel.org/r/1315437244-3788-4-git-send-email-jim.cromie@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index af0d65b..076eda5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -528,7 +528,7 @@ static void print_noise_pct(double total, double avg)
 
 	if (csv_output)
 		fprintf(output, "%s%.2f%%", csv_sep, pct);
-	else
+	else if (pct)
 		fprintf(output, "  ( +-%6.2f%% )", pct);
 }
 
-- 
1.6.2.5

