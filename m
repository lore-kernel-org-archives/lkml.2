Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0GRKeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 06:34:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:34723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0GRKeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 06:34:11 -0400
Date: Sun, 18 Jul 2010 10:33:44 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Make END go to the last entry, not the top of the last page
Message-ID: <tip-63f20e744a595444f7ab1d47a29c5b74830feb47@git.kernel.org>
Git-Commit-ID: 63f20e744a595444f7ab1d47a29c5b74830feb47
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 18 Jul 2010 10:33:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63f20e744a595444f7ab1d47a29c5b74830feb47
Gitweb:     http://git.kernel.org/tip/63f20e744a595444f7ab1d47a29c5b74830feb47
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 15 Jul 2010 07:21:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 17 Jul 2010 15:44:43 -0300

perf ui: Make END go to the last entry, not the top of the last page

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
