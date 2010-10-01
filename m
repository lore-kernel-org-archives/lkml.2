Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0JAHHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:07:06 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45900 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab0JAHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:35 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Michal Marek <mmarek@suse.cz>, Tim Abbott <tabbott@ksplice.com>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 18/18] powerpc: Fix jiffies variable on little endian
Date: Fri,  1 Oct 2010 17:06:11 +1000
Message-Id: <1285916771-18033-19-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

The vmlinux linker script sets the jiffies variable to the low word of
the jiffies_64 variable. This patch corrects which word is used on
little endian.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/kernel/vmlinux.lds.S |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8a0deef..7a9010f 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -34,8 +34,12 @@ OUTPUT_ARCH(powerpc:common64)
 jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(powerpc:common)
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+jiffies = jiffies_64;
+#else
 jiffies = jiffies_64 + 4;
 #endif
+#endif
 SECTIONS
 {
 	. = 0;
-- 
1.7.1

