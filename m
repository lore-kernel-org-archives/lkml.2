Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0EJXnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:43:21 -0400
Received: from kroah.org ([198.145.64.141]:32941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337Ab0EJWvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:50 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223319.012748121@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [020/117] sfc: Always close net device at the end of a disabling reset
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit f49a4589e9e25ef525da449b1ce5597cb659bbb5 upstream.

This fixes a regression introduced by commit
eb9f6744cbfa97674c13263802259b5aa0034594 "sfc: Implement ethtool
reset operation".

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sfc/efx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@ -1862,6 +1862,7 @@ out:
 	}
 
 	if (disabled) {
+		dev_close(efx->net_dev);
 		EFX_ERR(efx, "has been disabled\n");
 		efx->state = STATE_DISABLED;
 	} else {
@@ -1885,8 +1886,7 @@ static void efx_reset_work(struct work_s
 	}
 
 	rtnl_lock();
-	if (efx_reset(efx, efx->reset_pending))
-		dev_close(efx->net_dev);
+	(void)efx_reset(efx, efx->reset_pending);
 	rtnl_unlock();
 }
 


