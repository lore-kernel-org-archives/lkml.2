Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1KUS6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:58:05 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18939 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab1KUS6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:58:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6537"; a="137308954"
From: Stephen Boyd <sboyd@codeaurora.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sebastien Jan <s-jan@ti.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: [PATCH 0/5] ks8851 MAC and eeprom updates
Date: Mon, 21 Nov 2011 10:57:55 -0800
Message-Id: <1321901880-12883-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc2.3.g0911
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pulled this patch series off the netdev list[1] when the eeprom
reading didn't work for my ks8851 and I wanted the mac address to be
read out at boot. It all seems to work well, so I'm posting it here
again, slightly cleaned up and simplified, for inclusion.

Overall it reduces the lines of code and properly supports eeprom
reading; two things the previous implementation doesn't do.

This is based off of linux-next-20111025.

Thanks to Ben Dooks for doing the heavy lifting.

[1] http://article.gmane.org/gmane.linux.network/159708

Ben Dooks (4):
  eeprom_93cx6: Add data direction control.
  eeprom_93cx6: Add write support
  KSZ8851-SNL: Add support for EEPROM MAC address
  KSZ8851-SNL: Add ethtool support for EEPROM via eeprom_93cx6

Tristram Ha (1):
  KSZ8851-SNL: Fix MAC address change problem

 drivers/misc/eeprom/eeprom_93cx6.c   |   88 ++++++
 drivers/net/ethernet/micrel/Kconfig  |    2 +
 drivers/net/ethernet/micrel/ks8851.c |  513 ++++++++++++----------------------
 drivers/net/ethernet/micrel/ks8851.h |   15 +-
 include/linux/eeprom_93cx6.h         |    8 +
 5 files changed, 278 insertions(+), 348 deletions(-)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

