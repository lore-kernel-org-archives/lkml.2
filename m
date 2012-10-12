Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab2JLIXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:23:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52943 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab2JLIXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:23:16 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5077D353.3010708@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 17:22:43 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <rientjes@google.com>, <akpm@linux-foundation.org>,
        <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH] mm: cleanup register_node()
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_node() is defined as extern in include/linux/node.h. But the function
is only called from register_one_node() in driver/base/node.c.

So the patch defines register_node() as static.

CC: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 drivers/base/node.c  |    2 +-
 include/linux/node.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-3.6/drivers/base/node.c
===================================================================
--- linux-3.6.orig/drivers/base/node.c	2012-10-12 16:35:51.000000000 +0900
+++ linux-3.6/drivers/base/node.c	2012-10-12 16:52:25.294207322 +0900
@@ -259,7 +259,7 @@ static inline void hugetlb_unregister_no
  *
  * Initialize and register the node device.
  */
-int register_node(struct node *node, int num, struct node *parent)
+static int register_node(struct node *node, int num, struct node *parent)
 {
 	int error;
 
Index: linux-3.6/include/linux/node.h
===================================================================
--- linux-3.6.orig/include/linux/node.h	2012-10-01 08:47:46.000000000 +0900
+++ linux-3.6/include/linux/node.h	2012-10-12 16:52:55.215210433 +0900
@@ -30,7 +30,6 @@ struct memory_block;
 extern struct node node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
-extern int register_node(struct node *, int, struct node *);
 extern void unregister_node(struct node *node);
 #ifdef CONFIG_NUMA
 extern int register_one_node(int nid);

