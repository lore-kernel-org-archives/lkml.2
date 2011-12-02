Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1LBPDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:03:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55237 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1LBPDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:03:32 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 2/7] omap4: build fdif omap device from hwmod
Date: Fri,  2 Dec 2011 23:02:47 +0800
Message-Id: <1322838172-11149-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 arch/arm/mach-omap2/devices.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1166bdc..a392af5 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -728,6 +728,38 @@ void __init omap242x_init_mmc(struct omap_mmc_platform_data **mmc_data)
 
 #endif
 
+static struct platform_device* __init omap4_init_fdif(void)
+{
+	int id = -1;
+	struct platform_device *pd;
+	struct omap_hwmod *oh;
+	const char *dev_name = "fdif";
+
+	oh = omap_hwmod_lookup("fdif");
+	if (!oh) {
+		pr_err("Could not look up fdif hwmod\n");
+		return NULL;
+	}
+
+	pd = omap_device_build(dev_name, id, oh, NULL, 0, NULL, 0, 0);
+	WARN(IS_ERR(pd), "Can't build omap_device for %s.\n",
+				dev_name);
+	return pd;
+}
+
+static void __init omap_init_fdif(void)
+{
+	if (cpu_is_omap44xx()) {
+		struct platform_device *pd;
+
+		pd = omap4_init_fdif();
+		if (!pd)
+			return;
+
+		pm_runtime_enable(&pd->dev);
+	}
+}
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
@@ -808,6 +840,7 @@ static int __init omap2_init_devices(void)
 	omap_init_sham();
 	omap_init_aes();
 	omap_init_vout();
+	omap_init_fdif();
 
 	return 0;
 }
-- 
1.7.5.4

