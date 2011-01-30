Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1A3T0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 14:26:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1A3T0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 14:26:45 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Stefan Weil <weil@mail.berlios.de>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm: Fix possible memory leak
Date: Sun, 30 Jan 2011 20:26:27 +0100
Message-Id: <1296415587-4524-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:ph9aPENEho6JDKJBvClgf9tMFJFAzYNno4i7kdVHfKW
 rH3bun/6wLbcx3hD7fh1Qz5MpQpIhwQMDh1uQsDzwfAKSJiFMY
 jb+yWpb+urr1vj2jLEbQl3n8fRsGroMdobY5j/yZl2cayboQlj
 9gUigSCE5U3pjMBZZQne7yC53XYOjJG6vz2ByJNXOQnuVNHFUf
 KRdztIuj+t9qBUBXdyyNkpXhpV1DOnJ6Uk8u53DU5n/npavRTP
 HieQqmmpA8/Ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sr_info was allocated and needs a kfree before returning.

This error was reported by cppcheck:
arch/arm/mach-omap2/smartreflex.c:837: error: Memory leak: sr_info

To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 arch/arm/mach-omap2/smartreflex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index af39d17..07324607 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -832,7 +832,8 @@ static int __init omap_sr_probe(struct platform_device *pdev)

 	if (!pdata) {
 		dev_err(&pdev->dev, "%s: platform data missing\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_free_devinfo;
 	}

 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
--
1.7.2.3

