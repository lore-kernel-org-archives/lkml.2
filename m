Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1HWWmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:42:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54029 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab1HWWmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:08 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/8] [RESEND] staging: et131x: Remove unecessary *etdev NULL check in et1310_phy_init()
Date: Tue, 23 Aug 2011 23:40:33 +0100
Message-Id: <1314139240-869-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <1314139240-869-1-git-send-email-mark.einon@gmail.com>
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
index 2385d04..3653426 100644
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
1.7.6

