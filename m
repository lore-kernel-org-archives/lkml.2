Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2KWPLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:11:47 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:45167 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab2KWPKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:10:04 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH 2/8] gpio: pl061 depends on ARM
Date: Fri, 23 Nov 2012 16:08:24 +0100
Message-Id: <1353683310-23654-3-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

Commit dece904d (gpio: pl061: use chained_irq_* functions in irq
handler) introduced chained_irq_enter/exit, which is only
available for arch/arm and the driver won't compile elsewhere.

The dependency is thus made explicit, because AMBA is used in the x86
world by a PCI-to-AMBA bridge, to be submitted.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 536bc23..fb238d3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -185,7 +185,7 @@ config GPIO_MXS
 
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
-	depends on ARM_AMBA
+	depends on ARM && ARM_AMBA
 	select GENERIC_IRQ_CHIP
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
-- 
1.7.10.4

