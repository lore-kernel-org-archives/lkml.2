Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965588Ab2FAQzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:55:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50322 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965541Ab2FAQzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:55:36 -0400
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jim Cromie <jim.cromie@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH] init: Drop initcall level output
Date: Fri,  1 Jun 2012 18:56:00 +0200
Message-Id: <1338569760-28859-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

9fb48c744ba6a ("params: add 3rd arg to option handler callback
signature") added similar lines to dmesg:

initlevel:0=early, 4 registered initcalls
initlevel:1=core, 31 registered initcalls
initlevel:2=postcore, 11 registered initcalls
initlevel:3=arch, 7 registered initcalls
initlevel:4=subsys, 40 registered initcalls
initlevel:5=fs, 30 registered initcalls
initlevel:6=device, 250 registered initcalls
initlevel:7=late, 35 registered initcalls

but they don't contain any info for the general user staring at dmesg.
I'm very doubtful the count of initcalls registered per level helps
anyone so drop that output completely.

Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 init/main.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/init/main.c b/init/main.c
index 1ca6b32c4828..f956829b3add 100644
--- a/init/main.c
+++ b/init/main.c
@@ -755,13 +755,8 @@ static void __init do_initcalls(void)
 {
 	int level;
 
-	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++) {
-		pr_info("initlevel:%d=%s, %d registered initcalls\n",
-			level, initcall_level_names[level],
-			(int) (initcall_levels[level+1]
-				- initcall_levels[level]));
+	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++)
 		do_initcall_level(level);
-	}
 }
 
 /*
-- 
1.7.9.3.362.g71319

