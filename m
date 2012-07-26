Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2GZPex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:34:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:29921 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab2GZPew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:34:52 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="32688368"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 04/24] xen/arm: sync_bitops
Date: Thu, 26 Jul 2012 16:33:46 +0100
Message-ID: <1343316846-25860-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
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
index 0000000..d975092903
--- /dev/null
+++ b/arch/arm/include/asm/sync_bitops.h
@@ -0,0 +1,17 @@
+#ifndef __ASM_SYNC_BITOPS_H__
+#define __ASM_SYNC_BITOPS_H__
+
+#include <asm/bitops.h>
+#include <asm/system.h>
+
+#define sync_set_bit(nr, p)		_set_bit(nr, p)
+#define sync_clear_bit(nr, p)		_clear_bit(nr, p)
+#define sync_change_bit(nr, p)		_change_bit(nr, p)
+#define sync_test_and_set_bit(nr, p)	_test_and_set_bit(nr, p)
+#define sync_test_and_clear_bit(nr, p)	_test_and_clear_bit(nr, p)
+#define sync_test_and_change_bit(nr, p)	_test_and_change_bit(nr, p)
+#define sync_test_bit(nr, addr)		test_bit(nr, addr)
+#define sync_cmpxchg			cmpxchg
+
+
+#endif
-- 
1.7.2.5

