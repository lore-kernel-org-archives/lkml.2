Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2FNPni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:43:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51514 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab2FNPnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:43:37 -0400
From: Ido Yariv <ido@wizery.com>
To: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wfg@linux.intel.com, shai@scalemp.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH] x86/vsmp: Fix linker error when CONFIG_PROC_FS is not set
Date: Thu, 14 Jun 2012 18:43:08 +0300
Message-Id: <1339688588-12674-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <20120614105130.GB8683@gmail.com>
References: <20120614105130.GB8683@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_vsmp_pv_ops() references no_irq_affinity which is undeclared if
CONFIG_PROC_FS isn't set. Fix this by adding an ifdef around this
variable's access.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/kernel/vsmp_64.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 6b96a73..3f0285a 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -101,7 +101,10 @@ static void __init set_vsmp_pv_ops(void)
 #ifdef CONFIG_SMP
 	if (cap & ctl & BIT(8)) {
 		ctl &= ~BIT(8);
+#ifdef CONFIG_PROC_FS
+		/* Don't let users change irq affinity via procfs */
 		no_irq_affinity = 1;
+#endif
 	}
 #endif
 
-- 
1.7.10.2

