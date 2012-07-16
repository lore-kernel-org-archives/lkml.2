Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2GPNhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:37:31 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40316 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2GPNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:37:25 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, shangw@linux.vnet.ibm.com,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH] lib/kobject: restore old name on rename failure
Date: Mon, 16 Jul 2012 21:37:10 +0800
Message-Id: <1342445830-21909-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
x-cbid: 12071613-3548-0000-0000-0000028FE80E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Hao <haodong@linux.vnet.ibm.com>

The patch restores the old name while we fail to set the new
name for the kobject.

Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index ef3d807..9d396c5 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name){
+		kobj->name = old_name;
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))
-- 
1.7.2.5

