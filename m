Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0IOU7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:59:55 -0400
Received: from void.printf.net ([89.145.121.20]:60923 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab0IOU7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:59:54 -0400
Date: Wed, 15 Sep 2010 21:59:49 +0100
From: Chris Ball <cjb@laptop.org>
To: Saeed Bishara <saeed@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: Add architecture dependency for Marvell SoC
	controller
Message-ID: <20100915205949.GA7939@void.printf.net>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20100914190549.GA21918@void.printf.net> <20100915094006.GA21620@sirena.org.uk> <FCBE654890C0334289D0AD3AF4EF009FD18EE74AA8@IL-MB01.marvell.com> <20100915110001.GA4254@rakim.wolfsonmicro.main> <FCBE654890C0334289D0AD3AF4EF009FD18EE74AC7@IL-MB01.marvell.com> <AANLkTi=fsntfyAoFygrTrksVARvQpuxie6tFxCcuLtVR@mail.gmail.com> <FCBE654890C0334289D0AD3AF4EF009FD18EE74AE9@IL-MB01.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FCBE654890C0334289D0AD3AF4EF009FD18EE74AE9@IL-MB01.marvell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 01:29:11PM +0300, Saeed Bishara wrote:
> I think (ARCH_DOVE || ARCH_MMP) is prefered, when MG1 gets added to
> mainline, then we will add that new ARCH.

Thanks, pushed to mmc-next as below.

From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 15 Sep 2010 16:45:41 -0400
Subject: [PATCH] mmc: Add architecture dependency for Marvell SoC controller

Since the driver is for controllers integrated into Marvell SoCs only
offer MMC_SDHCI_MV if we're building for one.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Saeed Bishara <saeed@marvell.com>
[cjb: Use list of arches from Saeed, and update help text accordingly]
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ce099c4..6f12d5d 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -133,10 +133,11 @@ config MMC_SDHCI_CNS3XXX
 config MMC_SDHCI_MV
 	tristate "SDHCI support on Marvell's SoC"
 	depends on MMC_SDHCI
+	depends on (ARCH_DOVE || ARCH_MMP)
 	select MMC_SDHCI_IO_ACCESSORS
 	help
-	  This selects the Secure Digital Host Controller Interface in
-	  Marvell's SoC controllers.
+	  This selects SDHCI support for controllers found in the Dove
+	  and MMP SoCs from Marvell.
 
 	  If you have a controller with this interface, say Y or M here.
 
-- 
1.7.2.2

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
