Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2HQEdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 00:33:44 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47708 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2HQEdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 00:33:42 -0400
Message-ID: <502DC99E.4060408@linux.vnet.ibm.com>
Date: Fri, 17 Aug 2012 12:33:34 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
CC: catalin.marinas@arm.com,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 2/3] kmemleak: replace list_for_each_continue_rcu with new
 interface
References: <502CB92F.2010700@linux.vnet.ibm.com>
In-Reply-To: <502CB92F.2010700@linux.vnet.ibm.com>
X-Forwarded-Message-Id: <502CB92F.2010700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12081704-1396-0000-0000-000001B9889D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch replaces list_for_each_continue_rcu() with
list_for_each_entry_continue_rcu() to save a few lines
of code and allow removing list_for_each_continue_rcu().

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 mm/kmemleak.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..0de83b4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1483,13 +1483,11 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct kmemleak_object *prev_obj = v;
 	struct kmemleak_object *next_obj = NULL;
-	struct list_head *n = &prev_obj->object_list;
+	struct kmemleak_object *obj = prev_obj;

 	++(*pos);

-	list_for_each_continue_rcu(n, &object_list) {
-		struct kmemleak_object *obj =
-			list_entry(n, struct kmemleak_object, object_list);
+	list_for_each_entry_continue_rcu(obj, &object_list, object_list) {
 		if (get_object(obj)) {
 			next_obj = obj;
 			break;
-- 
1.7.4.1


