Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2JTSUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:20:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35190 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab2JTSUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:20:12 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH] kvm, svm: Cleanup error statements
Date: Sat, 20 Oct 2012 20:20:04 +0200
Message-Id: <1350757204-14547-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __func__ instead of the function name in svm_hardware_enable since
those things tend to get out of sync. This also slims down printk line
length in conjunction with using pr_err.

No functionality change.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kvm/svm.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d017df3899ef..e93908fabf46 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -630,15 +630,12 @@ static int svm_hardware_enable(void *garbage)
 		return -EBUSY;
 
 	if (!has_svm()) {
-		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n",
-		       me);
+		pr_err("%s: err EOPNOTSUPP on %d\n", __func__, me);
 		return -EINVAL;
 	}
 	sd = per_cpu(svm_data, me);
-
 	if (!sd) {
-		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
-		       me);
+		pr_err("%s: svm_data is NULL on %d\n", __func__, me);
 		return -EINVAL;
 	}
 
-- 
1.8.0.rc2

