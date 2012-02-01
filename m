Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2BAS4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:56:23 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37749 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2BAS4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:56:22 -0500
Date: Wed, 1 Feb 2012 10:55:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
        paul.gortmaker@windriver.com, ben@decadent.org.uk, mikey@neuling.org
Subject: [PATCH] powerpc: Define cpus_in_crash only for SMP kernels
Message-ID: <20120201185510.GA8542@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020118-2398-0000-0000-000003DCBC9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable cpus_in_crash gets a defined-but-not-used warning when
CONFIG_SMP=n, so fix by placing the variable under ifdef.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 28be345..eb3384e 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -46,7 +46,9 @@
 
 /* This keeps a track of which one is the crashing cpu. */
 int crashing_cpu = -1;
+#ifdef CONFIG_SMP
 static atomic_t cpus_in_crash;
+#endif /* #ifdef CONFIG_SMP */
 static int time_to_dump;
 
 #define CRASH_HANDLER_MAX 3

