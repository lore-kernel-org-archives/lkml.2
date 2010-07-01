Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab0GAU7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:59:51 -0400
Received: from kroah.org ([198.145.64.141]:47966 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab0GAUvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:31 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:39 2010
Message-Id: <20100701173439.541696001@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 151/164] KVM: x86: Check LMA bit before set_efer
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng Yang <sheng@linux.intel.com>

kvm_x86_ops->set_efer() would execute vcpu->arch.efer = efer, so the
checking of LMA bit didn't work.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit a3d204e28579427609c3d15d2310127ebaa47d94)
---
 arch/x86/kvm/x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -603,11 +603,11 @@ static void set_efer(struct kvm_vcpu *vc
 		}
 	}
 
-	kvm_x86_ops->set_efer(vcpu, efer);
-
 	efer &= ~EFER_LMA;
 	efer |= vcpu->arch.shadow_efer & EFER_LMA;
 
+	kvm_x86_ops->set_efer(vcpu, efer);
+
 	vcpu->arch.shadow_efer = efer;
 
 	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;


