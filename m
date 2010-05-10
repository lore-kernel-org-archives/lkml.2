Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab0EJXDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:03:38 -0400
Received: from kroah.org ([198.145.64.141]:45305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918Ab0EJW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:23 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:40 2010
Message-Id: <20100510223540.881268212@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [72/98] r8169: fix broken register writes
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 78f1cd02457252e1ffbc6caa44a17424a45286b8 upstream.

This is quite similar to b39fe41f481d20c201012e4483e76c203802dda7
though said registers are not even documented as 64-bit registers
- as opposed to the initial TxDescStartAddress ones - but as single
bytes which must be combined into 32 bits at the MMIO read/write
level before being merged into a 64 bit logical entity.

Credits go to Ben Hutchings <ben@decadent.org.uk> for the MAR
registers (aka "multicast is broken for ages on ARM) and to
Timo Teräs <timo.teras@iki.fi> for the MAC registers.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2832,8 +2832,8 @@ static void rtl_rar_set(struct rtl8169_p
 	spin_lock_irq(&tp->lock);
 
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
-	RTL_W32(MAC0, low);
 	RTL_W32(MAC4, high);
+	RTL_W32(MAC0, low);
 	RTL_W8(Cfg9346, Cfg9346_Lock);
 
 	spin_unlock_irq(&tp->lock);
@@ -4814,8 +4814,8 @@ static void rtl_set_rx_mode(struct net_d
 		mc_filter[1] = swab32(data);
 	}
 
-	RTL_W32(MAR0 + 0, mc_filter[0]);
 	RTL_W32(MAR0 + 4, mc_filter[1]);
+	RTL_W32(MAR0 + 0, mc_filter[0]);
 
 	RTL_W32(RxConfig, tmp);
 


