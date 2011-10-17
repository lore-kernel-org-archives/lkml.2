Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1JQBVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:21:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42981 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1JQBUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:20:49 -0400
From: chris@cnpbagwell.com
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        pinglinux@gmail.com
Cc: Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH 4/6] Input: wacom - relax Bamboo stylus ID check
Date: Sun, 16 Oct 2011 20:20:28 -0500
Message-Id: <1318814430-30316-5-git-send-email-chris@cnpbagwell.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
References: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Bagwell <chris@cnpbagwell.com>

Bit 0x02 always means tip versus eraser. Bit 0x01 is something related
to version of stylus and different values are starting to be used.

Relaxing proximity check is required to be used with 3rd generation Bamboo
Pen and Touch tablets.

Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
---
 drivers/input/tablet/wacom_wac.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 7fefd93..d1ced32 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -842,12 +842,7 @@ static int wacom_bpt_pen(struct wacom_wac *wacom)
 	unsigned char *data = wacom->data;
 	int prox = 0, x = 0, y = 0, p = 0, d = 0, pen = 0, btn1 = 0, btn2 = 0;
 
-	/*
-	 * Similar to Graphire protocol, data[1] & 0x20 is proximity and
-	 * data[1] & 0x18 is tool ID.  0x30 is safety check to ignore
-	 * 2 unused tool ID's.
-	 */
-	prox = (data[1] & 0x30) == 0x30;
+	prox = (data[1] & 0x20) == 0x20;
 
 	/*
 	 * All reports shared between PEN and RUBBER tool must be
-- 
1.7.6.4

