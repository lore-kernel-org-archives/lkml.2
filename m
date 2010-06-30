Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0F3QEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:04:08 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40204 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756783Ab0F3QED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:04:03 -0400
Date: Wed, 30 Jun 2010 18:04:01 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Russell King <linux@arm.linux.org.uk>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 32/33] Removing dead CPU_ICACHE_STREAMING_DISABLE
Message-ID: <c09196cb2149f5a1a845ead405b73add3c1a804f.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_ICACHE_STREAMING_DISABLE doesn't exist in Kconfig, therefore
removing all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mm/proc-arm925.S |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/proc-arm925.S b/arch/arm/mm/proc-arm925.S
index 3c6cffe..2a3bb73 100644
--- a/arch/arm/mm/proc-arm925.S
+++ b/arch/arm/mm/proc-arm925.S
@@ -437,9 +437,6 @@ ENTRY(cpu_arm925_set_pte_ext)
 	.type	__arm925_setup, #function
 __arm925_setup:
 	mov	r0, #0
-#if defined(CONFIG_CPU_ICACHE_STREAMING_DISABLE)
-        orr     r0,r0,#1 << 7
-#endif
 
 	/* Transparent on, D-cache clean & flush mode. See  NOTE2 above */
         orr     r0,r0,#1 << 1			@ transparent mode on
-- 
1.7.0.4

