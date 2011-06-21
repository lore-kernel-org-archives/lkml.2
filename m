Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1FUGMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 02:12:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55910 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1FUGMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 02:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MHXX51IJ+vP5lOy+BnjbRqALQU6n1QXcH5UrzuCy63TEydMMJNQ+Z2DQwCXuCOiD69
         4yLXShiuKSjQH1DPkCFRIcb1ch4MD8fL0ZEcesKBt7FOM14ihzbEhdKvvYqcWAC4Mj0l
         VHfHTmfWQkneMqUFU74nQ+o9x4JgvG6ngEC9Q=
From: Stephen Boyd <bebarino@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] configs: Include MODULE_*() when CONFIG_IKCONFIG_PROC=n
Date: Mon, 20 Jun 2011 23:12:27 -0700
Message-Id: <1308636747-2360-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.7.5.rc2.4.g4d8b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_IKCONFIG=m but CONFIG_IKCONFIG_PROC=n we get a module that has
no MODULE_LICENSE definition. Move the MODULE_*() definitions outside
the CONFIG_IKCONFIG_PROC #ifdef to prevent this configuration from
tainting the kernel.

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 kernel/configs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/configs.c b/kernel/configs.c
index b4066b4..42e8fa0 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -92,8 +92,8 @@ static void __exit ikconfig_cleanup(void)
 module_init(ikconfig_init);
 module_exit(ikconfig_cleanup);
 
+#endif /* CONFIG_IKCONFIG_PROC */
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Randy Dunlap");
 MODULE_DESCRIPTION("Echo the kernel .config file used to build the kernel");
-
-#endif /* CONFIG_IKCONFIG_PROC */
-- 
1.7.5.rc2.4.g4d8b3

