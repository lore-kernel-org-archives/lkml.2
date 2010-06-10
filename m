Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab0FJLNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:13:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39175 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0FJLKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:48 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: avi@redhat.com, kvm@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [11/23] KVM: Fix KVM_SET_SIGNAL_MASK
Message-Id: <20100610111047.1ED28B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Real bug fix.

When the user passed in a NULL mask pass this on from the ioctl
handler.

Found by gcc 4.6's new warnings.

Cc: avi@redhat.com
Cc: kvm@vger.kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35-rc2-gcc/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/virt/kvm/kvm_main.c
+++ linux-2.6.35-rc2-gcc/virt/kvm/kvm_main.c
@@ -1520,7 +1520,7 @@ out_free2:
 				goto out;
 			p = &sigset;
 		}
-		r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
+		r = kvm_vcpu_ioctl_set_sigmask(vcpu, p);
 		break;
 	}
 	case KVM_GET_FPU: {
