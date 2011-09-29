Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1I2PLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:11:12 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41615 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab1I2PLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:11:10 -0400
Subject: [RFC PATCH v2 09/10] fadump: Invalidate the fadump registration
	during machine shutdown.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 29 Sep 2011 20:40:14 +0530
Message-ID: <20110929151014.26689.79936.stgit@mars.in.ibm.com>
In-Reply-To: <20110929150117.26689.62053.stgit@mars.in.ibm.com>
References: <20110929150117.26689.62053.stgit@mars.in.ibm.com>
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
 arch/powerpc/kernel/setup-common.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index ce35aaf..67e5caa 100644
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

