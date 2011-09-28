Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab1I1WpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775Ab1I1WpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:40 2011
Message-Id: <20110928220140.709196163@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [146/244] rt2800pci: Fix compiler error on PowerPC
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit d331eb51e4d4190b2178c30fcafea54a94a577e8 upstream.

Using gcc 4.4.5 on a Powerbook G4 with a PPC cpu, a complicated
if statement results in incorrect flow, whereas the equivalent switch
statement works correctly.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3685,19 +3685,23 @@ int rt2800_init_eeprom(struct rt2x00_dev
 		return -ENODEV;
 	}
 
-	if (!rt2x00_rf(rt2x00dev, RF2820) &&
-	    !rt2x00_rf(rt2x00dev, RF2850) &&
-	    !rt2x00_rf(rt2x00dev, RF2720) &&
-	    !rt2x00_rf(rt2x00dev, RF2750) &&
-	    !rt2x00_rf(rt2x00dev, RF3020) &&
-	    !rt2x00_rf(rt2x00dev, RF2020) &&
-	    !rt2x00_rf(rt2x00dev, RF3021) &&
-	    !rt2x00_rf(rt2x00dev, RF3022) &&
-	    !rt2x00_rf(rt2x00dev, RF3052) &&
-	    !rt2x00_rf(rt2x00dev, RF3320) &&
-	    !rt2x00_rf(rt2x00dev, RF5370) &&
-	    !rt2x00_rf(rt2x00dev, RF5390)) {
-		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
+	switch (rt2x00dev->chip.rf) {
+	case RF2820:
+	case RF2850:
+	case RF2720:
+	case RF2750:
+	case RF3020:
+	case RF2020:
+	case RF3021:
+	case RF3022:
+	case RF3052:
+	case RF3320:
+	case RF5370:
+	case RF5390:
+		break;
+	default:
+		ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",
+		      rt2x00dev->chip.rf);
 		return -ENODEV;
 	}
 


