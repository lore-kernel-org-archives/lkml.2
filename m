Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2KTPST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:18:19 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:60204 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab2KTPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:17:18 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 10:17:12 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 11/11] x86: Add Xen kexec control code size check to linker script
Date: Tue, 20 Nov 2012 16:04:53 +0100
Message-Id: <1353423893-23125-12-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1353423893-23125-11-git-send-email-daniel.kiper@oracle.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-4-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-5-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-6-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-7-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-8-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-9-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-10-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-11-git-send-email-daniel.kiper@oracle.com>
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

