Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab0FKUle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:41:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51209 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab0FKUl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=w9ssss1ydW5dqPmYXwMW5aw7A1LQDikWsWPmZXb18yknk33UJ5lrK8y76WgffNr/49
         Rf5VS3VMwH3lJhVgZ6HTzk54VBwbGG1MGQIpIZ2M3tj0ZYbI36qxqnRGIElr/XtyVB1F
         KqJezmoeDy0WQo42Ci3sQxtu8HIyJLJUvj7fg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/6]kernel:module.c variable 'nowarn' set but not used
Date: Fri, 11 Jun 2010 13:41:08 -0700
Message-Id: <1276288869-16815-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a warning message 
reported by gcc 4.6.0.

  CC      kernel/module.o
kernel/module.c: In function 'add_usage_links':
kernel/module.c:1343:6: warning: variable 'nowarn' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 kernel/module.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 8c6b428..a71027a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1340,13 +1340,9 @@ static void add_usage_links(struct module *mod)
 {
 #ifdef CONFIG_MODULE_UNLOAD
 	struct module_use *use;
-	int nowarn;
-
+	
 	mutex_lock(&module_mutex);
-	list_for_each_entry(use, &mod->target_list, target_list) {
-		nowarn = sysfs_create_link(use->target->holders_dir,
-					   &mod->mkobj.kobj, mod->name);
-	}
+	list_for_each_entry(use, &mod->target_list, target_list); 
 	mutex_unlock(&module_mutex);
 #endif
 }
-- 
1.7.1.rc1.21.gf3bd6

