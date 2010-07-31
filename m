Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0GaBK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 21:10:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:41194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0GaBKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 21:10:24 -0400
Date: Sat, 31 Jul 2010 01:10:03 GMT
From: tip-bot for Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dilinger@queued.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100628220029.1555ac24@debian>
References: <20100628220029.1555ac24@debian>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc: Constify an olpc_ofw() arg
Message-ID: <tip-54e5bc020ce1c959eaa7be18cedb734b6b13745e@git.kernel.org>
Git-Commit-ID: 54e5bc020ce1c959eaa7be18cedb734b6b13745e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 31 Jul 2010 01:10:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54e5bc020ce1c959eaa7be18cedb734b6b13745e
Gitweb:     http://git.kernel.org/tip/54e5bc020ce1c959eaa7be18cedb734b6b13745e
Author:     Andres Salomon <dilinger@queued.net>
AuthorDate: Mon, 28 Jun 2010 22:00:29 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Jul 2010 18:02:21 -0700

x86, olpc: Constify an olpc_ofw() arg

The arguments passed to OFW shouldn't be modified; update the 'args'
argument of olpc_ofw to reflect this.  This saves us some later
casting away of consts.

Signed-off-by: Andres Salomon <dilinger@queued.net>
LKML-Reference: <20100628220029.1555ac24@debian>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/olpc_ofw.h |    2 +-
 arch/x86/kernel/olpc.c          |    2 +-
 arch/x86/kernel/olpc_ofw.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
index 3e63d85..08fde47 100644
--- a/arch/x86/include/asm/olpc_ofw.h
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -12,7 +12,7 @@
 #define olpc_ofw(name, args, res) \
 	__olpc_ofw((name), ARRAY_SIZE(args), args, ARRAY_SIZE(res), res)
 
-extern int __olpc_ofw(const char *name, int nr_args, void **args, int nr_res,
+extern int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
 		void **res);
 
 /* determine whether OFW is available and lives in the proper memory */
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index f5ff3903..0e0cdde 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -188,7 +188,7 @@ static void __init platform_detect(void)
 {
 	size_t propsize;
 	__be32 rev;
-	void *args[] = { NULL, "board-revision-int", &rev, (void *)4 };
+	const void *args[] = { NULL, "board-revision-int", &rev, (void *)4 };
 	void *res[] = { &propsize };
 
 	if (olpc_ofw("getprop", args, res) || propsize != 4) {
diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
index f5d499f..3218aa7 100644
--- a/arch/x86/kernel/olpc_ofw.c
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -40,7 +40,7 @@ void __init setup_olpc_ofw_pgd(void)
 	early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
 }
 
-int __olpc_ofw(const char *name, int nr_args, void **args, int nr_res,
+int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
 		void **res)
 {
 	int ofw_args[MAXARGS + 3];
