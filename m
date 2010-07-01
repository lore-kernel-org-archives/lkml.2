Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab0GAV3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:29:38 -0400
Received: from kroah.org ([198.145.64.141]:33262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163Ab0GAVPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:30 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174302.487936206@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [189/200] KVM: Dont allow lmsw to clear cr0.pe
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

The current lmsw implementation allows the guest to clear cr0.pe, contrary
to the manual, which breaks EMM386.EXE.

Fix by ORing the old cr0.pe with lmsw's operand.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit f78e917688edbf1f14c318d2e50dc8e7dad20445)
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -484,7 +484,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-	kvm_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~0x0ful) | (msw & 0x0f));
+	kvm_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~0x0eul) | (msw & 0x0f));
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 


