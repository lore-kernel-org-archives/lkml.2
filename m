Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2INQ1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:27:42 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36485 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab2INQ13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:27:29 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH 2/8] gpio: pl061 depends on ARM
Date: Fri, 14 Sep 2012 18:23:57 +0200
Message-Id: <1347639843-32119-3-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

Patch dece904d itroduced chained_irq_enter/exit, which is only
available for arch/arm and the driver won't compile elsewhere.

The dependency is thus made explicit, because AMBA is used in the x86
world by a PCI-to-AMBA bridge, to be submitted.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/gpio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 95778f1..090abd6 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -164,7 +164,7 @@ config GPIO_MXS
 
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
-	depends on ARM_AMBA
+	depends on ARM && ARM_AMBA
 	select GENERIC_IRQ_CHIP
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
-- 
1.7.9.1

