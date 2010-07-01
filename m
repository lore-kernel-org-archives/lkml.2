Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab0GASeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:34:36 -0400
Received: from kroah.org ([198.145.64.141]:40706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071Ab0GASYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:03 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:15 2010
Message-Id: <20100701173215.839622701@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 107/149] atl1e: Allow TX checksum offload and TSO to be disabled and reenabled
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit ac936929092dc6a5409b627c4c67305ab9b626b3 upstream.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1e/atl1e_ethtool.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/atl1e/atl1e_ethtool.c
+++ b/drivers/net/atl1e/atl1e_ethtool.c
@@ -394,11 +394,13 @@ static const struct ethtool_ops atl1e_et
 	.get_eeprom             = atl1e_get_eeprom,
 	.set_eeprom             = atl1e_set_eeprom,
 	.get_tx_csum            = atl1e_get_tx_csum,
+	.set_tx_csum            = ethtool_op_set_tx_hw_csum,
 	.get_sg                 = ethtool_op_get_sg,
 	.set_sg                 = ethtool_op_set_sg,
 #ifdef NETIF_F_TSO
 	.get_tso                = ethtool_op_get_tso,
 #endif
+	.set_tso                = ethtool_op_set_tso,
 };
 
 void atl1e_set_ethtool_ops(struct net_device *netdev)


