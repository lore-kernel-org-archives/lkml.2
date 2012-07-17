Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2GQWFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:05:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39593 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab2GQWE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:04:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 14/17] [ARM] pxa: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:33 -0400
Message-Id: <1342560756-18737-15-git-send-email-tytso@mit.edu>
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
 arch/arm/mach-pxa/lubbock.c  | 2 +-
 arch/arm/mach-pxa/magician.c | 5 ++---
 arch/arm/mach-pxa/trizeps4.c | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index 6bb3f47..0ca0db7 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -456,7 +456,7 @@ static int lubbock_mci_init(struct device *dev,
 	init_timer(&mmc_timer);
 	mmc_timer.data = (unsigned long) data;
 	return request_irq(LUBBOCK_SD_IRQ, lubbock_detect_int,
-			IRQF_SAMPLE_RANDOM, "lubbock-sd-detect", data);
+			   0, "lubbock-sd-detect", data);
 }
 
 static int lubbock_mci_get_ro(struct device *dev)
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index 2db697c..39561dc 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -633,9 +633,8 @@ static struct platform_device bq24022 = {
 static int magician_mci_init(struct device *dev,
 				irq_handler_t detect_irq, void *data)
 {
-	return request_irq(IRQ_MAGICIAN_SD, detect_irq,
-				IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
-				"mmc card detect", data);
+	return request_irq(IRQ_MAGICIAN_SD, detect_irq, IRQF_DISABLED,
+			   "mmc card detect", data);
 }
 
 static void magician_mci_exit(struct device *dev, void *data)
diff --git a/arch/arm/mach-pxa/trizeps4.c b/arch/arm/mach-pxa/trizeps4.c
index 2b6ac00..166dd32 100644
--- a/arch/arm/mach-pxa/trizeps4.c
+++ b/arch/arm/mach-pxa/trizeps4.c
@@ -332,8 +332,8 @@ static int trizeps4_mci_init(struct device *dev, irq_handler_t mci_detect_int,
 	int err;
 
 	err = request_irq(TRIZEPS4_MMC_IRQ, mci_detect_int,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_SAMPLE_RANDOM,
-		"MMC card detect", data);
+			  IRQF_DISABLED | IRQF_TRIGGER_RISING,
+			  "MMC card detect", data);
 	if (err) {
 		printk(KERN_ERR "trizeps4_mci_init: MMC/SD: can't request"
 						"MMC card detect IRQ\n");
-- 
1.7.11.1.108.gb129051

