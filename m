Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2BWRmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:42:39 -0500
Received: from smtp.citrix.com ([66.165.176.89]:14225 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab2BWRmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:42:37 -0500
X-IronPort-AV: E=Sophos;i="4.73,470,1325480400"; 
   d="scan'208";a="22387548"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, david.vrabel@citrix.com,
        Ian.Campbell@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH-WIP 04/13] xen/arm: sync_bitops
Date: Thu, 23 Feb 2012 17:48:25 +0000
Message-ID: <1330019314-20865-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_bitops functions are equivalent to the SMP implementation of the
original functions, independently from CONFIG_SMP being defined.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/sync_bitops.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/sync_bitops.h

diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
new file mode 100644
index 0000000..2b51456
--- /dev/null
+++ b/arch/arm/include/asm/sync_bitops.h
@@ -0,0 +1,17 @@
+#ifndef __ASM_SYNC_BITOPS_H__
+#define __ASM_SYNC_BITOPS_H__
+
+#include <asm/bitops.h>
+#include <asm/system.h>
+
+#define sync_set_bit(nr,p)		_set_bit(nr,p)
+#define sync_clear_bit(nr,p)		_clear_bit(nr,p)
+#define sync_change_bit(nr,p)		_change_bit(nr,p)
+#define sync_test_and_set_bit(nr,p)	_test_and_set_bit(nr,p)
+#define sync_test_and_clear_bit(nr,p)	_test_and_clear_bit(nr,p)
+#define sync_test_and_change_bit(nr,p)	_test_and_change_bit(nr,p)
+#define sync_test_bit(nr, addr)		test_bit(nr, addr)
+#define sync_cmpxchg			cmpxchg
+
+
+#endif
-- 
1.7.2.5

