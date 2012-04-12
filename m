Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497Ab2DLPmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:42:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47666 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934475Ab2DLPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:42:09 -0400
Message-ID: <1334245175.18090.40.camel@key-ThinkPad-W510>
Subject: [PATCH v3 17/17] powerpc: crypto: enable the PFO-based encryption
 device
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        key@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 12 Apr 2012 10:39:35 -0500
In-Reply-To: <1334242825.18090.4.camel@key-ThinkPad-W510>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041215-6148-0000-0000-000004FDE780
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the cas bits to advertise support for the Platform
Facilities Option (PFO) based encryption accelerator device. The nx
device driver provides support for this hardware feature.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 26f6317..604b4c4 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -702,6 +702,7 @@ static void __init early_cmdline_parse(void)
 #endif
 #define OV5_TYPE1_AFFINITY	0x80	/* Type 1 NUMA affinity */
 #define OV5_PFO_HW_RNG		0x80	/* PFO Random Number Generator */
+#define OV5_PFO_HW_ENCR		0x20	/* PFO Encryption Accelerator */
 
 /* Option Vector 6: IBM PAPR hints */
 #define OV6_LINUX		0x02	/* Linux is our OS */
@@ -769,7 +770,7 @@ static unsigned char ibm_architecture_vec[] = {
 	0,
 	0,
 	0,
-	OV5_PFO_HW_RNG,
+	OV5_PFO_HW_RNG | OV5_PFO_HW_ENCR,
 
 	/* option vector 6: IBM PAPR hints */
 	4 - 2,				/* length */
-- 
1.7.1


