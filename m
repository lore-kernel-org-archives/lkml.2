Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1LUHAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:00:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40083 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1LUHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:00:19 -0500
Message-ID: <4EF18426.3040805@linaro.org>
Date: Wed, 21 Dec 2011 11:00:54 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: linaro-dev@lists.linaro.org
CC: patches@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] omap: use usleep_range() instead of mdelay()/udelay()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From e4db974edb5c46360465462518a88b83f1bdedf6 Mon Sep 17 00:00:00 2001
From: Dmitry Antipov <dmitry.antipov@linaro.org>
Date: Wed, 21 Dec 2011 10:57:08 +0400
Subject: [PATCH] omap: use usleep_range() instead of mdelay()/udelay()

---
  arch/arm/mach-omap2/omap_phy_internal.c |    2 +-
  arch/arm/mach-omap2/vc.c                |    2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
index 58775e3..e5dff64 100644
--- a/arch/arm/mach-omap2/omap_phy_internal.c
+++ b/arch/arm/mach-omap2/omap_phy_internal.c
@@ -145,7 +145,7 @@ int omap4430_phy_suspend(struct device *dev, int suspend)
  		/* power on the phy */
  		if (__raw_readl(ctrl_base + CONTROL_DEV_CONF) & PHY_PD) {
  			__raw_writel(~PHY_PD, ctrl_base + CONTROL_DEV_CONF);
-			mdelay(200);
+			usleep_range(200000, 201000);
  		}

  		/* restore the context */
diff --git a/arch/arm/mach-omap2/vc.c b/arch/arm/mach-omap2/vc.c
index 031d116..57f44d5 100644
--- a/arch/arm/mach-omap2/vc.c
+++ b/arch/arm/mach-omap2/vc.c
@@ -151,7 +151,7 @@ void omap_vc_post_scale(struct voltagedomain *voltdm,
  	/* SMPS slew rate / step size. 2us added as buffer. */
  	smps_delay = ((smps_steps * voltdm->pmic->step_size) /
  			voltdm->pmic->slew_rate) + 2;
-	udelay(smps_delay);
+	usleep_range(smps_delay, smps_delay + 10);
  }

  /* vc_bypass_scale - VC bypass method of voltage scaling */
-- 
1.7.7.4

