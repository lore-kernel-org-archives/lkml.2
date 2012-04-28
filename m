Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2D1B7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 21:59:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34531 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2D1B7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 21:59:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6694"; a="185773401"
X-IronPort-AV: E=Sophos;i="4.75,493,1330934400"; 
   d="scan'208";a="158917508"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 00/10] atl1c: update hardware settings - v4
Date: Sat, 28 Apr 2012 09:58:35 +0800
Message-ID: <1335578325-21326-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update contains a serial of patches, most of them are hardware
settings related. register definitions are refined (or removed if
meaningless) for each patch.

This is the last patch set.

The patches have addressed all sparse and checkpatch warnings.

Following NICs are tested:
AR8131/AR8132/AR8151A/AR8152A/AR8152B
Test item includes:
build/install/uninstall/dhcp/ping/iperf/wol/reboot/etc.

xiong (10):
  atl1c: add workaround for issue of bit INTX-disable for MSI interrupt
  atl1c: add PHY link event(up/down) patch
  atl1c: clear WoL status when reset pcie
  atl1c: remove code of closing register writable attribution
  atl1c: refine mac address related code
  atl1c: enlarge L1 response waiting timer
  atl1c: cancel task when interface closed
  atl1c: do MAC-reset when PHY link down
  atl1c: Disable L0S when no cable link
  atl1c: remove PHY polling from atl1c_change_mtu

 drivers/net/ethernet/atheros/atl1c/atl1c.h      |    1 +
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c   |  141 ++++++++++++---------
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   |   35 ++---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |  153 +++++++++++++++++------
 drivers/pci/quirks.c                            |   12 ++
 5 files changed, 220 insertions(+), 122 deletions(-)

-- 
1.7.7
