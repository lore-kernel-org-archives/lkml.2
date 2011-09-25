Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1IYSTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 14:19:40 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58452 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1IYSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 14:19:30 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 6/6] staging: et131x: Bugfix - driver doesn't autoreneg after cable unplug/plug events
Date: Sun, 25 Sep 2011 19:17:57 +0100
Message-Id: <1316974677-17108-6-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
References: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has a long standing bug where removing and inserting the ethernet cable results in no packets being
trnasmitted / received and hence no autonegotiation occurring.

Fixed by resetting the rx/tx engines and queue on detecting a cable being removed.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_initpci.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 618f844..e9daa73 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -544,6 +544,10 @@ static void et131x_adjust_link(struct net_device *netdev)
 
 			/* Setup ET1310 as per the documentation */
 			et131x_adapter_setup(adapter);
+
+			/* perform reset of tx/rx */
+			et131x_disable_txrx(netdev);
+			et131x_enable_txrx(netdev);
 		}
 
 		adapter->link = phydev->link;
-- 
1.7.6

