Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0LASX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:23:58 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25448 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab0LASX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:23:56 -0500
X-IronPort-AV: E=Sophos;i="4.59,284,1288584000"; 
   d="scan'208";a="124875295"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 5/5] xen: unplug the emulated devices at resume time
Date: Wed,  1 Dec 2010 18:23:30 +0000
Message-Id: <1291227810-15094-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
X-OriginalArrivalTime: 01 Dec 2010 18:23:55.0689 (UTC) FILETIME=[E9F29190:01CB9184]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Early after being resumed we need to unplug again the emulated devices.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/platform-pci-unplug.c |    2 +-
 arch/x86/xen/suspend.c             |    1 +
 arch/x86/xen/xen-ops.h             |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
index 0f45638..25c52f9 100644
--- a/arch/x86/xen/platform-pci-unplug.c
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -68,7 +68,7 @@ static int __init check_platform_magic(void)
 	return 0;
 }
 
-void __init xen_unplug_emulated_devices(void)
+void xen_unplug_emulated_devices(void)
 {
 	int r;
 
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 1d789d5..9bbd63a 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -31,6 +31,7 @@ void xen_hvm_post_suspend(int suspend_cancelled)
 	int cpu;
 	xen_hvm_init_shared_info();
 	xen_callback_vector();
+	xen_unplug_emulated_devices();
 	if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
 		for_each_online_cpu(cpu) {
 			xen_setup_runstate_info(cpu);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 6404474..9d41bf9 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -43,7 +43,7 @@ void xen_vcpu_restore(void);
 
 void xen_callback_vector(void);
 void xen_hvm_init_shared_info(void);
-void __init xen_unplug_emulated_devices(void);
+void xen_unplug_emulated_devices(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
 
-- 
1.5.6.5

