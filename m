Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1B0Vhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:37:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:42202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1B0Vgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:36:50 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: trenn@suse.de, lenb@kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] perf: timechart: fix black idle boxes in the title.
Date: Sun, 27 Feb 2011 22:36:45 +0100
Message-Id: <1298842606-55712-5-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298842606-55712-1-git-send-email-trenn@suse.de>
References: <1298842606-55712-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix is needed for eye of gnome and firefox svg viewers.
Only Inkscape can handle the broken case.

Compare with the other svg_legenda_box declarations, looks
like a typo slipped in at this place.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: mingo@elte.hu
---
 tools/perf/util/svghelper.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index fb737fe..96c8660 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -456,9 +456,9 @@ void svg_legenda(void)
 		return;
 
 	svg_legenda_box(0,	"Running", "sample");
-	svg_legenda_box(100,	"Idle","rect.c1");
-	svg_legenda_box(200,	"Deeper Idle", "rect.c3");
-	svg_legenda_box(350,	"Deepest Idle", "rect.c6");
+	svg_legenda_box(100,	"Idle","c1");
+	svg_legenda_box(200,	"Deeper Idle", "c3");
+	svg_legenda_box(350,	"Deepest Idle", "c6");
 	svg_legenda_box(550,	"Sleeping", "process2");
 	svg_legenda_box(650,	"Waiting for cpu", "waiting");
 	svg_legenda_box(800,	"Blocked on IO", "blocked");
-- 
1.7.3.4

