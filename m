Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab2EJRlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:41:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58690 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760718Ab2EJRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:36 -0400
Message-Id: <20120510173135.941931360@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [ 35/52] KVM: s390: Sanitize fpc registers for KVM_SET_FPU
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Christian Borntraeger <borntraeger@de.ibm.com>

(cherry picked from commit 851755871c1f3184f4124c466e85881f17fa3226)

commit 7eef87dc99e419b1cc051e4417c37e4744d7b661 (KVM: s390: fix
register setting) added a load of the floating point control register
to the KVM_SET_FPU path. Lets make sure that the fpc is valid.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -418,7 +418,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	memcpy(&vcpu->arch.guest_fpregs.fprs, &fpu->fprs, sizeof(fpu->fprs));
-	vcpu->arch.guest_fpregs.fpc = fpu->fpc;
+	vcpu->arch.guest_fpregs.fpc = fpu->fpc & FPC_VALID_MASK;
 	restore_fp_regs(&vcpu->arch.guest_fpregs);
 	return 0;
 }


