Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1FOAHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:07:02 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41002 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1FOAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:06:58 -0400
Date: Tue, 14 Jun 2011 17:05:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: [PATCH 1/2] gpio: add GPIOF_ values regardless on kconfig settings
Message-Id: <20110614170511.5cb8c8b2.randy.dunlap@oracle.com>
In-Reply-To: <20110614161357.GB1839@ponder.secretlab.ca>
References: <4DDB3AFF.9030006@oracle.com>
	<20110524075248.GB19734@sirena.org.uk>
	<20110527074552.GA907@ponder.secretlab.ca>
	<4DDFE391.2030507@oracle.com>
	<20110527201201.GA6645@ponder.secretlab.ca>
	<BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
	<20110603171837.GA9918@opensource.wolfsonmicro.com>
	<BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
	<4DEC4D67.6010506@oracle.com>
	<20110614091211.465553de.randy.dunlap@oracle.com>
	<20110614161357.GB1839@ponder.secretlab.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DF7F792.00D8:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make GPIOF_ defined values available even when GPIOLIB nor GENERIC_GPIO
is enabled by moving them to <linux/gpio.h>.

Fixes these build errors in linux-next:
sound/soc/codecs/ak4641.c:524: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
sound/soc/codecs/wm8915.c:2921: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-generic/gpio.h |   10 ----------
 include/linux/gpio.h       |   11 +++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

--- linux-next-20110614.orig/include/asm-generic/gpio.h
+++ linux-next-20110614/include/asm-generic/gpio.h
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
--- linux-next-20110614.orig/include/linux/gpio.h
+++ linux-next-20110614/include/linux/gpio.h
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
 
