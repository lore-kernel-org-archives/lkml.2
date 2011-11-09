Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877Ab1KJD1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934074Ab1KJD1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:15 2011
Message-Id: <20111109212715.109729003@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Pirko <jpirko@redhat.com>,
        Matt Carlson <mcarlson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [144/262] tg3: negate USE_PHYLIB flag check
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jiri Pirko <jpirko@redhat.com>

[ Upstream commit e730c82347b9dc75914da998c44c3f348965db41 ]

USE_PHYLIB flag in tg3_remove_one() is being checked incorrectly. This
results tg3_phy_fini->phy_disconnect is never called and when tg3 module
is removed.

In my case this resulted in panics in phy_state_machine calling function
phydev->adjust_link.

So correct this check.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Acked-by: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/tg3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -15278,7 +15278,7 @@ static void __devexit tg3_remove_one(str
 
 		cancel_work_sync(&tp->reset_task);
 
-		if (!tg3_flag(tp, USE_PHYLIB)) {
+		if (tg3_flag(tp, USE_PHYLIB)) {
 			tg3_phy_fini(tp);
 			tg3_mdio_fini(tp);
 		}


