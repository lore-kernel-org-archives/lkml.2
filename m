Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0KDJql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:46:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39286 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0KDJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:46:38 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-pcmcia@lists.infradead.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia/sa1100: don't put machine specific init functions in .init.text
Date: Thu,  4 Nov 2010 10:46:14 +0100
Message-Id: <1288863974-20434-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are called by sa11x0_drv_pcmcia_probe (which is marked now with
__devinit) so they can go to .devinit.text now, too.

This fixes:

	WARNING: drivers/pcmcia/sa1100_cs.o(.text+0x10): Section mismatch in reference from the function sa11x0_drv_pcmcia_probe() to the function .init.text:pcmcia_simpad_init()
	The function sa11x0_drv_pcmcia_probe() references
	the function __init pcmcia_simpad_init().
	This is often because sa11x0_drv_pcmcia_probe lacks a __init
	annotation or the annotation of pcmcia_simpad_init is wrong.

and a similar warning for pcmcia_collie_init, pcmcia_cerf_init,
pcmcia_h3600_init and pcmcia_shannon_init.

While at it mark pcmcia_assabet_init with __devinit, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/pcmcia/pxa2xx_sharpsl.c |    2 +-
 drivers/pcmcia/sa1100_assabet.c |    2 +-
 drivers/pcmcia/sa1100_cerf.c    |    2 +-
 drivers/pcmcia/sa1100_generic.c |    2 +-
 drivers/pcmcia/sa1100_h3600.c   |    2 +-
 drivers/pcmcia/sa1100_shannon.c |    2 +-
 drivers/pcmcia/sa1100_simpad.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pcmcia/pxa2xx_sharpsl.c b/drivers/pcmcia/pxa2xx_sharpsl.c
index 0ea3b29..81af2b3 100644
--- a/drivers/pcmcia/pxa2xx_sharpsl.c
+++ b/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -237,7 +237,7 @@ static struct pcmcia_low_level sharpsl_pcmcia_ops __initdata = {
 #ifdef CONFIG_SA1100_COLLIE
 #include "sa11xx_base.h"
 
-int __init pcmcia_collie_init(struct device *dev)
+int __devinit pcmcia_collie_init(struct device *dev)
 {
        int ret = -ENODEV;
 
diff --git a/drivers/pcmcia/sa1100_assabet.c b/drivers/pcmcia/sa1100_assabet.c
index fd013a1..f1e8822 100644
--- a/drivers/pcmcia/sa1100_assabet.c
+++ b/drivers/pcmcia/sa1100_assabet.c
@@ -130,7 +130,7 @@ static struct pcmcia_low_level assabet_pcmcia_ops = {
 	.socket_suspend		= assabet_pcmcia_socket_suspend,
 };
 
-int pcmcia_assabet_init(struct device *dev)
+int __devinit pcmcia_assabet_init(struct device *dev)
 {
 	int ret = -ENODEV;
 
diff --git a/drivers/pcmcia/sa1100_cerf.c b/drivers/pcmcia/sa1100_cerf.c
index 9bf088b..30560df 100644
--- a/drivers/pcmcia/sa1100_cerf.c
+++ b/drivers/pcmcia/sa1100_cerf.c
@@ -97,7 +97,7 @@ static struct pcmcia_low_level cerf_pcmcia_ops = {
 	.socket_suspend		= cerf_pcmcia_socket_suspend,
 };
 
-int __init pcmcia_cerf_init(struct device *dev)
+int __devinit pcmcia_cerf_init(struct device *dev)
 {
 	int ret = -ENODEV;
 
diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_generic.c
index 945857f..6b22859 100644
--- a/drivers/pcmcia/sa1100_generic.c
+++ b/drivers/pcmcia/sa1100_generic.c
@@ -64,7 +64,7 @@ static int (*sa11x0_pcmcia_hw_init[])(struct device *dev) = {
 #endif
 };
 
-static int sa11x0_drv_pcmcia_probe(struct platform_device *dev)
+static int __devinit sa11x0_drv_pcmcia_probe(struct platform_device *dev)
 {
 	int i, ret = -ENODEV;
 
diff --git a/drivers/pcmcia/sa1100_h3600.c b/drivers/pcmcia/sa1100_h3600.c
index 56329ad..edf8f00 100644
--- a/drivers/pcmcia/sa1100_h3600.c
+++ b/drivers/pcmcia/sa1100_h3600.c
@@ -219,7 +219,7 @@ struct pcmcia_low_level h3600_pcmcia_ops = {
 	.socket_suspend		= h3600_pcmcia_socket_suspend,
 };
 
-int __init pcmcia_h3600_init(struct device *dev)
+int __devinit pcmcia_h3600_init(struct device *dev)
 {
 	int ret = -ENODEV;
 
diff --git a/drivers/pcmcia/sa1100_shannon.c b/drivers/pcmcia/sa1100_shannon.c
index c4d5186..7ff1b43 100644
--- a/drivers/pcmcia/sa1100_shannon.c
+++ b/drivers/pcmcia/sa1100_shannon.c
@@ -113,7 +113,7 @@ static struct pcmcia_low_level shannon_pcmcia_ops = {
 	.socket_suspend		= shannon_pcmcia_socket_suspend,
 };
 
-int __init pcmcia_shannon_init(struct device *dev)
+int __devinit pcmcia_shannon_init(struct device *dev)
 {
 	int ret = -ENODEV;
 
diff --git a/drivers/pcmcia/sa1100_simpad.c b/drivers/pcmcia/sa1100_simpad.c
index 05bd504..c998f7a 100644
--- a/drivers/pcmcia/sa1100_simpad.c
+++ b/drivers/pcmcia/sa1100_simpad.c
@@ -123,7 +123,7 @@ static struct pcmcia_low_level simpad_pcmcia_ops = {
 	.socket_suspend		= simpad_pcmcia_socket_suspend,
 };
 
-int __init pcmcia_simpad_init(struct device *dev)
+int __devinit pcmcia_simpad_init(struct device *dev)
 {
 	int ret = -ENODEV;
 
-- 
1.7.2.3

