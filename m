Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2GQVc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:32:59 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39558 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab2GQVcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:32:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Ben Dooks" <ben-linux@fluff.org>,
        "Wolfram Sang" <w.sang@pengutronix.de>
Subject: [PATCH 03/17] i2c-pmcmsp: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:22 -0400
Message-Id: <1342560756-18737-4-git-send-email-tytso@mit.edu>
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
Cc: "Ben Dooks" <ben-linux@fluff.org>
Cc: "Wolfram Sang" <w.sang@pengutronix.de>
---
 drivers/i2c/busses/i2c-pmcmsp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 07b7447..3d71395 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -306,8 +306,7 @@ static int __devinit pmcmsptwi_probe(struct platform_device *pldev)
 	pmcmsptwi_data.irq = platform_get_irq(pldev, 0);
 	if (pmcmsptwi_data.irq) {
 		rc = request_irq(pmcmsptwi_data.irq, &pmcmsptwi_interrupt,
-			IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			pldev->name, &pmcmsptwi_data);
+				 IRQF_SHARED, pldev->name, &pmcmsptwi_data);
 		if (rc == 0) {
 			/*
 			 * Enable 'DONE' interrupt only.
-- 
1.7.11.1.108.gb129051

