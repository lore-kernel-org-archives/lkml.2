Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2GQWFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:05:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39591 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165Ab2GQWE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:04:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 12/17] isp1301_omap: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:31 -0400
Message-Id: <1342560756-18737-13-git-send-email-tytso@mit.edu>
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
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/otg/isp1301_omap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
index 70cf5d7..512397a 100644
--- a/drivers/usb/otg/isp1301_omap.c
+++ b/drivers/usb/otg/isp1301_omap.c
@@ -1575,7 +1575,6 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		isp->irq_type = IRQF_TRIGGER_FALLING;
 	}
 
-	isp->irq_type |= IRQF_SAMPLE_RANDOM;
 	status = request_irq(i2c->irq, isp1301_irq,
 			isp->irq_type, DRIVER_NAME, isp);
 	if (status < 0) {
-- 
1.7.11.1.108.gb129051

