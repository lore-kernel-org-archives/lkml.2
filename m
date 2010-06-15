Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0FOHe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab0FOHe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:56 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 14/17] Fix SVM VMCB reset
Date: Mon, 14 Jun 2010 21:34:16 -1000
Message-Id: <1276587259-32319-15-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On reset, VMCB TSC should be set to zero.  Instead, code was setting
tsc_offset to zero, which passes through the underlying TSC.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4654507..a032e62 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -767,7 +767,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
-	control->tsc_offset = 0;
+	guest_write_tsc(&svm->vcpu, 0);
 	control->int_ctl = V_INTR_MASKING_MASK;
 
 	init_seg(&save->es);
-- 
1.7.1

