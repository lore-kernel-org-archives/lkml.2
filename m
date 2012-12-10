Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2LJV2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:28:35 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:41076 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2LJV2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:28:33 -0500
Message-ID: <50C653ED.9000009@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 15:28:13 -0600
From: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: KVM list <kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm/vmx: fix the return value of handle_vmcall()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121021-7606-0000-0000-0000065165B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The return value of kvm_emulate_hypercall() is intended to inform callers
whether or not we need to exit to userspace. However, handle_vmcall()
currently ignores the return value.

This patch simply propogates the return value from kvm_emulate_hypercall()
to callers so that it can be acted upon appropriately.

Signed-off-by: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f858159..8b37f5f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4682,8 +4682,7 @@ static int handle_halt(struct kvm_vcpu *vcpu)
 static int handle_vmcall(struct kvm_vcpu *vcpu)
 {
 	skip_emulated_instruction(vcpu);
-	kvm_emulate_hypercall(vcpu);
-	return 1;
+	return kvm_emulate_hypercall(vcpu);
 }
 
 static int handle_invd(struct kvm_vcpu *vcpu)
-- 
1.7.11.7

Jesse Larrew
Software Engineer, KVM Team
IBM Linux Technology Center
Phone: (512) 973-2052 (T/L: 363-2052)
jlarrew@linux.vnet.ibm.com

