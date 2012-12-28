Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2L1Tac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:30:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55567 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932272Ab2L1TT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:26 -0500
Message-Id: <20121228190343.166661855@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 062/173] powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 11ee7e99f35ecb15f59b21da6a82d96d2cd3fcc8 upstream.

If we build a kernel with CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n,
the kernel fails when we run at a non zero offset. It turns out
we were incorrectly wrapping some of the relocatable kernel code
with CONFIG_CRASH_DUMP.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 694e3fa..11a4df9 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -422,7 +422,7 @@ _STATIC(__after_prom_start)
 	tovirt(r6,r6)			/* on booke, we already run at PAGE_OFFSET */
 #endif
 
-#ifdef CONFIG_CRASH_DUMP
+#ifdef CONFIG_RELOCATABLE
 /*
  * Check if the kernel has to be running as relocatable kernel based on the
  * variable __run_at_load, if it is set the kernel is treated as relocatable


