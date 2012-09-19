Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2ISLzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:55:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:16618 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2ISLzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:55:42 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <havard@skinnemoen.net>
CC: <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 0/9] net/macb: driver enhancement concerning GEM support, ring logic and cleanup
Date: Wed, 19 Sep 2012 13:55:13 +0200
Message-ID: <cover.1348055112.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
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

The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
flavors.

v2: - modify the tx error handling: now uses a workqueue
    - information provided by ethtool -i were not accurate: removed

Havard Skinnemoen (4):
  net/macb: memory barriers cleanup
  net/macb: change debugging messages
  net/macb: clean up ring buffer logic
  net/macb: Offset first RX buffer by two bytes

Nicolas Ferre (4):
  net/macb: remove macb_get_drvinfo()
  net/macb: tx status is more than 8 bits now
  net/macb: ethtool interface: add register dump feature
  net/macb: better manage tx errors

Patrice Vilchez (1):
  net/macb: Add support for Gigabit Ethernet mode

 drivers/net/ethernet/cadence/macb.c | 433 +++++++++++++++++++++++++-----------
 drivers/net/ethernet/cadence/macb.h |  30 ++-
 2 files changed, 321 insertions(+), 142 deletions(-)

-- 
1.7.11.3

