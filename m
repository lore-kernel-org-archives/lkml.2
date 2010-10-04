Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0JDSyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:54:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:37824 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab0JDSyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:54:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf ui hist browser: Fix segfault on 'a' for annotate
Date: Mon,  4 Oct 2010 15:54:42 -0300
Message-Id: <1286218483-7219-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1286218483-7219-1-git-send-email-acme@infradead.org>
References: <1286218483-7219-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

There a typo in util/ui/browsers/hists.c that leads to a segfault when you
press the 'a' key on a non-resolved symbol (plain hex address).

LKML-Reference: <20100923201901.GE31726@gambetta>
Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index dafdf67..6866aa4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -773,7 +773,7 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 
 			switch (key) {
 			case 'a':
-				if (browser->selection->map == NULL &&
+				if (browser->selection->map == NULL ||
 				    browser->selection->map->dso->annotate_warned)
 					continue;
 				goto do_annotate;
-- 
1.6.2.5

