Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1GJNx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 09:53:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60837 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab1GJNxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 09:53:24 -0400
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: Simplify X86_CMPXCHG, CMPXCHG_LOCAL, and X86_XADD
Date: Sun, 10 Jul 2011 09:53:20 -0400
Message-Id: <1310306000-2447-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
References: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_64 and M386 can never be both set, so reduce the conditional to !M386.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/Kconfig.cpu |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index d801dfe..a913325 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -307,10 +307,10 @@ config X86_INTERNODE_CACHE_SHIFT
 	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
-	def_bool X86_64 || (X86_32 && !M386)
+	def_bool !M386
 
 config CMPXCHG_LOCAL
-	def_bool X86_64 || (X86_32 && !M386)
+	def_bool !M386
 
 config X86_L1_CACHE_SHIFT
 	int
@@ -320,8 +320,7 @@ config X86_L1_CACHE_SHIFT
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
 config X86_XADD
-	def_bool y
-	depends on X86_64 || !M386
+	def_bool !M386
 
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
-- 
1.7.4.4

