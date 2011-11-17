Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1KSL3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:29:46 -0500
Received: from www17.your-server.de ([213.133.104.17]:41079 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1KSL3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:29:40 -0500
Subject: [PATCH] ia64: sn: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: jes@sgi.com, tony.luck@intel.com, fenghua.yu@intel.com,
        linux-altix@sgi.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.269.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
--- a/arch/ia64/sn/kernel/irq.c 2011-11-07 19:37:22.046225104 +0100
+++ b/arch/ia64/sn/kernel/irq.c 2011-11-08 11:01:33.601378758 +0100
@@ -150,12 +150,11 @@ struct sn_irq_info *sn_retarget_vector(s
 	 * PROM does not support SAL_INTR_REDIRECT, or it failed.
 	 * Revert to old method.
 	 */
-	new_irq_info = kmalloc(sizeof(struct sn_irq_info), GFP_ATOMIC);
+	new_irq_info = kmemdup(sn_irq_info, sizeof(struct sn_irq_info),
+			       GFP_ATOMIC);
 	if (new_irq_info == NULL)
 		return NULL;
 
-	memcpy(new_irq_info, sn_irq_info, sizeof(struct sn_irq_info));
-
 	/* Free the old PROM new_irq_info structure */
 	sn_intr_free(local_nasid, local_widget, new_irq_info);
 	unregister_intr_pda(new_irq_info);
