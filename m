Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2GQVcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:32:51 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39557 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab2GQVct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:32:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 04/17] pda_power: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:23 -0400
Message-Id: <1342560756-18737-5-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
no-op; interrupt randomness is now collected unconditionally in a very
low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
flag was scheduled to be removed in 2009 on the
feature-removal-schedule, so this patch is preparation for the final
removal of this flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/pda_power.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 214468f..db5c526 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -24,11 +24,7 @@
 
 static inline unsigned int get_irq_flags(struct resource *res)
 {
-	unsigned int flags = IRQF_SAMPLE_RANDOM | IRQF_SHARED;
-
-	flags |= res->flags & IRQF_TRIGGER_MASK;
-
-	return flags;
+	return IRQF_SHARED | (res->flags & IRQF_TRIGGER_MASK);
 }
 
 static struct device *dev;
-- 
1.7.11.1.108.gb129051

