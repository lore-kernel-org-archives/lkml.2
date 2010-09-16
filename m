Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0IPHFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:05:15 -0400
Received: from pegase1.c-s.fr ([194.2.40.7]:53204 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0IPHFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:05:14 -0400
Subject: [PATCH] spi_mpc8xxx: issue with using definition of pram in Device Tree
From: christophe leroy <christophe.leroy@c-s.fr>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-Id: <20100916070503.10046C7391@messagerie.si.c-s.fr>
Date: Thu, 16 Sep 2010 09:05:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies to 2.6.34.7 and 2.6.35.4
It fixes an issue during the probe for CPM1 with definition of parameter ram from DTS

Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>

diff -urN b/drivers/spi/spi_mpc8xxx.c c/drivers/spi/spi_mpc8xxx.c
--- b/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:43:50.000000000 +0200
+++ c/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:44:03.000000000 +0200
@@ -822,7 +822,7 @@
 	if (!iprop || size != sizeof(*iprop) * 4)
 		return -ENOMEM;
 
-	spi_base_ofs = cpm_muram_alloc_fixed(iprop[2], 2);
+	spi_base_ofs = iprop[2];
 	if (IS_ERR_VALUE(spi_base_ofs))
 		return -ENOMEM;
 
@@ -844,7 +844,6 @@
 			return spi_base_ofs;
 	}
 
-	cpm_muram_free(spi_base_ofs);
 	return pram_ofs;
 }
