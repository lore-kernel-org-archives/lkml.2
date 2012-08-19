Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2HSC7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:30968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2HSC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="135817667"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/74] sections: Add __visible to init/* sections
Date: Sat, 18 Aug 2012 19:56:09 -0700
Message-Id: <1345345030-22211-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 init/do_mounts_initrd.c |    2 +-
 init/initramfs.c        |    4 ++--
 init/main.c             |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 135959a2..71a625e 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -36,7 +36,7 @@ __setup("noinitrd", no_initrd);
 static int __init do_linuxrc(void *_shell)
 {
 	static const char *argv[] = { "linuxrc", NULL, };
-	extern const char *envp_init[];
+	extern __visible const char *envp_init[];
 	const char *shell = _shell;
 
 	sys_close(old_fd);sys_close(root_fd);
diff --git a/init/initramfs.c b/init/initramfs.c
index 84c6bf1..8a1fd07 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -493,8 +493,8 @@ static int __init retain_initrd_param(char *str)
 }
 __setup("retain_initrd", retain_initrd_param);
 
-extern char __initramfs_start[];
-extern unsigned long __initramfs_size;
+extern __visible char __initramfs_start[];
+extern __visible unsigned long __initramfs_size;
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
diff --git a/init/main.c b/init/main.c
index e60679d..6438ffd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -470,7 +470,7 @@ static void __init mm_init(void)
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
-	extern const struct kernel_param __start___param[], __stop___param[];
+	extern __visible const struct kernel_param __start___param[], __stop___param[];
 
 	/*
 	 * Need to run as early as possible, to initialize the
-- 
1.7.7.6

