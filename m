Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1AXSIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab1AXSID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:03 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 08/16] KVM-HDR: Implement kvmclock systemtime over KVM - KVM Virtual Memory
Date: Mon, 24 Jan 2011 13:06:29 -0500
Message-Id: <1295892397-11354-9-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a proof of concept to KVM - Kernel Virtual Memory, this patch
implements kvmclock per-vcpu systime grabbing on top of it. At first, it
may seem as a waste of work to just redo it, since it is working well. But over
the time, other MSRs were added - think ASYNC_PF - and more will probably come.
After this patch, we won't need to ever add another virtual MSR to KVM.

If the hypervisor fails to register the memory area, we switch back to legacy
behavior on things that were already present - like kvm clock.

This patch contains the headers for it. I am keeping it separate to facilitate
backports to people who wants to backport the kernel part but not the
hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index de088c8..4df93cf 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -47,6 +47,7 @@ struct kvm_memory_area {
 };
 
 #define KVM_AREA_WALLCLOCK		1
+#define KVM_AREA_SYSTIME		2
 
 #define KVM_MAX_MMU_OP_BATCH           32
 
-- 
1.7.2.3

