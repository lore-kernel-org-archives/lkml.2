Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0IZOgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 10:36:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42105 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab0IZOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 10:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZHm4A0nvLsmp/svgixsZOvFVlkkZhFyxIawqRA+SFpK2LjziqclRLlyppc52adfkJ9
         +N4RFI87MxYeU2w5hts2knIDLcrq2IG9akKbXHW0AvzNZKjUmCIQgZtiA4oXw6Su1lfD
         8zFe6XRigQNlCBsmxhbzp9ZAtPjWPb8OQTbsM=
Date: Sun, 26 Sep 2010 16:38:20 +0200
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 3/3] watchdog: add f71862fg support
Message-ID: <20100926143820.GD2150@kreios.titan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Lutz Ballaschke <vegan.grindcore@googlemail.com>

Cleaned up and replaced some magic numbers by constants.

Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
---

 drivers/watchdog/f71808e_wdt.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)


diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index d070086..c7b9ba7 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -57,8 +57,6 @@
 #define SIO_F71882_ID		0x0541	/* Chipset ID */
 #define SIO_F71889_ID		0x0723	/* Chipset ID */
 
-#define	F71882FG_REG_START		0x01
-
 #define F71808FG_REG_WDO_CONF		0xf0
 #define F71808FG_REG_WDT_CONF		0xf5
 #define F71808FG_REG_WD_TIME		0xf6
@@ -83,7 +81,7 @@ module_param(force_id, ushort, 0);
 MODULE_PARM_DESC(force_id, "Override the detected device ID");
 
 static const int max_timeout = WATCHDOG_MAX_TIMEOUT;
-static int timeout = 60;	/* default timeout in seconds */
+static int timeout = WATCHDOG_TIMEOUT;	/* default timeout in seconds */
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,
 	"Watchdog timeout in seconds. 1<= timeout <="
@@ -352,13 +350,13 @@ static int watchdog_start(void)
 	switch (watchdog.type) {
 	case f71808fg:
 		/* Set pin 21 to GPIO23/WDTRST#, then to WDTRST# */
-		superio_clear_bit(watchdog.sioaddr, 0x2a, 3);
-		superio_clear_bit(watchdog.sioaddr, 0x2b, 3);
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_MFUNCT2, 3);
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_MFUNCT3, 3);
 		break;
 
 	case f71882fg:
 		/* Set pin 56 to WDTRST# */
-		superio_set_bit(watchdog.sioaddr, 0x29, 1);
+		superio_set_bit(watchdog.sioaddr, SIO_REG_MFUNCT1, 1);
 		break;
 
 	case f71862fg:
