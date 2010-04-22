Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0DVTi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:38:56 -0400
Received: from kroah.org ([198.145.64.141]:41400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828Ab0DVT3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.791470901@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Terry Loftin <terry.loftin@hp.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Matthew Burgess <matthew@linuxfromscratch.org>
Subject: [161/197] e1000e: stop cleaning when we reach tx_ring->next_to_use
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Terry Loftin <terry.loftin@hp.com>

commit dac876193cd79ced36d0462749ea47c05844fb49 upstream.

Tx ring buffers after tx_ring->next_to_use are volatile and could
change, possibly causing a crash.  Stop cleaning when we hit
tx_ring->next_to_use.

Signed-off-by: Terry Loftin <terry.loftin@hp.com>
Acked-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Matthew Burgess <matthew@linuxfromscratch.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/netdev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -665,6 +665,8 @@ static bool e1000_clean_tx_irq(struct e1
 				i = 0;
 		}
 
+		if (i == tx_ring->next_to_use)
+			break;
 		eop = tx_ring->buffer_info[i].next_to_watch;
 		eop_desc = E1000_TX_DESC(*tx_ring, eop);
 	}


