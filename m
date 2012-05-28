Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab2E1D4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:56:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51810 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203Ab2E1D25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:57 -0400
Message-Id: <20120528031203.461134868@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Nadav HarEl <nyh@math.technion.ac.il>, Nadav HarEl <nyh@il.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, Avi Kivity <avi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 004/117] KVM: nVMX: Fix erroneous exception bitmap check
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

From: Nadav Har'El <nyh@math.technion.ac.il>

(cherry picked from commit 9587190107d0c0cbaccbf7bf6b0245d29095a9ae)

The code which checks whether to inject a pagefault to L1 or L2 (in
nested VMX) was wrong, incorrect in how it checked the PF_VECTOR bit.
Thanks to Dan Carpenter for spotting this.

Signed-off-by: Nadav Har'El <nyh@il.ibm.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4ea7678..7ac5993 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1677,7 +1677,7 @@ static int nested_pf_handled(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 	/* TODO: also check PFEC_MATCH/MASK, not just EB.PF. */
-	if (!(vmcs12->exception_bitmap & PF_VECTOR))
+	if (!(vmcs12->exception_bitmap & (1u << PF_VECTOR)))
 		return 0;
 
 	nested_vmx_vmexit(vcpu);


