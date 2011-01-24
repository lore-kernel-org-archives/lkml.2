Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1AXSKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:10:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1AXSIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:04 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 11/16] KVM-HDR: KVM Steal time implementation
Date: Mon, 24 Jan 2011 13:06:32 -0500
Message-Id: <1295892397-11354-12-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement steal time, we need the hypervisor to pass the guest information
about how much time was spent running other processes outside the VM.
This is per-vcpu, and using the kvmclock structure for that is an abuse
we decided not to make.

This patch contains the headers for it. I am keeping it separate to facilitate
backports to people who wants to backport the kernel part but not the
hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 4df93cf..1ca49d8 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -46,8 +46,13 @@ struct kvm_memory_area {
 	__u8  pad[3];
 };
 
+struct kvm_steal_time {
+	__u64 steal;
+};
+
 #define KVM_AREA_WALLCLOCK		1
 #define KVM_AREA_SYSTIME		2
+#define KVM_AREA_STEAL_TIME		3
 
 #define KVM_MAX_MMU_OP_BATCH           32
 
-- 
1.7.2.3

