Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0GEXFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 19:05:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48562 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0GEXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 19:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=UBTEUsQp5OvULnXOldm9/b9OPHcdwqpCeZDuxUF6LA98kOQFIMzE43tlMeQ0vWtA66
         1bGNMd/EDTfxNlbMDjFn0wrxVSP/dZw2cmRI7HiHO4WuFxm5kozaF055Nx0X67eSBXPT
         rPqt7qy4uCrylzRkBQf4qXg8+XgjEIft7huDo=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] dmar: Fix statement with no effect warning in include/linux/dmar.h
Date: Mon,  5 Jul 2010 20:04:54 -0300
Message-Id: <1278371094-14393-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Dan Williams <dan.j.williams@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the CONFIG_INTR_REMAP=N case, most dmar functions become one-
line static inline functions.  However a few functions were instead
defined to constants.  This causes the following warnings for me:

arch/x86/kernel/apic/apic.c: In function ‘lapic_suspend’:
arch/x86/kernel/apic/apic.c:2014:3: warning: statement with no effect
arch/x86/kernel/apic/apic.c: In function ‘lapic_resume’:
arch/x86/kernel/apic/apic.c:2091:3: warning: statement with no effect

Correct these warnings by converting the defines into static inline
functions instead.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 include/linux/dmar.h |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index d7cecc9..f6fcece 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -176,11 +176,22 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 {
 	return 0;
 }
+static inline int irq_remapped(int irq)
+{
+	return 0;
+}
+static inline int enable_intr_remapping(int mode)
+{
+	return -1;
+}
+static inline void disable_intr_remapping(void)
+{
+}
+static inline int reenable_intr_remapping(int mode)
+{
+	return 0;
+}
 
-#define irq_remapped(irq)		(0)
-#define enable_intr_remapping(mode)	(-1)
-#define disable_intr_remapping()	(0)
-#define reenable_intr_remapping(mode)	(0)
 #define intr_remapping_enabled		(0)
 #endif
 
-- 
1.7.1

