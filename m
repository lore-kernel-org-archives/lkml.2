Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2L1TT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55623 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932418Ab2L1TTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:40 -0500
Message-Id: <20121228190338.081339835@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Graf <agraf@suse.de>
Subject: [ 039/173] KVM: PPC: 44x: fix DCR read/write
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <agraf@suse.de>

commit e43a028752fed049e4bd94ef895542f96d79fa74 upstream.

When remembering the direction of a DCR transaction, we should write
to the same variable that we interpret on later when doing vcpu_run
again.

Signed-off-by: Alexander Graf <agraf@suse.de>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kvm/44x_emulate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -79,6 +79,7 @@ int kvmppc_core_emulate_op(struct kvm_ru
 				run->dcr.dcrn = dcrn;
 				run->dcr.data =  0;
 				run->dcr.is_write = 0;
+				vcpu->arch.dcr_is_write = 0;
 				vcpu->arch.io_gpr = rt;
 				vcpu->arch.dcr_needed = 1;
 				kvmppc_account_exit(vcpu, DCR_EXITS);
@@ -100,6 +101,7 @@ int kvmppc_core_emulate_op(struct kvm_ru
 				run->dcr.dcrn = dcrn;
 				run->dcr.data = kvmppc_get_gpr(vcpu, rs);
 				run->dcr.is_write = 1;
+				vcpu->arch.dcr_is_write = 1;
 				vcpu->arch.dcr_needed = 1;
 				kvmppc_account_exit(vcpu, DCR_EXITS);
 				emulated = EMULATE_DO_DCR;


