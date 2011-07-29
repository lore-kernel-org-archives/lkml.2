Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab1G2OIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:08:50 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59779 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776Ab1G2OIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:08:49 -0400
Subject: sungem: fix compile failure caused by trivial #include
 consolidation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Miller <davem@davemloft.net>, Vitaliy Ivanov <vitalivanov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 18:08:44 +0400
Message-ID: <1311948524.8190.39.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:

commit e44ba033c5654dbfda53461c9b1f7dd9bd1d198f
Author: Vitaliy Ivanov <vitalivanov@gmail.com>
Date:   Mon Jun 20 16:08:07 2011 +0200

    treewide: remove duplicate includes

Causes this compile failure on parisc:

  CC [M]  drivers/net/sungem.o
drivers/net/sungem.c:49:22: error: asm/prom.h: No such file or directory
make[2]: *** [drivers/net/sungem.o] Error 1

Only Sparc and PPC actually have the asm/prom.h include, so you can't
consolidate it outside of the ifdefs.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---

This really shouldn't be happening with a trivial patch, since it's an
obviously non-trivial transformation ... I assume the duplicate include
checker isn't taking #ifdefs into account?

James

commit e44ba033c5654dbfda53461c9b1f7dd9bd1d198f
Author: Vitaliy Ivanov <vitalivanov@gmail.com>
Date:   Mon Jun 20 16:08:07 2011 +0200

    treewide: remove duplicate includes
    
    Many stupid corrections of duplicated includes based on the output of
    scripts/checkincludes.pl.
    
    Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index ab59300..70f018d 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -66,15 +66,14 @@
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
+#include <asm/prom.h>
 
 #ifdef CONFIG_SPARC
 #include <asm/idprom.h>
-#include <asm/prom.h>
 #endif
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/pci-bridge.h>
-#include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
 #endif


