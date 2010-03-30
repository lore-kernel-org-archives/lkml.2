Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab0CaAkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:40:36 -0400
Received: from kroah.org ([198.145.64.141]:48462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab0C3XJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:00 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:50 2010
Message-Id: <20100330224949.190687646@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike McCormack <mikem@ring3k.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [16/45] sky2: Set SKY2_HW_RAM_BUFFER in sky2_init
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike McCormack <mikem@ring3k.org>

commit 74a61ebf653c6abe459f228eb40e9f24f7ef1fb7 upstream.

The SKY2_HW_RAM_BUFFER bit in hw->flags was checked in sky2_mac_init(),
 before being set later in sky2_up().

Setting SKY2_HW_RAM_BUFFER in sky2_init() where other hw->flags are set
 should avoid this problem recurring.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1438,7 +1438,6 @@ static int sky2_up(struct net_device *de
 	if (ramsize > 0) {
 		u32 rxspace;
 
-		hw->flags |= SKY2_HW_RAM_BUFFER;
 		pr_debug(PFX "%s: ram buffer %dK\n", dev->name, ramsize);
 		if (ramsize < 16)
 			rxspace = ramsize / 2;
@@ -2846,6 +2845,9 @@ static int __devinit sky2_init(struct sk
 			++hw->ports;
 	}
 
+	if (sky2_read8(hw, B2_E_0))
+		hw->flags |= SKY2_HW_RAM_BUFFER;
+
 	return 0;
 }
 


