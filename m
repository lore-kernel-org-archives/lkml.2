Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1HFXWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 19:22:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:41547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab1HFXWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 19:22:13 -0400
Date: Sat, 6 Aug 2011 23:22:03 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-9387f774d61b01ab71bade85e6d0bfab0b3419bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1312633899-1131-1-git-send-email-bp@amd64.org>
References: <1312633899-1131-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86-32, amd: Move va_align definition to unbreak 32-bit build
Git-Commit-ID: 9387f774d61b01ab71bade85e6d0bfab0b3419bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 06 Aug 2011 23:22:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9387f774d61b01ab71bade85e6d0bfab0b3419bd
Gitweb:     http://git.kernel.org/tip/9387f774d61b01ab71bade85e6d0bfab0b3419bd
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Sat, 6 Aug 2011 14:31:38 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 6 Aug 2011 11:44:57 -0700

x86-32, amd: Move va_align definition to unbreak 32-bit build

hpa reported that dfb09f9b7ab03fd367740e541a5caf830ed56726 breaks 32-bit
builds with the following error message:

/home/hpa/kernel/linux-tip.cpu/arch/x86/kernel/cpu/amd.c:437: undefined
reference to `va_align'
/home/hpa/kernel/linux-tip.cpu/arch/x86/kernel/cpu/amd.c:436: undefined
reference to `va_align'

This is due to the fact that va_align is a global in a 64-bit only
compilation unit. Move it to mmap.c where it is visible to both
subarches.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1312633899-1131-1-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/sys_x86_64.c |    4 ----
 arch/x86/mm/mmap.c           |    5 ++++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index aaa8d09..fe7d2da 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -18,10 +18,6 @@
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
 
-struct __read_mostly va_alignment va_align = {
-	.flags = -1,
-};
-
 /*
  * Align a virtual address to avoid aliasing in the I$ on AMD F15h.
  *
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index d4c0736..4b5ba85 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -31,6 +31,10 @@
 #include <linux/sched.h>
 #include <asm/elf.h>
 
+struct __read_mostly va_alignment va_align = {
+	.flags = -1,
+};
+
 static unsigned int stack_maxrandom_size(void)
 {
 	unsigned int max = 0;
@@ -42,7 +46,6 @@ static unsigned int stack_maxrandom_size(void)
 	return max;
 }
 
-
 /*
  * Top of mmap area (just below the process stack).
  *
