Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2L0CrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:47:04 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:37610 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2L0Cp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:45:26 -0500
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 21:45:22 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, maxim.uvarov@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v3 11/11] x86: Add Xen kexec control code size check to linker script
Date: Thu, 27 Dec 2012 03:19:00 +0100
Message-Id: <1356574740-6806-12-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1356574740-6806-11-git-send-email-daniel.kiper@oracle.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-3-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-4-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-5-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-6-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-7-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-8-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-9-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-10-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-11-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.387740
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

