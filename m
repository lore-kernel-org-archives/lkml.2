Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2GVCZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 22:25:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:23317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2GVCZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 22:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="182766507"
Date: Sun, 22 Jul 2012 10:25:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] avr32: fix build error in ATSTK1002 code
Message-ID: <20120722022541.GA8279@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/avr32/boards/atstk1000/atstk1002.c:100: error: 'num_partitions' undeclared here (not in a function)

which is introduced by commit 1754aab9bb86 ("mtd: ATMEL, AVR32: inline
nand partition table access ").

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/avr32/boards/atstk1000/atstk1002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index dc52633..6c80aba 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -97,7 +97,7 @@ static struct atmel_nand_data atstk1006_nand_data __initdata = {
 	.enable_pin	= GPIO_PIN_PB(29),
 	.ecc_mode	= NAND_ECC_SOFT,
 	.parts		= nand_partitions,
-	.num_parts	= ARRAY_SIZE(num_partitions),
+	.num_parts	= ARRAY_SIZE(nand_partitions),
 };
 #endif
 
-- 
1.7.10

