Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2EVKxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:53:20 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:47510 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab2EVKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:53:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frank Arnold <frank.arnold@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] x86, bitops: Move BIT_64 for a wider use
Date: Tue, 22 May 2012 12:53:45 +0200
Message-Id: <1337684026-19740-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Needed for shifting 64-bit values on 32-bit, like MSR values, for
example.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/bitops.h |    2 ++
 drivers/edac/mce_amd.h        |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index b97596e2b68c..a6983b277220 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -15,6 +15,8 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 
+#define BIT_64(n)			(U64_C(1) << (n))
+
 /*
  * These have to be done with inline assembly: that way the bit-setting
  * is guaranteed to be atomic. All bit operations return 0 if the bit
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index c6074c5cd1ef..8c87a5e87057 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -5,8 +5,6 @@
 
 #include <asm/mce.h>
 
-#define BIT_64(n)			(U64_C(1) << (n))
-
 #define EC(x)				((x) & 0xffff)
 #define XEC(x, mask)			(((x) >> 16) & mask)
 
-- 
1.7.9.3.362.g71319

