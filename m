Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab0DVUf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:35:56 -0400
Received: from kroah.org ([198.145.64.141]:37519 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab0DVT2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:14 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:12 2010
Message-Id: <20100422190912.754331356@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [060/197] KVM: VMX: Disable unrestricted guest when EPT disabled
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Sheng Yang <sheng@linux.intel.com>

commit 046d87103addc117f0d397196e85189722d4d7de upstream

Otherwise would cause VMEntry failure when using ept=0 on unrestricted guest
supported processors.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2302,8 +2302,10 @@ static int vmx_vcpu_setup(struct vcpu_vm
 				~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
 		if (vmx->vpid == 0)
 			exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
-		if (!enable_ept)
+		if (!enable_ept) {
 			exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+			enable_unrestricted_guest = 0;
+		}
 		if (!enable_unrestricted_guest)
 			exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);


