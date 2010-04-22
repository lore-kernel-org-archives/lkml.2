Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab0DVUhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:37:01 -0400
Received: from kroah.org ([198.145.64.141]:37507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab0DVT2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:12 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:12 2010
Message-Id: <20100422190912.574452407@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [058/197] KVM: VMX: Use macros instead of hex value on cr0 initialization
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eduardo Habkost <ehabkost@redhat.com>

commit fa40052ca04bdbbeb20b839cc8ffe9fa7beefbe9 upstream

This should have no effect, it is just to make the code clearer.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2510,7 +2510,7 @@ static int vmx_vcpu_reset(struct kvm_vcp
 	if (vmx->vpid != 0)
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 
-	vmx->vcpu.arch.cr0 = 0x60000010;
+	vmx->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
 	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.arch.cr0); /* enter rmode */
 	vmx_set_cr4(&vmx->vcpu, 0);
 	vmx_set_efer(&vmx->vcpu, 0);


