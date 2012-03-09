Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2CIEmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:42:05 -0500
Received: from ozlabs.org ([203.10.76.45]:56601 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab2CIEmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.8104.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 1/8] ARM: KVM: Fix missing clobber (causes host oops on UP)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/kvm/arm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 3772847..f27a96b 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -585,7 +585,7 @@ static void cpu_set_vector(void *vector)
 		"smc	#0\n\t" : :
 		[vector_ptr] "r" (vector_ptr),
 		[smc_hyp_nr] "r" (smc_hyp_nr) :
-		"r0", "r1");
+		"r0", "r1", "r7");
 }
 
 static void cpu_init_hyp_mode(void *vector)

