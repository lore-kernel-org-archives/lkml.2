Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0G1QkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:40:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39164 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab0G1QkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JGUtnCbOVlP2sdECDJHg5DYcydNWo2RftDokpRqXFk0wh30jgPFkWRUk9S73vUIcRW
         EJAQxYu+ew+Wc+zs3ltiHYBiA82e9wA+LBAyHUpnkiolksxaOTfb6mig4vCOHKxMoQ+V
         dyrw6wjV+GHfgwaI20J3WnRIryO9wc5/eQtwA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <jbeulich@novell.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 05/10] mm: check kmalloc() return value
Date: Wed, 28 Jul 2010 20:40:03 +0400
Message-Id: <1280335203-23305-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 mm/vmalloc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b7e314b..f63684a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2437,8 +2437,11 @@ static int vmalloc_open(struct inode *inode, struct file *file)
 	unsigned int *ptr = NULL;
 	int ret;
 
-	if (NUMA_BUILD)
+	if (NUMA_BUILD) {
 		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+		if (ptr == NULL)
+			return -ENOMEM;
+	}
 	ret = seq_open(file, &vmalloc_op);
 	if (!ret) {
 		struct seq_file *m = file->private_data;
-- 
1.7.0.4

