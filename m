Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1AFAbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:48 -0500
Received: from kroah.org ([198.145.64.141]:36103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab1AFAbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:46 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002309.689444976@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sheng Yang <sheng@linux.intel.com>, Avi Kivity <avi@redhat.com>
Subject: [138/152] KVM: Fix OSXSAVE after migration
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sheng Yang <sheng@linux.intel.com>

commit 3ea3aa8cf67d3bbe00a19b6a4013d19efa7d0f41 upstream.

CPUID's OSXSAVE is a mirror of CR4.OSXSAVE bit. We need to update the CPUID
after migration.

KVM-Stable-Tag.
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5112,6 +5112,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
 
 	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
+	if (sregs->cr4 & X86_CR4_OSXSAVE)
+		update_cpuid(vcpu);
 	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.cr3);
 		mmu_reset_needed = 1;


