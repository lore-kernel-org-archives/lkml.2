Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0E1Lp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:45:56 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:33651 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0E1Lpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:45:54 -0400
Date: Fri, 28 May 2010 13:46:54 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH] ramoops: add HAS_IOMEM dependency
Message-ID: <20100528114654.GC3686@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The driver fails to compile on s390:

drivers/char/ramoops.c: In function 'ramoops_init':
drivers/char/ramoops.c:122: error: implicit declaration of function 'ioremap'

Since we won't make use of the driver anyway on s390 just let it
depend on HAS_IOMEM.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
---
 drivers/char/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1123,6 +1123,7 @@ source "drivers/s390/char/Kconfig"
 
 config RAMOOPS
 	tristate "Log panic/oops to a RAM buffer"
+	depends on HAS_IOMEM
 	default n
 	help
 	  This enables panic and oops messages to be logged to a circular
