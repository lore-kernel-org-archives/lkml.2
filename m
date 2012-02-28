Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab2B1BL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:11:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57828 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab2B1BLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.73.234 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010431.603991727@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Lv <DavidLv@viatech.com.cn>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/72] via-velocity: S3 resume fix.
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: David Lv <DavidLv@viatech.com.cn>

[ Upstream commit b530b1930bbd9d005345133f0ff0c556d2a52b19 ]

Initially diagnosed on Ubuntu 11.04 with kernel 2.6.38.

velocity_close is not called during a suspend / resume cycle in this
driver and it has no business playing directly with power states.

Signed-off-by: David Lv <DavidLv@viatech.com.cn>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/via/via-velocity.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2489,9 +2489,6 @@ static int velocity_close(struct net_dev
 	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
 
-	/* Power down the chip */
-	pci_set_power_state(vptr->pdev, PCI_D3hot);
-
 	velocity_free_rings(vptr);
 
 	vptr->flags &= (~VELOCITY_FLAGS_OPENED);


