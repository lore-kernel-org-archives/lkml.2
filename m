Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2AES5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:57:13 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab2AES5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:57:12 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
        xiyou.wangcong@gmail.com, ebiederm@xmission.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] init: Warn on non-existent rdinit
Date: Thu,  5 Jan 2012 19:56:59 +0100
Message-Id: <1325789819-30502-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Such a warning would have saved me some time...
Hopefully this printk() saves someone else's time. :-)

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 init/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index 217ed23..43733c4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -834,6 +834,8 @@ static int __init kernel_init(void * unused)
 		ramdisk_execute_command = "/init";
 
 	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
+		printk(KERN_WARNING "Warning: unable to access %s!\n",
+					ramdisk_execute_command);
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
-- 
1.7.7.3

