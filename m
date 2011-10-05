Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497Ab1JEMBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:01:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab1JEMBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:01:42 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH v2 9/9] KVM, VMX: Check for automatic switch msr table overflow.
Date: Wed,  5 Oct 2011 14:01:24 +0200
Message-Id: <1317816084-18026-10-git-send-email-gleb@redhat.com>
In-Reply-To: <1317816084-18026-1-git-send-email-gleb@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/vmx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d0d4afa..6e28d58 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1280,7 +1280,11 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 		if (m->guest[i].index == msr)
 			break;
 
-	if (i == m->nr) {
+	if (i == NR_AUTOLOAD_MSRS) {
+		printk_once(KERN_WARNING"Not enough mst switch entries. "
+				"Can't add msr %x\n", msr);
+		return;
+	} else if (i == m->nr) {
 		++m->nr;
 		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
-- 
1.7.5.3

