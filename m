Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab2EJRex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760582Ab2EJRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:48 -0400
Message-Id: <20120510173135.355621744@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gerard Lledo <gerard.lledo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/52] sungem: Fix WakeOnLan
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gerard Lledo <gerard.lledo@gmail.com>

[ Upstream commit 5a8887d39e1ba5ee2d4ccb94b14d6f2dce5ddfca ]

WakeOnLan was broken in this driver because gp->asleep_wol is a 1-bit
bitfield and it was being assigned WAKE_MAGIC, which is (1 << 5).
gp->asleep_wol remains 0 and the machine never wakes up.  Fixed by casting
gp->wake_on_lan to bool.  Tested on an iBook G4.

Signed-off-by: Gerard Lledo <gerard.lledo@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sun/sungem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2340,7 +2340,7 @@ static int gem_suspend(struct pci_dev *p
 	netif_device_detach(dev);
 
 	/* Switch off chip, remember WOL setting */
-	gp->asleep_wol = gp->wake_on_lan;
+	gp->asleep_wol = !!gp->wake_on_lan;
 	gem_do_stop(dev, gp->asleep_wol);
 
 	/* Unlock the network stack */


