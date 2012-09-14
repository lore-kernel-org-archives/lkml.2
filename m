Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab2INLl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:41:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9235 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758708Ab2INLlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:41:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="37874972"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 19/24] xen/arm: compile blkfront and blkback
Date: Fri, 14 Sep 2012 12:13:21 +0100
Message-ID: <1347621207-11294-19-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

