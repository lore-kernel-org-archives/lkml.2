Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab0FSUjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:39:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54767 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0FSUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Lby4oW2wvl7njsDPqeIRR5fWyv5IiVr6SfW+9PSagy80GhZSukDQGzcmOEXD6Gx2k8
         H9o/5JpiTCQBcROpprh10ujz4oH70DfgRy3AUzkYqJxTPcdl+gdse8MJebk941x6i13V
         GW17y94u9xzGxLbu/yLi/Sxd1iauehMYpmn/w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/6 v2]kernel:module.c variable 'nowarn' set but not used
Date: Sat, 19 Jun 2010 13:39:13 -0700
Message-Id: <1276979953-24443-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend from the original, due to the original being wrong,
and having whitespace issues.
The below patch marks the variable nowarn __unused to satisfy gcc 4.6.0 from
giving this warning:
  CC      kernel/module.o
kernel/module.c: In function 'add_usage_links':
kernel/module.c:1343:6: warning: variable 'nowarn' set but not used
after doing this the warning message goes away, but checkpatch.pl
gives a warning about externs should be avoided, so am not sure
this is the right approach(but could be wrong).

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 8c6b428..765bac5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1340,7 +1340,7 @@ static void add_usage_links(struct module *mod)
 {
 #ifdef CONFIG_MODULE_UNLOAD
 	struct module_use *use;
-	int nowarn;
+	int nowarn __attribute__((unused));
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry(use, &mod->target_list, target_list) {
-- 
1.7.1.rc1.21.gf3bd6

