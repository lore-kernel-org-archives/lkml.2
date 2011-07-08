Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1GHSnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:43:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62148 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GHSnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:43:01 -0400
From: Anupam Chanda <achanda@nicira.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        stefano.stabellini@eu.citrix.com, jeremy.fitzhardinge@citrix.com,
        eddie.dong@intel.com, linux-kernel@vger.kernel.org
Cc: achanda@nicira.com
Subject: [PATCH] Change hypervisor detection order
Date: Fri,  8 Jul 2011 11:42:50 -0700
Message-Id: <1310150570-26810-1-git-send-email-achanda@nicira.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect Xen before HyperV because in Viridian compatibility mode Xen presents
itself as HyperV.

Signed-off-by: Anupam Chanda <achanda@nicira.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/hypervisor.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8095f86..755f64f 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -32,11 +32,11 @@
  */
 static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
-	&x86_hyper_vmware,
-	&x86_hyper_ms_hyperv,
 #ifdef CONFIG_XEN_PVHVM
 	&x86_hyper_xen_hvm,
 #endif
+	&x86_hyper_vmware,
+	&x86_hyper_ms_hyperv,
 };
 
 const struct hypervisor_x86 *x86_hyper;
-- 
1.7.2.5

