Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2HFOzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:55:54 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52257 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2HFOzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:55:52 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="204279800"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 19/23] xen/arm: compile blkfront and blkback
Date: Mon, 6 Aug 2012 15:27:22 +0100
Message-ID: <1344263246-28036-19-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/block/xen-blkback/blkback.c  |    1 +
 include/xen/interface/io/protocols.h |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 73f196c..63dd5b9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -42,6 +42,7 @@
 
 #include <xen/events.h>
 #include <xen/page.h>
+#include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include "common.h"
diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
index 01fc8ae..0eafaf2 100644
--- a/include/xen/interface/io/protocols.h
+++ b/include/xen/interface/io/protocols.h
@@ -5,6 +5,7 @@
 #define XEN_IO_PROTO_ABI_X86_64     "x86_64-abi"
 #define XEN_IO_PROTO_ABI_IA64       "ia64-abi"
 #define XEN_IO_PROTO_ABI_POWERPC64  "powerpc64-abi"
+#define XEN_IO_PROTO_ABI_ARM        "arm-abi"
 
 #if defined(__i386__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_X86_32
@@ -14,6 +15,8 @@
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
 #elif defined(__powerpc64__)
 # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
+#elif defined(__arm__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_ARM
 #else
 # error arch fixup needed here
 #endif
-- 
1.7.2.5

