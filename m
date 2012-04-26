Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab2DZSZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:25:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:58980 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab2DZSZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:25:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Christoph Hellwig <hch@lst.de>, Chris Zankel <chris@zankel.net>
Subject: [PATCH] xtensa: fix build fail on undefined ack_bad_irq
Date: Thu, 26 Apr 2012 14:24:39 -0400
Message-Id: <1335464679-15064-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e520c410854bab763be24e0fce7ba89dc252efee

    "xtensa: convert to asm-generic/hardirq.h"

converted over to using the asm-generic parts, but it also
added the sentinel

	#define ack_bad_irq ack_bad_irq

which tells asm-generic to _not_ use the common ack_bad_irq.

Since e520c41 deleted the duplicated code from the arch specific
file, we _do_ want the asm-generic one in scope.  So delete
the trigger define above which hides it.  In doing so we'll
realize that we've got to delete the almost-duplicate prototype
as well to avoid "static declaration ... follows non-static".

Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/xtensa/include/asm/hardirq.h b/arch/xtensa/include/asm/hardirq.h
index 26664ce..91695a1 100644
--- a/arch/xtensa/include/asm/hardirq.h
+++ b/arch/xtensa/include/asm/hardirq.h
@@ -11,9 +11,6 @@
 #ifndef _XTENSA_HARDIRQ_H
 #define _XTENSA_HARDIRQ_H
 
-void ack_bad_irq(unsigned int irq);
-#define ack_bad_irq ack_bad_irq
-
 #include <asm-generic/hardirq.h>
 
 #endif	/* _XTENSA_HARDIRQ_H */
-- 
1.7.9.1

