Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab2EJRmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:42:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760712Ab2EJRg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:28 -0400
Message-Id: <20120510173136.455551655@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nadav HarEl <nyh@il.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, Avi Kivity <avi@redhat.com>
Subject: [ 41/52] KVM: nVMX: Fix erroneous exception bitmap check
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Nadav Har'El <nyh@math.technion.ac.il>

(cherry picked from commit 9587190107d0c0cbaccbf7bf6b0245d29095a9ae)

The code which checks whether to inject a pagefault to L1 or L2 (in
nested VMX) was wrong, incorrect in how it checked the PF_VECTOR bit.
Thanks to Dan Carpenter for spotting this.

Signed-off-by: Nadav Har'El <nyh@il.ibm.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1678,7 +1678,7 @@ static int nested_pf_handled(struct kvm_
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 	/* TODO: also check PFEC_MATCH/MASK, not just EB.PF. */
-	if (!(vmcs12->exception_bitmap & PF_VECTOR))
+	if (!(vmcs12->exception_bitmap & (1u << PF_VECTOR)))
 		return 0;
 
 	nested_vmx_vmexit(vcpu);


