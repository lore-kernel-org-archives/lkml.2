Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1AEXso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:48:44 -0500
Received: from kroah.org ([198.145.64.141]:41031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab1AEXpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:14 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:26 2011
Message-Id: <20110105230326.876575746@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [34/49] igb: only use vlan_gro_receive if vlans are registered
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

commit 31b24b955c3ebbb6f3008a6374e61cf7c05a193c upstream.

This change makes it so that vlan_gro_receive is only used if vlans have been
registered to the adapter structure.  Previously we were just sending all vlan
tagged frames in via this function but this results in a null pointer
dereference when vlans are not registered.

[ This fixes bugzilla entry 15582 -Eric Dumazet]

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/igb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -4560,7 +4560,7 @@ static void igb_receive_skb(struct igb_r
 	bool vlan_extracted = (adapter->vlgrp && (status & E1000_RXD_STAT_VP));
 
 	skb_record_rx_queue(skb, ring->queue_index);
-	if (vlan_extracted)
+	if (vlan_extracted && adapter->vlgrp)
 		vlan_gro_receive(&ring->napi, adapter->vlgrp,
 		                 le16_to_cpu(rx_desc->wb.upper.vlan),
 		                 skb);


