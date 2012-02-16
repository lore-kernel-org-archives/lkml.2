Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2BPLR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:17:29 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50684 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2BPLR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:17:27 -0500
Subject: [RFC PATCH v7 09/10] fadump: Invalidate the fadump registration
 during machine shutdown.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>, Kexec-ml <kexec@lists.infradead.org>,
        Milton Miller <miltonm@bga.com>, Haren Myneni <hbabu@us.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mackerras <paulus@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ananth Narayan <ananth@in.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Anton Blanchard <anton@samba.org>
Date: Thu, 16 Feb 2012 16:45:15 +0530
Message-ID: <20120216111515.4733.42652.stgit@mars>
In-Reply-To: <20120216111050.4733.38034.stgit@mars>
References: <20120216111050.4733.38034.stgit@mars>
User-Agent: StGit/0.15-4-g042f-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12021611-4790-0000-0000-0000015ABB44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

If dump is active during system reboot, shutdown or halt then invalidate
the fadump registration as it does not get invalidated automatically.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/setup-common.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 4e62a56..b0ebdea 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -110,6 +110,14 @@ EXPORT_SYMBOL(ppc_do_canonicalize_irqs);
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

