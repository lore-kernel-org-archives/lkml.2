Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2BQPny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:43:54 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42625 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065Ab2BQPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:43:51 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        b.a.t.m.a.n@lists.open-mesh.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH v2 00/10] Part 4: handle addr_assign_type for random addresses
Date: Fri, 17 Feb 2012 16:43:21 +0100
Message-Id: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329493430;31b320fb;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fourth part of my patch series to fix the handling of 
addr_assign_type for random MAC addresses. 

This most of the patches in this series are for slightly 
more complex cases to handle addr_assign_type and the
reset to NET_ADDR_PERM as soon as the MAC get changed via 
.ndo_set_mac_address where eth_mac_addr wasn't used.

Danny Kukawka (10):
  au1000_eth: use eth_hw_addr_random() instead of random_ether_addr()
  lantiq_etop: set addr_assign_type if random_ether_addr() used
  davinci_emac: use eth_hw_addr_random() instead of random_ether_addr()
  xilinx ll_temac: use eth_hw_addr_random() instead of
    random_ether_addr()
  igbvf: reset netdevice addr_assign_type if changed
  batman-adv: use eth_hw_addr_random() instead of random_ether_addr()
  cisco/enic: use eth_hw_addr_random() instead of random_ether_addr()
  ethoc: set addr_assign_type if random_ether_addr() used
  atheros eth: set addr_assign_type if random_ether_addr() used
  UML net: set addr_assign_type if random_ether_addr() used

 arch/um/drivers/net_kern.c                      |   11 ++++++++---
 drivers/net/ethernet/amd/au1000_eth.c           |    9 +++++----
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c   |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    9 ++++-----
 drivers/net/ethernet/atheros/atlx/atl1.c        |   12 +++++++++---
 drivers/net/ethernet/atheros/atlx/atlx.c        |    1 +
 drivers/net/ethernet/cisco/enic/enic_main.c     |   14 ++++++++++++--
 drivers/net/ethernet/ethoc.c                    |   20 ++++++++++++++++++--
 drivers/net/ethernet/intel/igbvf/netdev.c       |    1 +
 drivers/net/ethernet/lantiq_etop.c              |    7 +++++++
 drivers/net/ethernet/ti/davinci_emac.c          |    5 +++--
 drivers/net/ethernet/xilinx/ll_temac_main.c     |    4 +++-
 net/batman-adv/soft-interface.c                 |    5 ++---
 13 files changed, 74 insertions(+), 26 deletions(-)

-- 
1.7.8.3

