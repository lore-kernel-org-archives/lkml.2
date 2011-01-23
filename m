Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1AWB4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 20:56:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59168 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1AWB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 20:56:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Ingo Molnar <mingo@elte.hu>, arjan@infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf tools: Fix time function double declaration with glibc
Date: Sat, 22 Jan 2011 23:56:18 -0200
Message-Id: <1295747778-26186-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295747778-26186-1-git-send-email-acme@infradead.org>
References: <1295747778-26186-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

It's enough to include the local "debug.h" file to trigger it.

man time reveals this is already declared in glibc:

time - get time in seconds
-> rename the variable.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: arjan@infradead.org
LPU-Reference: <1295620209-13859-2-git-send-email-trenn@suse.de>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/svghelper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 805220a..fb737fe 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -44,11 +44,11 @@ static double cpu2y(int cpu)
 	return cpu2slot(cpu) * SLOT_MULT;
 }
 
-static double time2pixels(u64 time)
+static double time2pixels(u64 __time)
 {
 	double X;
 
-	X = 1.0 * svg_page_width * (time - first_time) / (last_time - first_time);
+	X = 1.0 * svg_page_width * (__time - first_time) / (last_time - first_time);
 	return X;
 }
 
-- 
1.6.2.5

