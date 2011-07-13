Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1GMSIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:08:43 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39688 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab1GMSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:08:41 -0400
Subject: [RFC PATCH 09/10] fadump: Invalidate the fadump registration during
	machine shutdown.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Haren Myneni <hbabu@us.ibm.com>,
        Anton Blanchard <anton@samba.org>, Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Jul 2011 23:38:36 +0530
Message-ID: <20110713180830.6210.75084.stgit@mars.in.ibm.com>
In-Reply-To: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

If dump is active during system reboot, shutdown or halt then invalidate
the fadump registration as it does not get invalidated automatically.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/setup-common.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 79fca26..5683661 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -61,6 +61,7 @@
 #include <asm/xmon.h>
 #include <asm/cputhreads.h>
 #include <mm/mmu_decl.h>
+#include <asm/fadump.h>
 
 #include "setup.h"
 
@@ -109,6 +110,14 @@ EXPORT_SYMBOL(ppc_do_canonicalize_irqs);
 /* also used by kexec */
 void machine_shutdown(void)
 {
+#ifdef CONFIG_FA_DUMP
+	/*
+	 * if fadump is active, cleanup the fadump registration before we
+	 * shutdown.
+	 */
+	fadump_cleanup();
+#endif
+
 	if (ppc_md.machine_shutdown)
 		ppc_md.machine_shutdown();
 }

