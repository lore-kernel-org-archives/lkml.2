Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2BWRni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:43:38 -0500
Received: from smtp.citrix.com ([66.165.176.89]:14225 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307Ab2BWRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:42:39 -0500
X-IronPort-AV: E=Sophos;i="4.73,470,1325480400"; 
   d="scan'208";a="22387551"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, david.vrabel@citrix.com,
        Ian.Campbell@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH-WIP 08/13] xen/arm: fix arm xen guest handle definitions
Date: Thu, 23 Feb 2012 17:48:29 +0000
Message-ID: <1330019314-20865-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__XEN__ is never defined in Linux: remove non-relevant functions and
macros

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/interface.h |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 93b0139..2ee39e8 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -9,27 +9,20 @@
 
 #include <linux/types.h>
 
-#ifdef __XEN__
-#define __DEFINE_GUEST_HANDLE(name, type) \
-    typedef struct { type *p; } __guest_handle_ ## name
-#else
 #define __DEFINE_GUEST_HANDLE(name, type) \
     typedef type * __guest_handle_ ## name
-#endif
 
 #define DEFINE_GUEST_HANDLE_STRUCT(name) \
 	__DEFINE_GUEST_HANDLE(name, struct name)
 #define DEFINE_GUEST_HANDLE(name) __DEFINE_GUEST_HANDLE(name, name)
 #define GUEST_HANDLE(name)        __guest_handle_ ## name
 
-#ifdef __XEN__
 #define set_xen_guest_handle(hnd, val)			\
 	do {						\
 		if (sizeof(hnd) == 8)			\
 			*(uint64_t *)&(hnd) = 0;	\
-		(hnd).p = val;				\
+		(hnd) = val;				\
 	} while (0)
-#endif
 
 #ifndef __ASSEMBLY__
 /* Guest handles for primitive C types. */
-- 
1.7.2.5

