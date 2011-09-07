Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1IGXOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:14:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42737 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab1IGXO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:14:27 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 3/5] perf stat: suppress printing std-dev when its 0
Date: Wed,  7 Sep 2011 17:14:02 -0600
Message-Id: <1315437244-3788-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315437244-3788-1-git-send-email-jim.cromie@gmail.com>
References: <20110902185857.GE17970@ghostprotocols.net>
 <1315437244-3788-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pretty output only (preserve column for cvs output), dont print
std-deviation when its 0.00.  Do this based upon value, instead of
checking for --no-aggr, since the stats could conceivably be computed
over the runs on each CPU, and theres no reason to preclude that.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c6e47d2..660bed1 100644
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
1.7.4.4

