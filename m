Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362Ab2CUVlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:41:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52965 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965027Ab2CUVlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:41:07 -0400
Message-ID: <1332366111.3858.56.camel@key-ThinkPad-W510>
Subject: [PATCH 17/17] powerpc: crypto: enable the PFO-based encryption
 device
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
Date: Wed, 21 Mar 2012 16:41:51 -0500
In-Reply-To: <1332365297.3858.5.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032121-8974-0000-0000-000007793A87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the cas bits to advertise support for the Platform
Facilities Option (PFO) based encryption accelerator device. The nx
device driver provides support for this hardware feature.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 6691077..fb5412e 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -716,6 +716,12 @@ static void __init early_cmdline_parse(void)
 #else
 #define OV5_PFO_HW_RNG		0x00
 #endif
+#if defined(CONFIG_CRYPTO_DEV_NX) || \
+	defined(CONFIG_CRYPTO_DEV_NX_MODULE)
+#define OV5_PFO_HW_ENCR		0x20
+#else
+#define OV5_PFO_HW_ENCR		0x00
+#endif
 
 /* Option Vector 6: IBM PAPR hints */
 #define OV6_LINUX		0x02	/* Linux is our OS */
@@ -783,7 +789,7 @@ static unsigned char ibm_architecture_vec[] = {
 	0,
 	0,
 	0,
-	OV5_PFO_HW_RNG,
+	OV5_PFO_HW_RNG | OV5_PFO_HW_ENCR,
 
 	/* option vector 6: IBM PAPR hints */
 	4 - 2,				/* length */
-- 
1.7.1


