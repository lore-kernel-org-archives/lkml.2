Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1JJWWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:22:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37914 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753340Ab1JJWWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:22:49 -0400
X-Authenticated: #1242716
X-Provags-ID: V01U2FsdGVkX1+FkhIowuKFxqaxyAsPLp3w4x10nMrj2JgyHIf4I+
	yyej1G3DKB1mgc
Message-ID: <4E937035.8020806@gmx.de>
Date: Tue, 11 Oct 2011 00:22:45 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: [Patch 1/2] gpio-pca953x: fix gpio_base and add verbosity
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_base was set to 0 if no system platform data or open firmware
platform data was provided. This led to conflicts, if any other gpiochip
with a gpiobase of 0 was instantiated already. Setting it to -1 will
automatically use the first one available.

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
-------------------------------------------------------------
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index c43b8ff..ae479fd 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -577,6 +577,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int
*gpio_base, int *invert)
 void
 pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int
*invert)
 {
+  *gpio_base = -1;
 }
 #endif
 

