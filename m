Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2GQWFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:05:02 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39592 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166Ab2GQWE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:04:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 11/17] pxa25x_udc: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:30 -0400
Message-Id: <1342560756-18737-12-git-send-email-tytso@mit.edu>
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
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 drivers/usb/gadget/pxa25x_udc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index f7ff9e8..c319814 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -2200,19 +2200,15 @@ static int __init pxa25x_udc_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_LUBBOCK
 	if (machine_is_lubbock()) {
-		retval = request_irq(LUBBOCK_USB_DISC_IRQ,
-				lubbock_vbus_irq,
-				IRQF_SAMPLE_RANDOM,
-				driver_name, dev);
+		retval = request_irq(LUBBOCK_USB_DISC_IRQ, lubbock_vbus_irq,
+				     0, driver_name, dev);
 		if (retval != 0) {
 			pr_err("%s: can't get irq %i, err %d\n",
 				driver_name, LUBBOCK_USB_DISC_IRQ, retval);
 			goto err_irq_lub;
 		}
-		retval = request_irq(LUBBOCK_USB_IRQ,
-				lubbock_vbus_irq,
-				IRQF_SAMPLE_RANDOM,
-				driver_name, dev);
+		retval = request_irq(LUBBOCK_USB_IRQ, lubbock_vbus_irq,
+				     0, driver_name, dev);
 		if (retval != 0) {
 			pr_err("%s: can't get irq %i, err %d\n",
 				driver_name, LUBBOCK_USB_IRQ, retval);
-- 
1.7.11.1.108.gb129051

