Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab0GXBm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 21:42:26 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16614 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab0GXBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 21:42:17 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, wim@iguana.be
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 4/7] MIPS: Octeon: Export prom_putchar().
Date: Fri, 23 Jul 2010 18:41:44 -0700
Message-Id: <1279935707-3997-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279935707-3997-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 24 Jul 2010 01:42:17.0187 (UTC) FILETIME=[72BF6B30:01CB2AD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The forthcoming watchdog driver will use it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/cavium-octeon/setup.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 6f36bc1..85a615a 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -691,7 +691,10 @@ void __init plat_mem_setup(void)
 		      "cvmx_bootmem_phy_alloc\n");
 }
 
-
+/*
+ * Emit one character to the boot UART.  Exported for use by the
+ * watchdog timer.
+ */
 int prom_putchar(char c)
 {
 	uint64_t lsrval;
@@ -705,6 +708,7 @@ int prom_putchar(char c)
 	cvmx_write_csr(CVMX_MIO_UARTX_THR(octeon_uart), c & 0xffull);
 	return 1;
 }
+EXPORT_SYMBOL(prom_putchar);
 
 void prom_free_prom_memory(void)
 {
-- 
1.7.1.1

