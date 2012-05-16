Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344Ab2EPLuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:50:24 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:55907 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967466Ab2EPLuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:50:22 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Takahiro Shimizu <tshimizu818@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ptp_pch: Add missing #include <linux/slab.h>
Date: Wed, 16 May 2012 13:50:17 +0200
Message-Id: <1337169017-15835-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ptp/ptp_pch.c: In function 'pch_remove':
drivers/ptp/ptp_pch.c:576:2: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
drivers/ptp/ptp_pch.c: In function 'pch_probe':
drivers/ptp/ptp_pch.c:587:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Not even compile-tested, as it fails on parisc only.
http://kisskb.ellerman.id.au/kisskb/buildresult/6312813/

 drivers/ptp/ptp_pch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 375eb04..6fff680 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/slab.h>
 
 #define STATION_ADDR_LEN	20
 #define PCI_DEVICE_ID_PCH_1588	0x8819
-- 
1.7.0.4

