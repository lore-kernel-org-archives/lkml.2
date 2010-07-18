Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab0GRBtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 21:49:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:39247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0GRBtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 21:49:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf ui: Make END go to the last entry, not the top of the last page
Date: Sat, 17 Jul 2010 22:48:54 -0300
Message-Id: <1279417736-4396-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279417736-4396-1-git-send-email-acme@infradead.org>
References: <1279417736-4396-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 06f248f..932f124 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -491,11 +491,11 @@ static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 			break;
 		case NEWT_KEY_END:
 			offset = self->height - 1;
+			if (offset >= self->nr_entries)
+				offset = self->nr_entries - 1;
 
-			if (offset > self->nr_entries)
-				offset = self->nr_entries;
-
-			self->index = self->first_visible_entry_idx = self->nr_entries - 1 - offset;
+			self->index = self->nr_entries - 1;
+			self->first_visible_entry_idx = self->index - offset;
 			self->seek(self, -offset, SEEK_END);
 			break;
 		case NEWT_KEY_RIGHT:
-- 
1.6.2.5

