Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1FWRhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:34760 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab1FWRhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 145/247] e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead
Date: Thu, 23 Jun 2011 13:33:33 -0400
Message-Id: <1308850515-15242-86-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4def99bbfd46e05c5e03b5b282cb4ee30e27ff19 upstream.

When support for 82577/82578 was added[1] in 2.6.31, PHY wakeup was in-
advertently enabled (even though it does not function properly) on ICH10
LOMs.  This patch makes it so that the ICH10 LOMs use MAC wakeup instead
as was done with the initial support for those devices (i.e. 82567LM-3,
82567LF-3 and 82567V-4).

[1] commit a4f58f5455ba0efda36fb33c37074922d1527a10

Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/e1000e/netdev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 56c9e69..d82c361 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -5185,7 +5185,8 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		/* APME bit in EEPROM is mapped to WUC.APME */
 		eeprom_data = er32(WUC);
 		eeprom_apme_mask = E1000_WUC_APME;
-		if (eeprom_data & E1000_WUC_PHY_WAKE)
+		if ((hw->mac.type > e1000_ich10lan) &&
+		    (eeprom_data & E1000_WUC_PHY_WAKE))
 			adapter->flags2 |= FLAG2_HAS_PHY_WAKEUP;
 	} else if (adapter->flags & FLAG_APME_IN_CTRL3) {
 		if (adapter->flags & FLAG_APME_CHECK_PORT_B &&
-- 
1.7.4.4

