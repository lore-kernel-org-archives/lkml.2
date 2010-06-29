Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0F2CAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:00:33 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59770 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0F2CAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:00:32 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2010 22:00:32 EDT
Date: Mon, 28 Jun 2010 22:00:29 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
       Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       grant.likely@secretlab.ca
Subject: [PATCH 1/4] x86: OLPC: constify an olpc_ofw() arg
Message-ID: <20100628220029.1555ac24@debian>
In-Reply-To: <20100628215407.2017bf2f@debian>
References: <20100628215407.2017bf2f@debian>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The arguments passed to OFW shouldn't be modified; update the 'args'
argument of olpc_ofw to reflect this.  This saves us some later
casting away of consts.

Signed-off-by: Andres Salomon <dilinger@queued.net>
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
index f5ff390..0e0cdde 100644
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
index deac703..3e13a4b 100644
--- a/arch/x86/kernel/olpc_ofw.c
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -39,7 +39,7 @@ void __init setup_olpc_ofw_pgd(void)
 	/* implicit optimization barrier here due to uninline function return */
 }
 
-int __olpc_ofw(const char *name, int nr_args, void **args, int nr_res,
+int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
 		void **res)
 {
 	int ofw_args[MAXARGS + 3];
-- 
1.5.6.5

