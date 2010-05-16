Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0EPBAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 21:00:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0EPA7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 20:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf newt: Exit browser unconditionally when CTRL+C, q or Q is pressed
Date: Sat, 15 May 2010 21:59:41 -0300
Message-Id: <1273971582-20206-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273971582-20206-1-git-send-email-acme@infradead.org>
References: <1273971582-20206-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

ESC still asks for confirmation.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 094887f..139eb1a 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -837,9 +837,10 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 		if (es.reason == NEWT_EXIT_HOTKEY) {
 			if (toupper(es.u.key) == 'A')
 				goto do_annotate;
-			if (es.u.key == NEWT_KEY_ESCAPE ||
-			    toupper(es.u.key) == 'Q' ||
-			    es.u.key == CTRL('c')) {
+			if (toupper(es.u.key) == 'Q' ||
+			    es.u.key == CTRL('c'))
+				break;
+			if (es.u.key == NEWT_KEY_ESCAPE) {
 				if (dialog_yesno("Do you really want to exit?"))
 					break;
 				else
-- 
1.6.2.5

