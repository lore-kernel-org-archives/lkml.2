Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2BYATx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 19:19:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34547 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753449Ab2BYATw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 19:19:52 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/PBn16vSfPyhgmDcj7qvSEHV0Nrns1cp/8L5tugZ
	a7RG4QNo+lrDBS
From: Peter Huewe <peterhuewe@gmx.de>
To: Jakub Schmidtke <sjakub@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pekka Paalanen <pq@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        <kernel@kenobrien.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/asus_oled: Remove superfluous loop
Date: Sat, 25 Feb 2012 01:19:41 +0100
Message-Id: <1330129181-4740-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a superfluous loop in asus_oled.c
The code is equivalent to do{...} while (0) and thus executes the code
exactly once -> so we can simply remove the loop.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/asus_oled/asus_oled.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 1df9586..83549d9 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -159,7 +159,6 @@ static void setup_packet_header(struct asus_oled_packet *packet, char flags,
 
 static void enable_oled(struct asus_oled_dev *odev, uint8_t enabl)
 {
-	int a;
 	int retval;
 	int act_len;
 	struct asus_oled_packet *packet;
@@ -178,17 +177,15 @@ static void enable_oled(struct asus_oled_dev *odev, uint8_t enabl)
 	else
 		packet->bitmap[0] = 0xae;
 
-	for (a = 0; a < 1; a++) {
-		retval = usb_bulk_msg(odev->udev,
-			usb_sndbulkpipe(odev->udev, 2),
-			packet,
-			sizeof(struct asus_oled_header) + 1,
-			&act_len,
-			-1);
+	retval = usb_bulk_msg(odev->udev,
+		usb_sndbulkpipe(odev->udev, 2),
+		packet,
+		sizeof(struct asus_oled_header) + 1,
+		&act_len,
+		-1);
 
-		if (retval)
-			dev_dbg(&odev->udev->dev, "retval = %d\n", retval);
-	}
+	if (retval)
+		dev_dbg(&odev->udev->dev, "retval = %d\n", retval);
 
 	odev->enabled = enabl;
 
-- 
1.7.3.4

