Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1H1T1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:27:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45969 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751396Ab1H1T1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:27:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1//mMNyce//FPs42WS3zOVToU76x/nVIpxwOEqimU
	pZFSQneRQCyk0k
From: Peter Huewe <peterhuewe@gmx.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] spi: Fix builderror in spi-pl022.c
Date: Sun, 28 Aug 2011 21:26:59 +0200
Message-Id: <1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build error, introduced by commit (67fc8b9f, "PM: add
runtime PM support to core Primecell driver") which unfortunately was a little
bit incomplete and did contain a typo (11 instead of 22).
I'm not sure how this patch could have been tested back then, if it
doesn't even compile ;)

The build failure was:
drivers/spi/spi-pl022.c:2292: error: 'adev' undeclared (first use in
this function)
drivers/spi/spi-pl022.c:2344: error: 'pl022_suspend' undeclared here
(not in a function)

The build failure appears e.g. for the u8500 and realview defconfig.

LinuxVersion: linux next-20110826

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/spi/spi-pl022.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 078338f..3520cf9 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2282,14 +2282,14 @@ pl022_remove(struct amba_device *adev)
 }
 
 #ifdef CONFIG_SUSPEND
-static int pl011_suspend(struct device *dev)
+static int pl022_suspend(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
 	int status = 0;
 
 	status = stop_queue(pl022);
 	if (status) {
-		dev_warn(&adev->dev, "suspend cannot stop queue\n");
+		dev_warn(dev, "suspend cannot stop queue\n");
 		return status;
 	}
 
@@ -2298,7 +2298,7 @@ static int pl011_suspend(struct device *dev)
 	load_ssp_default_config(pl022);
 	amba_pclk_disable(pl022->adev);
 	amba_vcore_disable(pl022->adev);
-	dev_dbg(&adev->dev, "suspended\n");
+	dev_dbg(dev, "suspended\n");
 	return 0;
 }
 
-- 
1.7.3.4

