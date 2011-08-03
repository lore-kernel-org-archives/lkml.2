Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1HCQmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:42:09 -0400
Received: from mga07.intel.com ([143.182.124.22]:36372 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752654Ab1HCQmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:42:05 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Aug 2011 12:42:05 EDT
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] xen: asm/io.h should not include xen.h if XEN is disabled
Date: Wed,  3 Aug 2011 19:33:00 +0300
Message-Id: <049cae3c2e2923ea7efbd205257e9e22b3df5e1a.1312388919.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel-devel package with kernel headers have no <include/xen> directory
if XEN is disabled. Modules which inclide asm/io.h won't compile.

XEN related content is behind the CONFIG_XEN flag in the io.h.
And <xen/xen.h> should be also behind CONFIG_XEN flag.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 arch/x86/include/asm/io.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 0722730..ef26712 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -41,7 +41,9 @@
 #include <asm-generic/int-ll64.h>
 #include <asm/page.h>
 
+#ifdef CONFIG_XEN
 #include <xen/xen.h>
+#endif
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
-- 
1.7.4.1

