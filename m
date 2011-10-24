Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1JXHWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:22:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64807 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1JXHWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:22:49 -0400
From: Zhao Jin <cronozhj@gmail.com>
To: avi@redhat.com, mtosatti@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: VMX: fix incorrect operand
Date: Mon, 24 Oct 2011 15:21:20 +0800
Message-Id: <1319440880-2610-3-git-send-email-cronozhj@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
References: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should test save->ar for access rights.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e65a158..62086da 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2544,7 +2544,7 @@ static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 
-	if (vmcs_readl(sf->base) == save->base && (save->base & AR_S_MASK)) {
+	if (vmcs_readl(sf->base) == save->base && (save->ar & AR_S_MASK)) {
 		vmcs_write16(sf->selector, save->selector);
 		vmcs_writel(sf->base, save->base);
 		vmcs_write32(sf->limit, save->limit);
-- 
1.7.5.4

