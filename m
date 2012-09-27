Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2I0SWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:22:35 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47488 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2I0SW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:22:28 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:22:16 EDT
From: Daniel Kiper <daniel.kiper@oracle.com>
To: konrad.wilk@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 11/11] x86: Add Xen kexec control code size check to linker script
Date: Thu, 27 Sep 2012 20:06:38 +0200
Message-Id: <1348769198-29580-12-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1348769198-29580-11-git-send-email-daniel.kiper@oracle.com>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-8-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-9-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-10-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-11-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.015652
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Xen kexec control code size check to linker script.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/kernel/vmlinux.lds.S |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 22a1530..f18786a 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -360,5 +360,10 @@ INIT_PER_CPU(irq_stack_union);
 
 . = ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
            "kexec control code size is too big");
-#endif
 
+#ifdef CONFIG_XEN
+. = ASSERT(xen_kexec_control_code_size - xen_relocate_kernel <=
+		KEXEC_CONTROL_CODE_MAX_SIZE,
+		"Xen kexec control code size is too big");
+#endif
+#endif
-- 
1.5.6.5

