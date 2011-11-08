Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab1KHTRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:17:53 -0500
Received: from www17.your-server.de ([213.133.104.17]:57849 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1KHTRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:17:52 -0500
Subject: [PATCH] KVM: PPC: e500: Casting (void *) value returned by kmalloc
 is useless
From: Thomas Meyer <thomas@m3y3r.de>
To: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:15:59 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320779766.8062.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
--- a/arch/powerpc/kvm/e500_tlb.c 2011-11-07 19:37:27.329638682 +0100
+++ b/arch/powerpc/kvm/e500_tlb.c 2011-11-08 09:18:39.955928218 +0100
@@ -1026,11 +1026,11 @@ int kvmppc_e500_tlb_init(struct kvmppc_v
 	if (vcpu_e500->gtlb_arch[1] == NULL)
 		goto err_out_guest0;
 
-	vcpu_e500->gtlb_priv[0] = (struct tlbe_priv *)
+	vcpu_e500->gtlb_priv[0] =
 		kzalloc(sizeof(struct tlbe_priv) * KVM_E500_TLB0_SIZE, GFP_KERNEL);
 	if (vcpu_e500->gtlb_priv[0] == NULL)
 		goto err_out_guest1;
-	vcpu_e500->gtlb_priv[1] = (struct tlbe_priv *)
+	vcpu_e500->gtlb_priv[1] =
 		kzalloc(sizeof(struct tlbe_priv) * KVM_E500_TLB1_SIZE, GFP_KERNEL);
 
 	if (vcpu_e500->gtlb_priv[1] == NULL)


