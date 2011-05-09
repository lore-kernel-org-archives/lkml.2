Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1EISgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:36:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55026 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1EISg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:36:28 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v3 2/6] x86, MCE: Export mce_get_debugfs_dir
Date: Mon,  9 May 2011 20:35:51 +0200
Message-Id: <1304966155-9841-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1304966155-9841-1-git-send-email-bp@amd64.org>
References: <1304966155-9841-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is needed for external users of the same debugfs toplevel dir.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h                |    1 +
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    1 -
 arch/x86/kernel/cpu/mcheck/mce.c          |    1 +
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index a2e3dcf..1c9c7be 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -241,5 +241,6 @@ struct cper_sec_mem_err;
 extern void apei_mce_report_mem_error(int corrected,
 				      struct cper_sec_mem_err *mem_err);
 
+struct dentry *mce_get_debugfs_dir(void);
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index fefcc69..660a9e1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -22,7 +22,6 @@ struct mce_bank {
 };
 
 int mce_severity(struct mce *a, int tolerant, char **msg);
-struct dentry *mce_get_debugfs_dir(void);
 
 extern int mce_ser;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..262f692 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2170,6 +2170,7 @@ struct dentry *mce_get_debugfs_dir(void)
 
 	return dmce;
 }
+EXPORT_SYMBOL_GPL(mce_get_debugfs_dir);
 
 static void mce_reset(void)
 {
-- 
1.7.4.rc2

