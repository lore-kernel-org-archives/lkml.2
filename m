Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2IKNAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:00:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61383 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKNAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 06/16] ARM: netx: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:40 +0200
Message-Id: <1347368390-31252-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ybdJljPcM7kEsUq5Dd1DcpCUoBiUMwoK0PSS3dxdQjL
 WbulacZdMj/6ZJdvql+nMZcBcbPEXp6C+K1RqQihUWU/pOXPcd
 7+fmmQbysSLDxvbaHMg21aTny4msoI0qn1Oatz15Rj9YsOUZ3D
 eYjZ9BlQMBXQEOy3BPQTs/3bF7nBu9+jvVk7KRda5aPXWcg8R5
 iXo4xHDJF1XR0kHCnJ4+peQQggJD3xRde5QcJCrg02/s/bPdVP
 3MHE+Zd9XYxvJd2XYRb6Oar0xL634BsBrubVgnM+xB7hv3oYj4
 z11BBz0JPINYlP+0bICQwqQk5rK2gUE3JqM6IbPlZJpXmL6JEM
 ARrppXpoZAsU1U3dU3hq3KqHxnpZesvWcRAA2H67AS0cj2pAcS
 f3kkjwtx3O7jBDSSFtCAIiOfXpcR6QAhRs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the netx include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-netx/nxdb500.c                                         |    2 +-
 arch/arm/mach-netx/nxdkn.c                                           |    2 +-
 arch/arm/mach-netx/nxeb500hmi.c                                      |    2 +-
 drivers/net/ethernet/netx-eth.c                                      |    2 +-
 .../include/mach/eth.h => include/linux/platform_data/eth-netx.h     |    0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename arch/arm/mach-netx/include/mach/eth.h => include/linux/platform_data/eth-netx.h (100%)

diff --git a/arch/arm/mach-netx/nxdb500.c b/arch/arm/mach-netx/nxdb500.c
index 180ea89..8b781ff 100644
--- a/arch/arm/mach-netx/nxdb500.c
+++ b/arch/arm/mach-netx/nxdb500.c
@@ -30,7 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/hardware/vic.h>
 #include <mach/netx-regs.h>
-#include <mach/eth.h>
+#include <linux/platform_data/eth-netx.h>
 
 #include "generic.h"
 #include "fb.h"
diff --git a/arch/arm/mach-netx/nxdkn.c b/arch/arm/mach-netx/nxdkn.c
index 58009e2..b26dbce 100644
--- a/arch/arm/mach-netx/nxdkn.c
+++ b/arch/arm/mach-netx/nxdkn.c
@@ -30,7 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/hardware/vic.h>
 #include <mach/netx-regs.h>
-#include <mach/eth.h>
+#include <linux/platform_data/eth-netx.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-netx/nxeb500hmi.c b/arch/arm/mach-netx/nxeb500hmi.c
index 122e998..257382e 100644
--- a/arch/arm/mach-netx/nxeb500hmi.c
+++ b/arch/arm/mach-netx/nxeb500hmi.c
@@ -30,7 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/hardware/vic.h>
 #include <mach/netx-regs.h>
-#include <mach/eth.h>
+#include <linux/platform_data/eth-netx.h>
 
 #include "generic.h"
 #include "fb.h"
diff --git a/drivers/net/ethernet/netx-eth.c b/drivers/net/ethernet/netx-eth.c
index 9d11ab7..63e7af4 100644
--- a/drivers/net/ethernet/netx-eth.c
+++ b/drivers/net/ethernet/netx-eth.c
@@ -34,7 +34,7 @@
 #include <mach/netx-regs.h>
 #include <mach/pfifo.h>
 #include <mach/xc.h>
-#include <mach/eth.h>
+#include <linux/platform_data/eth-netx.h>
 
 /* XC Fifo Offsets */
 #define EMPTY_PTR_FIFO(xcno)    (0 + ((xcno) << 3))	/* Index of the empty pointer FIFO */
diff --git a/arch/arm/mach-netx/include/mach/eth.h b/include/linux/platform_data/eth-netx.h
similarity index 100%
rename from arch/arm/mach-netx/include/mach/eth.h
rename to include/linux/platform_data/eth-netx.h
-- 
1.7.10

