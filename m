Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2JSKAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:00:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59646 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab2JSKAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:00:18 -0400
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
Subject: [PATCH v4 4/5] rtc: omap: depend on am33xx
Date: Fri, 19 Oct 2012 15:29:43 +0530
Message-ID: <461eeca5902e383a3d26149700cde751d5450951.1350633036.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1350633036.git.afzal@ti.com>
References: <cover.1350633036.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc-omap driver can be reused for AM33xx RTC.
Provide dependency in Kconfig.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---

v2:
 Modify Kconfig help, resolve checkpatch warning

 drivers/rtc/Kconfig | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 19c03ab..4f7ecb6 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -777,11 +777,13 @@ config RTC_DRV_IMXDI
 
 config RTC_DRV_OMAP
 	tristate "TI OMAP1"
-	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX
+	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX || SOC_AM33XX
 	help
-	  Say "yes" here to support the real time clock on TI OMAP1 and
-	  DA8xx/OMAP-L13x chips.  This driver can also be built as a
-	  module called rtc-omap.
+	  Say "yes" here to support the on chip real time clock
+	  present on TI OMAP1, AM33xx and DA8xx/OMAP-L13x.
+
+	  This driver can also be built as a module, if so, module
+	  will be called rtc-omap.
 
 config HAVE_S3C_RTC
 	bool
-- 
1.7.12

