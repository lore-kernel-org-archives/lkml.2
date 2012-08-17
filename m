Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2HQGpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:45:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2HQGpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:45:31 -0400
From: Adam Lee <adam8157@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz> (odd fixer:KCONFIG 
	,commit_signer:2/3=67%),
        "Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/3=67%),
        linux-kbuild@vger.kernel.org (open list:KCONFIG)
Subject: [PATCH] kconfig: document oldnoconfig to what it really does in conf.c
Date: Fri, 17 Aug 2012 14:45:23 +0800
Message-Id: <1345185924-16005-1-git-send-email-adam8157@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 67d34a6a391369269a2e5dba8a5f42cc4cd50231 said, the make target
'oldnoconfig' is a misnomer. It doesn't set new symbols to 'n', but
instead sets it to their default values.

This patch fixes the document in conf.c, and will submit another patch
to replace 'oldnoconfig' to 'olddefconfig'
---
 scripts/kconfig/conf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 0dc4a2c..6875680 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -467,7 +467,7 @@ static void conf_usage(const char *progname)
 	printf("  --oldaskconfig          Start a new configuration using a line-oriented program\n");
 	printf("  --oldconfig             Update a configuration using a provided .config as base\n");
 	printf("  --silentoldconfig       Same as oldconfig, but quietly, additionally update deps\n");
-	printf("  --oldnoconfig           Same as silentoldconfig but set new symbols to no\n");
+	printf("  --oldnoconfig           Same as silentoldconfig but sets new symbols to their default value\n");
 	printf("  --defconfig <file>      New config with default defined in <file>\n");
 	printf("  --savedefconfig <file>  Save the minimal current configuration to <file>\n");
 	printf("  --allnoconfig           New config where all options are answered with no\n");
-- 
1.7.11.2

