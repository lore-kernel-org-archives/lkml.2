Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1BBBDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:03:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:58186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1BBAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028384"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: romieu@fr.zoreil.com, daniel.blueman@gmail.com, rjw@sisk.pl,
        andrew.hendry@gmail.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [52/139] r8169: fix sleeping while holding spinlock.
Message-Id: <20110202004408.43F023E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: françois romieu <romieu@fr.zoreil.com>

[ Upstream commit ea80907ff066edd1dd43c5fe90ae6677d15e6384 ]

As device_set_wakeup_enable can now sleep, move the call to outside
the critical section.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/r8169.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/r8169.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/r8169.c
+++ linux-2.6.35.y/drivers/net/r8169.c
@@ -855,10 +855,10 @@ static int rtl8169_set_wol(struct net_de
 	else
 		tp->features &= ~RTL_FEATURE_WOL;
 	__rtl8169_set_wol(tp, wol->wolopts);
-	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
-
 	spin_unlock_irq(&tp->lock);
 
+	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
+
 	return 0;
 }
 
