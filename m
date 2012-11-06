Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2KFVzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:55:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KFVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 1/8] mtd: diskonchip: don't warn about ARM architecture
Date: Tue,  6 Nov 2012 22:55:26 +0100
Message-Id: <1352238933-4886-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:+SvEu/tfzYh3xf1Hif7kTafZQ9EIoKAuyYcHkanWrwN
 D29z3GnrN/OQxvSwkvjsU4UIT+4Nzzu3d4Sp01WOZpI6Gj3LtE
 K9cp+hSEVrlC2gDkvkWBgIsVlTm663gXMamwGGuDOEBByAw/Qz
 dMyehPmkvieC+0fueusoUCntqLfcnQMfmBNQHXIGD4mnxl0cFr
 AM5QuUOajztvmBUJjPDPi4mRHAKPzvyrtB147h4bLqEYkSt/w4
 8WdfTRE2BbiXI0SLIOfFtDmqdLPh5L789XjY3BY8kpOSlt3A3V
 0WpSX5iywKN4A0m8Mr5VSL12fjGENeL8p1E7z9MEoDHJ/0ats0
 GizXVPnANkVsOa9i9hlUSyqSj/VwEdZWbkazrlEuDZ+ZZZDKVo
 l0CY5EqlqcNew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling the diskonchip drivers on most architectures results
in a pointless warning "#warning Unknown architecture for
DiskOnChip. No default probe locations defined". The driver
can in fact handle the default location already through the
CONFIG_MTD_DOCPROBE_ADDRESS, which gets set on the platforms
that need it, and we get a run-time error if this is not
set correctly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/devices/docprobe.c |    2 --
 drivers/mtd/nand/diskonchip.c  |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/mtd/devices/docprobe.c b/drivers/mtd/devices/docprobe.c
index 706b847..88b3fd3 100644
--- a/drivers/mtd/devices/docprobe.c
+++ b/drivers/mtd/devices/docprobe.c
@@ -70,8 +70,6 @@ static unsigned long __initdata doc_locations[] = {
 	0xe0000, 0xe2000, 0xe4000, 0xe6000,
 	0xe8000, 0xea000, 0xec000, 0xee000,
 #endif /*  CONFIG_MTD_DOCPROBE_HIGH */
-#else
-#warning Unknown architecture for DiskOnChip. No default probe locations defined
 #endif
 	0xffffffff };
 
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index 256eb30..81fa578 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -53,8 +53,6 @@ static unsigned long __initdata doc_locations[] = {
 	0xe0000, 0xe2000, 0xe4000, 0xe6000,
 	0xe8000, 0xea000, 0xec000, 0xee000,
 #endif /*  CONFIG_MTD_DOCPROBE_HIGH */
-#else
-#warning Unknown architecture for DiskOnChip. No default probe locations defined
 #endif
 	0xffffffff };
 
-- 
1.7.10

