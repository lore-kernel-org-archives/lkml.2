Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2D3PUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 11:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab2D3PUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 11:20:44 -0400
Date: Mon, 30 Apr 2012 17:39:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: davej@redhat.com
Subject: [PATCH] kvm: fix cpuid eax
Message-ID: <20120430143902.GA10181@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuid eax should return the max leaf so that
guests can find out the valid range.
This matches Xen et al.

Tested using -cpu host.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/cpuid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7d00d2d..bda4877 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -397,7 +397,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	case KVM_CPUID_SIGNATURE: {
 		char signature[12] = "KVMKVMKVM\0\0";
 		u32 *sigptr = (u32 *)signature;
-		entry->eax = 0;
+		entry->eax = KVM_CPUID_FEATURES;
 		entry->ebx = sigptr[0];
 		entry->ecx = sigptr[1];
 		entry->edx = sigptr[2];
-- 
MST
