Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab1CEBBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:01:09 -0500
Received: from kroah.org ([198.145.64.141]:50515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab1CEBBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:01:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:41 2011
Message-Id: <20110305005641.509001803@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [71/73] e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit 4def99bbfd46e05c5e03b5b282cb4ee30e27ff19 upstream.

When support for 82577/82578 was added[1] in 2.6.31, PHY wakeup was in-
advertently enabled (even though it does not function properly) on ICH10
LOMs.  This patch makes it so that the ICH10 LOMs use MAC wakeup instead
as was done with the initial support for those devices (i.e. 82567LM-3,
82567LF-3 and 82567V-4).

[1] commit a4f58f5455ba0efda36fb33c37074922d1527a10

Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/netdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -5884,7 +5884,8 @@ static int __devinit e1000_probe(struct
 		/* APME bit in EEPROM is mapped to WUC.APME */
 		eeprom_data = er32(WUC);
 		eeprom_apme_mask = E1000_WUC_APME;
-		if (eeprom_data & E1000_WUC_PHY_WAKE)
+		if ((hw->mac.type > e1000_ich10lan) &&
+		    (eeprom_data & E1000_WUC_PHY_WAKE))
 			adapter->flags2 |= FLAG2_HAS_PHY_WAKEUP;
 	} else if (adapter->flags & FLAG_APME_IN_CTRL3) {
 		if (adapter->flags & FLAG_APME_CHECK_PORT_B &&


