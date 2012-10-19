Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab2JSKAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:00:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39104 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339Ab2JSKAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:00:36 -0400
From: Afzal Mohammed <afzal@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <rtc-linux@googlegroups.com>,
        Daniel Mack <zonque@gmail.com>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v4 2/5] ARM: davinci: remove rtc kicker release
Date: Fri, 19 Oct 2012 15:29:31 +0530
Message-ID: <53f02e0eb0c5142e47c9398eb00da0520a442745.1350633036.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1350633036.git.afzal@ti.com>
References: <cover.1350633036.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc-omap driver is now capable of handling kicker mechanism,
hence remove kicker handling at platform level, instead
provide proper device name so that driver can handle kicker
mechanism by itself

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---

v2:
 Use device name da830-rtc instead of am1808-rtc

 arch/arm/mach-davinci/devices-da8xx.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index bd2f72b..2d25b24 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -674,7 +674,7 @@ static struct resource da8xx_rtc_resources[] = {
 };
 
 static struct platform_device da8xx_rtc_device = {
-	.name           = "omap_rtc",
+	.name           = "da830-rtc",
 	.id             = -1,
 	.num_resources	= ARRAY_SIZE(da8xx_rtc_resources),
 	.resource	= da8xx_rtc_resources,
@@ -683,17 +683,6 @@ static struct platform_device da8xx_rtc_device = {
 int da8xx_register_rtc(void)
 {
 	int ret;
-	void __iomem *base;
-
-	base = ioremap(DA8XX_RTC_BASE, SZ_4K);
-	if (WARN_ON(!base))
-		return -ENOMEM;
-
-	/* Unlock the rtc's registers */
-	__raw_writel(0x83e70b13, base + 0x6c);
-	__raw_writel(0x95a4f1e0, base + 0x70);
-
-	iounmap(base);
 
 	ret = platform_device_register(&da8xx_rtc_device);
 	if (!ret)
-- 
1.7.12

