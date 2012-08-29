Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2H2Xce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:32:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2H2Xbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:44 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/8] KVM: SVM: constify lookup tables
Date: Thu, 30 Aug 2012 01:30:20 +0200
Message-Id: <1346283020-22385-9-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never modify direct_access_msrs[], msrpm_ranges[],
svm_exit_handlers[] or x86_intercept_map[] at runtime.
Mark them r/o.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 31be4a5..611c728 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -163,7 +163,7 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
 #define MSR_INVALID			0xffffffffU
 
-static struct svm_direct_access_msrs {
+static const struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is always on */
 } direct_access_msrs[] = {
@@ -400,7 +400,7 @@ struct svm_init_data {
 	int r;
 };
 
-static u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
+static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
 #define NUM_MSR_MAPS ARRAY_SIZE(msrpm_ranges)
 #define MSRS_RANGE_SIZE 2048
@@ -3267,7 +3267,7 @@ static int pause_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
-static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
+static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
 	[SVM_EXIT_READ_CR4]			= cr_interception,
@@ -4068,7 +4068,7 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 #define POST_MEM(exit) { .exit_code = (exit), \
 			.stage = X86_ICPT_POST_MEMACCESS, }
 
-static struct __x86_intercept {
+static const struct __x86_intercept {
 	u32 exit_code;
 	enum x86_intercept_stage stage;
 } x86_intercept_map[] = {
-- 
1.7.10.4

