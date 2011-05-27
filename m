Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1E0Rrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:47:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52857 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1E0Rrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:47:33 -0400
Message-ID: <4DDFE391.2030507@oracle.com>
Date: Fri, 27 May 2011 10:46:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: [PATCH] gpio: add GPIOF_ values regardless on kconfig settings
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523134815.fb87933a.randy.dunlap@oracle.com> <20110523224659.GB19533@opensource.wolfsonmicro.com> <20110523155343.2e68c265.randy.dunlap@oracle.com> <20110524000837.GA30515@opensource.wolfsonmicro.com> <4DDB082F.3010107@oracle.com> <20110524014959.GA27710@opensource.wolfsonmicro.com> <4DDB3AFF.9030006@oracle.com> <20110524075248.GB19734@sirena.org.uk> <20110527074552.GA907@ponder.secretlab.ca>
In-Reply-To: <20110527074552.GA907@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DDFE3A2.000A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
is enabled by moving them to <linux/gpio.h>.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-generic/gpio.h |   10 ----------
 include/linux/gpio.h       |   11 +++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

--- linux-next-20110523.orig/include/asm-generic/gpio.h
+++ linux-next-20110523/include/asm-generic/gpio.h
@@ -170,16 +170,6 @@ extern int __gpio_cansleep(unsigned gpio
 
 extern int __gpio_to_irq(unsigned gpio);
 
-#define GPIOF_DIR_OUT	(0 << 0)
-#define GPIOF_DIR_IN	(1 << 0)
-
-#define GPIOF_INIT_LOW	(0 << 1)
-#define GPIOF_INIT_HIGH	(1 << 1)
-
-#define GPIOF_IN		(GPIOF_DIR_IN)
-#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
-#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
-
 /**
  * struct gpio - a structure describing a GPIO with configuration
  * @gpio:	the GPIO number
--- linux-next-20110523.orig/include/linux/gpio.h
+++ linux-next-20110523/include/linux/gpio.h
@@ -3,6 +3,17 @@
 
 /* see Documentation/gpio.txt */
 
+/* make these flag values available regardless of GPIO kconfig options */
+#define GPIOF_DIR_OUT	(0 << 0)
+#define GPIOF_DIR_IN	(1 << 0)
+
+#define GPIOF_INIT_LOW	(0 << 1)
+#define GPIOF_INIT_HIGH	(1 << 1)
+
+#define GPIOF_IN		(GPIOF_DIR_IN)
+#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
+#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
+
 #ifdef CONFIG_GENERIC_GPIO
 #include <asm/gpio.h>
 
