Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1HBII5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:08:57 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:34283 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab1HBIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:08:51 -0400
Date: Tue, 2 Aug 2011 10:08:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pti: add missing CONFIG_PCI dependency
Message-ID: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

allmodconfig compile fails on s390 because of the new PTI driver:

drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'

Add a 'depends on PCI' statement so it doesn't get compiled.

Cc: J Freyensee <james_p_freyensee@linux.intel.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -146,6 +146,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+	depends on PCI
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
