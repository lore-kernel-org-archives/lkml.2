Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab0JGKdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 06:33:43 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:65275 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab0JGKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 06:33:42 -0400
From: Roman Tereshonkov <roman.tereshonkov@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Roman Tereshonkov <roman.tereshonkov@nokia.com>
Subject: [PATCH] kobject: name reference should not be lost when lack of memory error happens
Date: Thu,  7 Oct 2010 13:32:53 +0300
Message-Id: <1286447573-12579-1-git-send-email-roman.tereshonkov@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If lack of memory error happens we must restore the old kobject name reference

Signed-off-by: Roman Tereshonkov <roman.tereshonkov@nokia.com>
---
 lib/kobject.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index f07c572..c5cb117 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name) {
+		kobj->name = old_name;
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))
-- 
1.7.0.4

