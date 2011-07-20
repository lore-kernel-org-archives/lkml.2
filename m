Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1GTXXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 19:23:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3723 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1GTXXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 19:23:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6413"; a="104762511"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH] ARM: Migrate to asm-generic wrapper support
Date: Wed, 20 Jul 2011 16:23:45 -0700
Message-Id: <1311204225-13169-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6.233.gd79bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With d8ecc5c (kbuild: asm-generic support, 2011-04-27) we can
remove a handful of asm-generic wrappers in ARM code.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Imre Kaloz <kaloz@openwrt.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Eric Miao <eric.y.miao@gmail.com>
---

I've specifically left out topology.h as it looks like that will not
be generic much longer.

 arch/arm/include/asm/Kbuild              |   17 +++++++++++++++++
 arch/arm/include/asm/auxvec.h            |    4 ----
 arch/arm/include/asm/bitsperlong.h       |    1 -
 arch/arm/include/asm/cputime.h           |    6 ------
 arch/arm/include/asm/emergency-restart.h |    6 ------
 arch/arm/include/asm/errno.h             |    6 ------
 arch/arm/include/asm/ioctl.h             |    1 -
 arch/arm/include/asm/irq_regs.h          |    1 -
 arch/arm/include/asm/kdebug.h            |    1 -
 arch/arm/include/asm/local.h             |    1 -
 arch/arm/include/asm/local64.h           |    1 -
 arch/arm/include/asm/percpu.h            |    6 ------
 arch/arm/include/asm/poll.h              |    1 -
 arch/arm/include/asm/resource.h          |    6 ------
 arch/arm/include/asm/sections.h          |    1 -
 arch/arm/include/asm/siginfo.h           |    6 ------
 arch/arm/include/asm/sizes.h             |   21 ---------------------
 arch/arm/mach-ixp4xx/common-pci.c        |    3 ++-
 arch/arm/mach-mmp/aspenite.c             |    2 +-
 arch/arm/mach-mmp/ttc_dkb.c              |    2 +-
 arch/arm/mach-pxa/saar.c                 |    2 +-
 21 files changed, 22 insertions(+), 73 deletions(-)
 delete mode 100644 arch/arm/include/asm/auxvec.h
 delete mode 100644 arch/arm/include/asm/bitsperlong.h
 delete mode 100644 arch/arm/include/asm/cputime.h
 delete mode 100644 arch/arm/include/asm/emergency-restart.h
 delete mode 100644 arch/arm/include/asm/errno.h
 delete mode 100644 arch/arm/include/asm/ioctl.h
 delete mode 100644 arch/arm/include/asm/irq_regs.h
 delete mode 100644 arch/arm/include/asm/kdebug.h
 delete mode 100644 arch/arm/include/asm/local.h
 delete mode 100644 arch/arm/include/asm/local64.h
 delete mode 100644 arch/arm/include/asm/percpu.h
 delete mode 100644 arch/arm/include/asm/poll.h
 delete mode 100644 arch/arm/include/asm/resource.h
 delete mode 100644 arch/arm/include/asm/sections.h
 delete mode 100644 arch/arm/include/asm/siginfo.h
 delete mode 100644 arch/arm/include/asm/sizes.h

diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 6550db3..960abce 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -1,3 +1,20 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += hwcap.h
+
+generic-y += auxvec.h
+generic-y += bitsperlong.h
+generic-y += cputime.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += ioctl.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += local.h
+generic-y += local64.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += resource.h
+generic-y += sections.h
+generic-y += siginfo.h
+generic-y += sizes.h
diff --git a/arch/arm/include/asm/auxvec.h b/arch/arm/include/asm/auxvec.h
deleted file mode 100644
index c0536f6..0000000
--- a/arch/arm/include/asm/auxvec.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __ASMARM_AUXVEC_H
-#define __ASMARM_AUXVEC_H
-
-#endif
diff --git a/arch/arm/include/asm/bitsperlong.h b/arch/arm/include/asm/bitsperlong.h
deleted file mode 100644
index 6dc0bb0..0000000
--- a/arch/arm/include/asm/bitsperlong.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/bitsperlong.h>
diff --git a/arch/arm/include/asm/cputime.h b/arch/arm/include/asm/cputime.h
deleted file mode 100644
index 3a8002a..0000000
--- a/arch/arm/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARM_CPUTIME_H
-#define __ARM_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __ARM_CPUTIME_H */
diff --git a/arch/arm/include/asm/emergency-restart.h b/arch/arm/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/arm/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/arm/include/asm/errno.h b/arch/arm/include/asm/errno.h
deleted file mode 100644
index 6e60f06..0000000
--- a/arch/arm/include/asm/errno.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ARM_ERRNO_H
-#define _ARM_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/arch/arm/include/asm/ioctl.h b/arch/arm/include/asm/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/arch/arm/include/asm/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/arch/arm/include/asm/irq_regs.h b/arch/arm/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/arm/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/arm/include/asm/kdebug.h b/arch/arm/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/arm/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/arm/include/asm/local.h b/arch/arm/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/arm/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/arm/include/asm/local64.h b/arch/arm/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/arm/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
deleted file mode 100644
index b4e32d8..0000000
--- a/arch/arm/include/asm/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARM_PERCPU
-#define __ARM_PERCPU
-
-#include <asm-generic/percpu.h>
-
-#endif
diff --git a/arch/arm/include/asm/poll.h b/arch/arm/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/arm/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/arm/include/asm/resource.h b/arch/arm/include/asm/resource.h
deleted file mode 100644
index 734b581..0000000
--- a/arch/arm/include/asm/resource.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ARM_RESOURCE_H
-#define _ARM_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
diff --git a/arch/arm/include/asm/sections.h b/arch/arm/include/asm/sections.h
deleted file mode 100644
index 2b8c516..0000000
--- a/arch/arm/include/asm/sections.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sections.h>
diff --git a/arch/arm/include/asm/siginfo.h b/arch/arm/include/asm/siginfo.h
deleted file mode 100644
index 5e21852..0000000
--- a/arch/arm/include/asm/siginfo.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASMARM_SIGINFO_H
-#define _ASMARM_SIGINFO_H
-
-#include <asm-generic/siginfo.h>
-
-#endif
diff --git a/arch/arm/include/asm/sizes.h b/arch/arm/include/asm/sizes.h
deleted file mode 100644
index 154b89b..0000000
--- a/arch/arm/include/asm/sizes.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-/*  Size definitions
- *  Copyright (C) ARM Limited 1998. All rights reserved.
- */
-#include <asm-generic/sizes.h>
-
-#define SZ_48M	(SZ_32M + SZ_16M)
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index e2e98bb..9e651da 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -392,7 +392,8 @@ void __init ixp4xx_pci_preinit(void)
 		local_write_config(PCI_BASE_ADDRESS_0, 4, PHYS_OFFSET);
 		local_write_config(PCI_BASE_ADDRESS_1, 4, PHYS_OFFSET + SZ_16M);
 		local_write_config(PCI_BASE_ADDRESS_2, 4, PHYS_OFFSET + SZ_32M);
-		local_write_config(PCI_BASE_ADDRESS_3, 4, PHYS_OFFSET + SZ_48M);
+		local_write_config(PCI_BASE_ADDRESS_3, 4,
+					PHYS_OFFSET + SZ_32M + SZ_16M);
 
 		/*
 		 * Enable CSR window at 64 MiB to allow PCI masters
diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 06b5fa8..49c5d6d 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -160,7 +160,7 @@ static struct mtd_partition aspenite_nand_partitions[] = {
 	}, {
 		.name		= "filesystem",
 		.offset		= MTDPART_OFS_APPEND,
-		.size		= SZ_48M,
+		.size		= SZ_32M + SZ_16M,
 		.mask_flags	= 0,
 	}
 };
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index e411039..c5b068e 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -81,7 +81,7 @@ static struct mtd_partition ttc_dkb_onenand_partitions[] = {
 	}, {
 		.name		= "filesystem",
 		.offset		= MTDPART_OFS_APPEND,
-		.size		= SZ_48M,
+		.size		= SZ_32M + SZ_16M,
 		.mask_flags	= 0,
 	}
 };
diff --git a/arch/arm/mach-pxa/saar.c b/arch/arm/mach-pxa/saar.c
index fee97a9..19e7b36 100644
--- a/arch/arm/mach-pxa/saar.c
+++ b/arch/arm/mach-pxa/saar.c
@@ -540,7 +540,7 @@ static struct mtd_partition saar_onenand_partitions[] = {
 	}, {
 		.name		= "filesystem",
 		.offset		= MTDPART_OFS_APPEND,
-		.size		= SZ_48M,
+		.size		= SZ_32M + SZ_16M,
 		.mask_flags	= 0,
 	}
 };
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

