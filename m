Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0EIPUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 11:20:48 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:53763 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0EIPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 11:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=FksKOb85J/vxX8tcrJ5P30c6taGKrizHb5KJRuphDylfqvNcJ+1z0TysstxhIuIVu3
         3+1aXnLXpBARIwdz/GdtgDZ+nRueSd7njfq3BZ3GFiZTWumJvrt5hEl0CkzhP5VQHvmV
         3jyXEQK7WRvep14gpEjXlXuiqR/g78mXFV/n8=
Message-ID: <4BE6D437.9000200@gmail.com>
Date: Sun, 09 May 2010 17:26:47 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, kvm-ppc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Keep index within boundaries in kvmppc_44x_emul_tlbwe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An index of KVM44x_GUEST_TLB_SIZE is already one too large.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/powerpc/kvm/44x_tlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 2570fcc..8123125 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -440,7 +440,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	unsigned int gtlb_index;
 
 	gtlb_index = kvmppc_get_gpr(vcpu, ra);
-	if (gtlb_index > KVM44x_GUEST_TLB_SIZE) {
+	if (gtlb_index >= KVM44x_GUEST_TLB_SIZE) {
 		printk("%s: index %d\n", __func__, gtlb_index);
 		kvmppc_dump_vcpu(vcpu);
 		return EMULATE_FAIL;
