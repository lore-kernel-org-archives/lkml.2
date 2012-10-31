Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423197Ab2JaQFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:05:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:30433 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422946Ab2JaQFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:05:02 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <havard@skinnemoen.net>
CC: <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <David.Laight@ACULAB.COM>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v4 00/10] net/macb: driver enhancement concerning GEM support, ring logic and cleanup
Date: Wed, 31 Oct 2012 17:04:49 +0100
Message-ID: <cover.1351690694.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an enhancement work that began several years ago. I try to catchup with
some performance improvement that has been implemented then by Havard.
The ring index logic and the TX error path modification are the biggest changes
but some cleanup/debugging have been added along the way.
The GEM revision will benefit from the Gigabit support.
Newer pinctrl infrastructure support is added but it is optional.

The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
flavors.

v4: - remove unneeded device tree header includes
    - modified the computation of available entries in ring buffer
v3: - rebased on net-next to take into account current effor to merge
      at91_ether with macb drivers
    - add additional patch to use the new pinctrl infrastructure
v2: - modify the tx error handling: now uses a workqueue
    - information provided by ethtool -i were not accurate: removed


Havard Skinnemoen (4):
  net/macb: memory barriers cleanup
  net/macb: change debugging messages
  net/macb: clean up ring buffer logic
  net/macb: Offset first RX buffer by two bytes

Jean-Christophe PLAGNIOL-VILLARD (1):
  net/macb: add pinctrl consumer support

Nicolas Ferre (4):
  net/macb: remove macb_get_drvinfo()
  net/macb: tx status is more than 8 bits now
  net/macb: ethtool interface: add register dump feature
  net/macb: better manage tx errors

Patrice Vilchez (1):
  net/macb: Add support for Gigabit Ethernet mode

 drivers/net/ethernet/cadence/at91_ether.c |   6 +-
 drivers/net/ethernet/cadence/macb.c       | 448 +++++++++++++++++++++---------
 drivers/net/ethernet/cadence/macb.h       |  30 +-
 3 files changed, 337 insertions(+), 147 deletions(-)

-- 
1.8.0

