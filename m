Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2GSOni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:43:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53476 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2GSOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:43:34 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kent Yoder <key@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Subject: [PATCH 2/4] powerpc/crypto: add compression support to arch vec
Date: Thu, 19 Jul 2012 09:42:39 -0500
Message-Id: <1342708961-28587-3-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071914-7282-0000-0000-00000B170212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables compression engine support in the
architecture vector.  This causes the Power hypervisor
to allow access to the nx comrpession accelerator.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 0794a30..9ec5e55 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -705,6 +705,7 @@ static void __init early_cmdline_parse(void)
 #endif
 #define OV5_TYPE1_AFFINITY	0x80	/* Type 1 NUMA affinity */
 #define OV5_PFO_HW_RNG		0x80	/* PFO Random Number Generator */
+#define OV5_PFO_HW_842		0x40	/* PFO Compression Accelerator */
 #define OV5_PFO_HW_ENCR		0x20	/* PFO Encryption Accelerator */
 
 /* Option Vector 6: IBM PAPR hints */
@@ -774,8 +775,7 @@ static unsigned char ibm_architecture_vec[] = {
 	0,
 	0,
 	0,
-	OV5_PFO_HW_RNG | OV5_PFO_HW_ENCR,
-
+	OV5_PFO_HW_RNG | OV5_PFO_HW_ENCR | OV5_PFO_HW_842,
 	/* option vector 6: IBM PAPR hints */
 	4 - 2,				/* length */
 	0,
-- 
1.7.9.5

