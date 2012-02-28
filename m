Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2B1NmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:42:07 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:35459
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932641Ab2B1NmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:42:03 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275ch8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <akpm@linux-foundation.org>, <paul.gortmaker@windriver.com>,
        <linux@arm.linux.org.uk>, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] kernel.h: Include <linux/bug.h> to avoid build breakage with ARRAY_SIZE()
Date: Tue, 28 Feb 2012 10:41:39 -0300
Message-ID: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building imx_v6_v7_defconfig generated the following build error:

arch/arm/mach-imx/cpu_op-mx51.c: In function 'mx51_get_cpu_op':
arch/arm/mach-imx/cpu_op-mx51.c:27: error: implicit declaration of function 'BUILD_BUG_ON_ZERO'

commit 6f863554 (kernel.h: doesn't explicitly use bug.h, so don't include it.)
has removed asm/debug.h from linux/kernel.h.

Quoting Russell King (http://www.spinics.net/lists/arm-kernel/msg161916.html)

"linux/kernel.h _does_ use bug stuff - in ARRAY_SIZE().

ARRAY_SIZE() uses __must_be_array(), which is defined in linux/compiler-gcc.h,
which is obtained via linux/compiler.h and linux/linkage.h.

linux/compiler-gcc.h defines __must_be_array() to be:
#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))

and BUILD_BUG_ON_ZERO used to be in linux/kernel.h but got moved to
linux/bug.h.

Hence why people are seeing build breakage with ARRAY_SIZE()."

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 include/linux/kernel.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ed9f92e..9c0a86b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -21,6 +21,7 @@
 #include <linux/typecheck.h>
 #include <linux/printk.h>
 #include <linux/dynamic_debug.h>
+#include <linux/bug.h>
 #include <asm/byteorder.h>
 
 #define USHRT_MAX	((u16)(~0U))
-- 
1.7.1


