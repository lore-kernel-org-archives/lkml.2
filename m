Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2BUUD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab2BUUDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:55 -0500
Date: Tue, 21 Feb 2012 15:03:21 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        avi@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Message-Id: <efe2bfe6e4d46d5e489b012f484d5334fc7029ac.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 08/10] kvm: update to use very_unlikely()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kvm with api change: static_branch() -> very_unlikely().

Cc: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kvm/mmu_audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index fe15dcc..7709e02 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -250,7 +250,7 @@ static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 
 static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
-	if (static_branch((&mmu_audit_key)))
+	if (very_unlikely((&mmu_audit_key)))
 		__kvm_mmu_audit(vcpu, point);
 }
 
-- 
1.7.7.5

