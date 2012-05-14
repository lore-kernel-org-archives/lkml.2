Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2ENG7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:59:53 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39448 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2ENG7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:59:51 -0400
Message-ID: <4FB0AD32.6020104@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 14:58:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: VMX: unlike vmcs on fail path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12051320-7014-0000-0000-000001250191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:

[ 1529.577273] Call Trace:
[ 1529.577289]  [<ffffffffa060d58f>] kvm_arch_hardware_disable+0x13/0x30 [kvm]
[ 1529.577302]  [<ffffffffa05fa2d4>] hardware_disable_nolock+0x35/0x39 [kvm]
[ 1529.577311]  [<ffffffffa05fa29f>] ? cpumask_clear_cpu.constprop.31+0x13/0x13 [kvm]
[ 1529.577315]  [<ffffffff81096ba8>] on_each_cpu+0x44/0x84
[ 1529.577326]  [<ffffffffa05f98b5>] hardware_disable_all_nolock+0x34/0x36 [kvm]
[ 1529.577335]  [<ffffffffa05f98e2>] hardware_disable_all+0x2b/0x39 [kvm]
[ 1529.577349]  [<ffffffffa05fafe5>] kvm_put_kvm+0xed/0x10f [kvm]
[ 1529.577358]  [<ffffffffa05fb3d7>] kvm_vm_release+0x22/0x28 [kvm]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c98057..5203428 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6354,7 +6354,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	return &vmx->vcpu;

 free_vmcs:
-	free_vmcs(vmx->loaded_vmcs->vmcs);
+	free_loaded_vmcs(vmx->loaded_vmcs);
 free_msrs:
 	kfree(vmx->guest_msrs);
 uninit_vcpu:
-- 
1.7.7.6

