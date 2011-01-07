Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1AGKaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:30:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:43268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1AGKaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:30:08 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        lenb@kernel.org, j-pihet@ti.com, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] perf (userspace): Fix variable clash with glibc time() func
Date: Fri,  7 Jan 2011 11:29:47 +0100
Message-Id: <1294396190-23031-7-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294396190-23031-1-git-send-email-trenn@suse.de>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
CC: linux-perf-users@vger.kernel.org
---
 tools/perf/util/svghelper.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index b3637db..38b9e40 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -43,11 +43,12 @@ static double cpu2y(int cpu)
 	return cpu2slot(cpu) * SLOT_MULT;
 }
 
-static double time2pixels(u64 time)
+static double time2pixels(u64 __time)
 {
 	double X;
 
-	X = 1.0 * svg_page_width * (time - first_time) / (last_time - first_time);
+	X = 1.0 * svg_page_width *
+		(__time - first_time) / (last_time - first_time);
 	return X;
 }
 
-- 
1.7.3.1

