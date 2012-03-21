Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab2CUVjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:39:13 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35579 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760357Ab2CUVil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:38:41 -0400
Message-ID: <1332365949.3858.32.camel@key-ThinkPad-W510>
Subject: [PATCH 05/17] pseries: Enabled the PFO-based RNG accelerator
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 21 Mar 2012 16:39:09 -0500
In-Reply-To: <1332365297.3858.5.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032121-3352-0000-0000-0000037BC635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Jennings <rcj@linux.vnet.ibm.com>

This patch adds the cas bits to advertise support for the Platform
Facilities Option (PFO) based random number generator accerator.
The pseries-rng driver provides support for this hardware feature.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index eca626e..6691077 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -710,6 +710,12 @@ static void __init early_cmdline_parse(void)
 #define OV5_XCMO			0x00
 #endif
 #define OV5_TYPE1_AFFINITY	0x80	/* Type 1 NUMA affinity */
+#if defined(CONFIG_HW_RANDOM_PSERIES) || \
+	defined(CONFIG_HW_RANDOM_PSERIES_MODULE)
+#define OV5_PFO_HW_RNG		0x80	/* PFO Random Number Generator */
+#else
+#define OV5_PFO_HW_RNG		0x00
+#endif
 
 /* Option Vector 6: IBM PAPR hints */
 #define OV6_LINUX		0x02	/* Linux is our OS */
@@ -757,7 +763,7 @@ static unsigned char ibm_architecture_vec[] = {
 	0,				/* don't halt */
 
 	/* option vector 5: PAPR/OF options */
-	13 - 2,				/* length */
+	18 - 2,				/* length */
 	0,				/* don't ignore, don't halt */
 	OV5_LPAR | OV5_SPLPAR | OV5_LARGE_PAGES | OV5_DRCONF_MEMORY |
 	OV5_DONATE_DEDICATE_CPU | OV5_MSI,
@@ -773,6 +779,11 @@ static unsigned char ibm_architecture_vec[] = {
 	 */
 #define IBM_ARCH_VEC_NRCORES_OFFSET	100
 	W(NR_CPUS),			/* number of cores supported */
+	0,
+	0,
+	0,
+	0,
+	OV5_PFO_HW_RNG,
 
 	/* option vector 6: IBM PAPR hints */
 	4 - 2,				/* length */
-- 
1.7.1


