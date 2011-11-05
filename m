Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1KEV1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 17:27:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51388 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750860Ab1KEV1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 17:27:53 -0400
X-Authenticated: #1242716
X-Provags-ID: V01U2FsdGVkX1+GHwJVFziG4yewBX+CX1cJAglf1vy3p6CeOQy2Ux
	IeD7ymvGdxWtB5
Message-ID: <4EB5AA57.7070008@gmx.de>
Date: Sat, 05 Nov 2011 22:27:51 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Firefox/7.0.1 SeaMonkey/2.4.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] gpiolib: output basic details and consolidate gpio device
 drivers
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a kernel message, containing GPIO range and device name on successful device registration.

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
-------------------------------------------------------------
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..d919ac6 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1088,6 +1088,10 @@ unlock:
 	status = gpiochip_export(chip);
 	if (status)
 		goto fail;
+	
+	pr_info("gpiochip_add: registered GPIOs %d to %d on device: %s\n",
+		chip->base, chip->base + chip->ngpio - 1,
+		chip->label ? : "generic");
 
 	return 0;
 fail:

