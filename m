Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1JJPWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:22:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1JJPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:22:52 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: Fix et131x smatch issues
Date: Mon, 10 Oct 2011 16:21:12 +0100
Message-Id: <1318260072-2711-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318260072-2711-1-git-send-email-mark.einon@gmail.com>
References: <1318260072-2711-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following issues:

et131x_initpci.c +488 et131x_adjust_link(45) error: we previously assumed 'phydev' could be null.
et131x_initpci.c +504 et131x_adjust_link(61) warn: variable dereferenced before check 'phydev'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_initpci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 9b2dc55..45ce832 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -485,7 +485,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 		et1310_config_mac_regs2(adapter);
 	}
 
-	if (phydev->link != adapter->link) {
+	if (phydev && phydev->link != adapter->link) {
 		/*
 		 * Check to see if we are in coma mode and if
 		 * so, disable it because we will not be able
@@ -501,7 +501,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 			    "Link down - cable problem ?\n");
 			adapter->boot_coma = 0;
 
-			if (phydev && phydev->speed == SPEED_10) {
+			if (phydev->speed == SPEED_10) {
 				/* NOTE - Is there a way to query this without
 				 * TruePHY?
 				 * && TRU_QueryCoreType(adapter->hTruePhy, 0) ==
-- 
1.7.6.4

