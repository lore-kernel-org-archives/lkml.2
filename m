Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0EJQco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:32:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:59385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab0EJQck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:32:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/4] perf callchains: Use zalloc to allocate objects
Date: Mon, 10 May 2010 13:32:19 -0300
Message-Id: <1273509141-15696-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273509141-15696-1-git-send-email-acme@infradead.org>
References: <1273509141-15696-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ac14861..21a52e0 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -167,7 +167,7 @@ create_child(struct callchain_node *parent, bool inherit_children)
 {
 	struct callchain_node *new;
 
-	new = malloc(sizeof(*new));
+	new = zalloc(sizeof(*new));
 	if (!new) {
 		perror("not enough memory to create child for code path tree");
 		return NULL;
@@ -213,7 +213,7 @@ fill_node(struct callchain_node *node, struct resolved_chain *chain, int start)
 	for (i = start; i < chain->nr; i++) {
 		struct callchain_list *call;
 
-		call = malloc(sizeof(*call));
+		call = zalloc(sizeof(*call));
 		if (!call) {
 			perror("not enough memory for the code path tree");
 			return;
@@ -386,7 +386,7 @@ int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	if (!chain->nr)
 		return 0;
 
-	filtered = malloc(sizeof(*filtered) +
+	filtered = zalloc(sizeof(*filtered) +
 			  chain->nr * sizeof(struct resolved_ip));
 	if (!filtered)
 		return -ENOMEM;
-- 
1.6.2.5

