Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab2AFOGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:06:22 -0500
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:37530 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755950Ab2AFOGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:06:21 -0500
Subject: [PATCH] KVM: MMU: unnecessary NX state assignment
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 06 Jan 2012 15:06:18 +0100
Message-ID: <1325858778.3395.4.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

We can remove the first ->nx state assignment since it is assigned afterwards anyways.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/mmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f1b36cf..efc0dd2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3320,7 +3320,6 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_cr3 = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->nx = is_nx(vcpu);
 
 	if (!is_paging(vcpu)) {
 		context->nx = false;
-- 
1.7.4.1



