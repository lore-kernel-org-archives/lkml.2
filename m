Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0J0JGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:06:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60875 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab0J0JG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:06:29 -0400
Message-ID: <4CC7EC9B.6020507@cn.fujitsu.com>
Date: Wed, 27 Oct 2010 17:10:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 8/8] KVM: add debugfs file to show the number of async pf
References: <4CC7EA7D.5020901@cn.fujitsu.com>
In-Reply-To: <4CC7EA7D.5020901@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can help us to see the state of async pf

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0e7ad0..2dd8059 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -88,6 +88,8 @@ static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffffeULL;
 
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+#define VCPU_ASYNC_PF_STAT offsetof(struct kvm_vcpu, async_pf.queued), \
+							KVM_STAT_VCPU
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
@@ -141,6 +143,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "insn_emulation_fail", VCPU_STAT(insn_emulation_fail) },
 	{ "irq_injections", VCPU_STAT(irq_injections) },
 	{ "nmi_injections", VCPU_STAT(nmi_injections) },
+	{ "async_pf_queued", VCPU_ASYNC_PF_STAT},
 	{ "mmu_shadow_zapped", VM_STAT(mmu_shadow_zapped) },
 	{ "mmu_pte_write", VM_STAT(mmu_pte_write) },
 	{ "mmu_pte_updated", VM_STAT(mmu_pte_updated) },
-- 
1.7.0.4

