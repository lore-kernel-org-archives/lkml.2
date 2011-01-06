Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1AFIcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:32:02 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:41726 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751625Ab1AFIcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:32:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: len.brown@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: [PATCH 1/1] ia64: fix build of ioremap_cache
Date: Thu,  6 Jan 2011 09:31:27 +0100
Message-Id: <1294302687-8051-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4D257CD9.8060909@gmail.com>
References: <4D257CD9.8060909@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "ACPI: use ioremap_cache()" introduced ioremap_cache which
causes build failures. Remove "unsigned long" from parameters of
called ioremap.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Len Brown <len.brown@intel.com>
---
 arch/ia64/include/asm/io.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 009a7e0..e5a6c35 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -428,7 +428,7 @@ extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
 static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
 {
-	return ioremap(unsigned long phys_addr, unsigned long size);
+	return ioremap(phys_addr, size);
 }
 
 
-- 
1.7.3.4


