Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2DWKSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:18:22 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43776 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2DWKST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:18:19 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Xen <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 23 Apr 2012 15:30:02 +0530
Message-Id: <20120423100002.30893.60584.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V6 2/5] kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
x-cbid: 12042310-5816-0000-0000-0000023FE510
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6faa550..7354c1b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5691,7 +5691,9 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	mp_state->mp_state = vcpu->arch.mp_state;
+	mp_state->mp_state = (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
+				vcpu->arch.pv.pv_unhalted) ?
+	KVM_MP_STATE_RUNNABLE : vcpu->arch.mp_state;
 	return 0;
 }
 

