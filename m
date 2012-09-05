Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab2IEIZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:25:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24619 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2IEIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:25:08 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2012 04:25:08 EDT
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <havard@skinnemoen.net>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <jamie@jamieiles.com>,
        <linux-kernel@vger.kernel.org>, <patrice.vilchez@atmel.com>
Subject: [PATCH 00/10] net/macb: driver enhancement concerning GEM support, ring logic and cleanup
Date: Wed, 5 Sep 2012 10:19:07 +0200
Message-ID: <cover.1346775479.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
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

Havard Skinnemoen (5):
  net/macb: memory barriers cleanup
  net/macb: change debugging messages
  net/macb: Fix a race in macb_start_xmit()
  net/macb: clean up ring buffer logic
  net/macb: Offset first RX buffer by two bytes

Nicolas Ferre (4):
  net/macb: better manage tx errors
  net/macb: tx status is more than 8 bits now
  net/macb: macb_get_drvinfo: add GEM/MACB suffix to differentiate
    revision
  net/macb: ethtool interface: add register dump feature

Patrice Vilchez (1):
  net/macb: Add support for Gigabit Ethernet mode

 drivers/net/ethernet/cadence/macb.c |  408 ++++++++++++++++++++++++-----------
 drivers/net/ethernet/cadence/macb.h |   29 ++-
 2 files changed, 304 insertions(+), 133 deletions(-)

-- 
1.7.10

