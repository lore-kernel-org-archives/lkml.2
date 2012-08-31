Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab2HaG7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 02:59:18 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42953 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HaG7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 02:59:17 -0400
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [PATCH] [perf] Fix intlist node removal
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Suzuki K Poulose <suzuki@in.ibm.com>,
        David Ahern <dsahern@gmail.com>
Date: Fri, 31 Aug 2012 12:28:47 +0530
Message-ID: <20120831065840.5167.90318.stgit@suzukikp.in.ibm.com>
In-Reply-To: <503DB6CD.4070502@gmail.com>
References: <503DB6CD.4070502@gmail.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12083106-8878-0000-0000-000003D01342
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the one in :
	https://lkml.org/lkml/2012/8/29/27


Make sure we remove the node from the rblist before we delete the
node. The rblist__remove_node() will invoke rblist->node_delete,
which  will take care of deleting the node with the suitable function
provided by the user.

Signed-off-by: Suzuki K Poulose <suzuki@in.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
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

