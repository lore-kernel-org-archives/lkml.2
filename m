Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0DNBqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:46:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49106 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab0DNBqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:46:00 -0400
Date: Wed, 14 Apr 2010 11:45:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ken Kawasaki <ken_kawasaki@spring.nifty.jp>,
       Jiri Pirko <jpirko@redhat.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20100414114556.97d7583d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/pcmcia/smc91c92_cs.c between commit
a6d37024de02e7cb2b2333e438e71355a9c32a0a ("smc91c92_cs: define
multicast_table as unsigned char") from Linus' tree and commit
22bedad3ce112d5ca1eaf043d4990fa2ed698c87 ("net: convert multicast list to
list_head") from the net tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/pcmcia/smc91c92_cs.c
index fd9d6e3,ad22676..0000000
--- a/drivers/net/pcmcia/smc91c92_cs.c
+++ b/drivers/net/pcmcia/smc91c92_cs.c
@@@ -1621,10 -1618,14 +1621,10 @@@ static void set_rx_mode(struct net_devi
  	rx_cfg_setting = RxStripCRC | RxEnable | RxAllMulti;
      else {
  	if (!netdev_mc_empty(dev)) {
- 	    struct dev_mc_list *mc_addr;
+ 	    struct netdev_hw_addr *ha;
  
- 	    netdev_for_each_mc_addr(mc_addr, dev) {
- 		u_int position = ether_crc(6, mc_addr->dmi_addr);
+ 	    netdev_for_each_mc_addr(ha, dev) {
+ 		u_int position = ether_crc(6, ha->addr);
 -#ifndef final_version		/* Verify multicast address. */
 -		if ((ha->addr[0] & 1) == 0)
 -		    continue;
 -#endif
  		multicast_table[position >> 29] |= 1 << ((position >> 26) & 7);
  	    }
  	}
