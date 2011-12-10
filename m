Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1LJGvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 01:51:35 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60660 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1LJGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 01:51:32 -0500
Subject: [RFC PATCH v6 09/10] fadump: Invalidate the fadump registration
	during machine shutdown.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>, Kexec-ml <kexec@lists.infradead.org>,
        Milton Miller <miltonm@bga.com>, Haren Myneni <hbabu@us.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ananth Narayan <ananth@in.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Anton Blanchard <anton@samba.org>
Date: Sat, 10 Dec 2011 12:21:22 +0530
Message-ID: <20111210065122.10195.980.stgit@mars.in.ibm.com>
In-Reply-To: <20111210064301.10195.3344.stgit@mars.in.ibm.com>
References: <20111210064301.10195.3344.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120921-3568-0000-0000-000000DE4ADE
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

