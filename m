Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab1GUWi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 18:38:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1GUWiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 18:38:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=FEn/W7k0RGWyj60wjklEeVQf4Z+w8wIWs84RPGYlPVV2xBbRFmCM3mTpxBu3YU77u
	QjXxtRbGFsSYlVQVVbm6w==
From: Mike Waychison <mikew@google.com>
To: Cory Maccarrone <maccarro@google.com>, Andy Thornton <andrewth@google.com>,
        Miche Baker-Harvey <miche@google.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] kvm: get_msr support for HV_X64_MSR_APIC_ASSIST_PAGE
Date: Thu, 21 Jul 2011 15:38:10 -0700
Message-Id: <1311287890-22124-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"get" support for the HV_X64_MSR_APIC_ASSIST_PAGE msr was missing, even
though it is explicitly enumerated as something the vmm should save in
msrs_to_save and reported to userland via the KVM_GET_MSR_INDEX_LIST
ioctl.

Add "get" support for HV_X64_MSR_APIC_ASSIST_PAGE.  We simply return the
guest visible value of this register, which seems to be correct as a set
on the register is validated for us already.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77c9d86..15148ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1748,6 +1748,8 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		return kvm_hv_vapic_msr_read(vcpu, APIC_ICR, pdata);
 	case HV_X64_MSR_TPR:
 		return kvm_hv_vapic_msr_read(vcpu, APIC_TASKPRI, pdata);
+	case HV_X64_MSR_APIC_ASSIST_PAGE:
+		return vcpu->arch.hv_vapic;
 	default:
 		pr_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
-- 
1.7.3.1

