Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2HZO7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:59:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab2HZO7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:59:18 -0400
Date: Sun, 26 Aug 2012 18:00:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH for-3.6] kvm: fix KVM_GET_MSR for PV EOI
Message-ID: <20120826150029.GA11114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM_GET_MSR was missing support for PV EOI,
which is needed for migration.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Please consider this bugfix patch for 3.6.
Thanks!

 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91a5958..ff5e985 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1993,6 +1993,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_STEAL_TIME:
 		data = vcpu->arch.st.msr_val;
 		break;
+	case MSR_KVM_PV_EOI_EN:
+		data = vcpu->arch.pv_eoi.msr_val;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
-- 
MST
