Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab0GUXkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:40:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35567 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103Ab0GUXkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:40:15 -0400
Subject: [PATCH 4/5] of: remove asm/of_platform.h
To: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:40:10 -0600
Message-ID: <20100721234010.7782.3073.stgit@angua>
In-Reply-To: <20100721232817.7782.23410.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only thing left in it is of_instantiate_rtc() which can be moved to
asm/prom.h on PowerPC and is unused in microblaze.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/include/asm/of_platform.h |   19 -------------------
 arch/powerpc/include/asm/of_platform.h    |   16 ----------------
 arch/powerpc/include/asm/prom.h           |    2 ++
 arch/sparc/include/asm/of_platform.h      |   16 ----------------
 include/linux/of_platform.h               |    2 --
 5 files changed, 2 insertions(+), 53 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/of_platform.h
 delete mode 100644 arch/powerpc/include/asm/of_platform.h
 delete mode 100644 arch/sparc/include/asm/of_platform.h

diff --git a/arch/microblaze/include/asm/of_platform.h b/arch/microblaze/include/asm/of_platform.h
deleted file mode 100644
index 353d8f6..0000000
--- a/arch/microblaze/include/asm/of_platform.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
- *			<benh@kernel.crashing.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MICROBLAZE_OF_PLATFORM_H
-#define _ASM_MICROBLAZE_OF_PLATFORM_H
-
-/* This is just here during the transition */
-#include <linux/of_platform.h>
-
-extern void of_instantiate_rtc(void);
-
-#endif /* _ASM_MICROBLAZE_OF_PLATFORM_H */
diff --git a/arch/powerpc/include/asm/of_platform.h b/arch/powerpc/include/asm/of_platform.h
deleted file mode 100644
index d506aa6..0000000
--- a/arch/powerpc/include/asm/of_platform.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _ASM_POWERPC_OF_PLATFORM_H
-#define _ASM_POWERPC_OF_PLATFORM_H
-/*
- *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
- *			 <benh@kernel.crashing.org>
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License
- *  as published by the Free Software Foundation; either version
- *  2 of the License, or (at your option) any later version.
- *
- */
-
-extern void of_instantiate_rtc(void);
-
-#endif	/* _ASM_POWERPC_OF_PLATFORM_H */
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index f864722..da7dd63 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -117,5 +117,7 @@ extern const void *of_get_mac_address(struct device_node *np);
 struct pci_dev;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
+extern void of_instantiate_rtc(void);
+
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_PROM_H */
diff --git a/arch/sparc/include/asm/of_platform.h b/arch/sparc/include/asm/of_platform.h
deleted file mode 100644
index 26540dd..0000000
--- a/arch/sparc/include/asm/of_platform.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef ___ASM_SPARC_OF_PLATFORM_H
-#define ___ASM_SPARC_OF_PLATFORM_H
-/*
- *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
- *			 <benh@kernel.crashing.org>
- *    Modified for Sparc by merging parts of asm/of_device.h
- *		by Stephen Rothwell
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License
- *  as published by the Free Software Foundation; either version
- *  2 of the License, or (at your option) any later version.
- *
- */
-
-#endif
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 429513a..a79f59b 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -52,8 +52,6 @@ extern void of_unregister_platform_driver(struct of_platform_driver *drv);
 extern struct of_device *of_device_alloc(struct device_node *np,
 					 const char *bus_id,
 					 struct device *parent);
-#include <asm/of_platform.h>
-
 extern struct of_device *of_find_device_by_node(struct device_node *np);
 
 extern int of_bus_type_init(struct bus_type *bus, const char *name);

