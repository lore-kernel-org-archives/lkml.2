Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1BWRqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:46:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab1BWRqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:46:31 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] expose kvmclock upper msr set.
Date: Wed, 23 Feb 2011 12:44:14 -0500
Message-Id: <1298483054-1665-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
for a while now, but we're not exposing it yet, meaning nobody is using it.
This simple patch takes care of that.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/x86.c  |    1 +
 include/linux/kvm.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8575d85..c0808db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1966,6 +1966,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_SET_TSS_ADDR:
 	case KVM_CAP_EXT_CPUID:
 	case KVM_CAP_CLOCKSOURCE:
+	case KVM_CAP_CLOCKSOURCE2:
 	case KVM_CAP_PIT:
 	case KVM_CAP_NOP_IO_DELAY:
 	case KVM_CAP_MP_STATE:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ea2dc1a..a15d2e8 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -541,6 +541,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
 #define KVM_CAP_ASYNC_PF 59
+#define KVM_CAP_CLOCKSOURCE2 60 /* hypervisor supports MSRs at upper range */
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.7.3.4

