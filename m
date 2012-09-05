Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2IEXJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:34319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759839Ab2IEXJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/17] perf tools: Fix intlist node removal
Date: Wed,  5 Sep 2012 20:08:50 -0300
Message-Id: <1346886537-11621-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

Similar to the one in :
	https://lkml.org/lkml/2012/8/29/27

Make sure we remove the node from the rblist before we delete the node.
The rblist__remove_node() will invoke rblist->node_delete, which  will
take care of deleting the node with the suitable function provided by
the user.

Signed-off-by: Suzuki K Poulose <suzuki@in.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Suzuki K Poulose <suzuki@in.ibm.com>
Link: http://lkml.kernel.org/r/20120831065840.5167.90318.stgit@suzukikp.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/intlist.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index fd530dc..77c504f 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -52,9 +52,9 @@ int intlist__add(struct intlist *ilist, int i)
 	return rblist__add_node(&ilist->rblist, (void *)((long)i));
 }
 
-void intlist__remove(struct intlist *ilist __used, struct int_node *node)
+void intlist__remove(struct intlist *ilist, struct int_node *node)
 {
-	int_node__delete(node);
+	rblist__remove_node(&ilist->rblist, &node->rb_node);
 }
 
 struct int_node *intlist__find(struct intlist *ilist, int i)
-- 
1.7.1

