Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2JKHDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:03:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51631 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2JKHDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:03:47 -0400
Date: Thu, 11 Oct 2012 10:03:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] irq: potential integer wrapping __setup_irq()
Message-ID: <20121011070329.GH31607@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"thread_mask" is an unsigned long.  It's better to use 1UL here so we
can take advantage of the high bits as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..cfe1283 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1027,7 +1027,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * thread_mask assigned. See the loop above which or's
 		 * all existing action->thread_mask bits.
 		 */
-		new->thread_mask = 1 << ffz(thread_mask);
+		new->thread_mask = 1UL << ffz(thread_mask);
 
 	} else if (new->handler == irq_default_primary_handler &&
 		   !(desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)) {
