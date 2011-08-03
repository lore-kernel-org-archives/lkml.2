Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1HCS4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:56:08 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48517 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1HCS4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:56:05 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/kvm: fix build errors with older toolchains
Date: Wed,  3 Aug 2011 11:55:54 -0700
Message-Id: <1312397755-15737-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a box with gcc 4.3.2, I see errors like:

arch/powerpc/kvm/book3s_hv_rmhandlers.S:1254: Error: Unrecognized opcode: stxvd2x
arch/powerpc/kvm/book3s_hv_rmhandlers.S:1316: Error: Unrecognized opcode: lxvd2x

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 6dd3358..de29501 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1251,7 +1251,7 @@ BEGIN_FTR_SECTION
 	reg = 0
 	.rept	32
 	li	r6,reg*16+VCPU_VSRS
-	stxvd2x	reg,r6,r3
+	STXVD2X(reg,r6,r3)
 	reg = reg + 1
 	.endr
 FTR_SECTION_ELSE
@@ -1313,7 +1313,7 @@ BEGIN_FTR_SECTION
 	reg = 0
 	.rept	32
 	li	r7,reg*16+VCPU_VSRS
-	lxvd2x	reg,r7,r4
+	LXVD2X(reg,r7,r4)
 	reg = reg + 1
 	.endr
 FTR_SECTION_ELSE
-- 
1.7.4.1

