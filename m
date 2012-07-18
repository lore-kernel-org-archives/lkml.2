Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2GRItC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 04:49:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab2GRIsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 04:48:55 -0400
From: Avi Kivity <avi@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, hyper: fix build with !CONFIG_KVM_GUEST
Date: Wed, 18 Jul 2012 11:48:50 +0300
Message-Id: <1342601330-11044-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/cpu/hypervisor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 6d6dd7a..a8f8fa9 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -37,7 +37,9 @@
 #endif
 	&x86_hyper_vmware,
 	&x86_hyper_ms_hyperv,
+#ifdef CONFIG_KVM_GUEST
 	&x86_hyper_kvm,
+#endif
 };
 
 const struct hypervisor_x86 *x86_hyper;
-- 
1.7.11.2

