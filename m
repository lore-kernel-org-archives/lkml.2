Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1GGSUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:20:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40659 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1GGSUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:20:35 -0400
From: Anupam Chanda <achanda@nicira.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        stefano.stabellini@eu.citrix.com, jeremy.fitzhardinge@citrix.com,
        eddie.dong@intel.com, linux-kernel@vger.kernel.org
Cc: achanda@nicira.com
Subject: [PATCH] Change hypervisor detection order
Date: Thu,  7 Jul 2011 11:19:48 -0700
Message-Id: <1310062788-9445-1-git-send-email-achanda@nicira.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect Xen before HyperV because in Viridian compatibility mode Xen presents
itself as HyperV.

Signed-off-by: Anupam Chanda <achanda@nicira.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/kernel/cpu/hypervisor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8095f86..ca23091 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -33,10 +33,10 @@
 static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
 	&x86_hyper_vmware,
-	&x86_hyper_ms_hyperv,
 #ifdef CONFIG_XEN_PVHVM
 	&x86_hyper_xen_hvm,
 #endif
+	&x86_hyper_ms_hyperv,
 };
 
 const struct hypervisor_x86 *x86_hyper;
-- 
1.7.2.5

