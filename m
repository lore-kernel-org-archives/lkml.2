Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1J0CRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:17:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60723 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1J0CRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:17:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6511"; a="131237182"
From: Stephen Boyd <sboyd@codeaurora.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sebastien Jan <s-jan@ti.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: [PATCH 0/5] ks8851 MAC and eeprom updates
Date: Wed, 26 Oct 2011 19:17:45 -0700
Message-Id: <1319681870-11972-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.7.1.431.g10b2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pulled this patch series off the netdev list[1] when the eeprom
reading didn't work for my ks8851 and I wanted the mac address to be
read out at boot. It all seems to work well, so I'm posting it here
again, slightly cleaned up and simplified, for inclusion.

Overall it reduces the lines of code and properly support eeprom
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

