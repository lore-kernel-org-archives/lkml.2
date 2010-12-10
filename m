Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0LJKej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:34:39 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:44922 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab0LJKeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dxyylMPZpCfkI7v94zapzQPlg3Cd/jEinXVlHwbDpMOFTfUCv2RU9gCRH7M3Kolghv
         yBN5f4Ugz3LTGk9C4bgX0AlZ6cXnfsVPckm1LkvXGe/gBqv3URHhvWY8vmAYqdhRckFT
         y3tWpnnGsEUpxZsl9uEOT4+YgLo10XIoKjFBE=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] pch_phub: use kernel's '%pM' format option to print MAC
Date: Fri, 10 Dec 2010 12:34:27 +0200
Message-Id: <1291977267-28443-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/pch_phub.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 744b804..7907bc4 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -506,8 +506,7 @@ static ssize_t show_pch_mac(struct device *dev, struct device_attribute *attr,
 
 	pch_phub_read_gbe_mac_addr(chip, mac);
 
-	return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x\n",
-				mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+	return sprintf(buf, "%pM\n", mac);
 }
 
 static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
-- 
1.7.2.3

