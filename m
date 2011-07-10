Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1GJPgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:36:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58949 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1GJPgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:24 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 04/10] staging: et131x: Remove unecessary *etdev NULL check in et1310_phy_init()
Date: Sun, 10 Jul 2011 16:35:29 +0100
Message-Id: <1310312135-28407-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is impossible to get to this function with the pointer being NULL.
Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 72892e0..61ee744 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -908,9 +908,6 @@ void et1310_phy_init(struct et131x_adapter *etdev)
 {
 	u16 data, index;
 
-	if (etdev == NULL)
-		return;
-
 	/* get the identity (again ?) */
 	et131x_mii_read(etdev, PHY_ID_1, &data);
 	et131x_mii_read(etdev, PHY_ID_2, &data);
-- 
1.7.4.4

