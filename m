Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393Ab2DLPVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:21:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37610 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353Ab2DLPVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:21:37 -0400
Message-ID: <1334243871.18090.15.camel@key-ThinkPad-W510>
Subject: [PATCH v3 05/17] pseries: Enabled the PFO-based RNG accelerator
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        key@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 12 Apr 2012 10:17:51 -0500
In-Reply-To: <1334242825.18090.4.camel@key-ThinkPad-W510>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041215-1780-0000-0000-000004B53E9C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000266; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00130260; UDB=6.00030755; UTC=2012-04-12
 15:21:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the cas bits to advertise support for the Platform
Facilities Option (PFO) based random number generator accerator.
The pseries-rng driver provides support for this hardware feature.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 9986027..26f6317 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -701,6 +701,7 @@ static void __init early_cmdline_parse(void)
 #define OV5_XCMO			0x00
 #endif
 #define OV5_TYPE1_AFFINITY	0x80	/* Type 1 NUMA affinity */
+#define OV5_PFO_HW_RNG		0x80	/* PFO Random Number Generator */
 
 /* Option Vector 6: IBM PAPR hints */
 #define OV6_LINUX		0x02	/* Linux is our OS */
@@ -748,7 +749,7 @@ static unsigned char ibm_architecture_vec[] = {
 	0,				/* don't halt */
 
 	/* option vector 5: PAPR/OF options */
-	13 - 2,				/* length */
+	18 - 2,				/* length */
 	0,				/* don't ignore, don't halt */
 	OV5_LPAR | OV5_SPLPAR | OV5_LARGE_PAGES | OV5_DRCONF_MEMORY |
 	OV5_DONATE_DEDICATE_CPU | OV5_MSI,
@@ -764,6 +765,11 @@ static unsigned char ibm_architecture_vec[] = {
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


