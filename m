Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2BUMI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:08:29 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:57455 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211Ab2BUMIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:08:14 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: Danny Kukawka <dkukawka@suse.de>, bridge@lists.linux-foundation.org,
        Casey Leedom <leedom@chelsio.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Dimitris Michailidis <dm@chelsio.com>, Divy Le Ray <divy@chelsio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Mason <jdmason@kudzu.us>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>, linux-driver@qlogic.com,
        linux-usb@vger.kernel.org, Mark Einon <mark.einon@gmail.com>,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, Olof Johansson <olof@lixom.net>,
        "Solarflare linux maintainers" <linux-net-drivers@solarflare.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 0/4] Part 1: unify return value of .ndo_set_mac_address if address is invalid
Date: Tue, 21 Feb 2012 13:07:48 +0100
Message-Id: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329826094;f88341ae;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here a series of patches to unifiy the return value of 
.ndo_set_mac_address if the given address isn't valid. 
Return -EADDRNOTAVAIL as eth_mac_addr() and other 
.ndo_set_mac_address functions already do if is_valid_ether_addr() 
fails.

Other patches will follow if this set gets accepted.

The patches are against the net-next git tree.

Danny Kukawka (4):
  ethernet: unify return value of .ndo_set_mac_address if address is
    invalid
  mcs7830: unify return value of .ndo_set_mac_address if address is
    invalid
  Staging: et131x: unify return value of .ndo_set_mac_address if
    address is invalid
  br_device: unify return value of .ndo_set_mac_address if address is
    invalid

 drivers/net/ethernet/aeroflex/greth.c              |    2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    2 +-
 drivers/net/ethernet/dlink/sundance.c              |    2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |    2 +-
 drivers/net/ethernet/neterion/s2io.c               |    2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |    2 +-
 drivers/net/ethernet/sfc/efx.c                     |    2 +-
 drivers/net/ethernet/sun/niu.c                     |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    2 +-
 drivers/net/ethernet/tile/tilepro.c                |    2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |    2 +-
 drivers/net/usb/mcs7830.c                          |    2 +-
 drivers/staging/et131x/et131x.c                    |    2 +-
 net/bridge/br_device.c                             |    2 +-
 21 files changed, 21 insertions(+), 21 deletions(-)

-- 
1.7.8.3

